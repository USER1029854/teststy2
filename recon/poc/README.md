# PoC — resolving SECURITY_REVIEW.md §4.2 on a BSC mainnet fork

**Question (§4.2):** `MinerReward.order()` reads the token's **spot** `getCurrentPrice()`, and
`release()` pays STY with no signature. Could an unprivileged attacker inflate the "power"/reward a
stake records by pre-moving the spot price (donate USDT to the pair + `sync()`), then extract an
inflated STY payout?

**Answer: NO — refuted by fork execution.** `order()` records power = the **raw USDT principal**,
independent of spot price; the releasable/indexed reward-order path is **signature-gated**; and the
LP credit a stake earns is fully backed by the USDT actually paid.

## How to run
```bash
# from repo root; Foundry (anvil/forge/cast) on PATH
cd recon/poc
forge test -vv          # forks https://bsc-dataseed.binance.org via foundry.toml [rpc_endpoints] bsc
```
No external libs (self-contained cheatcode shim in `test/vm.sol`, no forge-std/git needed).
USDT is funded to the attacker by writing balance slot 1 (`keccak256(abi.encode(holder,1))`),
verified against a known holder. Captured output is in `RESULTS.txt`.

## What the three tests prove

### `test_order_power` — power is price-independent
Stake 1000 USDT via `order(1000e18)` at two spot prices and read `userTotalPower(attacker)`:

| Spot price (USDT/STY) | `userTotalPower` recorded |
|---|---|
| 2.72 (live) | 1000.0 |
| 7.88 (after donating 3,000,000 USDT to the pair + `sync()`, ~2.9× pump) | **1000.0 (identical)** |

Power = the USDT amount staked, **not** `f(price)`. The `getCurrentPrice` read in the decompilation
does not feed the power figure on the permissionless path.

### `test_indexed_order_is_signature_gated` — releasable orders need the signer
Calling the indexed-order creator (`0x0d3523bb`) from the attacker with a forged signature **reverts**
and leaves `orderIndex` unchanged (88033 → 88033). The orders that `release()` later pays out can
only be created with the off-chain signer's signature, so an attacker cannot manufacture a payable
position.

### `test_order_totalAdded_backed_by_principal` — no free credit
One `order(1000e18)`: attacker spends exactly **1000 USDT**, records power **1000**, and is credited
**606.1 LP** in LiquidityHolder (`totalAdded`) — i.e. the ~60% liquidity leg of the 60/30/10 split.
The position is fully backed by USDT actually paid; redemption is further signer-gated.

## Conclusion
The §4.2 vector is dead: there is no spot-price-manipulation path to a disproportionate,
stake-independent gain. Even hypothetically, the price pump used here costs the attacker the entire
3,000,000-USDT donation (surrendered to the pool/LPs), dwarfing any conceivable reward. The
reward-payout surface remains gated by the off-chain signer (see `docs/OFFCHAIN_COMPONENTS.md`),
which is the residual trust assumption — not an on-chain code flaw.
