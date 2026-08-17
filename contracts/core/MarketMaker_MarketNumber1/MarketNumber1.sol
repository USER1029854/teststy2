// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.0;

import "./SafeMath.sol";
import "./IBEP20.sol";
import "./Ownable.sol";


interface IPancakeRouter {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface ITOKEN
{
    function getCurrentPrice() external view returns (uint256 price);
    function dayOpenPrice(uint256 day) external view returns (uint256 price);
}


interface IPancakePair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function totalSupply() external view returns (uint256);
    function sync() external;
}

contract MarketNumber1 is Ownable
{
    using SafeMath for uint256;
    address _stytoken;
    uint256 nextbuytime;
    address _usdt;
    address _TeamA;
    address _bigpool;
    address _tradepair;
    mapping(address=>bool) public isCaller;
    IPancakeRouter pancakeRouter = IPancakeRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    constructor(address stytoken,address usdt,address bigpool,address tradepair)
    {
        _stytoken=stytoken;
        _usdt=usdt;
        _tradepair=tradepair;
        _bigpool= bigpool;
        nextbuytime=block.timestamp;
        isCaller[msg.sender]=true;
    }

    modifier onlyCaller()
    {
        require(isCaller[msg.sender],"Not Caller");
        _;
    }


    function setCaller(address caller,bool ok) public onlyOwner
    {
        isCaller[caller]=ok;
    }

    function setNextBuyTime(uint256 time) public onlyOwner
    {
        nextbuytime=time;
    }

    function getDay() public view returns(uint256)
    {
        return (block.timestamp - 1781049600) / 86400;
    }

    function setBigPool(address bigpool) public onlyOwner
    {
        _bigpool=bigpool;
    }
    
    function NeedSell() public view returns(bool)
    {
        uint256 day= getDay();
        uint256 openprice= ITOKEN(_stytoken).dayOpenPrice(day);
        uint256 nowprice = ITOKEN(_stytoken).getCurrentPrice();

        if(nowprice < openprice.mul(103).div(100))
            return false;
        else
            return true;
    }

    function NeedBuy() public view returns(bool)
    {
        if(block.timestamp < nextbuytime)
            return false;
        uint256 day= getDay();
        uint256 openprice= ITOKEN(_stytoken).dayOpenPrice(day);
        uint256 nowprice = ITOKEN(_stytoken).getCurrentPrice();

        if(nowprice > openprice.mul(103).div(100))
            return false;
        else
            return true;
    }

    function calcSellAmount(uint256 openprice,uint256 nowprice) public view returns(uint256)
    {
        uint256 baseprice=openprice.mul(103).div(100);
         if(nowprice < baseprice)
            return 0;
        (,uint256 r1,) = IPancakePair(_tradepair).getReserves();
        uint256 sellpct = nowprice.sub(baseprice).mul(10000).div(baseprice);
        if(sellpct > 600)
            sellpct = 600;

        return r1.mul(sellpct).div(20000);
    }
 
    function AutoSell() public onlyCaller
    {
        uint256 day= getDay();
        uint256 openprice= ITOKEN(_stytoken).dayOpenPrice(day);
        uint256 nowprice = ITOKEN(_stytoken).getCurrentPrice();

        if(nowprice < openprice.mul(103).div(100))
            return;

        uint256 amount = calcSellAmount(openprice, nowprice);
        if(IBEP20(_stytoken).balanceOf(address(this)) < amount)
            amount = IBEP20(_stytoken).balanceOf(address(this));
        
        IBEP20(_stytoken).approve(address(pancakeRouter), amount);
        address[] memory path = new address[](2);
        path[0] = _stytoken;
        path[1] = _usdt;

        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
    
    function AutoBuy() public onlyCaller
    {
        require(block.timestamp >= nextbuytime,"Not Time To Buy");
        nextbuytime=nextbuytime.add(600);
        uint256 day= getDay();
        uint256 openprice= ITOKEN(_stytoken).dayOpenPrice(day);
        uint256 nowprice = ITOKEN(_stytoken).getCurrentPrice();

        if(nowprice > openprice.mul(103).div(100))
            return;
        else
        {
             uint256 balance = IBEP20(_usdt).balanceOf(address(this));
            uint256 buyamount = balance.div(1000);

            if(buyamount > 0)
            {
                IBEP20(_usdt).approve(address(pancakeRouter), buyamount);

                address[] memory path = new address[](2);
                path[0] = _usdt;
                path[1] = _stytoken;

                pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    buyamount,
                    0,
                    path,
                    _bigpool,
                    block.timestamp
                );
            }
        }
 
        
    }
}