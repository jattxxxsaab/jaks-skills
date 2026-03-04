# 🚨 Disaster Recovery Playbook

## If Mac Mini Dies — Full Recovery

### Step 1: New Mac Setup (10 min)
1. Install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install Node: `brew install node`
3. Install OpenClaw: `npm install -g openclaw`
4. Install tools: `brew install gh steipete/tap/sag`

### Step 2: Restore Workspace (5 min)
1. Install gog CLI: `brew install steipete/tap/gog`
2. Auth Google Drive: `GOG_ACCOUNT=jimmy@apexrealty.io gog auth login --services="gmail,calendar,drive"`
3. Download backups: `GOG_ACCOUNT=jimmy@apexrealty.io gog drive search "OpenClaw-Backup"` then download latest tarball
4. Or clone from GitHub:
   - `gh auth login`
   - `git clone https://github.com/jattxxxsaab/jaks-skills.git`
   - `git clone https://github.com/jattxxxsaab/jaks-dashboard.git`
   - `git clone https://github.com/jattxxxsaab/str-tracker.git`
5. Extract workspace tarball to `~/.openclaw/workspace/`
6. Copy openclaw.json to `~/.openclaw/`

### Step 3: Decrypt Secrets (2 min)
```bash
openssl enc -aes-256-cbc -d -pbkdf2 -in secrets.enc -out secrets.md -pass pass:JaksBackup2026!
```
Use the decrypted file to restore all API keys and passwords.

### Step 4: Authenticate Services (5 min)
1. `openclaw configure` — set up Anthropic API key
2. `gog auth login jimmy@apexrealty.io` — Gmail OAuth
3. `gh auth login` — GitHub CLI
4. Verify iMessage is working

### Step 5: Start Gateway (1 min)
```bash
openclaw gateway start
```

### Step 6: Verify
- Send test iMessage
- Check cron jobs: `openclaw cron list`
- Check trading: `skills/alpaca-trading/trade account`
- Check HA: `skills/homeassistant/ha status`

## Key Accounts & Services
| Service | Username/URL |
|---------|-------------|
| GitHub | jattxxxsaab |
| Gmail (primary) | jimmy@apexrealty.io |
| Gmail (personal) | jimmybhullar26@gmail.com |
| Home Assistant | https://gsl2sq6tujk7wpbj9o9kyz6rt9bpkk5g.ui.nabu.casa |
| Alpaca (Paper) | PA3Y5I0GSM8Z |
| IHSS Provider | parminderbhullar |
| IHSS Recipient | sanjitbhullar (ID: 0289072) |
| AirDNA | jimmybhullar26@gmail.com |

## Backup Locations
- **Google Drive**: "OpenClaw-Backup" folder (jimmy@apexrealty.io)
- **Local**: `~/Documents/openclaw_backup/` and `~/openclaw-backup/`
- **GitHub**: github.com/jattxxxsaab/jaks-skills

## Encryption Password
`JaksBackup2026!` — for secrets.enc decryption

**Total recovery time: ~25 minutes**
