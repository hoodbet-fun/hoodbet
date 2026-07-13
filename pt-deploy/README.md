# PoolTogether V5 — Robinhood Chain Deploy

Fork and deploy using [GenerationSoftware/pt-v5-mainnet](https://github.com/GenerationSoftware/pt-v5-mainnet).

## Prerequisites

- Foundry, Node 18+, pnpm
- Safe `0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117` as deployer
- Config: [`../contracts/config/robinhood.json`](../contracts/config/robinhood.json)

## Setup

```bash
git clone https://github.com/GenerationSoftware/pt-v5-mainnet.git pt-deploy/vendor/pt-v5-mainnet
cd pt-deploy/vendor/pt-v5-mainnet
cp ../../../contracts/config/robinhood.json config/robinhood.json
pnpm install
```

## Deploy order

1. TwabController
2. PrizePool (immutable — simulate params first)
3. HoodRngBlockhash → wire to DrawManager
4. DrawManager
5. ClaimerFactory + TpdaLiquidationPairFactory
6. PrizeVaultFactory
7. PrizeVault (yieldVault = Morpho `0xDF06…2194`)
8. HoodFeeHarvester + HoodPointsRegistry (from `contracts/`)

```bash
# From contracts/
export SAFE_OWNER=0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117
export PRIZE_POOL=<deployed>
forge script script/DeployCore.s.sol --rpc-url https://rpc.mainnet.chain.robinhood.com --broadcast
```

## Post-deploy

Update `contracts/config/robinhood.json` → `deployed` addresses.

See [DEPLOYMENT.md](../docs/DEPLOYMENT.md) and [RNG.md](../docs/RNG.md).
