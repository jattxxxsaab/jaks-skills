#!/usr/bin/env bash
# Calculate yesterday's solar production from SolarEdge power history
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOKEN="$(cat "$SCRIPT_DIR/ha-token.txt" | tr -d '[:space:]')"
BASE="YOUR_HA_URL"

# Yesterday's date range in UTC (PST is UTC-8)
yesterday_start=$(date -u -v-1d +"%Y-%m-%dT08:00:00Z" 2>/dev/null || date -u -d "yesterday" +"%Y-%m-%dT08:00:00Z")
yesterday_end=$(date -u +"%Y-%m-%dT08:00:00Z")

curl -s -H "Authorization: Bearer $TOKEN" \
  "$BASE/api/history/period/$yesterday_start?end_time=$yesterday_end&filter_entity_id=sensor.solaredge_current_power" | \
python3 -c "
import sys, json
from datetime import datetime

data = json.load(sys.stdin)
if not data or not data[0]:
    print('No solar data available')
    sys.exit()

readings = []
for entry in data[0]:
    try:
        state = float(entry['state'])
        ts = entry['last_changed'][:19]
        dt = datetime.fromisoformat(ts)
        readings.append((dt, state))
    except:
        continue

readings.sort(key=lambda x: x[0])

total_wh = 0
for i in range(1, len(readings)):
    dt_hours = (readings[i][0] - readings[i-1][0]).total_seconds() / 3600
    avg_power = (readings[i][1] + readings[i-1][1]) / 2
    total_wh += avg_power * dt_hours

kwh = total_wh / 1000
peak = max(r[1] for r in readings)

print(f'{kwh:.1f} kWh | Peak: {peak:.0f}W | {len(readings)} readings')
"
