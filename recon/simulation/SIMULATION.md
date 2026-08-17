# Simulation: unprivileged-caller reachability

Method: `eth_call` against **live BSC state** with `from` = `0x1111...1111` (an arbitrary
address holding no roles, no balances, no approvals). Read-only probe: executes each function's
guards against current storage and reports revert-vs-return. Raw JSON in `results.json` /
`results2.json`.

IMPORTANT (per audit brief): a clean revert only proves *a guard exists*. For the
signature-gated functions it does **not** prove the signing key is safely held rather than
public/compromised — see docs/OFFCHAIN_COMPONENTS.md.

| Contract | Function | Result | Detail |
|---|---|---|---|
| FeeCutter | `CutBuyFee()` | **REVERT** | revert: `Only token contract can call` |
| FeeCutter | `CutSellFee(uint256)` | **REVERT** | revert: `Only token contract can call` |
| FeeCutter | `CutProfit(uint256)` | **REVERT** | revert: `Only token contract can call` |
| FeeCutter | `cutSellBurn(uint256)` | **REVERT** | revert: `Only token contract can call` |
| FeeCutter | `setOperator(address,bool)` | **REVERT** | revert: `Only superowner can call` |
| FeeCutter | `setAddresses(address,address,address,address,address,address)` | **REVERT** | revert: `Only superowner can call` |
| MinerReward | `addReward(uint256)` | **REVERT** | revert: `Only caller can call this function` |
| MinerReward | `setSigner(address)` | **REVERT** | revert: `018001` |
| MinerReward | `order(uint256)` | **REVERT** | revert: `Amount Must Be more than 100` |
| FeeOwnerNode | `addReward(uint256)` | **REVERT** | revert: `Only caller can call this function` |
| FeeOwnerNode | `setSigner(address)` | **REVERT** | revert: `018001` |
| FeeOwnerNode | `claim(uint256,uint256,uint256,string)` | **REVERT** | revert: `reward: no order information` |
| FeeOwnerTeam | `addReward(uint256)` | **REVERT** | revert: `caller is not allowed` |
| FeeOwnerTeam | `setSigner(address)` | **REVERT** | revert: `018001` |
| NodeNFT_STYNODE1 | `mint(address)` | **REVERT** | revert: `Media:Only Minter can mint` |
| NodeNFT_STYNODE1 | `burn(uint256)` | **REVERT** | revert: `Media: Only approved or owner` |
| STYTOKEN | `cutAmmPoolToMinerReward()` | **OK** | returned `0x` |
| STYTOKEN | `createPair()` | **REVERT** | revert: `018001` |
| STYTOKEN | `setExcludeFromFee(address,bool)` | **REVERT** | revert: `018001` |
| STYTOKEN | `setFeeCutter(address)` | **REVERT** | revert: `018001` |
| MinerReward | `order(uint256)` | **REVERT** | revert: `BEP20: transfer amount exceeds balance` |
| BigPool | `AddLiqlidity(uint256)` | **REVERT** | revert: `caller is not the locker` |
| LiquidityHolder | `ReedeemLP(uint256,uint256,uint256,string)` | **OK** | returned `0x` |
| MarketMaker | `AutoSell()` | **REVERT** | revert: `Not Caller` |
| MarketMaker | `AutoBuy()` | **REVERT** | revert: `Not Caller` |

## Reading of the results

- **All privileged setters revert** for the unprivileged caller. FeeCutter `setOperator`/`setAddresses`
  → `Only superowner can call`; reward-pool `setSigner` → `018001` (NOT_CURRENT_OWNER); token
  `setExcludeFromFee`/`setFeeCutter`/`createPair` → `018001` (token owner is **renounced**, so these
  are permanently uncallable).
- **All value-moving hooks revert** unless called by their operator: FeeCutter `CutBuyFee`/`CutSellFee`/
  `CutProfit`/`cutSellBurn` → `Only token contract can call`; reward `addReward` → `Only caller can
  call this function` / `caller is not allowed`; BigPool `AddLiqlidity` → `caller is not the locker`;
  MarketMaker `AutoBuy`/`AutoSell` → `Not Caller`.
- **Signature-gated claims** reject the forged signature: FeeOwnerNode `claim` → `reward: no order
  information`; LiquidityHolder `ReedeemLP` early-returns (probe address has `totalAdded==0`). Guard
  present; **key custody is the open question** (off-chain signer EOAs).
- **Permissionless entry points confirmed**: `STYTOKEN.cutAmmPoolToMinerReward()` returns OK (anyone
  can trigger the once-per-round 1% pool→MinerReward skim); `MinerRewardContract.order(uint256)`
  passes `amount>100` and only reverts later on `transfer amount exceeds balance` (open staking entry
  pulling the caller's own STY). NFT `mint`/`burn` are minter/owner gated (`Media:Only Minter can mint`).