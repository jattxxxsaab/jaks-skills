#!/bin/bash
# Full OpenClaw Google Drive Backup
# Uploads workspace tarball + config to Google Drive "OpenClaw-Backup" folder
set -euo pipefail

GOG="GOG_ACCOUNT=jimmy@apexrealty.io gog"
DATE=$(date +%Y-%m-%d_%H%M)
STAGING="/tmp/openclaw-backup-$$"

echo "☁️ Google Drive Full Backup — $DATE"
mkdir -p "$STAGING"

# Find or create the Google Drive backup folder
FOLDER_ID=$(GOG_ACCOUNT=jimmy@apexrealty.io gog drive search "OpenClaw-Backup" --json 2>/dev/null \
  | python3 -c "import json,sys; files=json.load(sys.stdin).get('files',[]); [print(f['id']) for f in files if f['name']=='OpenClaw-Backup' and f['mimeType']=='application/vnd.google-apps.folder']" 2>/dev/null \
  | head -1)

if [ -z "$FOLDER_ID" ]; then
  echo "📁 Creating OpenClaw-Backup folder..."
  FOLDER_ID=$(GOG_ACCOUNT=jimmy@apexrealty.io gog drive mkdir "OpenClaw-Backup" --json 2>/dev/null \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])")
  echo "  Created folder: $FOLDER_ID"
fi

# Create workspace tarball (excluding .git)
echo "📦 Creating workspace archive..."
tar czf "$STAGING/workspace-$DATE.tar.gz" -C "$HOME/.openclaw" --exclude='.git' workspace/

# Copy config files
cp ~/.openclaw/openclaw.json "$STAGING/openclaw.json"
cp ~/.openclaw/workspace/skills/backup/secrets.enc "$STAGING/secrets.enc" 2>/dev/null || true

# Export cron jobs
JOBS=$(curl -s "http://127.0.0.1:18789/api/cron/jobs?includeDisabled=true" 2>/dev/null || true)
[ -n "$JOBS" ] && echo "$JOBS" > "$STAGING/cron-jobs.json"

# Upload each file
echo "⬆️ Uploading to Google Drive..."
for f in "$STAGING"/*; do
  fname=$(basename "$f")
  echo "  Uploading $fname..."
  GOG_ACCOUNT=jimmy@apexrealty.io gog drive upload "$f" --parent "$FOLDER_ID" --name "$fname"
done

# Cleanup staging
rm -rf "$STAGING"

echo "✅ Google Drive backup complete ($DATE)"
