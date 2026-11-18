# Installing Accueil with ADB

*Version française : [INSTALL.fr.md](INSTALL.fr.md)*

All you need is a computer on the same network as the TV. Nothing is uninstalled from the TV: the original
launcher is backed up first and can be put back at any time.

> Tested on a Philips Android TV (Android 10/11). Other Android TV / Google TV devices should work, but this is
> a hobby project with **no warranty**. Read the commands before you run them.

## 1. Prepare the TV

1. **Settings › Device Preferences › About**, then click **Build** 7 times. This unlocks the developer options.
2. **Settings › Device Preferences › Developer options**: turn on **USB debugging**. If it is offered, also turn on
   **Network debugging** / **ADB over network**.
3. Note the TV's IP address: **Settings › Network & Internet › your network**.

## 2. Install ADB on your computer

Download **[Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)**, unzip it
and open a terminal in that folder (or add it to your `PATH`). Then check that it works:

```bash
adb version
```

## 3. Quick way: the install script

Download `Accueil.apk` from the **Releases** page and put it in `dist/` (or build it yourself, see the README). Then:

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File scripts\install.ps1 -Tv 192.168.1.50
```
```bash
# macOS / Linux
./scripts/install.sh 192.168.1.50
```

The first time, the TV asks you to **allow USB debugging** from your computer: tick "Always allow" and accept.

The script:
1. backs up your current launcher into `backup/` (its name and APK, plus the list of installed and disabled apps);
2. installs Accueil;
3. grants its permissions;
4. makes it the home screen.

If the stock launcher keeps coming back (common on **Google TV**), run it again with `-DisableStock` (Windows)
or `--disable-stock` (macOS/Linux).

## 4. Manual way: step by step

Replace `192.168.1.50` with your TV's IP.

### Connect
```bash
adb connect 192.168.1.50:5555
adb devices
```

### Back up the current launcher
```bash
# Which app is the home screen now? Write down the last line, e.g. com.google.android.tvlauncher/.MainActivity
adb shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME

# Where is its APK? (e.g. package:/system/priv-app/TVLauncher/TVLauncher.apk)
adb shell pm path com.google.android.tvlauncher
adb pull /system/priv-app/TVLauncher/TVLauncher.apk launcher-backup.apk

# List of installed and disabled apps, for reference
adb shell pm list packages -f > packages.txt
adb shell pm list packages -d > packages-disabled.txt
```
Common stock launchers:

| Device | Stock launcher |
|---|---|
| Android TV | `com.google.android.tvlauncher` |
| Google TV | `com.google.android.apps.tv.launcherx` |
| Older Android TV | `com.google.android.leanbacklauncher` |

### Install
```bash
adb install -r Accueil.apk
```

### Grant the permissions
These are needed for the now-playing widget, the equalizer and the weekly planner. Most TVs have no screen to
grant them, so ADB does it:
```bash
adb shell cmd notification allow_listener com.minimal.accueil/com.minimal.accueil.EcouteurNotifs
adb shell pm grant com.minimal.accueil android.permission.RECORD_AUDIO
adb shell pm grant com.minimal.accueil android.permission.READ_CALENDAR
```

### Make it the home screen
```bash
adb shell cmd package set-home-activity com.minimal.accueil/.Accueil
adb shell input keyevent KEYCODE_HOME
```
If pressing HOME still opens the stock launcher, disable it. This is reversible and does not uninstall it:
```bash
adb shell pm disable-user --user 0 com.google.android.tvlauncher
```

## 5. Add your own wallpapers

On the TV: **gear icon › Wallpapers › Import my pictures**. Scan the QR code with your phone (same Wi-Fi), pick
your photos, done. They are cropped to 16:9 automatically.

## 6. Go back to the original launcher

```powershell
powershell -ExecutionPolicy Bypass -File scripts\restore.ps1 -Tv 192.168.1.50            # add -Uninstall to remove Accueil
```
```bash
./scripts/restore.sh 192.168.1.50                                                     # add --uninstall to remove Accueil
```
Or by hand:
```bash
adb shell pm enable com.google.android.tvlauncher
adb shell cmd package set-home-activity com.google.android.tvlauncher/.MainActivity   # the line you wrote down
adb uninstall com.minimal.accueil                                                      # optional
```

## Troubleshooting

| Problem | Fix |
|---|---|
| `unauthorized` in `adb devices` | Accept the prompt on the TV, or turn debugging off and on again |
| `failed to connect` | Check the IP, that network debugging is on, and that both devices are on the same network |
| No "Network debugging" option | Connect once over USB, then run `adb tcpip 5555` |
| Spotify widget empty | Run the `allow_listener` command again, then start some music |
| Equalizer flat | Run the `RECORD_AUDIO` grant again (sound must come out of the TV, not a cast device) |
