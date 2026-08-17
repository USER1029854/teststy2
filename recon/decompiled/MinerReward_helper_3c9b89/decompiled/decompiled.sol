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
    
    mapping(bytes32 => bytes32) storage_map_b;
    address public owner;
    mapping(bytes32 => bytes32) storage_map_c;
    
    event OwnershipTransferred(address, address);
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   renounceOwnership() public payable
    function renounceOwnership() public payable {
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        emit OwnershipTransferred(address(owner), 0);
        owner = uint96(owner);
    }
    
    /// @custom:selector    0x7ac07dcc
    /// @custom:signature   isCaller(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isCaller(address arg0) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return !(!bytes1(storage_map_b[var_b]));
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
    
    /// @custom:selector    0xf5537ede
    /// @custom:signature   Unresolved_f5537ede(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f5537ede(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x5fd82414
    /// @custom:signature   Unresolved_5fd82414(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_5fd82414(address arg0, uint256 arg1) public payable {
        require(arg0 == (address(arg0)));
        require(arg1 == arg1);
        uint256 var_a = 0x40 + var_a;
        require(msg.sender == (address(owner)), "");
        address var_j = address(arg0);
        storage_map_c[var_j] = arg1 | (uint248(storage_map_c[var_j]));
    }
}