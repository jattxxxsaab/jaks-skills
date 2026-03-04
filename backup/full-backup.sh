#!/bin/bash
# Full OpenClaw iCloud Backup
# Copies entire workspace + config to iCloud Drive
set -euo pipefail

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/OpenClaw-Backup"
DATE=$(date +%Y-%m-%d_%H%M)

echo "☁️ iCloud Full Backup — $DATE"
mkdir -p "$ICLOUD"

# Copy entire workspace
rsync -a --delete --exclude='.git' ~/.openclaw/workspace/ "$ICLOUD/workspace/"

# Copy openclaw.json (actual, not redacted)
cp ~/.openclaw/openclaw.json "$ICLOUD/openclaw.json"

# Copy encrypted secrets
cp ~/.openclaw/workspace/skills/backup/secrets.enc "$ICLOUD/secrets.enc" 2>/dev/null || true

# Export cron jobs
JOBS=$(curl -s "http://127.0.0.1:18789/api/cron/jobs?includeDisabled=true" 2>/dev/null || true)
[ -n "$JOBS" ] && echo "$JOBS" > "$ICLOUD/cron-jobs.json"

# Timestamp
echo "$DATE" > "$ICLOUD/last-backup.txt"

echo "✅ iCloud backup complete: $ICLOUD"
du -sh "$ICLOUD"
