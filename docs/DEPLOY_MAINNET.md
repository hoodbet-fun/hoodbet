# HoodBet mainnet deploy runbook

Execute via Safe `0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117`.

## 1. HoodBet custom contracts

```bash
cd contracts
export SAFE_OWNER=0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117
export PRIZE_POOL=<after PT deploy>
export HOOD_TOKEN=<after Virtuals tokenize>
forge script script/DeployCore.s.sol \
  --rpc-url https://rpc.mainnet.chain.robinhood.com \
  --broadcast \
  --verify --verifier blockscout \
  --verifier-url https://robinhoodchain.blockscout.com/api/
```

## 2. PT V5 core

Follow [pt-deploy/README.md](../pt-deploy/README.md). Record addresses in `contracts/config/robinhood.json` → `deployed`.

## 3. PrizeVault

```text
PrizeVaultFactory.deployVault(
  name: "HoodPot USDG",
  symbol: "hpUSDG",
  yieldVault: 0xDF06045aBAE69d6e73a7F0197FED917032d22194,
  prizePool: <PrizePool>,
  ...
  owner: Safe
)
```

## 4. Wire HoodFeeHarvester

```solidity
harvester.setPrizeVault(<PrizeVault>);
```

## 5. Verify on Blockscout

All contracts at https://robinhoodchain.blockscout.com
