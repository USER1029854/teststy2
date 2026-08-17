# STYTOKEN (SWAN TREASURY / STY) — audit source bundle

Self-contained, audit-ready snapshot of the on-chain system behind the token
**`0xD6A4F5AADD88ebA9A170AcF67f737BD488142857`** and its PancakeSwap V2 pair
**`0x2BE23D76F423bf464F310aD98749d82691Ecc830`** on **BNB Smart Chain (chainId 56)**.

This is a *reconnaissance bundle for a security auditor*, not an exploitability assessment. The goal:
when the audit opens this repo, every contract that could bear on the target's security is already
here in readable form, and everything that can't be made readable is named precisely with the
evidence that bounds it.

## Start here
1. **[`docs/MAP.md`](docs/MAP.md)** — the trust graph in both directions, money flow, and a pointer
   to every contract's location. Read this first.
2. **[`docs/AUTHORITY_AND_CONFIG_STATE.md`](docs/AUTHORITY_AND_CONFIG_STATE.md)** — live authority &
   configuration (owners, signers, fees, limits, balances, `isOpenBuy`, reserves) at snapshot block.
3. **[`docs/OFFCHAIN_COMPONENTS.md`](docs/OFFCHAIN_COMPONENTS.md)** — the off-chain keys/backends the
   system trusts (reward signer, LP-redemption signer, superowner) and what each can do.
4. **[`docs/INTEGRITY.md`](docs/INTEGRITY.md)** — proof the "standard" pieces (Pancake, USDT, Safe,
   SafeMath) are actually standard.
5. **[`docs/UNRESOLVED.md`](docs/UNRESOLVED.md)** — the explicit open-items list.
6. **[`recon/ADDRESS_CENSUS.json`](recon/ADDRESS_CENSUS.json)** — machine-readable index of all ~25 addresses.

## Repository layout
```
contracts/
  target/            STYTOKEN — verified source (+ its SafeMath/Ownable/IBEP20)
  pair/              PancakePair STY/USDT — verified (canonical Pancake V2)
  core/              verified protocol contracts:
                       MarketMaker_MarketNumber1/  (auto buy/sell keeper)
                       BigPool_OrderBIGPOOL/        (holds 77% of STY; seeds LP)
                       LiquidityHolder_LiqlidityHolder/ (custodies LP; signed redemptions)
  authorities/       fee/treasury Gnosis Safes (proxies → v1.3.0 singleton):
                       FeeOwnerCollege_GnosisSafeProxy/, TeamB_GnosisSafeProxy/,
                       RewardTreasury_5f5149_GnosisSafeProxy/
  external/          canonical building blocks: PancakeRouterV2/, PancakeFactoryV2/,
                       USDT_BEP20/, GnosisSafe_Singleton_v1.3.0/
  unverified/        contracts with NO verified source — recovered behaviour:
                       FeeCutter/ (source known from STYTOKEN.sol + decompile-confirmed)
                       MinerRewardContract/, FeeOwnerNode/, FeeOwnerTeam/,
                       MinerReward_rewardpool_variant_97c1d9/, NodeNFT_STYNODE/,
                       NodeStoreH/, MinerReward_helper/
                     each dir: recovered.decompiled.sol, recovered.abi.json,
                               runtime.bytecode.hex, embedded_constants.json
docs/                MAP, AUTHORITY_AND_CONFIG_STATE, OFFCHAIN_COMPONENTS, INTEGRITY, UNRESOLVED
recon/
  ADDRESS_CENSUS.json    single source of truth for every address + role + state
  decompiled/            raw heimdall output + selector-resolution JSON per contract
  simulation/            SIMULATION.md + raw eth_call results
  scripts/               reproduction scripts (fetch_source, rpc, simulate, extract_constants, ...)
```

## One-paragraph orientation
STY is a hand-rolled BEP20 whose `_transfer` skims buy/sell/profit/burn fees into an (unverified but
source-known) **FeeCutter**, which swaps them to USDT and fans them out to a set of reward pools and
Gnosis-Safe treasuries. A permissionless `cutAmmPoolToMinerReward()` bleeds 1% of the pair's STY per
12h round into a **MinerReward** staking hub. **Token ownership is renounced**, so the wiring is
frozen; the live authority that remains lives in the contracts it points to — most importantly the
off-chain **signer keys** that authorize reward claims and LP redemptions, and the deployer key that
can retarget fees. **BigPool holds ~77% of supply**, movable only through the reward flow. See
`docs/MAP.md`.

## How this was produced (reproducibility)
- Source pulled via Etherscan V2 `getsourcecode` (chainId 56) — `recon/scripts/fetch_source.py`.
- Bytecode/state read from public BSC RPC — `recon/scripts/rpc.py`.
- Unverified contracts decompiled with **heimdall-rs v0.9.2** (built from source) — outputs in
  `recon/decompiled/` and `contracts/unverified/`.
- Embedded constants extracted from runtime bytecode — `recon/scripts/extract_constants.py`.
- Guards probed by `eth_call` from an unprivileged address — `recon/scripts/simulate.py`.

**Snapshot:** ~block 116,442,814 (2026-08-17). Live state (balances, reserves, `isOpenBuy`) changes
with every trade — re-read before relying on it.
