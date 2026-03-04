#!/usr/bin/env bash
# Autonomous Broker - News-reactive trading signal scanner
# Called by cron jobs to gather market data and output signals.json

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TRADE="$SCRIPT_DIR/trade"

# API credentials
API_KEY="PKEMX5CRIPIJ4S2YXCFUFRWX4D"
API_SECRET="AwcdsCTQbYrEDa2hb8eHXSX9zgy8uKhp9WnKg134fGcR"
AUTH_HEADERS=(-H "APCA-API-KEY-ID: $API_KEY" -H "APCA-API-SECRET-KEY: $API_SECRET")

SIGNALS_FILE="$SCRIPT_DIR/signals.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "[$TIMESTAMP] Starting autonomous broker scan..."

# 1. Scan financial news
echo "Fetching news..."
NEWS_RAW=$(curl -s --max-time 15 "https://data.alpaca.markets/v1beta1/news?limit=50" "${AUTH_HEADERS[@]}" 2>/dev/null || echo '{"news":[]}')

# Extract news signals: symbol, headline, sentiment hints
NEWS_SIGNALS=$(echo "$NEWS_RAW" | jq -r '
  [(.news // [])[:20] | .[] |
    {
      symbol: ((.symbols // [])[0] // "N/A"),
      headline: (.headline // ""),
      source: (.source // ""),
      created_at: (.created_at // ""),
      sentiment: (
        if (.headline | test("beat|surge|soar|jump|rally|upgrade|profit|record|boost|strong"; "i")) then "positive"
        elif (.headline | test("miss|drop|fall|crash|downgrade|loss|weak|cut|warn|decline"; "i")) then "negative"
        else "neutral"
        end
      ),
      action: (
        if (.headline | test("beat|surge|soar|jump|rally|upgrade|profit|record|boost|strong"; "i")) then "buy"
        elif (.headline | test("miss|drop|fall|crash|downgrade|loss|weak|cut|warn|decline"; "i")) then "sell"
        else "hold"
        end
      )
    }
  ] | map(select(.symbol != "N/A"))' 2>/dev/null || echo '[]')

# 2. Pre-market movers
echo "Fetching movers..."
MOST_ACTIVE=$(curl -s --max-time 15 "https://data.alpaca.markets/v1beta1/screener/stocks/most-actives?by=volume&top=20" "${AUTH_HEADERS[@]}" 2>/dev/null || echo '{"most_actives":[]}')
TOP_MOVERS=$(curl -s --max-time 15 "https://data.alpaca.markets/v1beta1/screener/stocks/movers?top=20" "${AUTH_HEADERS[@]}" 2>/dev/null || echo '{"gainers":[],"losers":[]}')

MOVERS=$(echo "$TOP_MOVERS" | jq '[
  (.gainers // [])[:10][] | {symbol: .symbol, change_pct: (.percent_change // 0), direction: "up"},
  (.losers // [])[:10][] | {symbol: .symbol, change_pct: (.percent_change // 0), direction: "down"}
]' 2>/dev/null || echo '[]')

# 3. Crypto prices
echo "Fetching crypto..."
BTC_QUOTE=$("$TRADE" quote BTC/USD 2>/dev/null | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0")
ETH_QUOTE=$("$TRADE" quote ETH/USD 2>/dev/null | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0")

# 4. Build signals.json
cat > "$SIGNALS_FILE" <<EOF
{
  "timestamp": "$TIMESTAMP",
  "news_signals": $NEWS_SIGNALS,
  "movers": $MOVERS,
  "crypto": {"BTC": $BTC_QUOTE, "ETH": $ETH_QUOTE}
}
EOF

echo "Signals written to $SIGNALS_FILE"
echo "News signals: $(echo "$NEWS_SIGNALS" | jq 'length') items"
echo "Movers: $(echo "$MOVERS" | jq 'length') items"
echo "BTC: $BTC_QUOTE | ETH: $ETH_QUOTE"
echo "Done."
