#!/system/bin/sh

MODDIR=${0%/*}
PREF="/data/data/com.brave.browser/app_chrome/Default/Preferences"

# Wait for credential-encrypted app data to become available after unlock.
COUNT=0
while [ ! -f "$PREF" ] && [ "$COUNT" -lt 180 ]; do
    sleep 10
    COUNT=$((COUNT + 1))
done

[ -f "$PREF" ] || exit 0
"$MODDIR/apply.sh" >/dev/null 2>&1
