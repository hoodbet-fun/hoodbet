# HoodBet — Security & Launch Checklist

## HoodFeeHarvester audit notes

| Item | Status |
|------|--------|
| Only owner sets `prizeVault` | OK — `onlyOwner` |
| Asset must match prize token | OK — constructor check |
| `harvest()` permissionless | By design — anyone can trigger |
| Morpho share redemption | Trust Morpho vault — use curated vault |
| Reentrancy | Uses OZ SafeERC20 + standard ERC4626 redeem |

## HoodRngBlockhash

- **MVP only** — not production-grade randomness
- Upgrade to Witnet before high TVL ([RNG.md](./RNG.md))

## HoodPointsRegistry

- Tier thresholds owner-adjustable
- Reads `$HOOD` balance — trust token contract

## Pre-launch checklist

- [ ] Simulate PrizePool params on fork (draw period, tiers, reserve %)
- [ ] Integration tests pass (`forge test` — 13 tests)
- [ ] RNG tested with 10+ consecutive draws on testnet
- [ ] Bot dry-run 7 days
- [ ] Review immutable PrizePool config
- [ ] Subgraph deployed on Goldsky
- [ ] Contracts verified on Blockscout
- [ ] Safe Morpho fee wiring complete
- [ ] Disclaimer on landing
- [ ] First public draw documented

## Launch sequence

1. Deploy PT core + verify
2. Deploy PrizeVault + liquidation pair
3. Deploy HoodFeeHarvester + HoodPointsRegistry
4. Subgraph + bots live
5. Virtuals `$HOOD` tokenize
6. Landing + app live
7. First draw

## First draw documentation

Record in `docs/DRAWS.md`:
- Draw ID, block, random number hash
- Winners, prize amounts
- Explorer links
