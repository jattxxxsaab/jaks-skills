#!/usr/bin/env bash
# Mean Reversion: Buy when RSI < 30, Sell when RSI > 70
set -euo pipefail
TRADE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/trade"
SYMBOL="${1:?Usage: mean-reversion.sh SYMBOL [PERIOD]}"
PERIOD="${2:-14}"

bars=$($TRADE bars "$SYMBOL" --timeframe 1Day --limit $((PERIOD + 1)))
closes=($(echo "$bars" | grep -oP 'C:[\d.]+' | cut -d: -f2))

if [ ${#closes[@]} -lt $((PERIOD + 1)) ]; then
  echo '{"symbol":"'"$SYMBOL"'","signal":"error","reason":"insufficient data"}'
  exit 1
fi

# Calculate RSI
gains=0; losses=0
for ((i=1; i<${#closes[@]}; i++)); do
  diff=$(echo "${closes[$i]} - ${closes[$((i-1))]}" | bc)
  if (( $(echo "$diff > 0" | bc -l) )); then
    gains=$(echo "$gains + $diff" | bc)
  else
    losses=$(echo "$losses + ${diff#-}" | bc)
  fi
done
avg_gain=$(echo "scale=4; $gains / $PERIOD" | bc)
avg_loss=$(echo "scale=4; $losses / $PERIOD" | bc)

if (( $(echo "$avg_loss == 0" | bc -l) )); then
  rsi=100
else
  rs=$(echo "scale=4; $avg_gain / $avg_loss" | bc)
  rsi=$(echo "scale=2; 100 - (100 / (1 + $rs))" | bc)
fi

if (( $(echo "$rsi < 30" | bc -l) )); then signal="BUY"
elif (( $(echo "$rsi > 70" | bc -l) )); then signal="SELL"
else signal="HOLD"; fi

jq -n --arg sym "$SYMBOL" --arg sig "$signal" --arg rsi "$rsi" \
  '{symbol:$sym, signal:$sig, rsi:($rsi|tonumber), period:'$PERIOD'}'
