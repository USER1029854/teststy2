# Live authority & configuration state

Read live from BSC mainnet at ~block **116,442,814** (2026-08-17). Re-read before relying on
any value; balances and `isOpenBuy` change every trade. Raw reads are reproducible with the
scripts in `recon/scripts/` (`rpc.py`, `simulate.py`).

## 1. Token (STYTOKEN `0xD6A4…2857`) — authority

| Field | Slot / getter | Live value | Meaning |
|---|---|---|---|
| `owner` | slot 0 / `owner()` | `0x0000…0000` | **Ownership RENOUNCED.** All `onlyOwner` setters (`setFeeCutter`, `setMinerRewardContract`, `setExcludeFromFee`, `setStartMineTime`, `createPair`) are permanently uncallable. Config below is frozen. |
| `pancakeRouter` | slot 8 / getter | `0x10ED43C7…24E` | Canonical PancakeRouter V2 |
| `pancakePair` | slot 9 / getter | `0x2BE23D76…830` | STY/USDT pair |
| `feecutter` | slot 17 (private) | `0x729d05b4…d0` | FeeCutter (unverified; source known) |
| `MinerRewardContract` | slot 14 (private) | `0x758905b3…88` | Miner reward hub (unverified) |
| `usdt` | immutable | `0x55d39832…55` | Binance-Peg BSC-USD |

## 2. Token — configuration / parameters

| Parameter | Live value | Notes / coherence check |
|---|---|---|
| `totalSupply()` | 9,999,990 STY | Constructor minted to `tx.origin` (deployer). Fixed; no `mint` path exists. |
| `decimals()` | 18 | — |
| `isOpenBuy()` | **false** | Public buys are BLOCKED until a buy sees pair USDT-reserve `r0 > 14,000,000e18`. Current `r0 ≈ 1.58M` USDT, so this will **not** flip soon. Only `isExcludedFromFee` recipients can currently buy. ⚠️ Live constraint an auditor must know. |
| `maxPoolUsdt()` | 1,786,627 USDT | High-water mark of pair USDT reserve. |
| `getCurrentPrice()` | ≈ 2.72 USDT/STY | `rUSDT*1e18/rSTY` from the pair. |
| `startminetime` | 1,782,561,600 (2026-06-27) | In the past ⇒ `cutAmmPoolToMinerReward()` mining is live. Constructor default was 1,782,475,200; it was moved +1 day via `setStartMineTime` before renounce. |
| `getDay()` | 68 | Day counter since epoch 1,781,049,600. |
| `getCutRound()` | 136 | 12-hour round counter (same epoch). |
| Buy fee | 2% (`amount/50`) | → FeeCutter, on `sender==pair` non-excluded buys. |
| Sell fee | 5% (`amount/20`) | → FeeCutter, on `recipient==pair` non-excluded sells; triggers `CutSellFee`. |
| Dynamic sell burn | 0–50% | `_getSellBurnRate`: 0 if post-price ≥ 97% of day-open; 50% if <93%; linear `(97-ratio)*10` between. |
| Profit cut | 25% of gain | `CalcProfit`: on any transfer where `holdPrice[sender] < nowprice`, 1/4 of the price-gain portion is cut. |
| Pool skim | 1% per 12h round | `cutAmmPoolToMinerReward()` (permissionless) moves 1% of the pair's STY balance to MinerReward and `sync()`s the pair. |

**Coherence flags**
- `isOpenBuy=false` with a 14M-USDT unlock threshold vs a ~1.58M-USDT pool means the token is,
  right now, **buy-restricted to fee-excluded addresses** — normal holders can sell but not buy on
  Pancake. Worth confirming this matches project intent.
- The token's `_transfer` calls into FeeCutter, MarketMaker (indirectly), and the pair on nearly
  every transfer (reserves read, `sync`, swap-back). Correctness depends on the pair actually being
  the canonical Pancake pair (confirmed) and on FeeCutter being solvent/liquid.

## 3. Fee / reward recipient authority (who controls the money sinks)

| Contract | owner (live) | signer (live) | Other controls |
|---|---|---|---|
| FeeCutter `0x729d05b4` | superowner `0xd8d76d04` (deployer EOA) | — | `setAddresses`/`setOperator` can retarget every fee recipient and add operators. **Not renounced.** |
| MinerRewardContract `0x758905b3` | `0x33992f55` | `0xa22ceb70` | `setSigner`, reward-rate setters. Holds 217,919 STY. |
| FeeOwnerNode `0x02464775` | `0x33992f55` | `0xa22ceb70` | `setSigner`. Holds 16,934 USDT. |
| FeeOwnerTeam `0x955ca489` | `0x33992f55` | `0xa22ceb70` | `setSigner`. Holds 11,878 USDT. |
| MarketMaker `0x492cfa70` | `0x0` (RENOUNCED) | — | `setCaller`/`setBigPool`/`setNextBuyTime` frozen. Holds 207,979 STY + 75,561 USDT. |
| BigPool `0xdb2dc12d` | `0x0` (RENOUNCED) | — | `_locker` = MinerReward; `setLocker`/`setLinqlidityHolder` frozen. Holds **7,669,198 STY (~77% of supply)**. |
| LiquidityHolder `0xccb498f5` | `0x0` (RENOUNCED) | `0xdEb4E4ed` | `setSigner`/`setCaller`/`takeOutErrorTransfer` frozen (owner=0). Holds ~1.447M LP. |
| FeeOwnerCollege Safe `0xf255a4e7` | 2-of-2 Gnosis Safe | — | owners `0x765e80ac` + `0xddb8749d`. Holds 356,042 STY + 15,844 USDT. |
| TeamB Safe `0x5205b848` | 2-of-2 Gnosis Safe | — | same owners. Holds ~3 USDT. |

## 4. STY supply distribution (live)

| Holder | STY | % of 10M |
|---|---:|---:|
| BigPool | 7,669,198 | 76.7% |
| Pair (STY/USDT) | 580,156 | 5.8% |
| FeeOwnerCollege Safe | 356,042 | 3.6% |
| MinerRewardContract | 217,919 | 2.2% |
| MarketMaker | 207,979 | 2.1% |
| (remainder) | ~968,696 | 9.7% |

The economic center of gravity is **BigPool** (77% of supply). Its STY can only leave via
`AddLiqlidity` (onlyLocker = MinerReward), which pairs it with incoming USDT and ships the LP to
LiquidityHolder. There is no STY-rescue function on BigPool, so a compromise of the reward flow
(MinerReward owner/caller) is the route by which BigPool's STY becomes reachable.
