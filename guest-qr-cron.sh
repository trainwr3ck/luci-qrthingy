#!/bin/sh

# Guest WiFi QR Generator Cron Script
# Place in /usr/local/bin/ and add to crontab:
# */5 * * * * /usr/local/bin/guest-qr-cron.sh

# Configuration
SCRIPT_PATH="/usr/local/bin/guest-qr-generator.lua"
LOG_FILE="/var/log/guest-qr.log"

# Run the generator
/usr/bin/lua "$SCRIPT_PATH" >> "$LOG_FILE" 2>&1

# Optional: Clean old logs (keep last 100 lines)
tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"