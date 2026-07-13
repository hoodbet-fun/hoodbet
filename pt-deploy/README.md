# PoolTogether V5 — Robinhood Chain Deploy

Deploy using [GenerationSoftware/pt-v5-mainnet](https://github.com/GenerationSoftware/pt-v5-mainnet) with **real mainnet tokens only**.

## Real on-chain assets (chain 4663)

| Asset | Address |
|-------|---------|
| **USDG** | `0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168` |
| **Morpho vault `hoodbet.fun`** | `0xDF06045aBAE69d6e73a7F0197FED917032d22194` |
| **Safe (owner)** | `0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117` |

No placeholder or zero addresses in production config. `$HOOD` is deployed separately via Virtuals **after** launch — do not use `0x000…000`.

Canonical list: [`config/hoodbet-tokens.json`](./config/hoodbet-tokens.json)

## Setup

```bash
git clone https://github.com/GenerationSoftware/pt-v5-mainnet.git pt-deploy/vendor/pt-v5-mainnet
cd pt-deploy/vendor/pt-v5-mainnet
git submodule update --init --recursive
yarn install && yarn compile
```

## Deploy order

1. **HoodRngBlockhash** — `contracts/script/DeployCore.s.sol` (no `PRIZE_POOL` yet)
2. Copy [`config/robinhood.pt.example.json`](../config/robinhood.pt.example.json) → `vendor/pt-v5-mainnet/config/robinhood.json`
3. Set `rng.contract` to the **deployed HoodRngBlockhash** address (real contract, not zero)
4. **PT V5 core** — `yarn deploy:robinhood` (after adding script — see below)
5. **HoodPot PrizeVault** — Morpho vault `0xDF06…2194` as `yieldVault`, USDG prizes
6. **HoodFeeHarvester** — `PRIZE_POOL` = deployed PrizePool
7. Safe: Morpho fee recipients → HoodFeeHarvester

### PT config notes

- `prize_token` = **USDG** (same as deposits)
- `stake_to_win.staking_vault.asset` = **USDG** (not a mock POOL token)
- HoodPot wrapper uses **Morpho ERC-4626** `0xDF06…2194`

## HoodBet contracts

```bash
cd contracts
export SAFE_OWNER=0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117
# Step 1 — RNG only:
forge script script/DeployCore.s.sol --rpc-url https://rpc.mainnet.chain.robinhood.com --broadcast
# Step 2 — after PrizePool deploy:
export PRIZE_POOL=<deployed PrizePool>
forge script script/DeployCore.s.sol --rpc-url https://rpc.mainnet.chain.robinhood.com --broadcast
# HoodPointsRegistry — only after real $HOOD from Virtuals:
export HOOD_TOKEN=<real HOOD address>
forge script script/DeployCore.s.sol --rpc-url https://rpc.mainnet.chain.robinhood.com --broadcast
```

## Post-deploy

Update [`contracts/config/robinhood.json`](../contracts/config/robinhood.json) → `deployed` with verified addresses.
