# HoodPot prize core — Robinhood Chain deploy

Deploy the prize pool stack using [GenerationSoftware/pt-v5-mainnet](https://github.com/GenerationSoftware/pt-v5-mainnet) scripts with **real mainnet tokens only**. User-facing brand: **HoodPot**.

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
4. **Prize pool core** — `forge script` with `config/robinhood.json` (see deploy order below)
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

## HoodPot PrizeVault redeploy (yield buffer fix)

The live HoodPot vault `0x318b…0e17` was deployed with **`yieldBuffer = 0`** (immutable). All deposits revert (`LossyDeposit` / `maxDeposit = 0`). **Upgrade is impossible** — deploy a new vault via the existing factory.

### Prerequisites

1. **≥ 1 USDG** on Safe (`0x5FF9…f117`) — seeded into the new vault at deploy
2. Safe executes the transactions below (see [`scripts/redeploy-hoodpot-vault.sh`](./scripts/redeploy-hoodpot-vault.sh))

### Safe transaction batch

| # | To | Function | Notes |
|---|-----|----------|-------|
| 1 | USDG `0x5fc5…d168` | `approve(factory, 1_000_000)` | Allow buffer transfer |
| 2 | PrizeVaultFactory `0xa81b…e5c2` | `deployVault(...)` | Morpho yield vault, buffer `1_000_000`, owner = Safe |
| 3 | HoodFeeHarvester `0x3632…159d` | `setPrizeVault(newVault)` | Point fee harvester at new vault |

Generate calldata:

```bash
cd pt-deploy
./scripts/redeploy-hoodpot-vault.sh status
./scripts/redeploy-hoodpot-vault.sh calldata-approve
./scripts/redeploy-hoodpot-vault.sh calldata-deploy
```

### After deploy

1. `NEW_VAULT=0x... ./scripts/redeploy-hoodpot-vault.sh verify` — `maxDeposit` must be **> 0**
2. Update `prizeVault` in `contracts/config/robinhood.json`, `app/src/config.js`, `packages/config/hoodbet.js`, subgraph `networks/robinhood.json`
3. Mark `0x318b…0e17` as deprecated in docs (zero TVL — no user migration)
4. Test a small deposit on app.hoodbet.fun
