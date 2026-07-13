# HoodBet RNG Decision — Robinhood Chain (4663)

## Decision (rng-gate)

| Option | Status on RH Chain | Verdict |
|--------|-------------------|---------|
| Chainlink VRF | Not listed on [supported networks](https://docs.chain.link/vrf/v2-5/supported-networks) | Defer |
| Witnet `witnet-randomness-v2` | Verify at deploy time via `pt-v5-mainnet` | **Production target** |
| L1 bridge (`RngAuction` + relay) | Works but adds latency + cost | Fallback |
| `HoodRngBlockhash` | Deployed with repo | **MVP bootstrap** |

## MVP: `HoodRngBlockhash`

- Same-chain adapter implementing PT `IRng`
- Request → wait 5 blocks → `fulfillRandomness`
- Draw bot calls `requestRandomness()` then `fulfillRandomness()` after delay
- **Not production-grade** — upgrade before high TVL

## Production path

1. Check Witnet deployment on chain 4663
2. If available: deploy `RngWitnet` from [rng-witnet-pooltogether](https://github.com/drcpu-github/rng-witnet-pooltogether)
3. Point `DrawManager` to new RNG via Safe governance
4. Deprecate blockhash adapter

## Config

See `contracts/config/robinhood.json` → `rng.type`: `blockhash-mvp` → upgrade to `witnet-randomness-v2`
