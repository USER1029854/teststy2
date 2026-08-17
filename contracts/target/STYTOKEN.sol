// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./IBEP20.sol";

interface IPancakeRouter {
    function factory() external view returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}


interface IFactory {
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IPancakePair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function totalSupply() external view returns (uint256);
    function sync() external;
}



interface IRewardContract
{
    function addReward(uint256 amount) external;
}

contract FeeCutter
{
    address superowner;
    address token;
    mapping(address=>bool) public isOperator;
    bool _entered;
    address usdt;
    IPancakeRouter pancakeRouter = IPancakeRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    address public FeeOwnerCollege;
    address public FeeOwnerNode;
    address public FeeOwnerTeam;
    address public TeamA;
    address public TeamB;

    using SafeMath for uint256;
    modifier onlyOwner()
    {
        require(msg.sender == superowner, "Only superowner can call");
        _;
    }

    modifier onlyToken()
    {
        require(isOperator[msg.sender], "Only token contract can call");
        _;
    }

    constructor(address _token,address _cfeeowner,address _FeeOwnerNode,address _FeeOwnerTeam,address _TeamA,address _TeamB,address _usdt)
    {
        token=_token;
        isOperator[_token] = true;
        superowner = tx.origin;
        FeeOwnerCollege=_cfeeowner;
        usdt = _usdt;
        FeeOwnerNode=_FeeOwnerNode;
        FeeOwnerTeam=_FeeOwnerTeam;
        TeamA=_TeamA;
        TeamB=_TeamB;
    }

    function setAddresses(address _FeeOwnerCollege, address _FeeOwnerNode, address _FeeOwnerTeam, address _TeamA, address _TeamB, address _usdt) public onlyOwner
    {
        FeeOwnerCollege = _FeeOwnerCollege;
        FeeOwnerNode = _FeeOwnerNode;
        FeeOwnerTeam = _FeeOwnerTeam;
        TeamA = _TeamA;
        TeamB = _TeamB;
        usdt = _usdt;
    }

    function setOperator(address account,bool value) public onlyOwner
    {
        isOperator[account] = value;
    }


    function CutBuyFee() external onlyToken
    {
         if(_entered)
        {
            return;
        }
        _entered = true;
        uint256 amount = IBEP20(token).balanceOf(address(this));
        if(amount == 0)
        {
            _entered=false;
            return;
        }

        IBEP20(token).approve(address(pancakeRouter), amount);
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = usdt;
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            FeeOwnerCollege,
            block.timestamp + 300
        );
        _entered = false;

    }


    function CutSellFee(uint256 amount) external onlyToken
    {
        if(_entered || amount ==0)
        {
            return;
        }
        _entered = true;

        uint256 beforeusdt = IBEP20(usdt).balanceOf(address(this));
        IBEP20(token).approve(address(pancakeRouter), amount);
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = usdt;
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp + 300
        );
        uint256 afterusdt = IBEP20(usdt).balanceOf(address(this));
        uint256 usdtamount = afterusdt.sub(beforeusdt);
        if(usdtamount > 0)
        {
            uint256 onepiece = usdtamount.div(5);

            IBEP20(usdt).transfer(FeeOwnerCollege, onepiece);
            IBEP20(usdt).transfer(FeeOwnerNode, onepiece);

            IRewardContract(FeeOwnerNode).addReward(onepiece);
            IBEP20(usdt).transfer(FeeOwnerTeam, onepiece.mul(3)); 
            IRewardContract(FeeOwnerTeam).addReward(onepiece.mul(3));
        }

        _entered = false;
    }

    function cutSellBurn(uint256 amount) external onlyToken
    {
        if(_entered)
        {
            return;
        }
        _entered = true;
        uint256 samount = amount.mul(4).div(10);
        IBEP20(token).transfer(TeamA, samount);
        IBEP20(token).transfer(FeeOwnerCollege, amount.sub(samount));
        _entered = false;

    }

    function CutProfit(uint256 amount) external onlyToken
    {
        if(_entered)
        {
            return;
        }
        _entered = true;
        uint256 beforeusdt = IBEP20(usdt).balanceOf(address(this));
        IBEP20(token).approve(address(pancakeRouter), amount);
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = usdt;
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp + 300
        );
        uint256 afterusdt = IBEP20(usdt).balanceOf(address(this));
        uint256 usdtamount = afterusdt.sub(beforeusdt);
        if(usdtamount > 0)
        {
            uint256 onepiece = usdtamount.div(5);

            IBEP20(usdt).transfer(FeeOwnerCollege, onepiece.mul(2));
            IBEP20(usdt).transfer(TeamB, onepiece);
            IBEP20(usdt).transfer(FeeOwnerTeam, onepiece); 
            IRewardContract(FeeOwnerTeam).addReward(onepiece);
            IBEP20(usdt).transfer(FeeOwnerNode, onepiece); 
            IRewardContract(FeeOwnerNode).addReward(onepiece);
        }

        _entered = false;

    }
}

 
contract STYTOKEN  is Ownable
{
    using SafeMath for uint256;
    string _name="SWAN TREASURY";
    string _symbol="STY";
    uint8 _decimals=18;
    uint256 _totalsupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping (address => mapping (address => uint256)) private _allowances;
    mapping(address=>uint256) _balances;

    mapping(address=>bool) public isExcludedFromFee;
    address public pancakeRouter=0x10ED43C718714eb63d5aA57B78B54704E256024E;
 
    address immutable usdt;
    address public pancakePair;

    bool public isOpenBuy;
    mapping(address=>mapping(uint256=>uint256)) public userDayBuyAmount;
    mapping(uint256=>uint256) public dayOpenPrice;
    mapping(address=>uint256) public holdPrice;
    uint256 public maxPoolUsdt;
    address MinerRewardContract;
    mapping(uint256=>bool) public roundCutted;

    uint256 startminetime;

    FeeCutter feecutter;
 
    constructor()
    {
       usdt= 0x55d398326f99059fF775485246999027B3197955;
       _totalsupply= 9999990 * 1e18;
       _balances[tx.origin] = _totalsupply;
       emit Transfer(address(0), tx.origin, _totalsupply);
       isExcludedFromFee[tx.origin] = true;
       startminetime =1782475200;
        require(address(this) > usdt, "Contract address must be greater than USDT address"); 
    }
  
    function setMinerRewardContract(address rewardContract) public onlyOwner
    {
        MinerRewardContract = rewardContract;
    }

    function setStartMineTime(uint256 time) public onlyOwner
    {
        startminetime = time;
    }

    function setFeeCutter(address _cutter) public onlyOwner
    {
        isExcludedFromFee[_cutter] = true;
        feecutter = FeeCutter(_cutter);
    }

    function createPair() public onlyOwner
    {
        address pairaddr= IFactory(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73).getPair(address(this),usdt);
        if(pairaddr != address(0))        {
            pancakePair = pairaddr;
            return;
        }
        address pair=IFactory(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73).createPair(address(this), usdt);
        pancakePair = pair; 
    }

    function getDay() public view returns(uint256)
    {
        return (block.timestamp - 1781049600) / 86400;
    }

    function getCutRound() public view returns(uint256)
    {
        return (block.timestamp - 1781049600) / 43200;
    }

     
    function setExcludeFromFee(address account,bool value) public onlyOwner
    {
        isExcludedFromFee[account] = value;
    }

    function name() public view  returns (string memory) {
        return _name;
    }

    function symbol() public  view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view  returns (uint256) {
        return _totalsupply;
    }


    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function balanceOf(address account) public view  returns (uint256) {
        return _balances[account];
    }
 
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _transfer(sender, recipient, amount);
        return true;
    }

   function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

   function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function burnFrom(address sender, uint256 amount) public  returns (bool)
    {
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _burn(sender,amount);
        return true;
    }

    function burn(uint256 amount) public returns (bool)
    {
        _burn(msg.sender,amount);
        return true;
    }
 
    function _burn(address sender,uint256 tAmount) private
    {
         require(sender != address(0), "BEP20: transfer from the zero address");
        _balances[sender] = _balances[sender].sub(tAmount);
        _balances[address(0)] = _balances[address(0)].add(tAmount);
         emit Transfer(sender, address(0), tAmount);
    }

    function cutAmmPoolToMinerReward() public
    {
        require(block.timestamp >= startminetime, "Mining has not started yet");
        uint256 round= getCutRound();
        if(roundCutted[round] || pancakePair == address(0) || MinerRewardContract == address(0))
        {
            return;
        }
        roundCutted[round] = true;
        uint256 balance = balanceOf(pancakePair);
        if(balance == 0) {
            return;
        } 
        uint256 amount = balance.div(100);
        _balances[pancakePair] = _balances[pancakePair].sub(amount);
        _balances[MinerRewardContract] = _balances[MinerRewardContract].add(amount);
        emit Transfer(pancakePair, MinerRewardContract, amount);
        IPancakePair(pancakePair).sync();
        IRewardContract(MinerRewardContract).addReward(amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        require(address(feecutter) != address(0), "FeeCutter contract is not set");
        require(pancakePair != address(0), "Pancake pair is not set");

        if(amount==0)
        {
            emit Transfer(sender, recipient, 0);
            return;
        }

        _balances[sender]= _balances[sender].sub(amount);
        uint256 toamount= amount;

         (uint256 r0,,) = IPancakePair(pancakePair).getReserves();

         if(r0> maxPoolUsdt)
         {
             maxPoolUsdt = r0;
         }

        uint256 day= getDay();
        uint256 nowprice= getCurrentPrice();
        if(dayOpenPrice[day] ==0 && !isExcludedFromFee[sender])
        {
            dayOpenPrice[day] = nowprice;
        }

         bool istrade=false;
 
        if(sender == pancakePair)
        {
            istrade=true;
            if(!isOpenBuy && r0 > 14000000 * 1e18)
            {
                isOpenBuy=true;
            }
            if( !isExcludedFromFee[recipient])
                require(isOpenBuy, "Not open to buy");

            bool isremove= (_isRemoveLiquidity(amount) > 0) && msg.sender ==pancakeRouter;
            if(!isremove && !isExcludedFromFee[recipient])
            {
                uint256 fee = amount.div(50);
                _balances[address(feecutter)] = _balances[address(feecutter)].add(fee);
                toamount = amount.sub(fee);
                emit Transfer(sender, address(feecutter), fee); 
                userDayBuyAmount[recipient][day] = userDayBuyAmount[recipient][day].add(amount);
            }
           
        }

        if(recipient== pancakePair)
        {
            istrade=true;
            bool isadd= (_isAddLiquidity(amount) > 0)  && msg.sender ==pancakeRouter;
            if(!isadd && !isExcludedFromFee[sender])
            {
                 uint256 fee = amount.div(20);
                _balances[address(feecutter)] = _balances[address(feecutter)].add(fee);
                toamount = amount.sub(fee);
                emit Transfer(sender, address(feecutter), fee); 
                feecutter.CutSellFee(fee);

                 uint256 afterprice= getNewPriceAfterSell(toamount);
                 uint256 burnRate = _getSellBurnRate(afterprice, dayOpenPrice[day]);
                if(burnRate > 0)
                {
                    uint256 burnamount = amount.mul(burnRate).div(100);
                    toamount = toamount.sub(burnamount);
                    _balances[address(feecutter)] = _balances[address(feecutter)].add(burnamount);
                    emit Transfer(sender, address(feecutter), burnamount);
                    feecutter.cutSellBurn(burnamount);
                }
                 
                uint256 hprice = holdPrice[sender];
                if(hprice>0 && nowprice > hprice)
                {
                    uint256 profit = CalcProfit(toamount, nowprice, hprice);
                    _balances[address(feecutter)] = _balances[address(feecutter)].add(profit);
                    toamount = toamount.sub(profit);
                    emit Transfer(sender, address(feecutter), profit);
                    feecutter.CutProfit(profit);
                }
            } 
        }

   
        if(!istrade  && sender != address(feecutter) && recipient != address(feecutter))
        {
            uint256 hprice = holdPrice[sender];
            if(hprice>0 && nowprice > hprice && !isExcludedFromFee[sender])
            {
                uint256 profit = CalcProfit(toamount, nowprice, hprice);
                _balances[address(feecutter)] = _balances[address(feecutter)].add(profit);
                toamount = toamount.sub(profit);
                emit Transfer(sender, address(feecutter), profit);
                feecutter.CutProfit(profit);
            }
            feecutter.CutBuyFee();
        }
        UpdateUserHoldPrice(recipient,toamount,nowprice);
        _balances[recipient] = _balances[recipient].add(toamount); 
        emit Transfer(sender, recipient, toamount); 
    }

    function UpdateUserHoldPrice(address user,uint256 amount,uint256 price) private
    {
        if(amount==0)
        {
            return;
        }
        if(holdPrice[user] == 0)
        {
            holdPrice[user] = price;
        }
        else
        {
            holdPrice[user] = (holdPrice[user].mul(balanceOf(user)).add(price.mul(amount))).div(balanceOf(user).add(amount));
        }
    }

 
    function _getSellBurnRate(uint256 afterprice, uint256 openPrice) private pure returns(uint256 burnRate)
    {
        if(openPrice == 0)
        {
            return 0;
        }

        uint256 priceRatio = afterprice.mul(100).div(openPrice);
        if(priceRatio >= 97)
        {
            return 0;
        }
        if(priceRatio < 93)
        {
            return 50;
        }

        return (97 - priceRatio).mul(10);
    }


    function CalcProfit(uint256 toamount,uint256 nowprice,uint256 holdprice) public pure returns(uint256 profit)
    {
         uint256 p =  (nowprice - holdprice).mul(toamount).div(nowprice).div(4); 
         return p;
    }


   function getNewPriceAfterSell(uint256 amount) public view returns (uint256 newPrice) { 
        uint amountInWithFee = amount.mul(9970).div(10000);
        (uint256 rOther, uint256 rThis,) = _getReserves();
        if (rThis > 0) {
            uint256 newRThis = rThis.add(amountInWithFee);
            uint256 newROther = rOther.mul(rThis).div(newRThis);
            newPrice = newROther.mul(1e18).div(newRThis);
        }
    }
 
    function _isRemoveLiquidity(uint256 amount) internal view returns (uint256 liquidity) {
        (uint256 rOther, , uint256 balanceOther) = _getReserves();
        if (balanceOther < rOther) {
            liquidity = (amount * IPancakePair(pancakePair).totalSupply()) / (balanceOf(pancakePair));
        } 
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    function _isAddLiquidity(uint256 amount) internal view returns (uint256 liquidity) {
        (uint256 rOther, uint256 rThis, uint256 balanceOther) = _getReserves();
        uint256 amountOther;
        if (rOther > 0 && rThis > 0) {
            amountOther = (amount * rOther) / rThis;
        }
        if (balanceOther > 0 && balanceOther >= rOther + amountOther) {
            liquidity = calLiquidity(balanceOther, amount, rOther, rThis);
        }
    }

    function calLiquidity(
        uint256 balanceA,
        uint256 amount,
        uint256 r0,
        uint256 r1
    ) private view returns (uint256 liquidity) {
        uint256 pairTotalSupply = IPancakePair(pancakePair).totalSupply();
        uint256 amount0 = balanceA - r0;
        if (pairTotalSupply == 0) {
            liquidity = 1e18;
        } else {
            liquidity = min((amount0 * pairTotalSupply) / r0, (amount * pairTotalSupply) / r1);
        }
    }

    function _getReserves() internal view returns (uint256 rOther, uint256 rThis, uint256 balanceOther) {
        address tokenOther = IPancakePair(pancakePair).token0() == address(this) ? IPancakePair(pancakePair).token1() : IPancakePair(pancakePair).token0();
        (uint256 r0, uint256 r1,) = IPancakePair(pancakePair).getReserves();
        (rOther, rThis) = IPancakePair(pancakePair).token0() == address(this) ? (r1, r0) : (r0, r1);
        balanceOther = IBEP20(tokenOther).balanceOf(pancakePair);   
    }

    function getCurrentPrice() public view returns (uint256 price) {
        (uint256 rOther, uint256 rThis,) = _getReserves();
        if (rThis > 0) {
            price = rOther.mul(1e18).div(rThis);
        }
        else
            return 1e18;
    }

}