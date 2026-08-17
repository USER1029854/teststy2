// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;
import "./IBEP20.sol";
import "./TransferHelper.sol";
import "./SafeMath.sol";
import "./Ownable.sol";

interface IPancakeRouter
{
        function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
}

interface IPancakePair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function totalSupply() external view returns (uint256);
    function sync() external;
}

 
contract LiqlidityHolder is Ownable 
{
   
    address _liquiditytoken;
    address _usdt;
    address _syttoken;
    address _signer;
    uint256 _type;
    address caller;
    address _bigpool;
    mapping(address=>uint256) public userTaked;
    mapping(uint256=>bool) public orderTaked;
    mapping(address=>uint256) public totalAdded;
    IPancakeRouter pancakeRouter = IPancakeRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    using SafeMath for uint256;
    constructor(address usdt, uint256 stype,address liquiditytoken,address syttoken,address bigpool)
    {
        _usdt=usdt;
        _type=stype; 
        _liquiditytoken=liquiditytoken;
        _syttoken=syttoken;
        _bigpool=bigpool;
         _signer=0xdEb4E4ed40E8d29d10A326Fb4652fDaa55438284;
        caller= bigpool;
    }

    function setSigner(address signer) public onlyOwner
    {
        _signer=signer;
    }

    function setCaller(address _caller) public onlyOwner
    {
        caller=_caller;
    }

     modifier onlyCaller()
    {
        require(caller==msg.sender,"NotCaller");
        _;
    }

    function addLiquidity(uint256 amount) public onlyCaller
    {
        totalAdded[tx.origin]=totalAdded[tx.origin].add(amount);
    }

    function getLiqlidityValue(uint256 Liqlidity) public view returns(uint256[2] memory)
    {
        (uint112 reserve0, uint112 reserve1, ) = IPancakePair(_liquiditytoken).getReserves();
        uint256 totalSupply = IPancakePair(_liquiditytoken).totalSupply();
        return [uint256(reserve0).mul(Liqlidity).div(totalSupply), uint256(reserve1).mul(Liqlidity).div(totalSupply)];
    }

    event OrderReedeemEvent(uint256 indexed orderid);
     
    function ReedeemLP(uint256 orderid,uint256 sendamount,uint256 totalBurnAmount,string memory signedmsg) public
    {
        require(_signer !=address(0),"InvalidSigner");
        require(!orderTaked[orderid],"Order taked");
        orderTaked[orderid]=true;
        address user=msg.sender;
        if(userTaked[user] +sendamount + totalBurnAmount > totalAdded[user])
            return; 
        bytes32 hashValue =  keccak256(abi.encode(user, sendamount,totalBurnAmount,orderid, _type));
        require(_signer == tryRecover(hashValue, hexStr2bytes(signedmsg)),"reward: invalid signer"); 
        userTaked[user] += sendamount;  
        if(sendamount > 0)
        {
            IBEP20(_liquiditytoken).approve(address(pancakeRouter), sendamount);
            uint256 beforusdt=IBEP20(_usdt).balanceOf(address(this));
            pancakeRouter.removeLiquidity(
                _usdt,
                _syttoken,
                sendamount,
                0,
                0,
                address(this),
                block.timestamp
            );
            uint256 afterusdt=IBEP20(_usdt).balanceOf(address(this));
            uint256 usdtamount=afterusdt.sub(beforusdt);
            IBEP20(_usdt).transfer(user, usdtamount);
            IBEP20(_syttoken).transfer(_bigpool, IBEP20(_syttoken).balanceOf(address(this)));
        }

        emit OrderReedeemEvent(orderid);
    
    }
    

    function takeOutErrorTransfer(address tokenaddress,address to,uint256 amount) public onlyOwner
    {
        IBEP20(tokenaddress).transfer(to, amount);
    }

    function tryRecover(bytes32 hashd, bytes memory signature) internal pure returns (address) {
        if (signature.length == 65) {
                bytes32 r;
                bytes32 s;
                uint8 v;
                assembly {
                    r := mload(add(signature, 0x20))
                    s := mload(add(signature, 0x40))
                    v := byte(0, mload(add(signature, 0x60)))
                }
                return ecrecover(hashd, v, r, s);
            } else {
                return address(0);
        }
    }
 
    function hexStr2bytes(string memory data) internal pure returns (bytes memory){

        bytes memory a = bytes(data);
        uint8[] memory b = new uint8[](a.length);
        for (uint i = 0; i < a.length; i++) {
            uint8 _a = uint8(a[i]);

            if (_a > 96) {
                b[i] = _a - 97 + 10;
            }
            else if (_a > 66) {
                b[i] = _a - 65 + 10;
            }
            else {
                b[i] = _a - 48;
            }
        }
        bytes memory c = new bytes(b.length / 2);
        for (uint _i = 0; _i < b.length; _i += 2) {
            c[_i / 2] = bytes1(uint8(b[_i] * 16 + b[_i + 1]));
        }
        return c;
    }
}