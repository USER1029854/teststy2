# Security review — STYTOKEN system (BSC)

Adversary model: a hostile, unprivileged, well-resourced actor with flash loans, many
addresses, atomic multi-step txs, arbitrary composability, and patience. Goal: take value or
seize control they weren't entitled to. Scope: the STY token and every contract it moves value
to/from or grants power over (see `docs/MAP.md`). Canonical externals (Pancake V2, USDT, Gnosis
Safe) are trusted as-is; the review covers how STY *uses* them.

Verified-source contracts are analysed line-by-line. Unverified contracts (FeeCutter — source known
from STYTOKEN.sol; MinerReward; FeeOwnerNode/Team + clones; NFTs; helpers) are analysed from
heimdall decompilation + disassembly + on-chain simulation; conclusions that depend on
decompilation are labelled as such.

## Verdict

**No confirmed exploit that lets an unprivileged attacker take value or seize control was found in
the readable (verified) contracts.** The token has fixed supply, ownership renounced, and its
custom `_transfer` conserves value (fees only reduce the trader's own proceeds). The two
signature-gated value paths I could read are correctly domain-separated (a replay path I pursued
across the 8 byte-identical reward-pool clones is **defeated** by a per-pool `_type` baked into the
signed hash — see §3.A). No embedded private key derives to any trusted signer (§3.B, 71,339
candidates across 12 bytecodes).

What remains are **(a)** one confirmed low-severity griefing DoS on redemptions (§4.1, does not meet
the value/access bar but is a real defect), **(b)** one plausible economic vector I could **not**
confirm or refute because it lives in unverified reward-math (§4.2), and **(c)** systemic trust
placed in off-chain signer keys and the un-renounced FeeCutter admin (§5). The system's safety
rests materially on off-chain components; a clean on-chain result does **not** imply the system is
sound (§5).

---

## 1. Artifact A — complete entry-point enumeration

Every externally-reachable function, with its guard and a one-line reason it isn't an unprivileged
value/control exploit. "DEAD" = `onlyOwner` on a contract whose `owner()` is live-confirmed `0x0`
(renounced), so permanently uncallable.

### STYTOKEN `0xD6A4…2857` (verified)
| Fn | Guard | Reason not exploitable |
|---|---|---|
| `setMinerRewardContract` / `setStartMineTime` / `setFeeCutter` / `createPair` / `setExcludeFromFee` | onlyOwner | **DEAD** (owner=0). Config frozen. |
| `renounceOwnership` / `transferOwnership` | onlyOwner | DEAD. |
| `approve` / `increaseAllowance` / `decreaseAllowance` | msg.sender's own allowance | Standard; only affects caller's allowances. |
| `transfer` / `transferFrom` | balance / allowance | → `_transfer`; conserves value (§2). transferFrom allowance-checked. |
| `burn` / `burnFrom` | own balance / allowance | Burns caller's (or approved) tokens; reduces supply, no gain. |
| `cutAmmPoolToMinerReward` | **permissionless** | Moves 1% of pair STY→MinerReward once per 12h round (`roundCutted`), then `sync()`. Rate-limited, non-profitable (see §2, C1). |
| views (`getCurrentPrice`, `getDay`, `getCutRound`, `getNewPriceAfterSell`, `CalcProfit`, balances, config) | — | Read-only. |

### FeeCutter `0x729d…12d0` (unverified; source in STYTOKEN.sol)
| Fn | Guard | Reason |
|---|---|---|
| `CutBuyFee` / `CutSellFee` / `cutSellBurn` / `CutProfit` | onlyToken (`isOperator`) | Only the token can invoke; simulated revert `Only token contract can call`. Reentrancy-guarded (`_entered`). |
| `setAddresses` / `setOperator` | onlyOwner (`superowner` = deployer `0xd8d76d04`, **NOT renounced**) | Centralization risk (§5.3), not unprivileged. |
| views | — | — |

### MarketMaker `0x492c…1929` (verified)
| Fn | Guard | Reason |
|---|---|---|
| `AutoSell` / `AutoBuy` | onlyCaller (keeper) | Simulated revert `Not Caller`. Sells ≤3% of pair STY/call from MM's own funds; buys `USDT/1000`. Attacker can't trigger. |
| `setCaller` / `setNextBuyTime` / `setBigPool` / renounce/transfer | onlyOwner | **DEAD** (owner=0). |
| `NeedSell`/`NeedBuy`/`calcSellAmount`/views | — | Read-only. |

### BigPool `0xdb2d…143d` (verified) — holds 7.67M STY (~77%)
| Fn | Guard | Reason |
|---|---|---|
| `AddLiqlidity(uint256)` | onlyLocker (=MinerReward) | Simulated revert `caller is not the locker`. Reachable only via MinerReward.order (§2, C2), which makes the caller pay USDT. |
| `setLocker` / `setLinqlidityHolder` / renounce/transfer | onlyOwner | **DEAD** (owner=0). No STY-rescue path exists. |
| views | — | — |

### LiquidityHolder `0xccb4…91db` (verified) — holds ~1.447M LP
| Fn | Guard | Reason |
|---|---|---|
| `ReedeemLP(uint,uint,uint,string)` | signer ECDSA + `orderTaked` + `totalAdded` cap | Payout gated by off-chain signer (§5.1). **Griefing DoS on `orderTaked` — §4.1.** |
| `addLiquidity(uint256)` | onlyCaller (=BigPool) | Credits `totalAdded[tx.origin]`; reachable only via the paid order() path. |
| `takeOutErrorTransfer` | onlyOwner | **DEAD** (owner=0). Would sweep any token incl. LP if owner were live — see §5.3. |
| `setSigner` / `setCaller` / renounce/transfer | onlyOwner | **DEAD** (owner=0) — signer key **cannot be rotated** (§5.1). |
| views | — | — |

### MinerReward `0x7589…1a88` (unverified) — holds 218K STY; BigPool locker
| Fn | Guard | Reason |
|---|---|---|
| `order(uint256)` | **permissionless** (arg0 ≥ 100e18) | Pulls caller's USDT, 60% → BigPool.AddLiqlidity (LP→LiquidityHolder, `totalAdded`←tx.origin), 30%/10% → team. Splits exact; min-stake blocks dust. Reads **spot** `getCurrentPrice` — see §4.2. |
| `claim` (0xf782bb1a) | signer ECDSA + cumulative + `_type=0x15` in hash | Pays STY cumulative; domain-separated, per-user, replay-safe (given signer). |
| `release` (0x10a2cdbd) | order-validity + maturity timer + released-flag | Simulated revert `Invalid Order` for arbitrary ids. **No signature** — see §4.2. |
| `addReward(uint256)` | onlyCaller (token registered) | Simulated revert `Only caller can call this function`. |
| `setSigner` and other setters, renounce/transfer | onlyOwner (`0x33992f55`) | Owner-only; centralization, not unprivileged. |
| `56a7d746`/`0d3523bb`/`4a2ce84d` | onlyOwner / caller | Owner/caller gated (simulated / decompiled). |
| views | — | — |

### FeeOwnerNode `0x0246…9223`, FeeOwnerTeam `0x955c…f2ab` (+8 clones) (unverified)
| Fn | Guard | Reason |
|---|---|---|
| `claim` (Node 0xb9a02901 / Team 0xc3ce5856) | signer ECDSA + cumulative + **per-pool `_type` in hash** | Pays USDT; **cross-clone replay defeated by per-pool `_type`** (§3.A). Node also reads STYNODE NFT holdings (attacker can't mint NFTs). |
| `addReward` | onlyCaller (FeeCutter) | Simulated revert `caller is not allowed`. |
| `setSigner` / renounce/transfer | onlyOwner (`0x33992f55`) | Owner-only. |
| views | — | — |

### STYNODE NFTs (3 clones), NodeStoreH, MinerReward_helper, reward-pool variant (unverified)
| Fn | Guard | Reason |
|---|---|---|
| NFT `mint(address)` | onlyMinter (deployer) | Simulated revert `Media:Only Minter can mint`. Attacker can't mint node eligibility. |
| NFT `burn` / `transferFrom` / `approve` | approved/owner | Standard ERC721. |
| helpers | called by reward contracts | Downstream accounting; cannot mint STY or move the pair. |

---

## 2. Artifact B — state-dependency map & compositions examined

Notation: **W** = writers, **R** = readers. Each composition was checked for a single actor staging
writer-then-reader (same tx or across txs), including flash-loan reserve distortion, callback
interleaving, and split/repetition.

**S1 — pair reserves / `getCurrentPrice` (spot).**
W: any Pancake swap; `cutAmmPoolToMinerReward`+`sync`; BigPool.AddLiqlidity; LiquidityHolder
removeLiquidity; anyone via `pair.sync()` after a raw USDT donation.
R: token `_transfer` (fee/profit calc); MarketMaker AutoBuy/Sell; **MinerReward.order** (§4.2);
LiquidityHolder.getLiqlidityValue (view).
- Reader = token fee/profit: manipulating spot price changes fee *magnitudes*, but every fee path
  moves value **from the trader to FeeCutter** — never to the attacker. No gain. ✗
- Reader = MarketMaker: `onlyCaller`; attacker can't trigger, and public buys are gated
  (`isOpenBuy=false`) so an attacker can't cash out a keeper-induced dump. ✗
- Reader = MinerReward.order → **unresolved economic vector, §4.2** (spot price feeds a "power"
  figure whose downstream use in the non-signature `release()` I could not read).
- Flash-borrowing STY from the pair to force a reserve/callback interleave **reverts**: a flash swap
  sends STY to a non-excluded `to`, which hits the token's buy path `require(isOpenBuy)` → revert.
  So the STY/USDT pair can't be flash-borrowed by an unprivileged address today. ✗

**S2 — `totalAdded[user]` (LiquidityHolder).**
W: `addLiquidity` (onlyCaller=BigPool, only through the paid `order()` chain, credits tx.origin).
R: `ReedeemLP` cap. An attacker cannot inflate `totalAdded` without actually paying USDT via
`order()`; redemption is further signer-gated. No free credit. ✗

**S3 — `claimed[user]` / cumulative reward (MinerReward, pools).**
W/R: `claim`. Same-pool replay blocked by `require(newCumulative > claimed[user])`; cross-pool/clone
replay blocked by per-pool `_type` in the signed hash (§3.A). ✗

**S4 — `orderTaked[orderid]` (LiquidityHolder).** W/R: `ReedeemLP`. Writer runs **before**
validation → **§4.1 griefing DoS.**

**S5 — `roundCutted[round]` (token).** W/R: `cutAmmPoolToMinerReward`.
- C1 (repetition): the 1% skim is latched once per 12h round; N calls in a round = 1 effect. The
  single 1% price bump costs the caller nothing but can't be repeated and is < the 2%+5% round-trip
  fees, so no buy-bump-sell profit. And `sync()` sets reserves = balances, creating no free arb. ✗

**S6 — `isOpenBuy` (token).** W: buy path sets it true once `USDT reserve > 14,000,000e18`. R: buy
gate. One-way latch; pool is 1.58M USDT so it stays false. Coherent (see §6). Not attacker-flippable
(would require adding >12M USDT of real liquidity). ✗

**S7 — `holdPrice[user]` (token).** W: `UpdateUserHoldPrice` on every transfer (uses *old* balance,
pre-credit). R: profit-cut. Manipulating one's own `holdPrice` only changes the *manipulator's own*
future profit-cut (a self-tax), never another user's funds. ✗

**S8 — `order()` split arithmetic (MinerReward).** 60/30/10 split is exact at the 100e18 minimum;
splitting one stake into many yields identical totals (no directional-rounding gain), and the
100-USDT floor blocks dust griefing. ✗

**C2 — order() → BigPool.AddLiqlidity → LiquidityHolder.addLiquidity chain.** A single actor stages
all three atomically, but each step is paid: the caller funds the USDT; BigPool matches STY at the
*current pool ratio*; LP is credited to the caller and redeemable only via signer-gated `ReedeemLP`.
BigPool's STY returns on redemption. No step lets the actor extract more than they funded — except
the §4.2 question of whether the recorded "power" (and thus a later `release()` STY payout) is
inflatable by pre-move-ing the spot price.

---

## 3. Things I tried to exploit and killed

### 3.A Cross-clone / cross-contract signature replay — DEFEATED
The 8 FeeOwnerTeam-shape reward pools are **byte-identical** and share signer keys (5 use
`0xdeb4e4ed…`, 2 use `0xa22ceb70…`). Neither `ADDRESS` (0x30) nor `CHAINID` (0x46) opcodes exist in
the bytecode, so the signed hash **cannot** bind to the pool contract or chain — a promising
one-signature-drains-all-pools path. **Killed by disassembly:** the message hash
(`keccak256` of a dynamic buffer at PC `0x500`) packs `(msg.sender, amount, SLOAD(slot 3))`, and
**slot 3 is a distinct per-pool `_type`** — live values 57111, 57222, 77009, 77010, 77011, 77012,
77013, 77014 (all different). A signature for one pool reconstructs a different hash on any other →
rejected. LiquidityHolder uses a different `_type` (0x11869) and a 5-field layout, so cross-*type*
collision is out too. Domain separation is present despite the missing `address(this)`. No finding.

### 3.B Hardcoded signer private key — NOT PRESENT
Treated **every** 32-byte window (PUSH32 operands + sliding windows) in all 12 in-scope bytecodes as
a secp256k1 private key and derived its address (71,339 candidates). **None** derives to any trusted
signer/owner (`0xa22ceb70`, `0xdeb4e4ed`, `0xd8d76d04`, `0x33992f55`, or the two Safe owners).
Extracted constants are event topics, SafeMath strings, and mapping storage-slot bases. The signer
keys live off-chain, not in deployed code. No finding. (Repro: `recon/scripts` + coincurve.)

---

## 4. Findings

### 4.1 [LOW / informational — griefing DoS, does not meet the value/access bar] `ReedeemLP` marks the order consumed before validating
`LiquidityHolder.ReedeemLP` (verified source, `contracts/core/LiquidityHolder_LiqlidityHolder/LiqlidityHolder.sol:86`):
```solidity
require(!orderTaked[orderid],"Order taked");
orderTaked[orderid]=true;                 // <-- state written first
address user=msg.sender;
if(userTaked[user] + sendamount + totalBurnAmount > totalAdded[user])
    return;                               // <-- early return PERSISTS orderTaked=true
bytes32 hashValue = keccak256(abi.encode(user, sendamount, totalBurnAmount, orderid, _type));
require(_signer == tryRecover(hashValue, hexStr2bytes(signedmsg)),"reward: invalid signer");
```
**Exploit:** any address with `totalAdded==0` calls `ReedeemLP(victimOrderId, 1, 0, "00")`. The
early-return branch (`0 + 1 + 0 > 0`) is taken *after* `orderTaked[victimOrderId]=true` and *before*
the signature check, so the write is not reverted. The victim's legitimate `ReedeemLP(victimOrderId,…)`
then fails at `require(!orderTaked[orderid])`.
**Impact:** an attacker can permanently consume arbitrary `orderid`s for ~1 tx of gas each; if the
backend issues predictable/sequential ids it can pre-burn a range, blocking redemptions. **No funds
are stolen and no access is gained** — the backend can re-issue a fresh `orderid`, so this is a
nuisance-grade DoS, below the value/access bar. Reported for completeness.
**Fix:** move `orderTaked[orderid]=true` to *after* the signature check (and drop the silent
early-return in favour of a revert), so an invalid/early call reverts and leaves the id unused.

### 4.2 [UNRESOLVED — needs source] MinerReward `order()` reads spot price; `release()` pays with no signature
`MinerReward.order()` reads the token's **spot** `getCurrentPrice()` (selector `0xeb91d37e`, no
TWAP), and `release()` (`0x10a2cdbd`) pays STY on a maturity timer with **no ECDSA check** (unlike
`claim`). If the "power"/reward figure a stake records is derived from that spot price, an attacker
could cheaply skew it: donate USDT to the pair + call `pair.sync()` to raise `getCurrentPrice`
(spot, manipulable), `order()` at the inflated price, and later `release()` an inflated STY payout
from MinerReward's 218K-STY balance — an economic gain roughly independent of stake.
**Why unresolved:** MinerReward is unverified; from decompilation I could **not** determine whether
the stored power is price-scaled (value-bearing) or whether `getCurrentPrice` is read only for the
`RewardAdded` event (as it demonstrably is in `addReward`). `release()` reverts `Invalid Order` for
all ids I could try, so I could not build a matured order to test end-to-end.
**What would make it real / would kill it:** real → power is `f(spotPrice)` and `release()` pays
`g(power)` without re-checking price or signer. Killed → power is the raw USDT amount, or every
value-bearing payout is signer-gated. **This needs the verified source or a traced mainnet
`order→release` cycle to resolve.** Flagged prominently rather than left implied-safe.

---

## 5. Off-chain trust boundary (safety depends on these; the chain can't verify them)

1. **LP-redemption signer `0xdEb4E4ed…`** (EOA) authorizes every `ReedeemLP` payout of the ~1.447M
   LP LiquidityHolder custodies. LiquidityHolder's owner is renounced, so **this key can never be
   rotated** — if it leaks, redemptions can be drained to attacker addresses (bounded by each user's
   `totalAdded`) with no on-chain recourse. The on-chain scheme is otherwise sound (binds user,
   orderid replay-guard, `_type`).
2. **Reward signer `0xa22ceb70…`** (EOA) authorizes reward-pool and MinerReward `claim` payouts;
   rotatable by owner `0x33992f55`. A leak drains the reward-pool USDT / MinerReward STY.
3. **FeeCutter superowner `0xd8d76d04…` (deployer, NOT renounced)** can `setAddresses` to retarget
   **every** fee recipient and `setOperator` to authorize new callers of FeeCutter's swap-and-send
   functions. This is legitimate admin power (out of the unprivileged-attacker model) but is a live
   centralization risk: the party controlling this key controls where all token fees flow.
4. The reward "backend" that decides claim amounts/orderids is trusted to issue non-replayable,
   correctly-sized grants. The on-chain code enforces per-pool/per-user/`_type` domain separation
   but cannot verify the *policy* behind a signature.

A clean on-chain result here means "the readable code enforces its guards," **not** "the system is
safe" — items 1–4 are unverifiable from the chain.

## 6. Configuration coherence (audited as deployed)

- **Token ordering invariant holds:** `address(STY) > address(USDT)` ⇒ `token0=USDT, token1=STY`
  (confirmed live), which the `_getReserves`/price logic assumes. ✓
- **Fee splits exact** at the 100e18 order minimum (60/30/10) and standard fees (2% buy, 5% sell,
  0–50% dynamic burn, 25% profit-cut); `_transfer` conserves value. ✓
- **`isOpenBuy=false` with a 14,000,000-USDT unlock vs a 1.58M-USDT pool:** public buys on Pancake
  are currently gated to fee-excluded addresses, and the latch won't flip without >12M USDT of new
  liquidity. Internally coherent and not attacker-flippable, but a **live constraint** an auditor/
  integrator must know (normal users can sell but not buy right now). ⚠
- **Ownership:** token, MarketMaker, BigPool, LiquidityHolder renounced (config frozen); FeeCutter
  and the reward contracts are **not** renounced (§5.3). No proxy/upgrade path anywhere (Proxy:0,
  no EIP-1967 slots).

## 7. Assumptions & what would change the conclusions

- **Unverified reward-math (MinerReward, FeeOwnerNode/Team, helpers):** analysed from decompilation.
  If §4.2's power figure is spot-price-derived and `release()` pays from it without a signature, that
  becomes a confirmed economic finding. Everything else about these contracts (guards, domain
  separation, no embedded key) was corroborated by disassembly + simulation.
- **Off-chain signer key custody (§5.1–5.2):** assumed secure. If not, the LP and reward balances are
  at risk; the LP signer is unrotatable.
- **Canonical externals** (Pancake pair/router/factory, USDT, Gnosis Safe) assumed byte-genuine —
  verified on-chain in `docs/INTEGRITY.md`.
- Findings excluded by the model as requested: ordering/front-running/sandwich effects, reliance on
  other users trading mid-exploit, and privileged parties using their own legitimate powers (noted
  as centralization in §5.3, not as attacks).
