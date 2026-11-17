# Brave Disable Touch to Search

A small KernelSU module that disables **Touch to Search** in Brave Browser by setting:

```json
"contextual_search_enabled":"false"
```

## Requirements

- KernelSU with module support
- Brave Browser installed for the primary Android user

## Install

1. Download the flashable ZIP from the [Releases](https://github.com/kyoyacchi/brave-disable-touch-to-search/releases) page.
2. Open **KernelSU Manager → Modules → Install from Storage** and select the ZIP.
3. Reboot.

The boot service waits for Brave's Preferences file to become available after the device is unlocked, then applies the change.

## Temporary root

If KernelSU is only active while a temporary root exploit is running, the boot service cannot run on boots where KernelSU is not active. After running the exploit and bringing KernelSU back, open this module in KernelSU Manager and use its **Action** button to apply the change manually.

## What it does

- Force-stops Brave before editing its preferences.
- Changes every exact occurrence of `"contextual_search_enabled":"true"` to `false`.
- Creates `/sdcard/Preferences.bak` before the first change, if that backup does not already exist.
- Preserves the Preferences file's owner, group and permissions.
- Does not modify the Brave APK or Android system files.

The automatic boot script waits up to 30 minutes for the Preferences file. Open Brave once before applying the module if the file has not been created yet.

## Remove

Disable or uninstall the module in KernelSU Manager. This stops future automatic runs; it does not revert the preference. To restore the previous file, force-stop Brave and restore your backup:

```sh
su
am force-stop com.brave.browser
cp /sdcard/Preferences.bak /data/data/com.brave.browser/app_chrome/Default/Preferences
chown 10342:10342 /data/data/com.brave.browser/app_chrome/Default/Preferences
chmod 600 /data/data/com.brave.browser/app_chrome/Default/Preferences
```

The UID/GID and file mode above are examples. Check the original file on your device before restoring ownership and permissions.

## Build

The GitHub Actions workflow creates a flashable ZIP when a `v*` tag is pushed. You can also run the workflow manually to download the ZIP as an Actions artifact.

KernelSU module documentation: https://kernelsu.org/guide/module.html
