# Unresolved / open items

Everything in the token's value path was recovered to readable form (verified source or
decompilation + constants + simulation). The items below are what genuinely resists that, each with
the specific question it leaves open and the evidence that bounds it.

## Blockers on nothing — but worth an auditor's eyes

### U1. Reward-pool decompilations are behavioural, not source-exact
**What.** `MinerRewardContract`, `FeeOwnerNode`, `FeeOwnerTeam` (+ its 8 clones), the reward-pool
variant, `NodeStoreH`, `MinerReward_helper`, and the STYNODE NFT are **unverified**; we hold
heimdall decompilations, ABIs, and extracted constants, not original source.
**Open question.** The decompiled control-flow is noisy (heimdall emits pseudo-Solidity); exact
arithmetic of the reward accounting (`reward1/2/3`, `store_l` scaling, per-power math) can be read in
intent but not compiled and diffed line-for-line.
**Bounded by.** Full ABIs recovered; all privileged/guarded entry points simulated and revert
correctly (`recon/simulation/SIMULATION.md`); embedded-constants scan found **no hardcoded secrets**
— only event topics, SafeMath strings, storage-hash words, and (in FeeOwnerNode/NodeStoreH) the
three STYNODE NFT addresses. These are fee-sink/staking contracts **downstream** of the token; none
can mint STY or move the pair.

### U2. Off-chain reward-claim signer key `0xa22ceb70…` — custody unknown
**What.** The three reward pools pay out on `ecrecover == 0xa22ceb70…` (a plain EOA).
**Open question.** Is that key held safely, or reused/leaked? Simulation can't tell — a forged sig
reverts either way.
**Bounded by.** Key is an EOA (off-chain, not compiled into bytecode); owner `0x33992f55` can rotate
it via `setSigner`. See OFFCHAIN_COMPONENTS.md §1.

### U3. Off-chain LP-redemption signer key `0xdEb4E4ed…` — custody unknown, **cannot be rotated**
**What.** `LiquidityHolder.ReedeemLP` releases custodied LP (~1.447M LP) on `ecrecover == _signer`.
**Open question.** Same custody question as U2, but **worse**: LiquidityHolder's owner is renounced,
so if this key leaks it can never be changed, and payouts are capped only by the same backend's
`totalAdded` accounting.
**Bounded by.** EOA off-chain; redemption bounded by `userTaked+send+burn ≤ totalAdded`, and
`totalAdded` only grows through BigPool's real-USDT `AddLiqlidity`. See OFFCHAIN_COMPONENTS.md §2.

### U4. Historical event logs not retrievable in this environment
**What.** `eth_getLogs` for the reward pools / LiquidityHolder was blocked on the public BSC RPCs
reachable here (Etherscan V2 free tier rejects BSC `logs`/`txlist`; public nodes returned
`limit exceeded` / 403 for ranged log queries).
**Open question.** The one piece of evidence that would bound U2/U3 empirically — *do the historical
claim/redeem payouts match a sane policy?* — is not captured.
**Next step for the auditor.** With a funded BscScan Pro key or an archive node, pull
`ReedeemLP`/reward-claim tx history for `0xccb4…91db`, `0x7589…1a88`, `0x0246…9223`, `0x955c…f2ab`
and reconcile amounts/recipients/cadence against the signed-message schema in the code. Everything
needed to do this (schemas, addresses, function selectors) is in this repo.

### U5. Unidentified 32-byte constants in MinerRewardContract bytecode
**What.** `embedded_constants.json` for MinerReward lists several 32-byte PUSH values that are not
event topics or ASCII (`0x17aca8c1…`, `0x774f910d…`, `0x8deac83b…`, `0xa810a581…`).
**Open question.** Most likely `keccak256` storage-slot bases for the many mappings (consistent with
the decompiled storage layout), i.e. benign. Not proven to be non-secret.
**Bounded by.** None resolve to a known signature; they don't appear as addresses; the guarded
functions that would use a "secret" all still require an EOA signature or an owner/caller check
(simulated, all revert). No value-bearing path was found that trusts one of these words directly.

## Explicitly NOT unresolved (so the auditor doesn't re-chase them)

- **FeeCutter** — unverified on BscScan, but its source is the `FeeCutter` contract inside the
  verified `STYTOKEN.sol`, and its runtime selectors match by decompilation. Treated as source-known.
- **The pair, router, factory, USDT, Gnosis Safe singleton** — canonical, verified, identity
  confirmed on-chain (INTEGRITY.md).
- **Token admin surface** — `owner()==0`; every `onlyOwner` setter is permanently uncallable
  (simulated: all `018001`). No proxy/upgrade path (Proxy:0, no EIP-1967 slots).
- **Clone families** — the 8 reward-pool clones and 3 NFT clones are byte-identical to a shape
  recovered once; verified by sha256 (MAP.md §5).

## Scope note
The graph resolved in ~25 addresses and stopped growing there. That is the whole of what the token
reaches and what reaches it — small because the target is a self-contained token+pool+reward system,
not because the search was cut short.
