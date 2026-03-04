#!/usr/bin/env bash
# Moving Average Crossover: 50/200 day SMA
set -euo pipefail
TRADE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/trade"
SYMBOL="${1:?Usage: ma-crossover.sh SYMBOL [SHORT_MA] [LONG_MA]}"
SHORT_MA="${2:-50}"
LONG_MA="${3:-200}"

bars=$($TRADE bars "$SYMBOL" --timeframe 1Day --limit "$LONG_MA")
closes=($(echo "$bars" | grep -oP 'C:[\d.]+' | cut -d: -f2))

if [ ${#closes[@]} -lt "$LONG_MA" ]; then
  echo '{"symbol":"'"$SYMBOL"'","signal":"error","reason":"need '"$LONG_MA"' bars, got '"${#closes[@]}"'"}'
  exit 1
fi

calc_sma() {
  local period=$1; shift; local vals=("$@")
  local sum=0 start=$(( ${#vals[@]} - period ))
  for ((i=start; i<${#vals[@]}; i++)); do sum=$(echo "$sum + ${vals[$i]}" | bc); done
  echo "scale=2; $sum / $period" | bc
}

sma_short=$(calc_sma "$SHORT_MA" "${closes[@]}")
sma_long=$(calc_sma "$LONG_MA" "${closes[@]}")
current="${closes[-1]}"

if (( $(echo "$sma_short > $sma_long" | bc -l) )); then signal="BUY"
else signal="SELL"; fi

jq -n --arg sym "$SYMBOL" --arg sig "$signal" --arg ss "$sma_short" --arg sl "$sma_long" --arg cur "$current" \
  '{symbol:$sym, signal:$sig, sma_short:($ss|tonumber), sma_long:($sl|tonumber), current_price:($cur|tonumber), short_period:'$SHORT_MA', long_period:'$LONG_MA'}'
