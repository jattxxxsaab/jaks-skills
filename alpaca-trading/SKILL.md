# 🐾 PaperPaws — Autonomous Trading Bot

Paper trading via Alpaca API v2. CLI: `skills/alpaca-trading/trade`

## Quick Reference

```bash
trade account                          # Balance, equity, buying power
trade positions                        # Open positions with P&L
trade orders                           # Recent orders
trade history                          # Recent fills
trade quote AAPL                       # Stock quote
trade quote BTC/USD                    # Crypto quote
trade bars AAPL --timeframe 1Day --limit 10  # Price candles
trade buy AAPL 10                      # Market buy
trade buy AAPL 10 --limit 150.00      # Limit buy
trade sell AAPL 10                     # Market sell
trade short TSLA 5                     # Short sell
trade buy-crypto BTC/USD 0.001        # Buy crypto
trade sell-crypto ETH/USD 0.1         # Sell crypto
trade close AAPL                       # Close position
trade close-all                        # Close all
trade cancel ORDER_ID                  # Cancel order
trade cancel-all                       # Cancel all orders
trade watch AAPL --above 200          # Price alert (JSON output)
trade watch AAPL --below 150          # Price alert (JSON output)
```

## Agent Usage Examples

**Direct trading:** When user says "buy 10 shares of AAPL":
```bash
skills/alpaca-trading/trade buy AAPL 10
```

**Portfolio check:** "How's my portfolio?"
```bash
skills/alpaca-trading/trade account
skills/alpaca-trading/trade positions
```

**Price alerts via cron:** Set up a cron job that runs:
```bash
result=$(skills/alpaca-trading/trade watch AAPL --above 200)
if echo "$result" | jq -e '.triggered' > /dev/null; then
  # notify user
fi
```

**Strategy execution:** Run strategy scripts from `strategies/` dir:
```bash
skills/alpaca-trading/strategies/momentum.sh AAPL
skills/alpaca-trading/strategies/ma-crossover.sh TSLA
```

## Safety Guardrails
- Max single trade: $10,000 (configurable in alpaca-keys.env)
- Daily loss limit: $5,000
- All trades logged to `trade-log.json`
- Paper trading only (https://paper-api.alpaca.markets)

## Autonomous Broker (Cron Jobs)

News-reactive autonomous trading system. Scans news, identifies opportunities, executes trades, and reports to Jimmy via iMessage.

### Schedule (All PT, Weekdays unless noted)

| Job | Time | Cron ID | Purpose |
|-----|------|---------|---------|
| Pre-Market Scan | 6:00 AM | `97d4c57d` | News scan, movers, plan trades |
| Market Open Exec | 6:31 AM | `606be50c` | Execute planned trades |
| Intraday Monitor | Every 30min 7AM-12:30PM | `35d5c08a` | Stop-loss, take-profit, news |
| EOD Review | 12:55 PM | `ea0e2fd3` | Hold/close decisions |
| Daily P&L Report | 1:15 PM | `fead2639` | Send daily summary to Jimmy |
| Crypto Monitor | Every 4h 24/7 | `a9b729af` | BTC/ETH price tracking |

### Key Files
- `autonomous-broker.sh` — Market scanner script (news + movers + crypto)
- `signals.json` — Latest scan output
- `daily-plan.json` — Today's trade plan (written by pre-market scan)
- `trade-executions.log` — Execution log
- `eod-summary.json` — End-of-day summary
- `crypto-last.json` — Last crypto price check

### Rules
- Max $10K per trade, max 10 open positions
- Auto-sell if position down >5%
- Consider profit-taking at >8% gain
- Crypto: trade on >3% moves
- Only messages Jimmy when trades execute or notable events occur

## Config
API keys in `alpaca-keys.env`. Never commit real keys.
