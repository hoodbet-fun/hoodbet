#!/usr/bin/env bash
# HoodPot PrizeVault redeploy — calldata helpers + extended verify.
set -euo pipefail

RPC="${RPC_URL:-https://rpc.mainnet.chain.robinhood.com}"

USDG=0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168
MORPHO=0xDF06045aBAE69d6e73a7F0197FED917032d22194
PRIZE_POOL=0x14e5004a757a85439fc379c8acd5b3b3cdf47344
CLAIMER=0x71ec0971e8f8e35568a4bbe0fc118e6ca0ebe707
FACTORY=0xa81b8281586115a228763a584734325beb71e5c2
LP_FACTORY=0x00049fce2de06310805693b00b63755ca6b22fe7
HARVESTER=0x3632Dd39B2717602fB4d7f79D001c3a51625159d
SAFE=0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117
OLD_VAULT=0x318b89c2b407f091adcbc02854dd3f96e3470e17
DEPLOYER=0x8Ac130E606545aD94E26fCF09CcDd950A981A704

YIELD_BUFFER="${YIELD_BUFFER:-500000}"
NAME="HoodPot"
SYMBOL="hpUSDG"

cmd="${1:-status}"

case "$cmd" in
  status)
    echo "=== Broken vault ==="
    echo "yieldBuffer:" $(cast call "$OLD_VAULT" "yieldBuffer()(uint256)" --rpc-url "$RPC")
    echo "maxDeposit:" $(cast call "$OLD_VAULT" "maxDeposit(address)(uint256)" "$DEPLOYER" --rpc-url "$RPC")
    echo
    echo "=== Deployer USDG (need >= $YIELD_BUFFER) ==="
    cast call "$USDG" "balanceOf(address)(uint256)" "$DEPLOYER" --rpc-url "$RPC"
    echo
    echo "=== Safe USDG ==="
    cast call "$USDG" "balanceOf(address)(uint256)" "$SAFE" --rpc-url "$RPC"
    echo
    echo "=== Morpho fee recipients (should be harvester after Safe batch) ==="
    echo "performance:" $(cast call "$MORPHO" "performanceFeeRecipient()(address)" --rpc-url "$RPC")
    echo "management:" $(cast call "$MORPHO" "managementFeeRecipient()(address)" --rpc-url "$RPC")
    echo
    echo "Harvester prizeVault:" $(cast call "$HARVESTER" "prizeVault()(address)" --rpc-url "$RPC")
    echo "Factory vault count:" $(cast call "$FACTORY" "totalVaults()(uint256)" --rpc-url "$RPC")
    ;;

  calldata-approve)
    cast calldata "approve(address,uint256)" "$FACTORY" "$YIELD_BUFFER"
    ;;

  calldata-deploy)
    cast calldata \
      "deployVault(string,string,address,address,address,address,uint32,uint256,address)" \
      "$NAME" "$SYMBOL" "$MORPHO" "$PRIZE_POOL" "$CLAIMER" \
      "0x0000000000000000000000000000000000000000" 0 "$YIELD_BUFFER" "$SAFE"
    ;;

  calldata-set-harvester)
    NEW_VAULT="${NEW_VAULT:?Set NEW_VAULT}"
    cast calldata "setPrizeVault(address)" "$NEW_VAULT"
    ;;

  calldata-morpho-fees)
    perf=$(cast calldata "setPerformanceFeeRecipient(address)" "$HARVESTER")
    mgmt=$(cast calldata "setManagementFeeRecipient(address)" "$HARVESTER")
    echo "submit(perf): $(cast calldata "submit(bytes)" "$perf")"
    echo "setPerformanceFeeRecipient: $perf"
    echo "---"
    echo "submit(mgmt): $(cast calldata "submit(bytes)" "$mgmt")"
    echo "setManagementFeeRecipient: $mgmt"
    ;;

  calldata-set-liquidation-pair)
    NEW_VAULT="${NEW_VAULT:?Set NEW_VAULT}"
    NEW_PAIR="${NEW_PAIR:?Set NEW_PAIR}"
    cast calldata "setLiquidationPair(address)" "$NEW_PAIR"
    ;;

  verify)
    NEW_VAULT="${NEW_VAULT:?Set NEW_VAULT}"
    min_buffer="${MIN_YIELD_BUFFER:-1}"
    fail=0

    check() {
      local label="$1" actual="$2" expected="$3"
      actual_lc=$(echo "$actual" | tr '[:upper:]' '[:lower:]')
      expected_lc=$(echo "$expected" | tr '[:upper:]' '[:lower:]')
      if [[ "$actual_lc" != "$expected_lc" ]]; then
        echo "FAIL $label: got $actual want $expected"
        fail=1
      else
        echo "OK   $label: $actual"
      fi
    }

    deployed=$(cast call "$FACTORY" "deployedVaults(address)(bool)" "$NEW_VAULT" --rpc-url "$RPC")
    check "factory.deployedVaults" "$deployed" "true"

    yb=$(cast call "$NEW_VAULT" "yieldBuffer()(uint256)" --rpc-url "$RPC")
    [[ "$yb" -ge "$min_buffer" ]] || { echo "FAIL yieldBuffer: $yb"; fail=1; }

    maxd=$(cast call "$NEW_VAULT" "maxDeposit(address)(uint256)" "$DEPLOYER" --rpc-url "$RPC")
    echo "INFO maxDeposit: $maxd (Morpho V2 may report 0 while deposits work)"

    check "yieldVault" "$(cast call "$NEW_VAULT" "yieldVault()(address)" --rpc-url "$RPC")" "$MORPHO"
    check "prizePool" "$(cast call "$NEW_VAULT" "prizePool()(address)" --rpc-url "$RPC")" "$PRIZE_POOL"
    check "owner" "$(cast call "$NEW_VAULT" "owner()(address)" --rpc-url "$RPC")" "$SAFE"

    lp=$(cast call "$NEW_VAULT" "liquidationPair()(address)" --rpc-url "$RPC")
    [[ "$lp" != "0x0000000000000000000000000000000000000000" ]] || { echo "FAIL liquidationPair unset"; fail=1; }

    hv=$(cast call "$HARVESTER" "prizeVault()(address)" --rpc-url "$RPC")
    if [[ "$(echo "$hv" | tr '[:upper:]' '[:lower:]')" != "$(echo "$NEW_VAULT" | tr '[:upper:]' '[:lower:]')" ]]; then
      echo "WARN harvester.prizeVault still $hv (Safe must call setPrizeVault)"
    else
      echo "OK   harvester.prizeVault"
    fi

    exit "$fail"
    ;;

  deploy)
  echo "Broadcasting forge script (DeployHoodPotVault.s.sol)..."
  cd "$(dirname "$0")/../../contracts"
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
  YIELD_BUFFER="$YIELD_BUFFER" forge script script/DeployHoodPotVault.s.sol \
    --rpc-url "${RH_RPC_URL:-$RPC}" \
    --broadcast \
    -vv
  ;;

  *)
    echo "Usage: $0 {status|deploy|verify|calldata-approve|calldata-deploy|calldata-set-harvester|calldata-morpho-fees|calldata-set-liquidation-pair}"
    exit 1
    ;;
esac
