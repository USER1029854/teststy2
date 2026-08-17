# FeeCutter — 0x729d05b4b45f5ad101f44b3b0c01e824972312d0 (UNVERIFIED on BscScan)

**Source is known.** The `FeeCutter` contract is defined verbatim inside the VERIFIED
`STYTOKEN.sol` compilation unit — see `source_from_STYTOKEN.sol` here (extracted) and
`../../target/STYTOKEN.sol`. The deployed instance is not separately verified on BscScan, but its
runtime function selectors were confirmed by decompilation (`recovered.decompiled.sol`) to match
that source. Treat as readable, not opaque.

**Role.** Receives STY fees that `STYTOKEN._transfer` skims, swaps STY→USDT via PancakeRouter, and
distributes to fee owners. See `docs/MAP.md` §2 for the per-cut split.

**Live authority (read from chain):**
- `superowner` (slot0) = `0xd8d76d04da5ec32d84edbd560916b1edd2194e8f` (deployer EOA) — can
  `setAddresses` (retarget ALL recipients) and `setOperator` (authorize new callers). **Not renounced.**
- operator = STYTOKEN only.
- recipients: College `0xf255…512c`, Node `0x0246…9223`, Team `0x955c…f2ab`, TeamA `0x492c…1929`,
  TeamB `0x5205…c522`.

Files: `source_from_STYTOKEN.sol` (known source), `recovered.decompiled.sol` (bytecode confirmation),
`recovered.abi.json`, `runtime.bytecode.hex`, `embedded_constants.json` (only SafeMath strings — no secrets).
