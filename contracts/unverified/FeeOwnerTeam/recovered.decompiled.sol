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
    bytes public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = 0xBytes([48, 49, 56, 48, 48, 50]);
    
    address store_b;
    bytes32 store_c;
    mapping(bytes32 => bytes32) storage_map_d;
    bytes32 store_e;
    address public owner;
    uint256 public totalreward;
    mapping(bytes32 => bytes32) storage_map_a;
    mapping(bytes32 => bytes32) storage_map_h;
    
    event RewardAdded(uint256, uint256);
    event OwnershipTransferred(address, address);
    
    /// @custom:selector    0x7ac07dcc
    /// @custom:signature   isCaller(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isCaller(address arg0) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return !(!bytes1(storage_map_a[var_b]));
    }
    
    /// @custom:selector    0xc3ce5856
    /// @custom:signature   Unresolved_c3ce5856(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_c3ce5856(uint256 arg0, uint256 arg1) public payable {
        require(!arg1 > 0xffffffffffffffff);
        if (!(arg1) > 0xffffffffffffffff) {
            require(!(arg1) > 0xffffffffffffffff);
            uint256 var_c = var_c + (uint248(0x3f + (arg1 + 0x1f)));
            require(!((var_c + (uint248(0x3f + (arg1 + 0x1f)))) < var_c) | ((var_c + (uint248(0x3f + (arg1 + 0x1f)))) > 0xffffffffffffffff));
            address var_a = msg.sender;
            var_g = 0x04;
            require(address(store_b));
            uint256 var_i = arg0;
            var_c = 0x80 + var_c;
            require(arg0 > storage_map_d[var_a]);
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
        require(address(var_v) == (address(store_b)), "reward: invalid signer");
        var_a = address(msg.sender);
        var_c = 0x40 + var_c;
        require(!(storage_map_d[var_a] > arg0), "");
        var_aa = 0;
        require(!(arg0 - storage_map_d[var_a]) > arg0);
        var_a = address(msg.sender);
        storage_map_d[var_a] = arg0;
        address var_y = address(msg.sender);
        (bool success, bytes memory ret0) = address(store_e).{ value: var_aa ether }many_msg_babbage(var_y); // call
        var_c = var_c + (uint248(ret0.length + 0x1f));
        require(!((var_c + ret0.length) - var_c) < 0x20);
        require(var_c.length == var_c.length);
    }
    
    /// @custom:selector    0x6c19e783
    /// @custom:signature   setSigner(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setSigner(address arg0) public payable {
        require(arg0 == (address(arg0)));
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        store_b = (address(arg0)) | (uint96(store_b));
    }
    
    /// @custom:selector    0xc6d716f2
    /// @custom:signature   Unresolved_c6d716f2(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c6d716f2(address arg0) public pure {
        require(arg0 == (address(arg0)));
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
    
    /// @custom:selector    0xb13d486e
    /// @custom:signature   Unresolved_b13d486e(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b13d486e(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return storage_map_a[var_b];
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
        storage_map_h[var_j] = arg1 | (uint248(storage_map_h[var_j]));
    }
    
    /// @custom:selector    0x74de4ec4
    /// @custom:signature   addReward(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function addReward(uint256 arg0) public payable {
        address var_a = msg.sender;
        require(bytes1(storage_map_d[var_a]), "caller is not allowed");
        require(!(totalreward > (arg0 + totalreward)), "caller is not allowed");
        totalreward = arg0 + totalreward;
        emit RewardAdded(arg0, 0);
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