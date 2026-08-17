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
    bytes public constant NOT_CURRENT_OWNER = 0xBytes([48, 49, 56, 48, 48, 49]);
    uint256 public constant unresolved_d39bef16 = 17597330313203588138820312606811238679313151328;
    uint256 public constant unresolved_7cf8db30 = 1347860084914731473914180229456556139483513854259;
    uint256 public constant unresolved_9adea95a = 351639376006379652747327544928451613835560728387;
    bytes public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = 0xBytes([48, 49, 56, 48, 48, 50]);
    
    address public owner;
    mapping(bytes32 => bytes32) storage_map_k;
    uint256 public reward3;
    mapping(bytes32 => bytes32) storage_map_d;
    uint256 public reward2;
    address store_f;
    bytes32 store_l;
    mapping(bytes32 => bytes32) storage_map_a;
    mapping(bytes32 => bytes32) storage_map_g;
    bytes32 store_h;
    uint256 public reward1;
    address public usdt;
    
    event OwnershipTransferred(address, address);
    
    /// @custom:selector    0x7ac07dcc
    /// @custom:signature   isCaller(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isCaller(address arg0) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return !(!bytes1(storage_map_a[var_b]));
    }
    
    /// @custom:selector    0x09329d92
    /// @custom:signature   Unresolved_09329d92(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_09329d92(uint256 arg0) public payable {
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        reward3 = arg0;
    }
    
    /// @custom:selector    0x9cae6eae
    /// @custom:signature   Unresolved_9cae6eae(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9cae6eae(address arg0, uint256 arg1) public payable {
        require(arg0 == (address(arg0)));
        require(arg1 == arg1);
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        address var_j = address(arg0);
        storage_map_d[var_j] = arg1 | (uint248(storage_map_d[var_j]));
    }
    
    /// @custom:selector    0xef6597c3
    /// @custom:signature   Unresolved_ef6597c3(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ef6597c3(uint256 arg0, uint256 arg1) public payable {
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        uint256 var_j = arg0;
        storage_map_d[var_j] = arg1;
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   transferOwnership(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function transferOwnership(address arg0) public payable {
        require(arg0 == (address(arg0)));
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        require(address(arg0));
        emit OwnershipTransferred(address(owner), address(arg0));
        owner = (address(arg0)) | (uint96(owner));
    }
    
    /// @custom:selector    0xb9a02901
    /// @custom:signature   Unresolved_b9a02901(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_b9a02901(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(!arg3 > 0xffffffffffffffff);
        if (!(arg3) > 0xffffffffffffffff) {
            require(!(arg3) > 0xffffffffffffffff);
            uint256 var_c = var_c + (uint248(0x3f + (arg3 + 0x1f)));
            require(!((var_c + (uint248(0x3f + (arg3 + 0x1f)))) < var_c) | ((var_c + (uint248(0x3f + (arg3 + 0x1f)))) > 0xffffffffffffffff));
            require(!arg0 > 0);
            require(!arg1 > 0);
            require(arg2 > 0);
            var_c = 0xa0 + var_c;
            require(address(store_f));
            var_c = var_c + (0x20 + (0x20 * var_c.length));
            require(!var_c.length > 0xffffffffffffffff);
            var_l = msg.data[4:4];
            require(!var_c.length);
            require(!(var_m >> 0xf8) > 0x60);
            require(!(bytes1(var_m >> 0xf8) - 0x61) > 0xff);
            require(!(bytes1((var_m >> 0xf8) - 0x61) + 0x0a) > 0xff);
            require(0x01);
        }
        require(0x02);
        require(!(var_c.length / 0x02) > 0xffffffffffffffff);
        var_c = var_c + (0x20 + (uint248(0x1f + (var_c.length / 0x02))));
        require(!var_c.length / 0x02);
        require(!0x01 > 0x01);
        require((bytes1(var_l) * 0x10) == (bytes1(var_l * 0x10)));
        require(0x41 - var_c.length);
        address var_v = ecrecover(keccak256(var_l), (var_r), var_l, var_u);
        require(var_w);
        require(address(var_v) == (address(store_f)), "reward: no order information");
        require(!arg0 > 0);
        require(!arg1 > 0);
        require(arg2 > 0);
        address var_x = address(msg.sender);
        (bool success, bytes memory ret0) = address(0xec1822f4ca5060d2740f1114b7ca44f3fba99933).balanceOf(var_x); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        address var_y = address(msg.sender);
        (bool success, bytes memory ret0) = address(0x03151771ee8b335bb3c0772f8a35e03b323c7560).balanceOf(var_y); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        address var_z = address(msg.sender);
        (bool success, bytes memory ret0) = address(0x3d980e120e30e87fc203098785fff42681bfb743).balanceOf(var_z); // staticcall
        var_z = address(msg.sender);
        uint256 var_aa = 0;
        (bool success, bytes memory ret0) = address(0x03151771ee8b335bb3c0772f8a35e03b323c7560).Unresolved_2f745c59(var_z, var_aa); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!(((var_c + ret0.length) - var_c) < 0x20), "SafeMath: addition overflow");
        uint256 var_a = var_c.length;
        require(!(bytes1(storage_map_g[var_a])), "SafeMath: addition overflow");
        var_a = var_c.length;
        require(!(storage_map_g[var_a] > reward2), "SafeMath: addition overflow");
        require(!(0 > 0), "SafeMath: addition overflow");
        require(!(0 < 0), "SafeMath: addition overflow");
        require(0x01);
        var_a = 0x4e487b7100000000000000000000000000000000000000000000000000000000;
        require(!(reward2 - storage_map_g[var_a]) > reward2);
        var_aa = 0x03151771ee8b335bb3c0772f8a35e03b323c7560;
        (bool success, bytes memory ret0) = address(store_h).Unresolved_be95492b(var_aa); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        require(!var_c.length > reward2);
        require(!(reward2 - var_c.length) > reward2);
        var_y = address(msg.sender);
        var_z = 0;
        (bool success, bytes memory ret0) = address(0xec1822f4ca5060d2740f1114b7ca44f3fba99933).tokenOfOwnerByIndex(var_y, var_z); // staticcall
    }
    
    /// @custom:selector    0x27838905
    /// @custom:signature   Unresolved_27838905(address arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_27838905(address arg0, uint256 arg1) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        var_b = arg1;
        return !(!bytes1(storage_map_a[var_b]));
    }
    
    /// @custom:selector    0xe6b1258f
    /// @custom:signature   Unresolved_e6b1258f(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_e6b1258f(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(arg0 == (address(arg0)));
        require(!arg1 > 0);
        require(!arg2 > 0);
        require(arg3 > 0);
        address var_b = address(arg0);
        (bool success, bytes memory ret0) = address(0xec1822f4ca5060d2740f1114b7ca44f3fba99933).Unresolved_70a08231(var_b); // staticcall
        uint256 var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        address var_e = address(arg0);
        (bool success, bytes memory ret0) = address(0x03151771ee8b335bb3c0772f8a35e03b323c7560).Unresolved_70a08231(var_e); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        address var_g = address(arg0);
        (bool success, bytes memory ret0) = address(0x3d980e120e30e87fc203098785fff42681bfb743).Unresolved_70a08231(var_g); // staticcall
        var_g = address(arg0);
        (bool success, bytes memory ret0) = address(0x03151771ee8b335bb3c0772f8a35e03b323c7560).Unresolved_2f745c59(var_g); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!(((var_c + ret0.length) - var_c) < 0x20), "SafeMath: addition overflow");
        uint256 var_i = var_c.length;
        require(!(bytes1(storage_map_k[var_i])), "SafeMath: addition overflow");
        var_i = var_c.length;
        require(!(storage_map_k[var_i] > reward2), "SafeMath: addition overflow");
        require(!(0 > 0), "SafeMath: addition overflow");
        require(!(0 < 0), "SafeMath: addition overflow");
        require(0x01);
        var_i = 0x4e487b7100000000000000000000000000000000000000000000000000000000;
        require(!(reward2 - storage_map_k[var_i]) > reward2);
        var_h = 0x03151771ee8b335bb3c0772f8a35e03b323c7560;
        (bool success, bytes memory ret0) = address(store_h).Unresolved_be95492b(var_h); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        require(!var_c.length > reward2);
        require(!(reward2 - var_c.length) > reward2);
        var_e = address(arg0);
        var_g = 0;
        (bool success, bytes memory ret0) = address(0xec1822f4ca5060d2740f1114b7ca44f3fba99933).tokenOfOwnerByIndex(var_e, var_g); // staticcall
    }
    
    /// @custom:selector    0x50138ae9
    /// @custom:signature   Unresolved_50138ae9(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_50138ae9(uint256 arg0) public view returns (uint256) {
        uint256 var_b = arg0;
        return storage_map_a[var_b];
    }
    
    /// @custom:selector    0xbe95492b
    /// @custom:signature   Unresolved_be95492b(address arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_be95492b(address arg0, uint256 arg1) public payable returns (uint256) {
        require(arg0 == (address(arg0)));
        var_a = arg1;
        require(!bytes1(storage_map_g[var_a]));
        var_a = arg1;
        return storage_map_g[var_a];
        address var_d = address(arg0);
        (bool success, bytes memory ret0) = address(store_h).Unresolved_be95492b(var_d); // staticcall
        uint256 var_f = var_f + (uint248(ret0.length + 0x1f));
        require(!((var_f + ret0.length) - var_f) < 0x20);
        return var_f.length;
    }
    
    /// @custom:selector    0xc6d716f2
    /// @custom:signature   Unresolved_c6d716f2(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c6d716f2(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x75231f74
    /// @custom:signature   Unresolved_75231f74(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_75231f74(uint256 arg0) public payable {
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        reward2 = arg0;
    }
    
    /// @custom:selector    0x74de4ec4
    /// @custom:signature   addReward(uint256 arg0) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function addReward(uint256 arg0) public view {
        address var_a = msg.sender;
        require(bytes1(storage_map_g[var_a]), "");
        require((store_l == ((store_l * 0x64) / 0x64)) | !0x64, "");
        require(0 - arg0, "");
        require((0x28 == ((0x28 * arg0) / arg0)) | !arg0, "");
        require(arg0, "");
        require(((0x28 * arg0) / arg0) == 0x28, "");
        uint256 var_d = 0x40 + var_d;
        require(store_l * 0x64, "");
        require(store_l * 0x64, "");
        require(!(reward1 > ((0x28 * arg0) / (store_l * 0x64) + reward1)), "");
    }
    
    /// @custom:selector    0x595596ef
    /// @custom:signature   Unresolved_595596ef(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_595596ef(uint256 arg0) public payable {
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        reward1 = arg0;
    }
    
    /// @custom:selector    0xd7c31176
    /// @custom:signature   Unresolved_d7c31176(address arg0, uint256 arg1) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_d7c31176(address arg0, uint256 arg1) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        var_b = arg1;
        return storage_map_a[var_b];
    }
    
    /// @custom:selector    0x6c19e783
    /// @custom:signature   setSigner(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setSigner(address arg0) public payable {
        require(arg0 == (address(arg0)));
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        store_f = (address(arg0)) | (uint96(store_f));
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   renounceOwnership() public payable
    function renounceOwnership() public payable {
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        emit OwnershipTransferred(address(owner), 0);
        owner = uint96(owner);
    }
}