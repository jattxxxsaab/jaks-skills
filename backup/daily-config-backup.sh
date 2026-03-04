#!/bin/bash
# Daily lightweight config + memory backup to Google Drive
# Runs at 2 AM via cron
set -euo pipefail

DATE=$(date +%Y-%m-%d_%H%M)
STAGING="/tmp/openclaw-daily-$$"
WS="$HOME/.openclaw/workspace"

mkdir -p "$STAGING/memory"

# Gather config files
cp ~/.openclaw/openclaw.json "$STAGING/openclaw.json"
for f in MEMORY.md TOOLS.md USER.md IDENTITY.md SOUL.md AGENTS.md; do
  [ -f "$WS/$f" ] && cp "$WS/$f" "$STAGING/$f"
done
rsync -a "$WS/memory/" "$STAGING/memory/" 2>/dev/null || true

# Create tarball
tar czf "/tmp/daily-config-$DATE.tar.gz" -C "$STAGING" .

# Find backup folder
FOLDER_ID=$(GOG_ACCOUNT=jimmy@apexrealty.io gog drive search "OpenClaw-Backup" --json 2>/dev/null \
  | python3 -c "import json,sys; files=json.load(sys.stdin).get('files',[]); [print(f['id']) for f in files if f['name']=='OpenClaw-Backup' and f['mimeType']=='application/vnd.google-apps.folder']" 2>/dev/null \
  | head -1)

if [ -z "$FOLDER_ID" ]; then
  FOLDER_ID=$(GOG_ACCOUNT=jimmy@apexrealty.io gog drive mkdir "OpenClaw-Backup" --json 2>/dev/null \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])")
fi

# Upload
GOG_ACCOUNT=jimmy@apexrealty.io gog drive upload "/tmp/daily-config-$DATE.tar.gz" --parent "$FOLDER_ID" --name "daily-config-$DATE.tar.gz"

# Cleanup
rm -rf "$STAGING" "/tmp/daily-config-$DATE.tar.gz"
