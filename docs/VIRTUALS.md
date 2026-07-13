# Virtuals.io — $HOOD token launch

## Overview

HoodBet agent token launches via [Virtuals Protocol](https://www.virtuals.io/) on Robinhood Chain.

## Steps

1. Create HoodBet agent on Virtuals (EconomyOS / ACP CLI)
2. Verify chain support:
   ```bash
   acp chain list --json
   ```
3. Tokenize:
   ```bash
   acp agent tokenize --chain-id 4663 --symbol HOOD --json
   ```
4. Record token address in `contracts/config/robinhood.json` → `tokens.hood`
5. Deploy `HoodPointsRegistry`:
   ```bash
   export HOOD_TOKEN=0x...
   forge script script/DeployCore.s.sol --rpc-url $RH_RPC --broadcast
   ```

## Post-launch

- Subgraph indexes `$HOOD` transfers (see `services/subgraph/schema-hood.graphql`)
- App shows tier badge from `HoodPointsRegistry.getTier()`
- Optional: route agent trading fees to `VaultBooster` for jackpot

## References

- [Virtuals agent token docs](https://os.virtuals.io/agent-identity/token/overview)
- [Robinhood Chain × Virtuals](https://morpho.org/blog/robinhood-chooses-morpho-to-power-new-earn-product/)
