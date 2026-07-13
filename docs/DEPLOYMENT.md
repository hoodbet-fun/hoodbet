# hoodbet.fun deployment checklist

## Current on-chain state (mainnet)

| Item | Status |
|------|--------|
| Morpho vault `hoodbet.fun` | Deployed (~$1 TVL) |
| USDG asset | Live |
| Safe as owner + fee recipient | Configured |
| PoolTogether V5 core | Pending — see pt-deploy/ |
| PrizeVault wrapper | Pending |
| HoodFeeHarvester | Contract ready — pending deploy |
| HoodRngBlockhash | Contract ready — pending deploy |
| HoodPointsRegistry | Pending $HOOD token |
| Subgraph Goldsky | Scaffold in services/subgraph/ |
| Bots | Scaffold in services/bots/ |
| Landing | `landing/` — build OK |
| App | `app/` — build OK |

## Deploy flow

1. [pt-deploy/README.md](../pt-deploy/README.md) — PT V5 core
2. [DEPLOY_MAINNET.md](./DEPLOY_MAINNET.md) — HoodBet contracts
3. [SAFE_MORPHO_WIRING.md](./SAFE_MORPHO_WIRING.md) — Safe + Morpho
4. [VIRTUALS.md](./VIRTUALS.md) — $HOOD token
5. [services/subgraph/README.md](../services/subgraph/README.md) — Goldsky

## HoodBet custom deploy

```bash
cd contracts
export SAFE_OWNER=0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117
export PRIZE_POOL=<deployed>
forge script script/DeployCore.s.sol --rpc-url https://rpc.mainnet.chain.robinhood.com --broadcast
```

## Frontend deploy

| URL | Directory |
|-----|-------------|
| hoodbet.fun | `landing/` |
| app.hoodbet.fun | `app/` |
