// SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity >=0.8.0;
// Source extracted verbatim from the VERIFIED STYTOKEN.sol (same compilation unit).
// The deployed FeeCutter at 0x729d05b4b45f5ad101f44b3b0c01e824972312d0 is UNVERIFIED on BscScan,
// but its runtime bytecode's function set was confirmed by decompilation to match this source.
// Interfaces used (IBEP20, IPancakeRouter, IRewardContract, SafeMath) are defined in STYTOKEN.sol.

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
