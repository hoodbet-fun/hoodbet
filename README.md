# hoodbet.fun

Prize-linked savings on [Robinhood Chain](https://docs.robinhood.com/chain/) — PoolTogether V5 + Morpho + HoodBet branding.

## Repositories

| Repo | Description |
|------|-------------|
| [docs](https://github.com/hoodbet-fun/docs) | Protocol documentation (GitBook) |
| [hoodbet](https://github.com/hoodbet-fun/hoodbet) | Monorepo index + PT deploy guide |
| [contracts](https://github.com/hoodbet-fun/contracts) | Smart contracts (Foundry) |
| [landing](https://github.com/hoodbet-fun/landing) | hoodbet.fun marketing site |
| [app](https://github.com/hoodbet-fun/app) | HoodPot dApp (app.hoodbet.fun) |
| [subgraph](https://github.com/hoodbet-fun/subgraph) | Goldsky subgraph extensions |
| [bots](https://github.com/hoodbet-fun/bots) | Draw, liquidation, claim bots |

## Structure

```
├── landing/          → hoodbet.fun
├── app/              → app.hoodbet.fun (HoodPot dApp)
├── contracts/        → HoodFeeHarvester, HoodPointsRegistry, HoodRngBlockhash
├── pt-deploy/        → PT V5 mainnet deploy guide
├── services/
│   ├── subgraph/     → Goldsky (free tier)
│   └── bots/         → liquidation, draw, claim
├── packages/config/  → shared theme + addresses
└── docs/
```

## Quick start

```bash
# Contracts
cd contracts && forge test

# Landing
cd landing && npm install && npm run dev

# App
cd app && npm install && npm run dev
```

## On-chain

| Item | Address |
|------|---------|
| Morpho vault | `0xDF06045aBAE69d6e73a7F0197FED917032d22194` |
| USDG | `0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168` |
| Safe | `0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117` |

## Docs

Published on [GitBook](https://hoodbet-fun.gitbook.io) from [hoodbet-fun/docs](https://github.com/hoodbet-fun/docs):

- [Architecture](https://github.com/hoodbet-fun/docs/blob/main/ARCHITECTURE.md)
- [Brand Book](https://github.com/hoodbet-fun/docs/blob/main/BRAND.md)
- [Deploy mainnet](https://github.com/hoodbet-fun/docs/blob/main/DEPLOY_MAINNET.md)
- [RNG decision](https://github.com/hoodbet-fun/docs/blob/main/RNG.md)
- [Virtuals $HOOD](https://github.com/hoodbet-fun/docs/blob/main/VIRTUALS.md)
- [Security checklist](https://github.com/hoodbet-fun/docs/blob/main/SECURITY.md)
