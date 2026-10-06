param([switch]$IsolatedCache)
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $taskRoot
$env:CI = 'true'
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
if ($IsolatedCache) {
    $env:GRADLE_USER_HOME = Join-Path $taskRoot '.gradle-local'
    # Gradle expects the parent directory containing modules-2.
    $taskSharedCache = Join-Path $env:USERPROFILE '.gradle\caches'
    if (Test-Path -LiteralPath (Join-Path $taskSharedCache 'modules-2')) {
        $env:GRADLE_RO_DEP_CACHE = $taskSharedCache
    }
}
$taskFlutterBin = Split-Path -Parent (Get-Command flutter -ErrorAction Stop).Source
$taskDart = Join-Path $taskFlutterBin 'cache\dart-sdk\bin\dart.exe'
$taskSnapshot = Join-Path $taskFlutterBin 'cache\flutter_tools.snapshot'
& $taskDart $taskSnapshot build apk --debug --no-pub
$taskExit = $LASTEXITCODE
@{ exitCode = $taskExit; apkExists = (Test-Path -LiteralPath 'build\app\outputs\flutter-apk\app-debug.apk') } | ConvertTo-Json | Set-Content -LiteralPath 'build\android-build-result.json' -Encoding UTF8
exit $taskExit
