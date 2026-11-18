# Accueil: a minimal, fast launcher for Android TV

*Version française : [README.fr.md](README.fr.md)*

A clean home screen for Android TV / Google TV with a favourites dock, rotating wallpapers with a slow
"Ken Burns" motion, and a few live widgets. The whole APK is about 100 KB, with no ads, no tracking, no account
and no third-party library.

<!-- Add screenshots here: docs/screenshot-1.jpg … -->

## Features

- **Favourites dock** in black-and-white tiles with an animated neon border on focus, plus an "All apps" grid
  (long-press OK to add or remove favourites).
- **Wallpapers**: your own photos, Bing's picture of the day, or both, shown with a slow zoom and pan that lasts
  the whole display time.
  - **Import from your phone**: scan a QR code on the TV, pick photos, done.
- **Widgets**:
  - clock and date, which opens a **weekly planner** from the TV's Google Calendar;
  - **weather** with animated icons and an hourly and daily forecast;
  - **now playing** (Spotify or any music app) with cover, controls and an LED equalizer.
- **Synced lyrics** while music plays.
- **Ambient particles** (bokeh) above the dock that react to the remote and to the bass. They come in several
  colour themes, including one that follows the wallpaper's colours.
- **Screen neon border**: always, during music only, or never.
- **Startup animations** (minimal, or a small retro-TV mascot) with a synthesised sound.
- **Settings menu** with the remote. The interface is in French, English and Spanish, or follows the TV's
  language. Interface size is adjustable.

## Captures

<img width="1920" height="1080" alt="capture01" src="https://github.com/user-attachments/assets/52e21784-70a7-4b4c-ac9e-a18c1f5e7fa3" />
<img width="1920" height="1080" alt="capture02" src="https://github.com/user-attachments/assets/236e4f66-5835-4fd6-9662-83c9bcfe4d37" />
<img width="1920" height="1080" alt="capture03" src="https://github.com/user-attachments/assets/108aba7a-39c1-43ab-bd1a-26f1ab575b00" />
<img width="1920" height="1080" alt="capture04" src="https://github.com/user-attachments/assets/2421d98b-5adb-4d3b-822d-ffc23a18db0c" />
<img width="1920" height="1080" alt="capture05" src="https://github.com/user-attachments/assets/fd2408a7-f474-4eac-937b-342919ce7eff" />
<img width="1920" height="1080" alt="capture06" src="https://github.com/user-attachments/assets/6e73f00e-35cf-4c03-b834-c90782b9d588" />
<img width="1920" height="1080" alt="capture07" src="https://github.com/user-attachments/assets/df30f236-94a6-4e86-b403-5a2ea8b941bb" />


## Install

See **[INSTALL.md](INSTALL.md)**: back up your current launcher, install, grant the permissions and set it as
default, with one script or step by step. Everything is reversible.

## Build from source

No Gradle and no Android Studio: just a JDK (17+) and the Android SDK command-line tools (build-tools + one
platform, API 30 or newer).

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1 -Sdk C:\path\to\android-sdk     # Windows
```
```bash
ANDROID_HOME=~/Android/Sdk ./build.sh                                             # macOS / Linux
```

The APK is written to `dist/Accueil.apk`. On the first build a signing key, `release.keystore`, is created and
you choose its password. **Keep that file and password private and never commit them**: Android only accepts
updates signed with the same key.

### Code map (`app/src/com/minimal/accueil/`)

| File | Role |
|---|---|
| `Accueil.java` | Main activity: wallpapers, clock, weather, dock, app grid |
| `EcranReglages.java` / `Reglages.java` | Settings menu / preferences and proportional UI scaling |
| `T.java` | Translations (FR / EN / ES) |
| `WidgetSpotify.java`, `EcouteurNotifs.java` | Now-playing widget (Android media sessions) |
| `Rythme.java`, `Particules.java`, `HaloEcran.java`, `Neon.java` | Bass detection, particles, screen and tile neon |
| `PanneauParoles.java` | Synced lyrics (LRCLIB) |
| `PanneauAgenda.java` | Weekly planner |
| `FondsBing.java`, `ServeurFonds.java`, `QrCode.java`, `CouleursDominantes.java` | Bing pictures, phone import server, QR code, wallpaper colours |
| `Intro.java`, `Mascotte.java`, `SonIntro.java`, `IconeMeteo.java` | Startup animations, synthesised sound, weather icons |

The code comments are in French.

## Privacy

The app has no backend and collects nothing. From the TV it only contacts:
- Open-Meteo (weather, city search);
- LRCLIB (title and artist of the current song, to fetch lyrics);
- Bing (picture of the day, if enabled).

The now-playing state, sound analysis and calendar are read **on the TV only**. The phone-import server runs only
while its screen is open, on your local network, behind a random one-time address.

## Licences

| What | Licence |
|---|---|
| **This project** (code, scripts, docs) | **[MIT](LICENSE)**: free to use, copy, modify, share and redistribute; keep the licence notice |
| QR code generator (`QrCode.java`) | Independent implementation based on the structure of [Project Nayuki's QR Code generator](https://www.nayuki.io/page/qr-code-generator-library) (MIT) |
| Android SDK (build only, not included) | [Android SDK License](https://developer.android.com/studio/terms) / Apache 2.0 |
| Weather and geocoding: [Open-Meteo](https://open-meteo.com/) | Data **CC BY 4.0**, free for non-commercial use (place names: GeoNames, CC BY 4.0) |
| Lyrics: [LRCLIB](https://lrclib.net/) | Free public API. Lyrics © their authors and publishers, displayed only and never stored |
| Bing picture of the day | Images © Microsoft and/or their photographers, for personal wallpaper use. Can be turned off |

Full details, attributions and trademark notices are in **[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md)**.

*Android, Android TV, Google TV and Google Calendar are trademarks of Google LLC. Spotify is a trademark of
Spotify AB. Bing is a trademark of Microsoft. Philips and Ambilight are trademarks of Koninklijke Philips N.V.
This project is not affiliated with or endorsed by any of them.*

## Disclaimer

A hobby project, provided **as is, without any warranty**. ADB gives deep access to your TV: read the commands
before running them. Every change made by the install script can be undone with the restore script.
