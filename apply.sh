#!/system/bin/sh

PACKAGE="com.brave.browser"
PREF="/data/data/$PACKAGE/app_chrome/Default/Preferences"
BACKUP="/sdcard/Preferences.bak"

if [ ! -f "$PREF" ]; then
    echo "Brave Preferences file not found. Open Brave once and try again."
    exit 1
fi

am force-stop "$PACKAGE" >/dev/null 2>&1

if grep -q '"contextual_search_enabled":"false"' "$PREF"; then
    echo "Touch to Search is already disabled."
    exit 0
fi

if ! grep -q '"contextual_search_enabled":"true"' "$PREF"; then
    echo "The expected preference was not found. No changes made."
    exit 1
fi

OWNER="$(stat -c '%u:%g' "$PREF" 2>/dev/null)"
MODE="$(stat -c '%a' "$PREF" 2>/dev/null)"

if [ ! -f "$BACKUP" ]; then
    cp "$PREF" "$BACKUP" || {
        echo "Could not create the Preferences backup. No changes made."
        exit 1
    }
fi

sed -i 's/"contextual_search_enabled":"true"/"contextual_search_enabled":"false"/g' "$PREF" || exit 1

[ -n "$OWNER" ] && chown "$OWNER" "$PREF"
[ -n "$MODE" ] && chmod "$MODE" "$PREF"

if grep -q '"contextual_search_enabled":"false"' "$PREF"; then
    echo "Touch to Search disabled successfully."
    exit 0
fi

echo "Failed to update Brave Preferences."
exit 1
