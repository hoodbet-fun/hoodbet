#!/usr/bin/env bash
# Generate Morpho Vault V2 collateral token cap calldata (submit + execute).
# Curator: Safe 0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117
# Vault:   0xDF06045aBAE69d6e73a7F0197FED917032d22194
set -euo pipefail

MORPHO="${MORPHO:-0xDF06045aBAE69d6e73a7F0197FED917032d22194}"
MAX_ABS="${MAX_ABS:-340282366920938463463374607431768211455}" # type(uint128).max
REL_CAP="${REL_CAP:-1000000000000000000}"                    # 1e18 = 100%

declare -a TOKENS=(
  "syrupUSDG:0x40858070814a57FdF33a613ae84fE0a8b4a874f7"
  "USDe:0x5d3a1ff2b6bab83b63cd9ad0787074081a52ef34"
  "spUSDG:0xde770c84FE66E063336b31737cFE9790f18c4087"
)

cap_txs() {
  local token="$1"
  local idData absInner relInner
  idData=$(cast abi-encode 'f(string,address)' 'collateralToken' "$token")
  absInner=$(cast calldata "increaseAbsoluteCap(bytes,uint256)" "$idData" "$MAX_ABS")
  relInner=$(cast calldata "increaseRelativeCap(bytes,uint256)" "$idData" "$REL_CAP")
  echo "submit(bytes) abs: $(cast calldata 'submit(bytes)' "$absInner")"
  echo "increaseAbsoluteCap: $absInner"
  echo "submit(bytes) rel: $(cast calldata 'submit(bytes)' "$relInner")"
  echo "increaseRelativeCap: $relInner"
  echo "---"
}

case "${1:-calldata}" in
  calldata)
    for entry in "${TOKENS[@]}"; do
      echo "=== ${entry%%:*} ==="
      cap_txs "${entry##*:}"
    done
    ;;
  check)
    RPC="${RPC:-https://rpc.mainnet.chain.robinhood.com}"
    for entry in "${TOKENS[@]}"; do
      token="${entry##*:}"
      id=$(cast keccak "$(cast abi-encode 'f(string,address)' 'collateralToken' "$token")")
      abs=$(cast call "$MORPHO" "absoluteCap(bytes32)(uint256)" "$id" --rpc-url "$RPC")
      rel=$(cast call "$MORPHO" "relativeCap(bytes32)(uint256)" "$id" --rpc-url "$RPC")
      echo "${entry%%:*}: absolute=$abs relative=$rel"
    done
    ;;
  *)
    echo "Usage: $0 {calldata|check}"
    exit 1
    ;;
esac
