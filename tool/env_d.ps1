# Dot-source this script before Flutter commands; settings affect this shell only.
$taskProjectRoot = Split-Path -Parent $PSScriptRoot
if ([System.IO.Path]::GetPathRoot($taskProjectRoot) -ne 'D:\') {
    throw 'Proyek ini dikonfigurasi untuk berjalan dan menyimpan cache di drive D.'
}
$taskRuntime = Join-Path $taskProjectRoot '.runtime'
$taskDirectories = @('temp', 'appdata', 'localappdata', 'pub-cache', 'pip-cache')
foreach ($taskDirectory in $taskDirectories) {
    New-Item -ItemType Directory -Force -Path (Join-Path $taskRuntime $taskDirectory) | Out-Null
}
$env:TEMP = Join-Path $taskRuntime 'temp'
$env:TMP = $env:TEMP
$env:APPDATA = Join-Path $taskRuntime 'appdata'
$env:LOCALAPPDATA = Join-Path $taskRuntime 'localappdata'
$env:PUB_CACHE = Join-Path $taskRuntime 'pub-cache'
$env:PIP_CACHE_DIR = Join-Path $taskRuntime 'pip-cache'
$env:GRADLE_USER_HOME = Join-Path $taskProjectRoot '.gradle-local'
# Dependencies are now resolved into the D cache instead of using C as a cache.
Remove-Item Env:GRADLE_RO_DEP_CACHE -ErrorAction SilentlyContinue
$env:ANDROID_HOME = 'D:\Android\Sdk'
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:ANDROID_USER_HOME = 'D:\android_prefs'
$env:ANDROID_AVD_HOME = 'D:\AndroidAVD'
$env:ANDROID_EMULATOR_HOME = $env:ANDROID_AVD_HOME
$env:CI = 'true'
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
$env:JAVA_TOOL_OPTIONS = '-Xmx512m -XX:ActiveProcessorCount=2 -XX:+UseSerialGC'
$taskJdk = Join-Path $taskRuntime 'jdk-17'
if (-not (Test-Path -LiteralPath (Join-Path $taskJdk 'bin\java.exe'))) {
    throw "JDK lokal D belum tersedia. Salin JDK 17 ke $taskJdk terlebih dahulu."
}
$env:JAVA_HOME = $taskJdk
$taskFlutterSettings = Join-Path $env:APPDATA '.flutter_settings'
$taskSettingsJson = @{'jdk-dir' = $taskJdk; 'enable-android' = $true; 'enable-web' = $true} | ConvertTo-Json
[System.IO.File]::WriteAllText($taskFlutterSettings, $taskSettingsJson, [System.Text.UTF8Encoding]::new($false))
Set-Location -LiteralPath $taskProjectRoot
