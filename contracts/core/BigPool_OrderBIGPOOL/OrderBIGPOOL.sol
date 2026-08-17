// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.0;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./IBEP20.sol";

interface IPancakeRouter {
    function factory() external view returns (address);

     function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

 
}

interface IPancakePair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function totalSupply() external view returns (uint256);
    function sync() external;
}

interface LIQHOLDER
{
    function addLiquidity(uint256 amount) external;
}


contract OrderBIGPOOL is Ownable
{
    address public _usdt;
    address public _syttoken;
    address public _locker;
    IPancakeRouter pancakeRouter = IPancakeRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    address public _pancakepair;
    using SafeMath for uint256;
    address linqlidityholder;

    event UserAddEvent(address indexed user, uint256 indexed liquidity);

    constructor(address usdt,address syttoken,address pair)
    {
        _usdt = usdt;
        _syttoken=syttoken;
        _pancakepair=pair;
    }

    function setLocker(address locker) public onlyOwner
    {
        _locker=locker;
    }

    function setLinqlidityHolder(address liquidityholder) public onlyOwner
    {
        linqlidityholder=liquidityholder;
    }

    modifier onlyLocker() {
        require(msg.sender == _locker, "caller is not the locker");
        _;
    }
 
    function AddLiqlidity(uint256 ustamount) public onlyLocker returns(uint256 liqlidity) 
    {
        require(linqlidityholder != address(0), "Liquidity holder is not set");
        address user=msg.sender;
        IBEP20(_usdt).transferFrom(user, address(this), ustamount);
        IBEP20(_usdt).approve(address(pancakeRouter), ustamount);
        IBEP20(_syttoken).approve(address(pancakeRouter), 1e40);

       (uint256 rU, uint256 rS, )= IPancakePair(_pancakepair).getReserves();

       uint256 addamount = ustamount.mul(rS).div(rU);

        ( , , uint256 liquiditys) = pancakeRouter.addLiquidity(
            _usdt,
            _syttoken,
            ustamount,
            addamount,
            0,
            0,
            linqlidityholder,
            block.timestamp
        );

        LIQHOLDER(linqlidityholder).addLiquidity(liquiditys);
        return liquiditys;
    }
 
}