# Brave Disable Touch to Search

A small KernelSU module that disables **Touch to Search** in Brave Browser by setting:

```json
"contextual_search_enabled":"false"
```

## Requirements

- KernelSU with module support
- Brave Browser installed for the primary Android user

## Install

1. Download the flashable ZIP from [Releases](https://github.com/kyoyacchi/brave-disable-touch-to-search/releases).
2. Open **KernelSU Manager → Modules → Install from Storage** and select the ZIP.
3. Reboot.

The boot service waits for Brave's Preferences file to become available after the device is unlocked, then applies the change.

## Temporary root

Automatic boot-time execution requires KernelSU to be active during startup. If KernelSU is only activated manually through a temporary root exploit, the boot service will not run on a reboot where KernelSU is inactive.

In that case, activate KernelSU with your usual method after reboot, open this module in KernelSU Manager, and use its **Action** button to apply the change manually.

## What it does

- Force-stops Brave before editing its preferences.
- Changes every exact occurrence of `"contextual_search_enabled":"true"` to `false`.
- Creates `/sdcard/Preferences.bak` before the first change, if that backup does not already exist. If the backup cannot be created, it aborts without changing the setting.
- Preserves the Preferences file's owner, group and permissions.
- Does not modify the Brave APK or Android system files.

The automatic boot script waits up to 30 minutes for the Preferences file. Open Brave once before applying the module if the file has not been created yet.

## Remove

Disable or uninstall the module in KernelSU Manager. This stops future automatic runs; it does not revert the preference.

To restore the backup, force-stop Brave and copy the backup over the Preferences file. Then restore the file's original owner and permissions:

```sh
su
am force-stop com.brave.browser
cp /sdcard/Preferences.bak /data/data/com.brave.browser/app_chrome/Default/Preferences
dumpsys package com.brave.browser | grep -m1 userId
ls -ln /data/data/com.brave.browser/app_chrome/Default/Preferences
```

Use the UID/GID and permissions appropriate for your device; do not copy the example UID from another phone.

## Build

The GitHub Actions workflow creates a flashable ZIP when a `v*` tag is pushed. You can also run the workflow manually to download the ZIP as an Actions artifact.

KernelSU module documentation: https://kernelsu.org/guide/module.html
