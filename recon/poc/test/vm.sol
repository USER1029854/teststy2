// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface Vm {
    function createSelectFork(string calldata) external returns (uint256);
    function deal(address token, address to, uint256 give) external;      // stdstore-style token deal
    function startPrank(address, address) external;
    function stopPrank() external;
    function warp(uint256) external;
    function snapshotState() external returns (uint256);
    function revertToState(uint256) external returns (bool);
    function label(address, string calldata) external;
    function store(address, bytes32, bytes32) external;
    function load(address, bytes32) external view returns (bytes32);
}

contract T {
    Vm constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    address constant CONSOLE = 0x000000000000000000636F6e736F6c652e6c6f67;
    function _log(string memory s) internal view {
        (bool ok,) = CONSOLE.staticcall(abi.encodeWithSignature("log(string)", s)); ok;
    }
    function logu(string memory k, uint256 v) internal view {
        (bool ok,) = CONSOLE.staticcall(abi.encodeWithSignature("log(string,uint256)", k, v)); ok;
    }
    function logi(string memory k, int256 v) internal view {
        (bool ok,) = CONSOLE.staticcall(abi.encodeWithSignature("log(string,int256)", k, v)); ok;
    }
    function logs(string memory k, string memory v) internal view {
        (bool ok,) = CONSOLE.staticcall(abi.encodeWithSignature("log(string,string)", k, v)); ok;
    }
    function loga(string memory k, address v) internal view {
        (bool ok,) = CONSOLE.staticcall(abi.encodeWithSignature("log(string,address)", k, v)); ok;
    }
}
