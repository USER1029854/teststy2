# Trust-graph map — STYTOKEN (SWAN TREASURY / STY)

- **Chain:** BNB Smart Chain (BSC) mainnet, chainId 56
- **Target token:** `0xD6A4F5AADD88ebA9A170AcF67f737BD488142857` (STYTOKEN, symbol `STY`, 18 dec, supply 9,999,990)
- **Target pair (given):** `0x2BE23D76F423bf464F310aD98749d82691Ecc830` (PancakeSwap V2 STY/USDT)
- Machine-readable index of every address: [`../recon/ADDRESS_CENSUS.json`](../recon/ADDRESS_CENSUS.json)

The graph resolved to **~25 addresses**. Everything the token's code reaches, and everything that
holds power over it, is either saved as verified source or recovered by decompilation. Nothing in
the value path is left as an opaque blob.

---

## 1. What the token *is* (one paragraph)

STY is a hand-rolled BEP20 (its own balance/allowance logic, custom `Ownable`, its own SafeMath —
**not** an OZ/standard token). Its `_transfer` is where all the action is: on buys and sells against
the Pancake pair it skims fees to a **FeeCutter**, applies a dynamic sell-burn and a "profit cut,"
tracks a per-holder `holdPrice`, and gates public buying behind an `isOpenBuy` switch. A separate
permissionless `cutAmmPoolToMinerReward()` skims 1% of the pair's STY every 12h to a miner-reward
contract. Token ownership is **renounced**, so the fee/reward *wiring* is frozen — but the contracts
it points to are where authority and value actually live.

## 2. Outbound graph — everything the token leans on

```
STYTOKEN (0xD6A4…2857)  [verified]  contracts/target/
 ├─ pancakeRouter  → PancakeRouter V2 (0x10ED…24E)         [verified, canonical]   contracts/external/PancakeRouterV2/
 ├─ factory        → PancakeFactory V2 (0xcA14…c73)        [verified, canonical]   contracts/external/PancakeFactoryV2/
 ├─ pancakePair    → PancakePair STY/USDT (0x2BE2…830)     [verified, canonical]   contracts/pair/
 ├─ usdt           → Binance-Peg BSC-USD (0x55d3…955)      [verified, canonical]   contracts/external/USDT_BEP20/
 ├─ feecutter      → FeeCutter (0x729d…12d0)               [UNVERIFIED; src known] contracts/unverified/FeeCutter/
 │    ├─ swaps STY→USDT via router, distributes to:
 │    ├─ FeeOwnerCollege (0xf255…512c)   Gnosis Safe 2/2   [verified]  contracts/authorities/FeeOwnerCollege_GnosisSafeProxy/
 │    ├─ FeeOwnerNode    (0x0246…9223)   reward pool       [UNVERIFIED → decompiled]  contracts/unverified/FeeOwnerNode/
 │    ├─ FeeOwnerTeam    (0x955c…f2ab)   reward pool       [UNVERIFIED → decompiled]  contracts/unverified/FeeOwnerTeam/
 │    ├─ TeamA           (0x492c…1929)   MarketMaker       [verified]  contracts/core/MarketMaker_MarketNumber1/
 │    └─ TeamB           (0x5205…c522)   Gnosis Safe 2/2   [verified]  contracts/authorities/TeamB_GnosisSafeProxy/
 └─ MinerRewardContract → (0x7589…1a88) staking/reward hub [UNVERIFIED → decompiled]  contracts/unverified/MinerRewardContract/
      ├─ references MarketMaker, BigPool, LiquidityHolder, College Safe, FeeOwnerNode
      ├─ references a Reward-treasury Gnosis Safe 2/2 (0x5f51…92e8)  [verified]  contracts/authorities/RewardTreasury_5f5149_GnosisSafeProxy/
      ├─ references a small helper (0x3c9b…fd00)   [UNVERIFIED → decompiled]  contracts/unverified/MinerReward_helper/
      └─ references reward-pool clones (see §5)
```

### The FeeCutter money flow (the token's fee engine)

FeeCutter's source is present inside the verified `STYTOKEN.sol` (same file), so it is readable
even though its own deployment is unverified. Behaviour, per cut:

- **CutBuyFee** — sells all STY it holds → USDT to **FeeOwnerCollege**.
- **CutSellFee(amt)** — sells `amt` STY → USDT, splits: 1/5 College, 1/5 Node (+`addReward`), 3/5 Team (+`addReward`).
- **cutSellBurn(amt)** — 40% of the burn-cut STY to **TeamA (MarketMaker)**, 60% to **College**.
- **CutProfit(amt)** — sells `amt` STY → USDT, splits: 2/5 College, 1/5 TeamB, 1/5 Team (+`addReward`), 1/5 Node (+`addReward`).

`superowner` (deployer `0xd8d76d04`) can `setAddresses` to change **every** recipient above — this is
the single biggest live authority over where token fees go (see OFFCHAIN_COMPONENTS.md §4).

## 3. Core protocol contracts (verified) — what they do

| Contract | Address | Role | Location |
|---|---|---|---|
| MarketMaker (MarketNumber1) | `0x492c…1929` | `AutoBuy/AutoSell` (onlyCaller) defend price band via router; STY burn-cut sink | `contracts/core/MarketMaker_MarketNumber1/` |
| BigPool (OrderBIGPOOL) | `0xdb2d…143d` | Holds **77% of STY**; `AddLiqlidity` (onlyLocker=MinerReward) pairs its STY with incoming USDT into LP → LiquidityHolder | `contracts/core/BigPool_OrderBIGPOOL/` |
| LiquidityHolder (LiqlidityHolder) | `0xccb4…91db` | Custodies ~1.447M LP; `ReedeemLP` (signature-gated) removes liquidity, pays USDT to user | `contracts/core/LiquidityHolder_LiqlidityHolder/` |

Liquidity lifecycle: **BigPool** (STY) + user USDT → **PancakeRouter.addLiquidity** → LP to
**LiquidityHolder** → later **LiquidityHolder.ReedeemLP** (off-chain signer approves) → USDT back to
user, STY back to BigPool. The reward hub (**MinerReward**) is the `locker`/`caller` that drives it.

## 4. Inbound graph — who holds power *over* the token / its value

Token `owner` is `0x0` (renounced) so there is **no mint, no blacklist, no fee-change** authority
left on the token itself. Power that remains, ranked by reach:

1. **FeeCutter superowner `0xd8d76d04`** — retarget all fee recipients; authorize new FeeCutter operators.
2. **Reward-pool owner `0x33992f55`** — `setSigner` on Miner/Node/Team ⇒ controls who can authorize reward payouts.
3. **Reward signer `0xa22ceb70`** (EOA) — signs reward claims (drains reward-pool balances if key leaks).
4. **LP signer `0xdEb4E4ed`** (EOA) — signs LP redemptions (drains custodied LP if key leaks); **cannot be rotated** (LiquidityHolder owner renounced).
5. **NFT owner/minter `0xd8d76d04`** — mints STYNODE NFTs that gate Node-reward eligibility.
6. **Gnosis Safe 2-of-2 (`0x765e80ac` + `0xddb8749d`)** — controls the College / TeamB / Reward-treasury balances.

None of these can mint STY or move the pair's reserves directly. The route to BigPool's 77% of
supply is **through the reward flow** (MinerReward `locker` → BigPool `AddLiqlidity`), so the reward
subsystem's keys (#2/#3) are the practical crown jewels. Full detail: `AUTHORITY_AND_CONFIG_STATE.md`
and `OFFCHAIN_COMPONENTS.md`.

## 5. Reward / staking subsystem (downstream of fees) — clone census

MinerReward is the hub of a node-staking + reward-claim subsystem. Its periphery is a family of
byte-identical clones. Identical bytecode verified/recovered once ⇒ readable everywhere:

| Shape (sha256[:12]) | Instances | Recovered at | Notes |
|---|---|---|---|
| `0a135c5a5bfe` FeeOwnerTeam-shape reward pool | **8**: `0x955c…f2ab` (Team), `0x473a…c7cf`, `0x8a73…1eee`, `0xb091…2aa7`, `0x2e19…b6cd`, `0xc378…5b35`, `0x5ba6…0335`, `0x244f…6cfc` | `contracts/unverified/FeeOwnerTeam/` | signature-gated claim pools |
| `300bb116f1a7` reward-pool variant | 1: `0x97c1…075d` | `contracts/unverified/MinerReward_rewardpool_variant_97c1d9/` | distinct bytecode, same size |
| `15d48debf9a1` STYNODE ERC721 | **3**: `0xec18…9933` (NODE1), `0x0315…7560` (NODE2), `0x3d98…b743` (NODE2) | `contracts/unverified/NodeNFT_STYNODE/` | node membership NFTs, minter = `0xd8d76d04` |
| `d59efee138e1` NodeStoreH | 1: `0xcaec…21f5` | `contracts/unverified/NodeStoreH/` | helper referenced by FeeOwnerNode |
| `1c012d799986` MinerReward helper | 1: `0x3c9b…fd00` | `contracts/unverified/MinerReward_helper/` | small helper |
| GnosisSafeProxy → v1.3.0 | 3: College, TeamB, Reward-treasury `0x5f51…92e8` | `contracts/authorities/` | 2-of-2, same owners |

These are **downstream fee sinks / staking accounting** — they receive value from the token/FeeCutter
and let users stake (`order`) and claim (signature-gated). None can mint STY or touch the pair's
reserves. They are recovered and named here for completeness; the security-critical facts about them
(shared owner/signer EOAs, balances) are in the state and off-chain docs.

## 6. Where to read each thing

- Verified source (target + core + external): `contracts/target/`, `contracts/core/`, `contracts/external/`, `contracts/pair/`, `contracts/authorities/`
- Recovered behaviour for unverified contracts: `contracts/unverified/<Name>/` — each has
  `recovered.decompiled.sol`, `recovered.abi.json`, `runtime.bytecode.hex`, `embedded_constants.json`.
- Selector resolution for decompiled functions: `recon/decompiled/_selector_resolution.json` (openchain) + `_selector_computed.json`.
- Live state: `docs/AUTHORITY_AND_CONFIG_STATE.md`. Simulation: `recon/simulation/SIMULATION.md`.
- Integrity of standard pieces: `docs/INTEGRITY.md`. Off-chain trust: `docs/OFFCHAIN_COMPONENTS.md`.
- What's still open: `docs/UNRESOLVED.md`.
- Reproduction scripts: `recon/scripts/`.
