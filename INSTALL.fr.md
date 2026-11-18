# Installer Accueil avec ADB

*English version: [INSTALL.md](INSTALL.md)*

Il suffit d'un ordinateur sur le même réseau que la télé. Rien n'est désinstallé de la télé : le lanceur
d'origine est sauvegardé d'abord et peut être remis à tout moment.

> Testé sur une Android TV Philips (Android 10/11). Les autres Android TV / Google TV devraient fonctionner, mais
> c'est un projet perso, **sans garantie**. Lis les commandes avant de les lancer.

## 1. Préparer la télé

1. **Paramètres › Préférences de l'appareil › À propos**, puis clique 7 fois sur **Build** (ou « Version »).
   Ça débloque les options pour les développeurs.
2. **Paramètres › Préférences de l'appareil › Options pour les développeurs** : active le **Débogage USB**.
   Si l'option existe, active aussi le **Débogage réseau** / **ADB par le réseau**.
3. Note l'adresse IP de la télé : **Paramètres › Réseau et Internet › ton réseau**.

## 2. Installer ADB sur l'ordinateur

Télécharge **[Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools?hl=fr)**,
décompresse-le et ouvre un terminal dans ce dossier (ou ajoute-le au `PATH`). Puis vérifie que ça marche :

```bash
adb version
```

## 3. Méthode rapide : le script

Télécharge `Accueil.apk` depuis la page **Releases** et place-le dans `dist/` (ou compile-le toi-même, voir le
README). Puis :

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File scripts\install.ps1 -Tv 192.168.1.50
```
```bash
# macOS / Linux
./scripts/install.sh 192.168.1.50
```

La première fois, la télé demande **d'autoriser le débogage** depuis l'ordinateur : coche « Toujours autoriser »
et accepte.

Le script :
1. sauvegarde ton lanceur actuel dans `backup/` (son nom et son APK, plus la liste des applis installées et désactivées) ;
2. installe Accueil ;
3. lui donne ses autorisations ;
4. le met comme écran d'accueil.

Si le lanceur d'origine revient quand même (fréquent sur **Google TV**), relance le script avec `-DisableStock`
(Windows) ou `--disable-stock` (macOS/Linux).

## 4. Méthode manuelle, étape par étape

Remplace `192.168.1.50` par l'IP de ta télé.

### Se connecter
```bash
adb connect 192.168.1.50:5555
adb devices
```

### Sauvegarder le lanceur actuel
```bash
# Quel est l'écran d'accueil actuel ? Note la dernière ligne, ex. com.google.android.tvlauncher/.MainActivity
adb shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME

# Où est son APK ? (ex. package:/system/priv-app/TVLauncher/TVLauncher.apk)
adb shell pm path com.google.android.tvlauncher
adb pull /system/priv-app/TVLauncher/TVLauncher.apk lanceur-sauvegarde.apk

# Liste des applis installées et désactivées, pour mémoire
adb shell pm list packages -f > paquets.txt
adb shell pm list packages -d > paquets-desactives.txt
```
Lanceurs d'origine courants :

| Appareil | Lanceur d'origine |
|---|---|
| Android TV | `com.google.android.tvlauncher` |
| Google TV | `com.google.android.apps.tv.launcherx` |
| Ancienne Android TV | `com.google.android.leanbacklauncher` |

### Installer
```bash
adb install -r Accueil.apk
```

### Donner les autorisations
Elles servent au widget de lecture en cours, à l'égaliseur et au planning de la semaine. La plupart des télés
n'ont pas d'écran pour les accorder, donc c'est ADB qui s'en charge :
```bash
adb shell cmd notification allow_listener com.minimal.accueil/com.minimal.accueil.EcouteurNotifs
adb shell pm grant com.minimal.accueil android.permission.RECORD_AUDIO
adb shell pm grant com.minimal.accueil android.permission.READ_CALENDAR
```

### Le mettre par défaut
```bash
adb shell cmd package set-home-activity com.minimal.accueil/.Accueil
adb shell input keyevent KEYCODE_HOME
```
Si le bouton Accueil ouvre encore le lanceur d'origine, désactive-le. C'est réversible, rien n'est désinstallé :
```bash
adb shell pm disable-user --user 0 com.google.android.tvlauncher
```

## 5. Ajouter tes propres fonds d'écran

Sur la télé : **roue dentée › Fonds d'écran › Importer mes images**. Scanne le QR code avec ton téléphone (même
Wi-Fi) et choisis tes photos. Elles sont recadrées automatiquement en 16:9.

## 6. Revenir au lanceur d'origine

```powershell
powershell -ExecutionPolicy Bypass -File scripts\restore.ps1 -Tv 192.168.1.50            # ajoute -Uninstall pour supprimer Accueil
```
```bash
./scripts/restore.sh 192.168.1.50                                                     # ajoute --uninstall pour supprimer Accueil
```
Ou à la main :
```bash
adb shell pm enable com.google.android.tvlauncher
adb shell cmd package set-home-activity com.google.android.tvlauncher/.MainActivity   # la ligne notée plus haut
adb uninstall com.minimal.accueil                                                      # facultatif
```

## Dépannage

| Problème | Solution |
|---|---|
| `unauthorized` dans `adb devices` | Accepte la demande sur la télé, ou désactive puis réactive le débogage |
| `failed to connect` | Vérifie l'IP, que le débogage réseau est actif, et que la télé et l'ordinateur sont sur le même réseau |
| Pas d'option « Débogage réseau » | Branche une fois en USB, puis lance `adb tcpip 5555` |
| Widget Spotify vide | Relance la commande `allow_listener`, puis lance une musique |
| Égaliseur plat | Relance l'autorisation `RECORD_AUDIO` (le son doit sortir de la télé, pas d'un appareil Cast) |
