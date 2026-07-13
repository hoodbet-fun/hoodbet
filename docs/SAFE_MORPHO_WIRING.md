# Safe + Morpho vault wiring

Safe: https://app.safe.global/home?safe=robinhood:0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117

Morpho vault: `0xDF06045aBAE69d6e73a7F0197FED917032d22194`

## Prerequisites

- `HoodFeeHarvester` deployed
- `PrizeVault` deployed and `harvester.setPrizeVault()` called

## Morpho timelock steps

Morpho Vault V2 uses `submit(bytes)` + wait timelock + `execute(bytes)`.

### 1. Set performance fee recipient

```solidity
// calldata for setPerformanceFeeRecipient(harvester)
vault.submit(abi.encodeCall(IVault.setPerformanceFeeRecipient, (harvesterAddress)));
```

### 2. Set management fee recipient

```solidity
vault.submit(abi.encodeCall(IVault.setManagementFeeRecipient, (harvesterAddress)));
```

### 3. After timelock

```solidity
vault.execute(/* same calldata */);
```

### 4. Verify harvester can receive shares

Ensure `HoodFeeHarvester` passes Morpho `canReceiveShares` gate.

### 5. First harvest

```solidity
harvester.harvest(); // permissionless after fees accrue
```

## Checklist

- [ ] `performanceFeeRecipient` = HoodFeeHarvester
- [ ] `managementFeeRecipient` = HoodFeeHarvester
- [ ] `harvester.prizeVault()` = PrizeVault address
- [ ] Test harvest with small fee accrual
