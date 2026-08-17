# Integrity of shared building blocks

Goal: make sure the "standard" pieces are actually standard, so a diff-based review of the
bespoke code isn't blinded by a doctored baseline.

## Canonical external contracts — verified against real upstream identity

| Contract | Address | How confirmed canonical |
|---|---|---|
| PancakeRouter V2 | `0x10ED43C718714eb63d5aA57B78B54704E256024E` | The well-known canonical PancakeSwap V2 router address on BSC; source verified on BscScan (`contracts/external/PancakeRouterV2/`). |
| PancakeFactory V2 | `0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73` | Canonical PancakeSwap V2 factory. Confirmed live: `factory.getPair(STY, USDT)` returns the exact target pair `0x2BE2…830`. |
| STY/USDT PancakePair | `0x2BE23D76F423bf464F310aD98749d82691Ecc830` | Live `pair.factory()` == the canonical factory above, and the factory's `getPair` maps back to it ⇒ the pair is a genuine factory-minted Pancake pair, not a look-alike. Source verified as `PancakePair`. |
| USDT (Binance-Peg BSC-USD) | `0x55d398326f99059fF775485246999027B3197955` | Canonical Binance-Peg BSC-USD; source verified (`contracts/external/USDT_BEP20/`). |
| Gnosis Safe singleton | `0x3e5c63644e683549055b9be8653de26e0b4cd36e` | `GnosisSafeL2 v1.3.0`, source verified (`contracts/external/GnosisSafe_Singleton_v1.3.0/`). All three project Safes' proxies delegate to it (read from proxy slot 0). |

## Project boilerplate — self-consistency

The four verified project contracts (STYTOKEN, MarketMaker, BigPool, LiquidityHolder) each ship
their own copies of `SafeMath.sol`, `Ownable.sol`, `IBEP20.sol`. Byte-for-byte hashes:

| File | sha256 | Identical across all copies? |
|---|---|---|
| `SafeMath.sol` | `6ee8d67f…92fa15` | ✅ yes (4/4) |
| `Ownable.sol` | `f935de59…9bc9b7ae` | ✅ yes (4/4) |
| `IBEP20.sol` | `1bccc694…cab8066f` | ✅ yes (3/3 that ship it) |

- **SafeMath** — standard overflow-checked arithmetic (`add`/`sub`/`mul`/`div`/`mod` all keep their
  `require` guards; not weakened). It is a **superset**: adds `subwithlesszero` (saturating sub),
  `min`, and `sqrt`. No tampering found in the checked operations.
- **Ownable** — ⚠️ **NOT OpenZeppelin.** Custom implementation with numeric error strings
  (`018001` = NOT_CURRENT_OWNER, `018002`) and, notably, a constructor that sets
  `owner = tx.origin` (**not** `msg.sender`). Because these tokens are deployed by a factory/EOA
  flow, `tx.origin` = the human deployer. Same pattern in FeeCutter (`superowner = tx.origin`) and
  the token constructor (`_balances[tx.origin] = totalSupply`). Auditors should treat the
  `tx.origin`-as-owner idiom as intentional here, and note it would misbehave if any of these were
  ever deployed via an intermediary contract.

## Notes for the reviewer

- No proxy/upgradeability on the token or any core contract (all `Proxy: 0` on BscScan, no EIP-1967
  slots populated) — the only proxies in the system are the Gnosis Safe proxies, which delegate to
  the canonical v1.3.0 singleton.
- The FeeCutter deployed at `0x729d05b4…` is **unverified on BscScan**, but its source is present
  verbatim inside the verified `STYTOKEN.sol` compilation unit, and its runtime function selectors
  were confirmed by decompilation to match that source (see
  `contracts/unverified/FeeCutter/`). It is therefore treated as *readable*, not opaque.
