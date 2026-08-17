// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title            Decompiled Contract
/// @author           Jonathan Becker <jonathan@jbecker.dev>
/// @custom:version   heimdall-rs v0.9.2
///
/// @notice           This contract was decompiled using the heimdall-rs decompiler.
///                     It was generated directly by tracing the EVM opcodes from this contract.
///                     As a result, it may not compile or even be valid solidity code.
///                     Despite this, it should be obvious what each function does. Overall
///                     logic should have been preserved throughout decompiling.
///
/// @custom:github    You can find the open-source decompiler here:
///                       https://heimdall.rs

contract DecompiledContract {
    address public unresolved_dcded11a;
    address public unresolved_8ac77ea6;
    bytes32 store_d;
    address public unresolved_71591565;
    mapping(bytes32 => bytes32) storage_map_f;
    mapping(bytes32 => bytes32) storage_map_k;
    bytes32 store_g;
    bytes32 store_h;
    address public unresolved_b0fa73d9;
    mapping(bytes32 => bytes32) storage_map_e;
    address public unresolved_99522174;
    bytes32 store_j;
    
    
    /// @custom:selector    0x558a7297
    /// @custom:signature   Unresolved_558a7297(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_558a7297(address arg0, uint256 arg1) public payable {
        require(arg0 == (address(arg0)));
        require(arg1 == arg1);
        require(msg.sender == (address(store_d)), "Only superowner can call");
        address var_e = address(arg0);
        storage_map_e[var_e] = arg1 | (uint248(storage_map_e[var_e]));
    }
    
    /// @custom:selector    0xf5089a10
    /// @custom:signature   Unresolved_f5089a10(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_f5089a10(uint256 arg0) public payable {
        address var_a = msg.sender;
        require(bytes1(storage_map_f[var_a]), "");
        require(bytes1(store_g), "");
        store_g = 0x01 | (uint248(store_g));
        require(0 - arg0, "");
        require((0x04 == ((0x04 * arg0) / arg0)) | !arg0, "");
        require(arg0, "");
        require(((0x04 * arg0) / arg0) == 0x04, "");
        uint256 var_d = 0x40 + var_d;
        require(0x0a, "");
        var_j = 0;
        require(0x0a);
        address var_h = address(unresolved_8ac77ea6);
        (bool success, bytes memory ret0) = address(store_h).{ value: var_j ether }Unresolved_a9059cbb(var_h); // call
        var_d = var_d + (uint248(ret0.length + 0x1f));
        require(!(((var_d + ret0.length) - var_d) < 0x20), "");
        require(var_d.length == var_d.length, "");
        var_d = 0x40 + var_d;
        require(!(((0x04 * arg0) / 0x0a) > arg0), "");
        var_r = 0;
        require(!(arg0 - ((0x04 * arg0) / 0x0a)) > arg0);
        address var_p = address(unresolved_99522174);
        (bool success, bytes memory ret0) = address(store_h).{ value: var_r ether }Unresolved_a9059cbb(var_p); // call
    }
    
    /// @custom:selector    0xbe8531a9
    /// @custom:signature   Unresolved_be8531a9(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_be8531a9(uint256 arg0) public payable {
        address var_a = msg.sender;
        require(bytes1(storage_map_f[var_a]));
        require(bytes1(store_g));
        store_g = 0x01 | (uint248(store_g));
        address var_d = address(this);
        (bool success, bytes memory ret0) = address((0x01 | (uint248(store_g))) / 0x0100).Unresolved_70a08231(var_d); // staticcall
        uint256 var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        address var_g = address(store_j);
        (bool success, bytes memory ret0) = address(store_h).{ value: 0 ether }Unresolved_095ea7b3(var_g); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(var_e.length == var_e.length);
        var_e = var_e + 0x60;
        require(var_e.length);
        require(!0x012c > (block.timestamp + 0x012c));
        uint256 var_o = arg0;
        uint256 var_p = 0;
        require(address(store_j).code.length);
        (bool success, bytes memory ret0) = address(store_j).{ value: var_p ether }Unresolved_5c11d795(var_o); // call
        var_o = address(this);
        (bool success, bytes memory ret0) = address(store_g / 0x0100).Unresolved_70a08231(var_o); // staticcall
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!(((var_e + ret0.length) - var_e) < 0x20), "");
        var_e = 0x40 + var_e;
        require(!(var_e.length > var_e.length), "");
        require(!((var_e.length - var_e.length) > var_e.length), "");
        require(!(var_e.length - var_e.length), "");
        var_e = 0x40 + var_e;
        require(0x05, "");
        require(0x05);
        require(0 - ((var_e.length - var_e.length) / 0x05));
        require((0x02 == ((0x02 * ((var_e.length - var_e.length) / 0x05)) / ((var_e.length - var_e.length) / 0x05))) | (!(var_e.length - var_e.length) / 0x05));
        var_r = address(unresolved_99522174);
        (bool success, bytes memory ret0) = address(store_g / 0x0100).{ value: var_p ether }Unresolved_a9059cbb(var_r); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(var_e.length == var_e.length);
        var_ab = address(unresolved_71591565);
        (bool success, bytes memory ret0) = address(store_g / 0x0100).{ value: var_p ether }Unresolved_a9059cbb(var_ab); // call
        store_g = uint248(store_g);
    }
    
    /// @custom:selector    0x6d70f7ae
    /// @custom:signature   isOperator(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isOperator(address arg0) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return !(!bytes1(storage_map_k[var_b]));
    }
    
    /// @custom:selector    0x9e94f03d
    /// @custom:signature   Unresolved_9e94f03d(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_9e94f03d(uint256 arg0) public payable {
        address var_a = msg.sender;
        require(bytes1(storage_map_f[var_a]));
        require(bytes1(store_g));
        require(bytes1(store_g));
        store_g = 0x01 | (uint248(store_g));
        address var_d = address(this);
        (bool success, bytes memory ret0) = address((0x01 | (uint248(store_g))) / 0x0100).Unresolved_70a08231(var_d); // staticcall
        uint256 var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        address var_g = address(store_j);
        (bool success, bytes memory ret0) = address(store_h).{ value: 0 ether }Unresolved_095ea7b3(var_g); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(var_e.length == var_e.length);
        var_e = var_e + 0x60;
        require(var_e.length);
        require(!0x012c > (block.timestamp + 0x012c));
        uint256 var_o = arg0;
        uint256 var_p = 0;
        require(address(store_j).code.length);
        (bool success, bytes memory ret0) = address(store_j).{ value: var_p ether }Unresolved_5c11d795(var_o); // call
        var_o = address(this);
        (bool success, bytes memory ret0) = address(store_g / 0x0100).Unresolved_70a08231(var_o); // staticcall
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!(((var_e + ret0.length) - var_e) < 0x20), "");
        var_e = 0x40 + var_e;
        require(!(var_e.length > var_e.length), "");
        require(!((var_e.length - var_e.length) > var_e.length), "");
        require(!(var_e.length - var_e.length), "");
        var_e = 0x40 + var_e;
        require(0x05, "");
        require(0x05);
        var_r = address(unresolved_99522174);
        (bool success, bytes memory ret0) = address(store_g / 0x0100).{ value: var_p ether }Unresolved_a9059cbb(var_r); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(var_e.length == var_e.length);
        var_ab = address(unresolved_dcded11a);
        (bool success, bytes memory ret0) = address(store_g / 0x0100).{ value: var_p ether }Unresolved_a9059cbb(var_ab); // call
        store_g = uint248(store_g);
        require(!arg0, "Only token contract can call");
    }
    
    /// @custom:selector    0x6cfb6bf9
    /// @custom:signature   Unresolved_6cfb6bf9(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6cfb6bf9(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x6564c61e
    /// @custom:signature   Unresolved_6564c61e() public payable
    function Unresolved_6564c61e() public payable {
        address var_a = msg.sender;
        require(bytes1(storage_map_f[var_a]));
        require(bytes1(store_g));
        store_g = 0x01 | (uint248(store_g));
        address var_d = address(this);
        (bool success, bytes memory ret0) = address(store_h).Unresolved_70a08231(var_d); // staticcall
        uint256 var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(0 - var_e.length);
        store_g = uint248(store_g);
        address var_g = address(store_j);
        (bool success, bytes memory ret0) = address(store_h).{ value: 0 ether }Unresolved_095ea7b3(var_g); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(var_e.length == var_e.length);
        var_e = var_e + 0x60;
        require(var_e.length);
        require(!0x012c > (block.timestamp + 0x012c));
        uint256 var_o = var_e.length;
        uint256 var_p = 0;
        require(address(store_j).code.length);
        (bool success, bytes memory ret0) = address(store_j).{ value: var_p ether }Unresolved_5c11d795(var_o); // call
        store_g = uint248(store_g);
    }
}