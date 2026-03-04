#!/usr/bin/env bash
# Momentum Strategy: Buy if stock is up X% over last N days
set -euo pipefail
TRADE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/trade"
SYMBOL="${1:?Usage: momentum.sh SYMBOL [THRESHOLD_PCT] [DAYS]}"
THRESHOLD="${2:-3}"  # 3% default
DAYS="${3:-5}"

bars=$($TRADE bars "$SYMBOL" --timeframe 1Day --limit "$DAYS")
first_close=$(echo "$bars" | head -1 | grep -oP 'C:[\d.]+' | cut -d: -f2)
last_close=$(echo "$bars" | tail -1 | grep -oP 'C:[\d.]+' | cut -d: -f2)

if [ -z "$first_close" ] || [ -z "$last_close" ]; then
  echo '{"symbol":"'"$SYMBOL"'","signal":"error","reason":"insufficient data"}'
  exit 1
fi

pct=$(echo "scale=2; ($last_close - $first_close) / $first_close * 100" | bc)
if (( $(echo "$pct >= $THRESHOLD" | bc -l) )); then
  signal="BUY"
elif (( $(echo "$pct <= -$THRESHOLD" | bc -l) )); then
  signal="SELL"
else
  signal="HOLD"
fi

jq -n --arg sym "$SYMBOL" --arg sig "$signal" --arg pct "$pct" --arg fc "$first_close" --arg lc "$last_close" \
  '{symbol:$sym, signal:$sig, change_pct:($pct|tonumber), open_price:($fc|tonumber), close_price:($lc|tonumber)}'
