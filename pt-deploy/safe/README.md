# Safe Transaction Builder — HoodPot

Import these JSON files into [Safe Transaction Builder](https://app.safe.global) on **Robinhood Chain (4663)**.

Safe: `0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117`  
Direct link: https://app.safe.global/home?safe=robinhood:0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117

## Import steps

1. Open Safe → **New transaction** → **Transaction Builder**
2. Top right **⋮** menu → **Import transaction**
3. Upload the JSON file (or paste contents)
4. Review each step → **Create batch** → sign & execute

## Batches

| File | What it does |
|------|----------------|
| [`hoodpot-harvester-v2.batch.json`](./hoodpot-harvester-v2.batch.json) | **Harvester v2** — wire fixed HoodFeeHarvester + Morpho fee recipients (5 txs) |
| [`hoodpot-wiring.batch.json`](./hoodpot-wiring.batch.json) | **Step 1** — liquidation pair + harvester (2 txs, no GS013) — superseded by harvester-v2 for fee wiring |
| [`hoodpot-morpho-fees.batch.json`](./hoodpot-morpho-fees.batch.json) | **Step 2** — Morpho fee recipients via `submit` + execute (4 txs) — superseded by harvester-v2 |
| [`morpho-collateral-caps.batch.json`](./morpho-collateral-caps.batch.json) | **Morpho curator** — collateral caps syrupUSDG / USDe / spUSDG (12 txs) |
| [`hoodpot-seed-10-usdg.batch.json`](./hoodpot-seed-10-usdg.batch.json) | **Optional** — seed $10 USDG into PrizePool |
| [`hoodpot-seed-100-usdg.batch.json`](./hoodpot-seed-100-usdg.batch.json) | **Optional** — seed $100 USDG into PrizePool for HoodPot vault |

Run **wiring → morpho fees**, then seed (if desired).

### Why two wiring batches?

Morpho Vault V2 curator functions (including `setPerformanceFeeRecipient` and `setManagementFeeRecipient`) require a prior `submit(bytes)` call. Calling them directly reverts with `DataNotTimelocked()` — Safe shows this as **GS013** during gas estimation. The Morpho vault timelock for these selectors is **0**, so `submit` and the actual call can run in the **same** multisend batch.

The same applies to **collateral token caps** (`increaseAbsoluteCap` / `increaseRelativeCap`): the Morpho curator UI shows **Not Set** when caps are zero, but saving from the UI may fail unless you use **Timelocks → submit → accept**. Use `morpho-collateral-caps.batch.json` on the Safe instead.

Verify caps after execution:

```bash
./scripts/morpho-collateral-caps.sh check
```

## After execution

```bash
cd pt-deploy
NEW_VAULT=0x11da9bE66d20328c6eA16d52079890322fA90f24 ./scripts/redeploy-hoodpot-vault.sh verify
```

All checks should pass (harvester + liquidation pair). Then start bots and test a deposit on app.hoodbet.fun.

## Addresses reference

| | |
|---|---|
| HoodPot PrizeVault | `0x11da9bE66d20328c6eA16d52079890322fA90f24` |
| Liquidation pair | `0x8d1877D32eF88DFb98059d1eE50EFCB68094B772` |
| HoodFeeHarvester | `0x3632Dd39B2717602fB4d7f79D001c3a51625159d` |
| HoodFeeHarvester (deprecated) | `0x7FB9C432e78101a6bB59e681458888acaA3db532` |
| Morpho vault | `0xDF06045aBAE69d6e73a7F0197FED917032d22194` |
| PrizePool | `0x14E5004A757A85439Fc379C8AcD5b3b3CDF47344` |
| USDG | `0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168` |

To change seed amount, edit `amount` / `_amount` fields in the seed JSON (`100000000` = 100 USDG, 6 decimals).
