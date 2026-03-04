#!/bin/bash
# Daily lightweight config + memory backup to iCloud
# Runs at 2 AM via cron
set -euo pipefail

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/OpenClaw-Backup/daily"
WS="$HOME/.openclaw/workspace"
DATE=$(date +%Y-%m-%d_%H%M)

mkdir -p "$ICLOUD/memory"

cp ~/.openclaw/openclaw.json "$ICLOUD/openclaw.json"
for f in MEMORY.md TOOLS.md USER.md IDENTITY.md SOUL.md AGENTS.md; do
  [ -f "$WS/$f" ] && cp "$WS/$f" "$ICLOUD/$f"
done
rsync -a "$WS/memory/" "$ICLOUD/memory/" 2>/dev/null || true
echo "$DATE" > "$ICLOUD/last-daily-backup.txt"
