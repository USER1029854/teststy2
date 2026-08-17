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
    bytes32 store_d;
    mapping(bytes32 => bytes32) storage_map_f;
    uint256 store_p;
    uint256 store_k;
    mapping(bytes32 => bytes32) storage_map_a;
    mapping(bytes32 => bytes32) storage_map_g;
    bytes32 store_m;
    bytes32 store_n;
    mapping(bytes32 => bytes32) storage_map_j;
    uint256 public totalSupply;
    address public owner;
    mapping(bytes32 => bytes32) storage_map_i;
    uint256 public currentId;
    mapping(bytes32 => bytes32) storage_map_e;
    mapping(bytes32 => bytes32) storage_map_l;
    mapping(bytes32 => bytes32) storage_map_o;
    
    event Approval(address, address, uint256);
    event Transfer(address, address, uint256);
    event ApprovalForAll(address, address, bool);
    event OwnershipTransferred(address, address);
    
    /// @custom:selector    0x095ea7b3
    /// @custom:signature   approve(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function approve(address arg0, uint256 arg1) public payable {
        require(arg0 == (address(arg0)));
        uint256 var_d = arg1;
        require(storage_map_a[var_d], "");
        require(storage_map_a[var_d], "");
        require(address(arg0) - (address(storage_map_a[var_d])), "");
        require(address(storage_map_a[var_d]) == msg.sender, "");
        var_d = address(msg.sender);
        require(bytes1(storage_map_a[var_d]), "");
        var_d = arg1;
        storage_map_a[var_d] = (address(arg0)) | (uint96(storage_map_a[var_d]));
        var_a = 0x60 + var_a;
        var_d = arg1;
        require(storage_map_a[var_d], "");
        require(storage_map_a[var_d], "");
        emit Approval(address(storage_map_a[var_d]), address(arg0), arg1);
        require(address(storage_map_a[var_d]) == msg.sender, "ERC721: approve caller is not owner nor approved for all");
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   renounceOwnership() public payable
    function renounceOwnership() public payable {
        require(msg.sender == (address(owner)), "Ownable: caller is not the owner");
        emit OwnershipTransferred(address(owner), 0);
        owner = uint96(owner);
    }
    
    /// @custom:selector    0xb1e130fc
    /// @custom:signature   revokeApproval(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function revokeApproval(uint256 arg0) public payable {
        require(store_d - 0x02, "ReentrancyGuard: reentrant call");
        store_d = 0x02;
        uint256 var_e = arg0;
        require(storage_map_e[var_e], "Media: caller not approved address");
        var_e = arg0;
        require(address(msg.sender) == (address(storage_map_e[var_e])), "Media: caller not approved address");
        var_e = arg0;
        storage_map_e[var_e] = 0 | (uint96(storage_map_e[var_e]));
        uint256 var_h = 0x60 + var_h;
        var_e = arg0;
        require(storage_map_e[var_e], "");
        require(storage_map_e[var_e], "");
        emit Approval(address(storage_map_e[var_e]), 0, arg0);
        store_d = 0x01;
    }
    
    /// @custom:selector    0x2f745c59
    /// @custom:signature   tokenOfOwnerByIndex(address arg0, uint256 arg1) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function tokenOfOwnerByIndex(address arg0, uint256 arg1) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_a = address(arg0);
        require(arg1 < (storage_map_f[var_a]));
        var_a = 0 + keccak256(var_a);
        return storage_map_g[var_a];
    }
    
    /// @custom:selector    0x8093f3eb
    /// @custom:signature   _minter(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function _minter(address arg0) public view returns (bool) {
        require(arg0 == (address(arg0)));
        address var_b = arg0;
        return !(!bytes1(storage_map_i[var_b]));
    }
    
    /// @custom:selector    0x01ffc9a7
    /// @custom:signature   supportsInterface(bytes4 arg0) public view returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function supportsInterface(bytes4 arg0) public view returns (bool) {
        require(arg0 == (uint32(arg0)));
        uint32 var_a = uint32(arg0);
        return !(!bytes1(storage_map_j[var_a]));
    }
    
    /// @custom:selector    0xe985e9c5
    /// @custom:signature   Unresolved_e985e9c5(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e985e9c5(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0xc87b56dd
    /// @custom:signature   tokenURI(uint256 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function tokenURI(uint256 arg0) public view returns (bytes memory) {
        uint256 var_a = arg0;
        require(storage_map_j[var_a], "ERC721Metadata: URI query for nonexistent token");
        require(bytes1(store_k), "ERC721Metadata: URI query for nonexistent token");
        require(bytes1(store_k) - ((store_k >> 0x01) < 0x20), "ERC721Metadata: URI query for nonexistent token");
        uint256 var_d = var_d + (0x20 + (((0x1f + (store_k >> 0x01)) / 0x20) * 0x20));
        require(bytes1(store_k), "ERC721Metadata: URI query for nonexistent token");
        require(bytes1(store_k) - ((store_k >> 0x01) < 0x20), "ERC721Metadata: URI query for nonexistent token");
        require(!(store_k >> 0x01), "ERC721Metadata: URI query for nonexistent token");
        require(0x1f < (store_k >> 0x01), "ERC721Metadata: URI query for nonexistent token");
        var_a = 0x0a;
        require((0x20 + var_d) + (store_k >> 0x01) > (0x20 + (0x20 + var_d)), "ERC721Metadata: URI query for nonexistent token");
        return abi.encodePacked(0x20, var_d.length);
    }
    
    /// @custom:selector    0xe26882d5
    /// @custom:signature   isTokenExist(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function isTokenExist(uint256 arg0) public view returns (bool) {
        uint256 var_a = arg0;
        return storage_map_j[var_a];
    }
    
    /// @custom:selector    0xa22cb465
    /// @custom:signature   Unresolved_a22cb465(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_a22cb465(address arg0, uint256 arg1) public payable {
        require(arg0 == (address(arg0)));
        require(arg1 == arg1);
        require(address(arg0) - msg.sender, "ERC721: approve to caller");
        var_a = address(arg0);
        storage_map_j[var_a] = arg1 | (uint248(storage_map_j[var_a]));
        emit ApprovalForAll(msg.sender, address(arg0), arg1);
    }
    
    /// @custom:selector    0x6352211e
    /// @custom:signature   ownerOf(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function ownerOf(uint256 arg0) public view returns (address) {
        uint256 var_a = 0x60 + var_a;
        uint256 var_d = arg0;
        require(storage_map_a[var_d], "");
        require(storage_map_a[var_d], "");
        return address(storage_map_a[var_d]);
    }
    
    /// @custom:selector    0x4f6ccce7
    /// @custom:signature   tokenByIndex(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function tokenByIndex(uint256 arg0) public view returns (uint256) {
        require(arg0 < totalSupply);
        uint256 var_a = storage_map_l[var_a];
        return storage_map_l[var_a];
    }
    
    /// @custom:selector    0x06fdde03
    /// @custom:signature   name() public view returns (string memory)
    function name() public view returns (string memory) {
        if (store_m) {
            if (store_m - ((store_m >> 0x01) < 0x20)) {
                uint256 var_c = var_c + (0x20 + (((0x1f + (store_m >> 0x01)) / 0x20) * 0x20));
                if (store_m) {
                    if (store_m - ((store_m >> 0x01) < 0x20)) {
                        if (!store_m >> 0x01) {
                            if (0x1f < (store_m >> 0x01)) {
                                var_a = 0x07;
                                if ((0x20 + var_c) + (store_m >> 0x01) > (0x20 + (0x20 + var_c))) {
                                    return abi.encodePacked(0x20, var_c.length);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x95d89b41
    /// @custom:signature   symbol() public view returns (string memory)
    function symbol() public view returns (string memory) {
        if (store_n) {
            if (store_n - ((store_n >> 0x01) < 0x20)) {
                uint256 var_c = var_c + (0x20 + (((0x1f + (store_n >> 0x01)) / 0x20) * 0x20));
                if (store_n) {
                    if (store_n - ((store_n >> 0x01) < 0x20)) {
                        if (!store_n >> 0x01) {
                            if (0x1f < (store_n >> 0x01)) {
                                var_a = 0x08;
                                if ((0x20 + var_c) + (store_n >> 0x01) > (0x20 + (0x20 + var_c))) {
                                    return abi.encodePacked(0x20, var_c.length);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x8c268689
    /// @custom:signature   Unresolved_8c268689(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_8c268689(uint256 arg0) public payable {
        require(!arg0 > 0xffffffffffffffff);
        require(!(arg0 > 0xffffffffffffffff), "Ownable: caller is not the owner");
        require(!(((var_c + (uint248(0x3f + (arg0 + 0x1f)))) < var_c) | ((var_c + (uint248(0x3f + (arg0 + 0x1f)))) > 0xffffffffffffffff)), "Ownable: caller is not the owner");
        uint256 var_c = var_c + (uint248(0x3f + (arg0 + 0x1f)));
        require(msg.sender == (address(owner)), "Ownable: caller is not the owner");
        require(!var_c.length > 0xffffffffffffffff);
        require(bytes1(store_k));
        require(bytes1(store_k) - ((store_k >> 0x01) < 0x20));
        require(!(store_k >> 0x01) > 0x1f);
        var_a = 0x0a;
        require(!var_c.length < 0x20);
        require(!(keccak256(var_a) + ((var_c.length + 0x1f) >> 0x05)) < (keccak256(var_a) + (((store_k >> 0x01) + 0x1f) >> 0x05)));
        require((var_c.length > 0x1f) == 0x01);
        var_a = 0x0a;
        require(!0 < (uint248(var_c.length)));
        require(!(uint248(var_c.length)) < var_c.length);
        storage_map_j[var_a] = (~(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff >> (bytes1(var_c.length << 0x03)))) & (var_j);
        store_k = (var_c.length << 0x01) + 0x01;
        store_k = (var_c.length << 0x01) + 0x01;
        require(!var_c.length);
        store_k = (var_c.length << 0x01) | (~(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff >> (var_c.length << 0x03)) & (var_j));
        store_k = (var_c.length << 0x01) | (~(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff >> (var_c.length << 0x03)) & (0));
    }
    
    /// @custom:selector    0xb88d4fde
    /// @custom:signature   Unresolved_b88d4fde(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b88d4fde(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x081812fc
    /// @custom:signature   getApproved(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function getApproved(uint256 arg0) public view returns (address) {
        uint256 var_a = arg0;
        require(storage_map_j[var_a], "ERC721: approved query for nonexistent token");
        var_a = arg0;
        return address(storage_map_j[var_a]);
    }
    
    /// @custom:selector    0x23b872dd
    /// @custom:signature   Unresolved_23b872dd(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_23b872dd(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x368e0956
    /// @custom:signature   Unresolved_368e0956(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_368e0956(address arg0, uint256 arg1) public payable {
        require(arg0 == (address(arg0)));
        require(arg1 == arg1);
        require(msg.sender == (address(owner)), "Ownable: caller is not the owner");
        address var_e = address(arg0);
        storage_map_e[var_e] = arg1 | (uint248(storage_map_e[var_e]));
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   transferOwnership(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function transferOwnership(address arg0) public payable {
        require(arg0 == (address(arg0)));
        require(msg.sender == (address(owner)), "Ownable: caller is not the owner");
        require(address(arg0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(address(owner), address(arg0));
        owner = (address(arg0)) | (uint96(owner));
    }
    
    /// @custom:selector    0x70a08231
    /// @custom:signature   balanceOf(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function balanceOf(address arg0) public view returns (uint256) {
        require(arg0 == (address(arg0)));
        require(address(arg0), "ERC721: balance query for the zero address");
        address var_a = address(arg0);
        return storage_map_j[var_a];
    }
    
    /// @custom:selector    0x6c0360eb
    /// @custom:signature   baseURI() public view returns (bytes memory)
    function baseURI() public view returns (bytes memory) {
        if (store_k) {
            if (store_k - ((store_k >> 0x01) < 0x20)) {
                uint256 var_c = var_c + (0x20 + (((0x1f + (store_k >> 0x01)) / 0x20) * 0x20));
                if (store_k) {
                    if (store_k - ((store_k >> 0x01) < 0x20)) {
                        if (!store_k >> 0x01) {
                            if (0x1f < (store_k >> 0x01)) {
                                var_a = 0x0a;
                                if ((0x20 + var_c) + (store_k >> 0x01) > (0x20 + (0x20 + var_c))) {
                                    return abi.encodePacked(0x20, var_c.length);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x42842e0e
    /// @custom:signature   Unresolved_42842e0e(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_42842e0e(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x42966c68
    /// @custom:signature   burn(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function burn(uint256 arg0) public payable {
        require(store_d - 0x02, "ReentrancyGuard: reentrant call");
        store_d = 0x02;
        uint256 var_e = arg0;
        require(storage_map_e[var_e], "Media: Only approved or owner");
        var_e = arg0;
        require(storage_map_e[var_e], "Media: Only approved or owner");
        uint256 var_g = 0x60 + var_g;
        var_e = arg0;
        require(storage_map_e[var_e], "Media: Only approved or owner");
        require(storage_map_e[var_e], "Media: Only approved or owner");
        require(address(msg.sender) == (address(storage_map_e[var_e])), "Media: Only approved or owner");
        var_e = arg0;
        require(storage_map_e[var_e], "Media: Only approved or owner");
        var_e = arg0;
        require(address(storage_map_e[var_e]) == (address(msg.sender)), "Media: Only approved or owner");
        var_e = address(msg.sender);
        require(bytes1(storage_map_e[var_e]), "Media: Only approved or owner");
        require(address(storage_map_e[var_e]) == (address(msg.sender)), "Media: Only approved or owner");
    }
    
    /// @custom:selector    0x9ca89d1c
    /// @custom:signature   Unresolved_9ca89d1c(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9ca89d1c(address arg0) public pure {
        require(arg0 == (address(arg0)));
    }
    
    /// @custom:selector    0x6a627842
    /// @custom:signature   mint(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function mint(address arg0) public payable returns (uint256) {
        require(arg0 == (address(arg0)));
        address var_a = msg.sender;
        require(bytes1(storage_map_j[var_a]), "ERC721: token already minted");
        require(currentId + 0x01, "ERC721: token already minted");
        currentId = 0x01 + currentId;
        require(address(arg0), "ERC721: token already minted");
        var_a = currentId;
        require(!storage_map_j[var_a], "ERC721: token already minted");
        var_a = currentId;
        require(storage_map_j[var_a], "ERC721: mint to the zero address");
        var_a = currentId;
        storage_map_j[var_a] = address(arg0);
        var_a = currentId;
        require(storage_map_j[var_a], "ERC721: mint to the zero address");
        emit Transfer(0, address(arg0), currentId);
        return currentId;
        totalSupply = 0x01 + totalSupply;
        var_a = 0x02;
        storage_map_o[var_a] = currentId;
        var_a = currentId;
        storage_map_j[var_a] = totalSupply;
        emit Transfer(0, address(arg0), currentId);
        return currentId;
    }
    
    /// @custom:selector    0x0b81e216
    /// @custom:signature   Unresolved_0b81e216(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_0b81e216(uint256 arg0) public payable {
        require(arg0 == arg0);
        require(msg.sender == (address(owner)), "Ownable: caller is not the owner");
        store_p = arg0 | (uint248(store_p));
    }
    
    /// @custom:selector    0x18e97fd1
    /// @custom:signature   Unresolved_18e97fd1(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_18e97fd1(uint256 arg0, uint256 arg1) public payable {
        require(!arg1 > 0xffffffffffffffff);
        require(!(arg1) > 0xffffffffffffffff);
        require(store_d - 0x02, "ReentrancyGuard: reentrant call");
        store_d = 0x02;
        address var_e = msg.sender;
        require(bytes1(storage_map_e[var_e]), "ERC721Metadata: URI set of nonexistent token");
        uint256 var_g = var_g + (0x20 + (((0x1f + (arg1)) / 0x20) * 0x20));
        var_e = arg0;
        require(storage_map_e[var_e], "ERC721Metadata: URI set of nonexistent token");
        require(!(var_g.length > 0xffffffffffffffff), "ERC721Metadata: URI set of nonexistent token");
        var_e = 0x4e487b7100000000000000000000000000000000000000000000000000000000;
        require(bytes1(storage_map_e[var_e]), "ERC721Metadata: URI set of nonexistent token");
        require(bytes1(storage_map_e[var_e]) - ((storage_map_e[var_e] >> 0x01) < 0x20), "ERC721Metadata: URI set of nonexistent token");
        var_e = 0x4e487b7100000000000000000000000000000000000000000000000000000000;
        require(!((storage_map_e[var_e] >> 0x01) > 0x1f), "ERC721Metadata: URI set of nonexistent token");
        var_e = keccak256(var_e);
        require(!(var_g.length < 0x20), "ERC721Metadata: URI set of nonexistent token");
        require(!(keccak256(var_e) + ((var_g.length + 0x1f) >> 0x05) < (keccak256(var_e) + (((storage_map_e[var_e] >> 0x01) + 0x1f) >> 0x05))), "ERC721Metadata: URI set of nonexistent token");
        require((var_g.length > 0x1f) == 0x01, "ERC721Metadata: URI set of nonexistent token");
        var_e = keccak256(var_e);
        require(!(0 < (uint248(var_g.length))), "ERC721Metadata: URI set of nonexistent token");
        require(!(uint248(var_g.length) < var_g.length), "ERC721Metadata: URI set of nonexistent token");
        storage_map_e[var_e] = (~(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff >> (bytes1(var_g.length << 0x03)))) & (var_k);
        storage_map_e[var_e] = (var_g.length << 0x01) + 0x01;
        store_d = 0x01;
        storage_map_e[var_e] = (var_g.length << 0x01) + 0x01;
        store_d = 0x01;
        require(!var_g.length, "ERC721Metadata: URI set of nonexistent token");
        storage_map_e[var_e] = (var_g.length << 0x01) | (~(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff >> (var_g.length << 0x03)) & (var_k));
        store_d = 0x01;
        storage_map_e[var_e] = (var_g.length << 0x01) | (~(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff >> (var_g.length << 0x03)) & (0));
        store_d = 0x01;
    }
}