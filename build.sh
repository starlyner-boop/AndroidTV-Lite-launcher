#!/usr/bin/env bash
# Builds dist/Accueil.apk without Gradle: aapt2 -> javac -> d8 -> zipalign -> apksigner.
# Requirements: a JDK (17+) on PATH and the Android SDK (build-tools + one platform, API 30 or newer).
#   ANDROID_HOME=~/Android/Sdk ./build.sh
# On first run a signing key (release.keystore) is created; keytool and apksigner ask for its password.
# Keep that file and password: Android only accepts updates signed with the same key. Never commit it.
set -euo pipefail
cd "$(dirname "$0")"
SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
[ -d "$SDK" ] || { echo "Android SDK not found: set ANDROID_HOME." >&2; exit 1; }
BT="$(ls -d "$SDK"/build-tools/*/ | sort -V | tail -1)"
PF="$(ls -d "$SDK"/platforms/android-*/ | sort -V | tail -1)"
JAR="${PF}android.jar"
echo "Build-tools: $BT"; echo "Platform:    $JAR"

O=build; rm -rf "$O"; mkdir -p "$O/res" "$O/gen" "$O/classes" "$O/dex" dist
"$BT/aapt2" compile --dir app/res -o "$O/res/res.zip"
"$BT/aapt2" link -I "$JAR" --manifest app/AndroidManifest.xml --java "$O/gen" -o "$O/base.apk" "$O/res/res.zip"
find app/src "$O/gen" -name '*.java' > "$O/sources.txt"
javac -encoding UTF-8 --release 8 -nowarn -classpath "$JAR" -d "$O/classes" @"$O/sources.txt"
jar cf "$O/classes.jar" -C "$O/classes" .
"$BT/d8" --release --min-api 26 --lib "$JAR" --output "$O/dex" "$O/classes.jar"
cp "$O/base.apk" "$O/unaligned.apk"
(cd "$O/dex" && jar uf ../unaligned.apk classes.dex)
"$BT/zipalign" -f -p 4 "$O/unaligned.apk" "$O/aligned.apk"

if [ ! -f release.keystore ]; then
  echo "Creating your signing key (release.keystore). Choose a password and keep it safe."
  keytool -genkeypair -keystore release.keystore -alias accueil -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Accueil"
fi
"$BT/apksigner" sign --ks release.keystore --ks-key-alias accueil --out dist/Accueil.apk "$O/aligned.apk"
ls -l dist/Accueil.apk
