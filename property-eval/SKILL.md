# Property Evaluation Skill

Evaluate California investment properties against multiple strategies with clear pass/fail verdicts.

## How To Use

Jimmy provides: **address** + **strategy** (or "all" for full 9-strategy analysis)

Strategies available:
1. **BRRRR** (Buy, Rehab, Rent, Refinance, Repeat)
2. **Seller Financing**
3. **Subject-To**
4. **Wholesaling**
5. **Lease Options**
6. **Fix & Flip**
7. **Buy & Hold**
8. **STR** (Short-Term Rental / Airbnb)
9. **LTR** (Long-Term Rental)

## Data Collection

For every evaluation, gather:

### Property Data (from Zillow, Redfin, or listing)
- List price
- Property type (SFR, duplex, triplex, fourplex, multi)
- Bedrooms / bathrooms
- Square footage
- Lot size
- Year built
- HOA (if any)
- Current condition (from photos/description)
- Days on market
- Price history / reductions
- Zoning
- APN / parcel info

### Rent Comps (from Zillow + Rentometer)
- Use browser to check Zillow rent estimates and Rentometer for the address
- Pull 3-5 comparable rents nearby
- Use conservative estimate (not the high end)

### STR Revenue (from AirDNA — only if STR strategy requested)
- Use browser to check AirDNA for the address/area
- Average daily rate (ADR)
- Assume **60% occupancy** rate
- Monthly STR revenue = ADR × 30 × 0.60

### Tax & Insurance Estimates
- Property tax: pull from Zillow or county records
- Insurance: estimate 0.35% of property value annually (CA average)

### ARV (After Repair Value)
- Check recent sold comps within 0.5 mile, similar size/type, last 6 months
- Use Zillow Zestimate as a reference point (not gospel)

## Jimmy's Investment Parameters

```
GENERAL:
- Cash-on-cash return minimum:     8%
- Cap rate minimum:                5%
- Monthly cash flow minimum:       8% of cash invested (annualized = CoC)
- Conventional interest rate:      7%
- Down payment:                    25%
- Property management:             8% of gross rent
- Vacancy rate:                    5%
- Maintenance reserve:             5% of gross rent
- CapEx reserve:                   5% of gross rent

BRRRR:
- Max acquisition:                 70% of ARV (minus rehab)
- Refinance LTV:                   75%
- Refi rate:                       7%

FIX & FLIP:
- Minimum profit:                  20% of ARV
- Formula: MAO = ARV × 0.80 - rehab costs

SELLER FINANCING:
- Look for: below-market rate, low/no down, balloon 5-7 yrs
- Evaluate based on actual cash flow with seller terms

SUBJECT-TO:
- Look for: existing low-rate mortgage, equity spread
- Evaluate based on existing loan terms vs rental income

LEASE OPTIONS:
- Option fee: 3-5% of purchase price
- Monthly credit toward purchase
- Evaluate based on spread between lease payment and market rent

WHOLESALING:
- Assignment fee target: TBD (skip for now)

STR (Short-Term Rental):
- Data source: AirDNA
- Occupancy assumption: 60%
- Revenue = ADR × 30 × 0.60
- Check local STR regulations/permits

LTR (Long-Term Rental):
- Standard buy & hold analysis with long-term tenants
- Use Zillow/Rentometer for rent comps
```

## Calculations

### Monthly Expenses (LTR/Buy & Hold)
```
Mortgage P&I:        Standard amortization (30yr, 7%, 75% LTV)
Property Tax:        From records (monthly)
Insurance:           0.35% of value / 12
Property Mgmt:       8% of gross rent
Vacancy:             5% of gross rent
Maintenance:         5% of gross rent
CapEx Reserve:       5% of gross rent
HOA:                 If applicable
TOTAL EXPENSES:      Sum of above
```

### Key Metrics
```
NOI = Gross Rent - Operating Expenses (excl. mortgage)
Cap Rate = NOI / Purchase Price × 100
Cash Flow = Gross Rent - Total Expenses (incl. mortgage)
CoC Return = (Annual Cash Flow / Total Cash Invested) × 100
Total Cash Invested = Down Payment + Closing Costs (est. 3%)
```

### BRRRR Analysis
```
Max Purchase = ARV × 0.70 - Rehab
After Rehab: Refinance at 75% of ARV
Cash Left In = Total Invested - Refi Proceeds
CoC on remaining cash = Annual Cash Flow / Cash Left In
Goal: Get most/all cash back out
```

### Fix & Flip Analysis
```
MAO (Max Allowable Offer) = ARV × 0.80 - Rehab
Profit = ARV - Purchase - Rehab - Holding Costs - Selling Costs (6%)
Minimum acceptable profit = 20% of ARV
```

### STR Analysis
```
Gross Monthly Revenue = ADR × 30 × 0.60
Expenses: mortgage + tax + insurance + mgmt (20% for STR) + utilities ($200) + supplies ($100) + vacancy
Net Monthly Cash Flow = Revenue - Expenses
CoC = Annual Net / Cash Invested
```

## Output Format

For each strategy evaluated:

```
🏠 PROPERTY: [Address]
📊 LIST PRICE: $XXX,XXX
🏷️ TYPE: [SFR/Duplex/etc] | [Beds/Baths] | [SqFt] | Built [Year]

📈 MARKET DATA:
- Zestimate/ARV: $XXX,XXX
- Monthly Rent (LTR): $X,XXX
- Monthly Revenue (STR): $X,XXX (if applicable)
- Property Tax: $X,XXX/yr
- Days on Market: XX
- Price History: [any drops]

═══ STRATEGY: [NAME] ═══

✅ DEAL @ $XXX,XXX  or  ❌ NO DEAL @ asking

Key Metrics:
- Cap Rate: X.X%
- Cash-on-Cash: X.X%
- Monthly Cash Flow: $XXX
- Total Cash Needed: $XX,XXX

The Numbers:
[Detailed breakdown]

💡 THE MOVE: [What Jimmy should do — counter price, walk, negotiate terms, etc.]
```

## Final Verdict (when running all strategies)

```
═══ VERDICT ═══
✅ STRATEGIES THAT WORK: [list]
❌ STRATEGIES THAT FAIL: [list]
🎯 BEST PLAY: [recommendation]
💰 OFFER PRICE: $XXX,XXX
📞 THE MOVE: [specific action]
```

## Notes
- Always be conservative with estimates
- Round to nearest $100 for monthly, $1,000 for purchase prices
- If data is unavailable, state assumption clearly
- Flag any red flags (environmental, zoning, flood zone, foundation, etc.)
- Check if property is in an STR-restricted zone before recommending STR
- Pull actual data via browser — don't guess rent or values
