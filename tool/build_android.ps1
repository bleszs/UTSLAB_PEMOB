param([switch]$IsolatedCache)
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'env_d.ps1')
# IsolatedCache remains accepted for compatibility; the D cache is now mandatory.
$taskFlutterBin = Split-Path -Parent (Get-Command flutter -ErrorAction Stop).Source
$taskDart = Join-Path $taskFlutterBin 'cache\dart-sdk\bin\dart.exe'
$taskSnapshot = Join-Path $taskFlutterBin 'cache\flutter_tools.snapshot'
& $taskDart $taskSnapshot build apk --debug --no-pub
$taskExit = $LASTEXITCODE
@{ exitCode = $taskExit; apkExists = (Test-Path -LiteralPath 'build\app\outputs\flutter-apk\app-debug.apk') } | ConvertTo-Json | Set-Content -LiteralPath 'build\android-build-result.json' -Encoding UTF8
exit $taskExit
