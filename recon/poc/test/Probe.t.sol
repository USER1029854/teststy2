// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./vm.sol";

interface IERC20 { function approve(address,uint256) external returns (bool); function transfer(address,uint256) external returns (bool); function balanceOf(address) external view returns (uint256); }
interface ISTY { function getCurrentPrice() external view returns (uint256); function balanceOf(address) external view returns (uint256); }
interface IMR {
    function order(uint256) external;
    function orderIndex() external view returns (uint256);
    function userTotalPower(address) external view returns (uint256);
    function takedA(address) external view returns (uint256);
    function takedB(address) external view returns (uint256);
    function isCaller(address) external view returns (bool);
}
interface IPair { function sync() external; function getReserves() external view returns (uint112,uint112,uint32); function token0() external view returns (address); function token1() external view returns (address); }

contract Probe is T {
    address constant STY  = 0xD6A4F5AADD88ebA9A170AcF67f737BD488142857;
    address constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address constant MR   = 0x758905b399f4216E9e3fF791EEa16c05c91A1a88;
    address constant PAIR = 0x2BE23D76F423bf464F310aD98749d82691Ecc830;
    address constant ATK  = 0x00000000000000000000000000000000000A11cE;

    function fundUSDT(address who, uint256 amt) internal {
        vm.store(USDT, keccak256(abi.encode(who, uint256(1))), bytes32(amt));
    }

    function report(string memory tag) internal view {
        _log(tag);
        logu("  spot price 1e18", ISTY(STY).getCurrentPrice());
        logu("  MR.orderIndex", IMR(MR).orderIndex());
        logu("  power(ATK)", IMR(MR).userTotalPower(ATK));
        logu("  takedA(ATK)", IMR(MR).takedA(ATK));
        logu("  ATK USDT", IERC20(USDT).balanceOf(ATK));
        logu("  ATK STY", ISTY(STY).balanceOf(ATK));
    }

    // Does the permissionless order() create a power position? Is it price-sensitive?
    function test_order_power() public {
        vm.createSelectFork("bsc");
        logs("MR.isCaller(STY)", IMR(MR).isCaller(STY) ? "yes" : "no");

        // --- run 1: order at normal price ---
        uint256 s = vm.snapshotState();
        report("BEFORE order (normal price)");
        fundUSDT(ATK, 2000e18);
        vm.startPrank(ATK, ATK);
        IERC20(USDT).approve(MR, type(uint256).max);
        try IMR(MR).order(1000e18) { _log("order(1000e18) OK"); }
        catch Error(string memory r) { logs("order reverted", r); }
        catch { _log("order reverted (no reason)"); }
        vm.stopPrank();
        report("AFTER order (normal price)");
        uint256 powNormal = IMR(MR).userTotalPower(ATK);
        vm.revertToState(s);

        // --- run 2: inflate spot price via USDT donation + sync, then order ---
        uint256 s2 = vm.snapshotState();
        // donate a large amount of USDT to the pair and sync -> raises USDT reserve -> price up
        fundUSDT(address(this), 3_000_000e18);
        IERC20(USDT).transfer(PAIR, 3_000_000e18);
        IPair(PAIR).sync();
        logu("spot price AFTER manipulation", ISTY(STY).getCurrentPrice());
        fundUSDT(ATK, 2000e18);
        vm.startPrank(ATK, ATK);
        IERC20(USDT).approve(MR, type(uint256).max);
        try IMR(MR).order(1000e18) { _log("order(1000e18) OK @inflated"); }
        catch Error(string memory r) { logs("order reverted @inflated", r); }
        catch { _log("order reverted @inflated (no reason)"); }
        vm.stopPrank();
        uint256 powInflated = IMR(MR).userTotalPower(ATK);
        report("AFTER order (inflated price)");
        vm.revertToState(s2);

        _log("=================== RESULT ===================");
        logu("power recorded @ normal price  ", powNormal);
        logu("power recorded @ inflated price", powInflated);
        if (powNormal == powInflated) _log(">> power is PRICE-INDEPENDENT for order()");
        else _log(">> power DIFFERS with price -> investigate release()");
    }
}

interface ILH { function totalAdded(address) external view returns (uint256); function userTaked(address) external view returns (uint256); }
contract Probe2 is T {
    address constant STY  = 0xD6A4F5AADD88ebA9A170AcF67f737BD488142857;
    address constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address constant MR   = 0x758905b399f4216E9e3fF791EEa16c05c91A1a88;
    address constant LH   = 0xCcB498f56EB836343A352E6169033e411d6891DB;
    address constant ATK  = 0x00000000000000000000000000000000000A11cE;
    function fundUSDT(address who, uint256 amt) internal { vm.store(USDT, keccak256(abi.encode(who, uint256(1))), bytes32(amt)); }

    // 1) can an unprivileged attacker CREATE an indexed (releasable) reward order? (0x0d3523bb)
    function test_indexed_order_is_signature_gated() public {
        vm.createSelectFork("bsc");
        uint256 idxBefore = IMROI(MR).orderIndex();
        vm.startPrank(ATK, ATK);
        // 0x0d3523bb(uint256 amount, uint256 signedAmount, uint256 v, uint256 r?) with junk -> expect signer revert
        (bool ok, bytes memory ret) = MR.call(abi.encodeWithSelector(0x0d3523bb, uint256(1000e18), uint256(1000e18), uint256(27), uint256(0x1234)));
        vm.stopPrank();
        logs("indexed-order call from attacker succeeded?", ok ? "YES (bad!)" : "no (reverted)");
        if (ret.length == 0) _log("  revert: (no reason bytes)");
        else { // try decode Error(string)
            if (ret.length >= 68) { bytes memory r = ret; string memory reason; assembly { reason := add(r, 0x44) } logs("  revert reason", reason); }
        }
        logu("orderIndex before", idxBefore);
        logu("orderIndex after ", IMROI(MR).orderIndex());
    }

    // 2) after paid order(), how much LP credit (totalAdded) does attacker get, vs USDT paid?
    function test_order_totalAdded_backed_by_principal() public {
        vm.createSelectFork("bsc");
        logu("LH.totalAdded(ATK) before", ILH(LH).totalAdded(ATK));
        fundUSDT(ATK, 2000e18);
        vm.startPrank(ATK, ATK);
        IERC20b(USDT).approve(MR, type(uint256).max);
        IMROI(MR).order(1000e18);
        vm.stopPrank();
        logu("USDT actually spent (of 2000)", 2000e18 - IERC20b(USDT).balanceOf(ATK));
        logu("MR.userTotalPower(ATK)", IMROI(MR).userTotalPower(ATK));
        logu("LH.totalAdded(ATK) after (LP credited)", ILH(LH).totalAdded(ATK));
        logu("LH.userTaked(ATK)", ILH(LH).userTaked(ATK));
    }
}
interface IMROI { function order(uint256) external; function orderIndex() external view returns (uint256); function userTotalPower(address) external view returns (uint256); }
interface IERC20b { function approve(address,uint256) external returns (bool); function balanceOf(address) external view returns (uint256); }
