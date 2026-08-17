# FeeOwnerNode — 0x024647750c9b261960fbaf61899f25346cb19223 (UNVERIFIED)

Recovered by decompilation. Node reward pool.

**Role / value.** USDT recipient from FeeCutter (CutSellFee 1/5, CutProfit 1/5) + `addReward`.
Holds **16,934 USDT** (live). `claim(uint256,uint256,uint256,string)` pays out on
`ecrecover == signer`; the claim logic reads `balanceOf`/`tokenOfOwnerByIndex` on THREE hardcoded
STYNODE NFT contracts (node membership gates eligibility).

**Hardcoded in bytecode (see embedded_constants.json):**
`0xec1822…9933` (STYNODE1), `0x031517…7560` (STYNODE2), `0x3d980e…b743` (STYNODE2) — all ERC721,
minter `0xd8d76d04`. Also calls a helper `NodeStoreH` (`0xcaec…21f5`, slot9).

**Live authority:** owner `0x33992f55…117063`; signer `0xa22ceb70…6ae1b` (slot5, EOA — off-chain key).

Simulation: `addReward` → `Only caller can call this function`; `setSigner` → `018001`;
`claim` with forged sig → `reward: no order information`. Guards present.
