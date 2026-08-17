# STYNODE node NFTs (ERC721) — UNVERIFIED

Recovered by decompilation. Runtime bytecode (sha256 `15d48deb…`) is byte-identical across three
deployments:
- `0xec1822f4ca5060d2740f1114b7ca44f3fba99933` — name `STYNODE1`, totalSupply 376
- `0x03151771ee8b335bb3c0772f8a35e03b323c7560` — name `STYNODE2`, totalSupply 250
- `0x3d980e120e30e87fc203098785fff42681bfb743` — name `STYNODE2`, totalSupply 71

**Role.** Node membership tokens. `FeeOwnerNode` / `NodeStoreH` read holders' `balanceOf` and
`tokenOfOwnerByIndex` to determine reward eligibility/tier.

**Authority.** `owner`/minter = `0xd8d76d04da5ec32d84edbd560916b1edd2194e8f` (deployer). `mint(address)`
is `onlyMinter` (sim: `Media:Only Minter can mint`); `burn` is approved/owner-gated. Standard ERC721
surface otherwise (`ownerOf`, `transferFrom`, `approve`, `tokenURI`, `baseURI`).
