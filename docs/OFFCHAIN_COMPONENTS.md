# Off-chain components in the trust path

These parts of the system have **no bytecode to read and no address to simulate**. They decide
things off-chain and then act on-chain via a signature or a privileged call. Each is a hole exactly
like an unread contract, so each is named here with the decision it controls, the damage if it
decides wrongly or is compromised, and whatever on-chain evidence bounds its behavior.

---

## 1. Reward-claim signer — EOA `0xa22ceb70389d918899111db96dc44be66ab6ae1b`

**Where it's trusted.** `MinerRewardContract`, `FeeOwnerNode`, `FeeOwnerTeam` all gate their
value-paying `claim(...)` functions on `ecrecover(hash, sig) == signer`, where `signer` is this
EOA (read live from storage; identical across all three reward pools). Decompilation confirms the
recovery: FeeOwnerNode reverts `reward: no order information` when recovery ≠ signer (see
`contracts/unverified/FeeOwnerNode/recovered.decompiled.sol`, the `claim(uint256,uint256,uint256,string)`
function around the `ecrecover` call).

**Decision it controls.** An off-chain backend decides *who is owed how much reward* and signs a
message `(user, sendAmount, burnAmount, orderId, …)`. The contract trusts that signature as the
sole authorization to pay out USDT/STY it holds (Node holds 16.9k USDT, Team 11.9k USDT, Miner
217.9k STY).

**Damage if wrong/compromised.** Anyone holding this key can drain the reward pools to arbitrary
recipients up to their balances, by signing claims for themselves. This is the classic
"separate contract holding a key with permission to move value" surface. Simulation cannot rule it
out — a forged signature correctly reverts whether the key is safe or public.

**Evidence gathered / how to bound it.**
- The signer is a plain **EOA (no code)** — so the key lives off-chain (a backend/HSM/hot wallet),
  not in an on-chain contract. Extracted-constants review of all three reward-pool bytecodes found
  **no hardcoded private key or secret** embedded (only event topics, SafeMath strings, and
  storage-hash constants). So this is a live off-chain key, not a key accidentally compiled into
  bytecode.
- To finish bounding it, an auditor should pull the historical `claim`/reward-payout transactions
  for the three pools and confirm the payouts match a plausible reward policy (amounts, recipients,
  cadence). Historical `eth_getLogs` for these addresses was **not retrievable** from the public
  RPCs available in this environment (range/ACL limited — see UNRESOLVED.md); this is the one
  evidence item left open.

## 2. LP-redemption signer — EOA `0xdEb4E4ed40E8d29d10A326Fb4652fDaa55438284`

**Where it's trusted.** `LiquidityHolder.ReedeemLP(orderId, sendAmount, totalBurnAmount, signedMsg)`
requires `ecrecover(keccak256(abi.encode(user, sendAmount, totalBurnAmount, orderId, _type)), sig)
== _signer`. `_signer` read live = this EOA (also the constructor default, see verified
`contracts/core/LiquidityHolder_LiqlidityHolder/LiqlidityHolder.sol:52`).

**Decision it controls.** An off-chain backend decides when a user may redeem LP. On a valid
signature the contract removes liquidity from the Pancake pair (burning LP it custodies, ~1.447M
LP) and sends the resulting USDT to the user and the STY to BigPool.

**Damage if wrong/compromised.** The `_signer` key can authorize LP removal → the LP that
LiquidityHolder holds (the protocol's own liquidity) can be pulled out as USDT to attacker-chosen
`user` addresses, subject only to the per-user `totalAdded` accounting the same backend feeds via
`addLiquidity` (called by BigPool during `AddLiqlidity`). Because `owner` is renounced,
`setSigner` can no longer rotate this key — **the key cannot be changed if it leaks.**

**Evidence gathered / how to bound it.**
- `_signer` is an **EOA (no code)** ⇒ off-chain key.
- The redemption math is bounded by `userTaked[user] + sendAmount + totalBurnAmount ≤ totalAdded[user]`,
  and `totalAdded` is only incremented through BigPool's `AddLiqlidity` path (which pulls real USDT
  from the caller). So absent a signer compromise, a user can't redeem more LP-value than was added
  on their behalf. The whole guarantee rests on the signer key.

## 3. Reward-subsystem operator — EOA `0x33992f55832af553310489e1c808be007b117063`

Owner of MinerReward/FeeOwnerNode/FeeOwnerTeam. Off-chain human/key that can `setSigner` (swap the
signer in #1) and tune reward parameters. A compromise here is equivalent to a #1 compromise (it can
install an attacker-controlled signer) for the reward pools, though **not** for LiquidityHolder
(whose owner is renounced).

## 4. Fee-routing superowner / NFT minter — EOA `0xd8d76d04da5ec32d84edbd560916b1edd2194e8f`

Deployer. Is FeeCutter's `superowner` (can `setAddresses` to retarget *every* fee recipient, and
`setOperator` to authorize new callers of FeeCutter's swap-and-distribute functions) and is the
`owner`/minter of the three STYNODE NFT contracts (can mint node NFTs, which are the eligibility
tokens the FeeOwnerNode reward math reads via `balanceOf`/`tokenOfOwnerByIndex`). Off-chain key;
not renounced. Its power is over *fee destinations and reward eligibility*, not over token supply or
the pair directly.

## 5. MarketMaker caller — off-chain bot

`MarketMaker.AutoBuy()/AutoSell()` are `onlyCaller`. The caller set (frozen; owner renounced) is an
off-chain keeper bot that decides *when* to buy/sell STY to defend the `openPrice*1.03` band. If the
keeper key is compromised, the attacker can only trigger the same band-defending swaps (buy with
MarketMaker's USDT / sell MarketMaker's STY) — bounded by MarketMaker's own balances and the
`calcSellAmount` cap (≤ 3% of pair STY reserve per call). Lower severity, but it is an off-chain
decision-maker in the price path and is named here for completeness.

---

### Summary of off-chain keys the whole system leans on

| Key (EOA) | Authorizes | Renounceable now? | If leaked |
|---|---|---|---|
| `0xa22ceb70…` | Reward-pool claims (USDT/STY payout) | owner can rotate | Drain reward pools |
| `0xdEb4E4ed…` | LP redemption (USDT payout, LP burn) | **No (owner=0)** | Drain custodied LP |
| `0x33992f55…` | `setSigner` on reward pools | itself | Install rogue reward signer |
| `0xd8d76d04…` | Retarget FeeCutter recipients; mint node NFTs | itself | Redirect fees; mint reward eligibility |
| MarketMaker caller | AutoBuy/AutoSell timing | No (owner=0) | Churn MM balances within caps |
