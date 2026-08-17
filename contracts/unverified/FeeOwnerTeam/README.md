# FeeOwnerTeam — 0x955ca4890461c134ead18420788b4d9862b0f2ab (UNVERIFIED)

Recovered by decompilation. Team reward pool. Holds **11,878 USDT** (live).

**Role / value.** USDT recipient from FeeCutter (CutSellFee 3/5, CutProfit 1/5) + `addReward`.
Signature-gated claim (`ecrecover == signer`).

**Live authority:** owner `0x33992f55…117063`; signer `0xa22ceb70…6ae1b` (slot2, EOA — off-chain key).

**Bytecode is a CLONE.** This runtime bytecode (sha256 `0a135c5a…`) is byte-identical across **8**
deployed reward pools — decompiling it once covers all of them:
`0x955ca489…` (this), `0x473aea0c…`, `0x8a7306e2…`, `0xb09111ff…`, `0x2e1928ab…`, `0xc3787015…`,
`0x5ba6803b…`, `0x244fb07c…`. (See docs/MAP.md §5.)
