# 🐾 PaperPaws — Autonomous Trading Bot

## Overview

PaperPaws is an AI-powered autonomous trading bot that reacts to real-time financial news, market movers, and technical signals to execute trades automatically. Built on Alpaca's paper trading platform, it simulates a fully autonomous broker managing a $100,000 portfolio across stocks and cryptocurrency.

The bot is designed to operate independently during market hours with minimal human intervention, sending trade confirmations and daily performance reports via iMessage.

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    PaperPaws 🐾                      │
├─────────────────────────────────────────────────────┤
│                                                      │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐     │
│   │  News &   │    │ Decision │    │  Trade   │     │
│   │  Data     │───▶│  Engine  │───▶│ Executor │     │
│   │  Scanner  │    │  (AI)    │    │  (CLI)   │     │
│   └──────────┘    └──────────┘    └──────────┘     │
│        │                │               │            │
│        ▼                ▼               ▼            │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐     │
│   │  Alpaca   │    │  Signal  │    │  Trade   │     │
│   │  News API │    │  Store   │    │   Log    │     │
│   └──────────┘    └──────────┘    └──────────┘     │
│                         │                            │
│                         ▼                            │
│                  ┌──────────────┐                    │
│                  │   iMessage   │                    │
│                  │  Reporting   │                    │
│                  └──────────────┘                    │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

## How It Works

### 1. Data Collection

PaperPaws gathers information from multiple sources:

- **Alpaca News API** — Real-time financial news headlines with associated stock symbols and sentiment
- **Market Screeners** — Pre-market movers (biggest gainers/losers), most active stocks by volume
- **Price Data** — Live quotes, historical bars/candles for technical analysis
- **Crypto Markets** — BTC/USD and ETH/USD pricing (24/7)

### 2. Signal Generation

The AI analyzes collected data and generates trading signals based on:

**News-Based Signals:**
- Positive catalysts → BUY signal (e.g., earnings beat, FDA approval, major contract win, analyst upgrade)
- Negative catalysts → SHORT or AVOID signal (e.g., earnings miss, lawsuit, downgrade, executive departure)
- Sector momentum → Identify trending sectors and find best entries

**Technical Signals:**
- **Momentum Strategy** — Buy stocks showing strong upward momentum over the last 5-20 days
- **Mean Reversion (RSI)** — Buy when RSI drops below 30 (oversold), sell when RSI rises above 70 (overbought)
- **Moving Average Crossover** — Buy when 50-day MA crosses above 200-day MA (golden cross), sell on death cross

**Pre-Market Movers:**
- Stocks gapping up >3% on high volume → potential momentum play
- Stocks gapping down >5% → potential mean reversion bounce or short continuation

### 3. Trade Execution

Once signals are generated, the bot:

1. Validates the trade against safety guardrails
2. Calculates position size (max $10,000 per trade)
3. Submits the order via Alpaca API (market or limit order)
4. Sets a stop-loss at -5% from entry
5. Sets a take-profit target at +8% from entry
6. Logs the trade with full reasoning

### 4. Position Management

Throughout the day, PaperPaws:
- Monitors all open positions every 30 minutes
- Checks for new news on held stocks
- Auto-sells if stop-loss is hit (-5%)
- Takes partial or full profit at +8%
- Adjusts stops to breakeven after +4% gain (trailing stop logic)
- Closes weak positions before market close if no overnight thesis

### 5. Reporting

- **Pre-Market Briefing (6:00 AM)** — Top opportunities, planned trades, portfolio status
- **Trade Confirmations** — Instant iMessage when a trade executes
- **Notable Alerts** — Major news on held positions, stop-loss triggers
- **Daily P&L Report (1:15 PM)** — Full summary of the day's performance

---

## Daily Schedule

| Time (PST) | Action | Description |
|------------|--------|-------------|
| 6:00 AM | **Pre-Market Scan** | Scan news, identify movers, analyze signals, send game plan to user |
| 6:31 AM | **Market Open Execution** | Execute planned trades from pre-market analysis |
| 7:00 AM – 12:30 PM | **Intraday Monitor** (every 30 min) | Check positions, scan news, execute stops/profits, enter new positions on breaking news |
| 12:55 PM | **End-of-Day Review** | Review all positions, close weak holdings, prepare overnight strategy |
| 1:15 PM | **Daily P&L Report** | Send complete performance summary via iMessage |
| Every 4 hours (24/7) | **Crypto Monitor** | Check BTC & ETH prices, scan crypto news, trade on major moves (>3%) |

---

## Risk Management & Safety Guardrails

| Rule | Setting | Purpose |
|------|---------|---------|
| Max Trade Size | $10,000 | Limits exposure on any single trade |
| Max Open Positions | 10 | Prevents over-diversification and capital spread |
| Stop-Loss | -5% per position | Automatic downside protection |
| Take-Profit | +8% per position | Locks in gains |
| Daily Loss Limit | $5,000 | Bot stops trading for the day if hit |
| Max Portfolio Risk | 50% of capital | Never more than $50K deployed at once |
| Trade Logging | Every trade logged | Full audit trail with reasoning |

### Safety Logic Flow:

```
New Trade Signal Detected
        │
        ▼
  ┌─────────────┐    NO     ┌──────────┐
  │ Daily loss   │─────────▶│  REJECT  │
  │ limit hit?   │          │  TRADE   │
  └──────┬──────┘          └──────────┘
         │ NO
         ▼
  ┌─────────────┐    YES    ┌──────────┐
  │ Trade > $10K?│─────────▶│  REJECT  │
  └──────┬──────┘          │  TRADE   │
         │ NO              └──────────┘
         ▼
  ┌─────────────┐    YES    ┌──────────┐
  │ Max positions│─────────▶│  REJECT  │
  │ reached (10)?│          │  TRADE   │
  └──────┬──────┘          └──────────┘
         │ NO
         ▼
  ┌─────────────┐
  │  EXECUTE    │
  │  TRADE      │
  │ + Set Stop  │
  │ + Log       │
  │ + Notify    │
  └─────────────┘
```

---

## Trading Strategies

### Strategy 1: News Catalyst Trading
- **Trigger:** Breaking news with positive/negative sentiment on a specific stock
- **Entry:** Immediately on signal, market order
- **Exit:** Stop-loss at -5%, take-profit at +8%, or on reversing news
- **Edge:** Speed of reaction to news before broader market prices it in

### Strategy 2: Momentum / Pre-Market Movers
- **Trigger:** Stock gapping up >3% on 2x average volume in pre-market
- **Entry:** At market open (6:31 AM)
- **Exit:** Intraday — sell on momentum fade, trailing stop at -3% from high
- **Edge:** Catching continuation of strong opening moves

### Strategy 3: Mean Reversion (RSI)
- **Trigger:** RSI drops below 30 (oversold) on a fundamentally sound stock
- **Entry:** Limit order near support levels
- **Exit:** RSI returns above 50, or stop-loss at -5%
- **Edge:** Buying temporary fear/panic on quality names

### Strategy 4: Moving Average Crossover
- **Trigger:** 50-day MA crosses above 200-day MA (golden cross)
- **Entry:** Market order on confirmation
- **Exit:** 50-day crosses below 200-day (death cross), or stop-loss
- **Edge:** Riding long-term trend changes

### Strategy 5: Crypto Swing Trading
- **Trigger:** BTC or ETH moves >3% in a 4-hour window
- **Entry:** Momentum continuation or reversal depending on context
- **Exit:** Take profit at +5%, stop at -3%
- **Edge:** 24/7 market allows capturing moves outside stock market hours

---

## Technology Stack

| Component | Technology |
|-----------|-----------|
| **Execution Platform** | Alpaca Markets (Paper Trading API v2) |
| **AI Engine** | Claude (Anthropic) via OpenClaw |
| **Orchestration** | OpenClaw Cron Jobs (isolated sessions) |
| **Data Sources** | Alpaca News API, Market Screeners, Price API |
| **Trade CLI** | Custom bash script (`trade`) wrapping Alpaca REST API |
| **Notifications** | iMessage via OpenClaw |
| **Logging** | JSON trade log with timestamps and reasoning |
| **Hosting** | Mac mini (local, always-on) |

---

## Account Details

| Field | Value |
|-------|-------|
| Platform | Alpaca Markets |
| Account Type | Paper Trading (simulated) |
| Account ID | PA3Y5I0GSM8Z |
| Starting Capital | $100,000 |
| Buying Power | $200,000 (2x margin) |
| Crypto | Enabled (BTC, ETH, and more) |
| Options | Level 3 approved |
| Shorting | Enabled |

---

## File Structure

```
skills/alpaca-trading/
├── trade                      # Main CLI (27 commands)
├── autonomous-broker.sh       # News scanner & signal generator
├── alpaca-keys.env            # API credentials & safety config
├── SKILL.md                   # Technical documentation
├── PaperPaws-Overview.md      # This document
├── trade-log.json             # Audit log of all trades
├── signals.json               # Latest trading signals
├── daily-plan.json            # Daily trade plan (generated pre-market)
└── strategies/
    ├── momentum.sh            # Momentum strategy
    ├── mean-reversion.sh      # RSI-based mean reversion
    └── ma-crossover.sh        # 50/200 MA crossover
```

---

## Sample Daily Report

```
🐾 PaperPaws Daily Report — March 4, 2026

📊 PERFORMANCE
• Day P&L: +$1,247.50 (+1.25%)
• Portfolio Value: $101,247.50
• Cash: $82,500.00

📈 TRADES TODAY (5)
• NVDA: Bought 15 @ $892.30 → Sold @ $921.50 (+$438.00) ✅
  Reason: Earnings beat + raised guidance
• AMD: Bought 25 @ $178.40 → Holding @ $182.10 (+$92.50)
  Reason: Semiconductor momentum, NVDA sympathy play
• TSLA: Shorted 10 @ $245.00 → Covered @ $238.50 (+$65.00) ✅
  Reason: Downgrade from Morgan Stanley
• BTC/USD: Bought 0.05 @ $69,200 → Holding @ $69,850 (+$32.50)
  Reason: Crypto bouncing off support
• META: Bought 8 @ $512.00 → Stop hit @ $486.40 (-$204.80) ❌
  Reason: AI infrastructure spending news (reversed on profit concerns)

📋 OPEN POSITIONS (2)
• AMD: 25 shares @ $178.40 | Current: $182.10 | P&L: +$92.50
• BTC/USD: 0.05 @ $69,200 | Current: $69,850 | P&L: +$32.50

🔒 RISK STATUS
• Daily Loss Used: $204.80 / $5,000 limit
• Open Position Value: $17,560 / $100,000 max
• Win Rate Today: 3/4 (75%)
```

---

## Transition to Live Trading

When ready to transition from paper to live trading:

1. **Track Performance** — Run paper trading for 2-4 weeks minimum
2. **Analyze Results** — Review win rate, average gain/loss, max drawdown
3. **Adjust Parameters** — Tune position sizes, stop-losses, strategy weights
4. **Create Live Account** — Switch API keys from paper to live Alpaca
5. **Start Small** — Begin with 10-20% of intended capital
6. **Scale Up** — Gradually increase position sizes as confidence builds

**Key Metrics to Track:**
- Win rate (target: >55%)
- Average win vs average loss (target: 2:1 ratio)
- Max drawdown (target: <10%)
- Sharpe ratio (target: >1.5)
- Total return vs S&P 500 benchmark

---

## Disclaimer

PaperPaws is a paper trading bot using simulated money. Past performance in paper trading does not guarantee results in live trading. Real markets involve slippage, partial fills, and liquidity constraints not fully replicated in paper trading. Always start with small positions when transitioning to live trading.

---

*Built by Jaks 🐕 for Jimmy Bhullar | Powered by OpenClaw + Alpaca + Claude*
