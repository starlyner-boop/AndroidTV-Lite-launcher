# Builds dist/Accueil.apk without Gradle: aapt2 -> javac -> d8 -> zipalign -> apksigner.
# Requirements: a JDK (17+) on PATH and the Android SDK (build-tools + one platform, API 30 or newer).
#   powershell -ExecutionPolicy Bypass -File build.ps1 [-Sdk C:\Android\sdk]
# On first run a signing key (release.keystore) is created; keytool and apksigner ask for its password.
# Keep that file and password: Android only accepts updates signed with the same key. Never commit it.
param([string]$Sdk = $(if ($env:ANDROID_HOME) { $env:ANDROID_HOME } else { $env:ANDROID_SDK_ROOT }))
$ErrorActionPreference = 'Continue'   # tools print notes on stderr; exit codes are checked instead
if (-not $Sdk -or -not (Test-Path $Sdk)) { throw "Android SDK not found: pass -Sdk <path> or set ANDROID_HOME." }

$bt = Get-ChildItem "$Sdk\build-tools" -Directory | Sort-Object { [version]($_.Name -replace '[^0-9.].*$', '') } | Select-Object -Last 1
$pf = Get-ChildItem "$Sdk\platforms" -Directory | Where-Object Name -match '^android-\d+$' |
      Sort-Object { [int]($_.Name -replace 'android-', '') } | Select-Object -Last 1
if (-not $bt -or -not $pf) { throw "Install build-tools and a platform with sdkmanager." }
$bt = $bt.FullName; $jar = "$($pf.FullName)\android.jar"
"Build-tools: $bt`nPlatform:    $jar"

$app = Join-Path $PSScriptRoot 'app'
$o = Join-Path $PSScriptRoot 'build'
$dist = Join-Path $PSScriptRoot 'dist'
if (Test-Path $o) { Remove-Item -Recurse -Force $o }
New-Item -ItemType Directory -Force "$o\res", "$o\gen", "$o\classes", "$o\dex", $dist | Out-Null
function Run($exe) { & $exe @args; if ($LASTEXITCODE) { throw "$exe failed ($LASTEXITCODE)" } }
function Tool($name) { foreach ($e in '.exe', '.bat', '') { if (Test-Path "$bt\$name$e") { return "$bt\$name$e" } }; throw "$name not found in $bt" }

Run (Tool aapt2) compile --dir "$app\res" -o "$o\res\res.zip"
Run (Tool aapt2) link -I $jar --manifest "$app\AndroidManifest.xml" --java "$o\gen" -o "$o\base.apk" "$o\res\res.zip"
# Source list in a file and classes in a jar: avoids "command line too long" on Windows.
Get-ChildItem -Recurse "$app\src", "$o\gen" -Filter *.java | ForEach-Object { '"' + ($_.FullName -replace '\\', '/') + '"' } |
    Set-Content -Encoding ASCII "$o\sources.txt"
Run javac -encoding UTF-8 --release 8 -nowarn -classpath $jar -d "$o\classes" "@$o\sources.txt"
Run jar cf "$o\classes.jar" -C "$o\classes" .
Run (Tool d8) --release --min-api 26 --lib $jar --output "$o\dex" "$o\classes.jar"
Copy-Item "$o\base.apk" "$o\unaligned.apk"
Push-Location "$o\dex"; Run jar uf "$o\unaligned.apk" classes.dex; Pop-Location
Run (Tool zipalign) -f -p 4 "$o\unaligned.apk" "$o\aligned.apk"

$ks = Join-Path $PSScriptRoot 'release.keystore'
if (-not (Test-Path $ks)) {
    "Creating your signing key (release.keystore). Choose a password and keep it safe."
    Run keytool -genkeypair -keystore $ks -alias accueil -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Accueil"
}
Run (Tool apksigner) sign --ks $ks --ks-key-alias accueil --out "$dist\Accueil.apk" "$o\aligned.apk"
Get-Item "$dist\Accueil.apk" | Select-Object FullName, Length
