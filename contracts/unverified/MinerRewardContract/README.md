# MinerRewardContract — 0x758905b399f4216e9e3ff791eea16c05c91a1a88 (UNVERIFIED)

Recovered by decompilation (heimdall v0.9.2). Staking + reward hub.

**Role / value in path.** Target address of `STYTOKEN.cutAmmPoolToMinerReward()` (1% of the pair's
STY per 12h round) and of FeeCutter `addReward` calls. Holds **217,919 STY** (live). Is BigPool's
`_locker` and LiquidityHolder's `caller` — i.e. it drives the liquidity lifecycle.

**Entry points (from ABI + simulation):**
- `order(uint256)` — permissionless staking (requires `amount>100`; pulls caller's STY). Confirmed
  reachable by an unprivileged caller (reverts only on token balance).
- signature-gated claim path — `ecrecover` against `signer`.
- `addReward(uint256)` — `onlyCaller`.
- `setSigner(address)` — `onlyOwner` (reverts `018001` for others).

**Live authority:** owner `0x33992f55…117063`; signer `0xa22ceb70…6ae1b` (slot20, EOA — off-chain
key, see docs/OFFCHAIN_COMPONENTS.md §1). References MarketMaker, BigPool, LiquidityHolder, College
Safe, FeeOwnerNode, a reward-treasury Safe, and reward-pool clones.

**Constants:** `embedded_constants.json` — event topics + SafeMath strings + several unidentified
32-byte words (likely mapping storage-slot bases; see docs/UNRESOLVED.md U5). No hardcoded secret found.
