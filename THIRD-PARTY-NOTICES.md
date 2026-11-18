# Third-party notices and credits

Accueil itself is released under the [MIT License](LICENSE).
It **bundles no third-party library, font, image or sound**: the code uses only the Android framework, the
startup sounds are synthesised in code, and the animations, mascot and icons are drawn in code.

Below is everything else the project relies on, and under which terms.

## 1. Code and algorithms

| Item | Used for | Licence / terms |
|---|---|---|
| **QR Code generator library** by Project Nayuki | `QrCode.java` is a small, independent re-implementation, but its structure (format bits, zig-zag placement, Reed-Solomon helpers) follows this library | MIT, see the notice below |
| QR Code specification (ISO/IEC 18004) | QR code shown on the "Import my pictures" screen | "QR Code" is a registered trademark of DENSO WAVE INCORPORATED |
| Android SDK (`android.jar`, build-tools) | Building the APK only. It is not redistributed in this repository | [Android Software Development Kit License](https://developer.android.com/studio/terms) / Apache License 2.0 |

### Project Nayuki QR Code generator: MIT License

```
Copyright © Project Nayuki. (MIT License)
https://www.nayuki.io/page/qr-code-generator-library

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:
- The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
- The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall the
  authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising from,
  out of or in connection with the Software or the use or other dealings in the
  Software.
```

## 2. Online services (called by the TV at run time)

The app talks directly to these services from the TV, with no server of ours in between. Nothing they return
is stored in this repository or redistributed with the app.

| Service | Used for | Terms |
|---|---|---|
| **[Open-Meteo](https://open-meteo.com/)** forecast API | Weather widget and forecast | Free for **non-commercial** use, no API key. Data under **[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)**: attribution "Weather data by Open-Meteo.com" (shown in Settings › About). A commercial fork needs an [Open-Meteo API plan](https://open-meteo.com/en/pricing). |
| **Open-Meteo Geocoding API** | City search in Settings | Same terms. Place names come from [GeoNames](https://www.geonames.org/) (CC BY 4.0). |
| **[LRCLIB](https://lrclib.net/)** | Synced song lyrics | Free public API, no key. The app identifies itself with its own User-Agent, as LRCLIB asks. **Lyrics remain the property of their authors and publishers**: they are only displayed while the song plays and are never stored or redistributed. |
| **Bing "image of the day"** (`bing.com/HPImageArchive.aspx`) | Optional wallpapers | Unofficial endpoint, no published terms. **Images are © Microsoft and/or their photographers** and are meant for personal wallpaper use. They are downloaded by each TV and never redistributed. Turn it off in Settings › Wallpapers › Image source › "My pictures". |

## 3. Data read on the TV itself

| Data | How | Notes |
|---|---|---|
| Now playing (Spotify or any music app) | Android `MediaSession` / `NotificationListenerService` | No Spotify API, account or credential is used. The widget works with any player that publishes a media session. |
| Sound level for the equalizer and particles | Android `Visualizer` on the TV's audio output | Analysed live on the TV. Nothing is recorded or sent anywhere. |
| Calendar (weekly planner) | Android `CalendarContract`: the Google Calendar already synced on the TV | Read-only and on the TV only. |
| Your own pictures | Uploaded from your phone over the local network (Settings › Wallpapers › Import my pictures) | They stay on the TV. The local server only runs while that screen is open, behind a random one-time address. |

## 4. Trademarks

Android, Android TV, Google TV and Google Calendar are trademarks of Google LLC.
Spotify is a trademark of Spotify AB.
Bing is a trademark of Microsoft Corporation.
Philips and Ambilight are trademarks of Koninklijke Philips N.V. The startup animation shows the TV's own brand,
read from the device, and the word "Ambilight" appears only on Philips TVs.
QR Code is a registered trademark of DENSO WAVE INCORPORATED.

These names are used only to describe compatibility. **This project is not affiliated with, endorsed by or
sponsored by any of these companies.**
