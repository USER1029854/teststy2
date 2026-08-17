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
    bytes public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = 0xBytes([48, 49, 56, 48, 48, 50]);
    bytes public constant NOT_CURRENT_OWNER = 0xBytes([48, 49, 56, 48, 48, 49]);
    
    mapping(bytes32 => bytes32) storage_map_w;
    address public unresolved_2ed046fe;
    mapping(bytes32 => bytes32) storage_map_s;
    address public unresolved_32b5f0d6;
    address public unresolved_217629df;
    mapping(bytes32 => bytes32) storage_map_ac;
    address public unresolved_e1917caa;
    bytes32 store_c;
    mapping(bytes32 => bytes32) storage_map_b;
    uint256 public orderIndex;
    address store_f;
    address public unresolved_2c9ad7e0;
    address public unresolved_dcded11a;
    address public unresolved_7584db29;
    mapping(bytes32 => bytes32) storage_map_x;
    address public unresolved_71591565;
    bytes32 store_af;
    mapping(bytes32 => bytes32) storage_map_ae;
    address public unresolved_3413f7bd;
    address public _usdt;
    mapping(bytes32 => bytes32) storage_map_o;
    mapping(bytes32 => bytes32) storage_map_v;
    address public unresolved_ed94743c;
    address public unresolved_8ac77ea6;
    mapping(bytes32 => bytes32) storage_map_a;
    mapping(bytes32 => bytes32) storage_map_ad;
    mapping(bytes32 => bytes32) storage_map_t;
    address public unresolved_99522174;
    mapping(bytes32 => bytes32) storage_map_r;
    address public owner;
    address public unresolved_f43c67e9;
    mapping(bytes32 => bytes32) storage_map_u;
    address public unresolved_d0e5c50e;
    
    event RewardAdded(uint256, uint256);
    event OwnershipTransferred(address, address);
    
    /// @custom:selector    0x333d58f4
    /// @custom:signature   Unresolved_333d58f4(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_333d58f4(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return storage_map_a[var_b];
    }
    
    /// @custom:selector    0x1c4fcb22
    /// @custom:signature   Unresolved_1c4fcb22(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_1c4fcb22(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x56a7d746
    /// @custom:signature   Unresolved_56a7d746(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_56a7d746(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(arg2 == arg2);
        address var_a = msg.sender;
        require(bytes1(storage_map_b[var_a]));
        var_a = arg0;
        require(bytes1(storage_map_b[var_a]));
        require(!arg2);
        (bool success, bytes memory ret0) = address(store_c / 0x01).pancakePair(); // staticcall
        uint256 var_d = var_d + (uint248(ret0.length + 0x1f));
        require(!(((var_d + ret0.length) - var_d) < 0x20), "");
        require(var_d.length == (address(var_d.length)), "");
        var_d = 0x40 + var_d;
        require(0x02, "");
        var_j = 0;
        require(0x02);
        uint256 var_h = address(var_d.length);
        (bool success, bytes memory ret0) = address(store_c).{ value: var_j ether }Unresolved_a9059cbb(var_h); // call
        var_d = var_d + (uint248(ret0.length + 0x1f));
        require(!((var_d + ret0.length) - var_d) < 0x20);
        require(var_d.length == var_d.length);
        require(address(var_d.length).code.length);
        (bool success, bytes memory ret0) = address(var_d.length).{ value: var_j ether }sync(); // call
    }
    
    /// @custom:selector    0x5e002433
    /// @custom:signature   userTotalPower(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function userTotalPower(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return storage_map_a[var_b];
    }
    
    /// @custom:selector    0x0d3523bb
    /// @custom:signature   Unresolved_0d3523bb(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_0d3523bb(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(!arg3 > 0xffffffffffffffff);
        require(!(arg3) > 0xffffffffffffffff);
        require(!((var_c + (uint248(0x3f + (arg3 + 0x1f)))) < var_c) | ((var_c + (uint248(0x3f + (arg3 + 0x1f)))) > 0xffffffffffffffff));
        require(orderIndex + 0x01);
        orderIndex = 0x01 + orderIndex;
        (bool success, bytes memory ret0) = address(store_c).getCurrentPrice(); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!(((var_c + ret0.length) - var_c) < 0x20), "");
        require(0 - arg0, "");
        require((var_c.length == ((var_c.length * arg0) / arg0)) | !arg0, "");
        require(arg0, "");
        require(((var_c.length * arg0) / arg0) == var_c.length, "");
        var_c = 0x40 + var_c;
        require(0x0de0b6b3a7640000, "");
        require(0x0de0b6b3a7640000, "InvalidSigner");
        require(0 - arg2, "InvalidSigner");
        require(0x0e - arg2, "InvalidSigner");
        require(0x1c - arg2, "InvalidSigner");
        require(0x39 - arg2, "InvalidSigner");
        require(address(store_f), "InvalidSigner");
        address var_a = msg.sender;
        require(arg1 > storage_map_b[var_a], "InvalidSigner");
        var_c = 0x80 + var_c;
        require(!(var_c.length > 0xffffffffffffffff), "InvalidSigner");
        var_c = var_c + (0x20 + (0x20 * var_c.length));
        require(!var_c.length, "InvalidSigner");
        require(!((var_n >> 0xf8) > 0x60), "InvalidSigner");
        require(!(bytes1(var_n >> 0xf8) > 0x42), "InvalidSigner");
        require(!((bytes1(var_n >> 0xf8) - 0x30) > 0xff), "InvalidSigner");
        require(0x01, "InvalidSigner");
    }
    
    /// @custom:selector    0xfa6adfe7
    /// @custom:signature   takedB(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function takedB(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return storage_map_a[var_b];
    }
    
    /// @custom:selector    0xecf93426
    /// @custom:signature   Unresolved_ecf93426(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_ecf93426(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return storage_map_a[var_b];
    }
    
    /// @custom:selector    0x7044ba12
    /// @custom:signature   Unresolved_7044ba12(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7044ba12(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
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
    
    /// @custom:selector    0xdd467015
    /// @custom:signature   Unresolved_dd467015(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_dd467015(address arg0) public payable {
        require(arg0 == (address(arg0)));
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        unresolved_2ed046fe = (address(arg0)) | (uint96(unresolved_2ed046fe));
    }
    
    /// @custom:selector    0x7ac07dcc
    /// @custom:signature   isCaller(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isCaller(address arg0) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return !(!bytes1(storage_map_a[var_b]));
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
        storage_map_o[var_j] = arg1 | (uint248(storage_map_o[var_j]));
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
    
    /// @custom:selector    0xa2992488
    /// @custom:signature   Unresolved_a2992488(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a2992488(address arg0) public payable {
        require(arg0 == (address(arg0)));
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        unresolved_3413f7bd = (address(arg0)) | (uint96(unresolved_3413f7bd));
    }
    
    /// @custom:selector    0x856652e9
    /// @custom:signature   userOrders(address arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function userOrders(address arg0, uint256 arg1) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        var_b = arg1;
        return abi.encodePacked(storage_map_a[var_b], storage_map_r[var_b], storage_map_s[var_b], (bytes1(storage_map_t[var_b])));
    }
    
    /// @custom:selector    0x752edf91
    /// @custom:signature   Unresolved_752edf91(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_752edf91(uint256 arg0) public view returns (bool) {
        uint256 var_b = arg0;
        return !(!bytes1(storage_map_a[var_b]));
    }
    
    /// @custom:selector    0xf782bb1a
    /// @custom:signature   Unresolved_f782bb1a(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_f782bb1a(uint256 arg0, uint256 arg1) public payable {
        require(!arg1 > 0xffffffffffffffff);
        if (!(arg1) > 0xffffffffffffffff) {
            require(!(arg1) > 0xffffffffffffffff);
            uint256 var_c = var_c + (uint248(0x3f + (arg1 + 0x1f)));
            require(!((var_c + (uint248(0x3f + (arg1 + 0x1f)))) < var_c) | ((var_c + (uint248(0x3f + (arg1 + 0x1f)))) > 0xffffffffffffffff));
            address var_a = msg.sender;
            var_g = 0x15;
            require(address(store_f));
            uint256 var_i = arg0;
            var_c = 0x80 + var_c;
            require(arg0 > storage_map_b[var_a]);
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
        require(var_g);
        require(address(var_v) == (address(store_f)), "reward: invalid signer");
        var_a = address(msg.sender);
        var_c = 0x40 + var_c;
        require(!(storage_map_b[var_a] > arg0), "");
        var_aa = 0;
        require(!(arg0 - storage_map_b[var_a]) > arg0);
        var_a = address(msg.sender);
        storage_map_b[var_a] = arg0;
        (bool success, bytes memory ret0) = address(store_c).isOpenBuy(); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        require(var_c.length == var_c.length);
        require(!var_c.length);
        var_z = address(msg.sender);
        (bool success, bytes memory ret0) = address(store_c).{ value: var_aa ether }Unresolved_a9059cbb(var_z); // call
        var_z = address(unresolved_3413f7bd);
        (bool success, bytes memory ret0) = address(store_c).{ value: var_aa ether }Unresolved_a9059cbb(var_z); // call
    }
    
    /// @custom:selector    0x6e247371
    /// @custom:signature   Unresolved_6e247371(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_6e247371(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        (bool success, bytes memory ret0) = address(store_c).getCurrentPrice(); // staticcall
        uint256 var_b = var_b + (uint248(ret0.length + 0x1f));
        require(!(((var_b + ret0.length) - var_b) < 0x20), "");
        require(0 - arg0, "");
        require((var_b.length == ((var_b.length * arg0) / arg0)) | !arg0, "");
        require(arg0, "");
        require(((var_b.length * arg0) / arg0) == var_b.length, "");
        var_b = 0x40 + var_b;
        require(0x0de0b6b3a7640000, "");
        require(0x0de0b6b3a7640000, "SafeMath: multiplication overflow");
        require(0 - arg1, "SafeMath: multiplication overflow");
        require(0x0e - arg1, "SafeMath: multiplication overflow");
        require(0x1c - arg1, "SafeMath: multiplication overflow");
        require(0x39 - arg1, "SafeMath: multiplication overflow");
        return (var_b.length * arg0) / 0x0de0b6b3a7640000;
    }
    
    /// @custom:selector    0x4a2ce84d
    /// @custom:signature   Unresolved_4a2ce84d(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_4a2ce84d(uint256 arg0) public payable {
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        var_j = arg0;
        require(storage_map_o[var_j], "Invalid Order");
        var_j = arg0;
        storage_map_x[var_j] = 0;
    }
    
    /// @custom:selector    0x24863199
    /// @custom:signature   takedA(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function takedA(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return storage_map_a[var_b];
    }
    
    /// @custom:selector    0xc6d716f2
    /// @custom:signature   Unresolved_c6d716f2(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c6d716f2(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x74de4ec4
    /// @custom:signature   addReward(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function addReward(uint256 arg0) public payable {
        address var_a = msg.sender;
        require(bytes1(storage_map_b[var_a]));
        (bool success, bytes memory ret0) = address(store_c / 0x01).getCurrentPrice(); // staticcall
        uint256 var_d = var_d + (uint248(ret0.length + 0x1f));
        require(!((var_d + ret0.length) - var_d) < 0x20);
        emit RewardAdded(arg0, var_d.length);
    }
    
    /// @custom:selector    0x83a33fbe
    /// @custom:signature   Unresolved_83a33fbe(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_83a33fbe(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x10a2cdbd
    /// @custom:signature   Unresolved_10a2cdbd(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_10a2cdbd(uint256 arg0) public payable {
        var_a = arg0;
        require(storage_map_b[var_a], "SafeMath: addition overflow");
        require(0 - (var_h), "SafeMath: addition overflow");
        require((0x015180 == ((0x015180 * (var_h)) / (var_h))) | (!var_h), "SafeMath: addition overflow");
        require(var_h, "SafeMath: addition overflow");
        require((0x015180 * (var_h)) / (var_h) == 0x015180, "SafeMath: addition overflow");
        require(!(var_j > ((0x015180 * (var_h)) + (var_j))), "SafeMath: addition overflow");
        require(!((0x015180 * (var_h)) + (var_j) < (var_j)), "SafeMath: addition overflow");
        require(!(block.timestamp < ((0x015180 * (var_h)) + (var_j))), "Not Reach Unlock Time");
        require(!(var_o), "Order Has Released");
        var_a = arg0;
        storage_map_ae[var_a] = 0x01 | (uint248(storage_map_ae[var_a]));
        (bool success, bytes memory ret0) = address(store_c).isOpenBuy(); // staticcall
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        require(var_c.length == var_c.length);
        require(0x01 - var_c.length);
        address var_m = address(msg.sender);
        (bool success, bytes memory ret0) = address(store_c).{ value: 0 ether }Unresolved_a9059cbb(var_m); // call
        var_m = address(unresolved_3413f7bd);
        (bool success, bytes memory ret0) = address(store_c).{ value: 0 ether }Unresolved_a9059cbb(var_m); // call
    }
    
    /// @custom:selector    0x14ba5c09
    /// @custom:signature   getDay() public view returns (uint256)
    function getDay() public view returns (uint256) {
        if (!(block.timestamp - 0x6a28a900) > block.timestamp) {
            if (0xa8c0) {
                return (block.timestamp - 0x6a28a900) / 0xa8c0;
            }
        }
    }
    
    /// @custom:selector    0x21603f43
    /// @custom:signature   order(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function order(uint256 arg0) public payable {
        require(!arg0 < 0x056bc75e2d63100000);
        address var_b = address(msg.sender);
        uint256 var_d = arg0;
        (bool success, bytes memory ret0) = address(_usdt).{ value: 0 ether }Unresolved_23b872dd(var_b); // call
        uint256 var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!(((var_e + ret0.length) - var_e) < 0x20), "");
        require(var_e.length == var_e.length, "");
        require(0 - arg0, "");
        require((0x06 == ((0x06 * arg0) / arg0)) | !arg0, "");
        require(arg0, "");
        require(((0x06 * arg0) / arg0) == 0x06, "");
        var_e = 0x40 + var_e;
        require(0x0a, "");
        var_m = 0;
        require(0x0a);
        address var_k = address(store_af);
        (bool success, bytes memory ret0) = address(_usdt).{ value: var_m ether }Unresolved_095ea7b3(var_k); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(var_e.length == var_e.length);
        var_l = (0x06 * arg0) / 0x0a;
        (bool success, bytes memory ret0) = address(store_af).{ value: var_m ether }Unresolved_a68e214b(var_l); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!(((var_e + ret0.length) - var_e) < 0x20), "");
        require(0 - arg0, "");
        require((0x03 == ((0x03 * arg0) / arg0)) | !arg0, "");
        require(arg0, "");
        require(((0x03 * arg0) / arg0) == 0x03, "");
        var_e = 0x40 + var_e;
        require(0x0a, "");
        require(0x0a);
        address var_t = address(unresolved_8ac77ea6);
        (bool success, bytes memory ret0) = address(_usdt).{ value: var_m ether }Unresolved_a9059cbb(var_t); // call
        var_e = var_e + (uint248(ret0.length + 0x1f));
        require(!((var_e + ret0.length) - var_e) < 0x20);
        require(var_e.length == var_e.length);
        require(0x0a);
        require(0x0a);
        address var_aa = address(unresolved_7584db29);
        (bool success, bytes memory ret0) = address(_usdt).{ value: var_m ether }Unresolved_a9059cbb(var_aa); // call
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