param([string]$Label, [ValidateSet('A','B','C','D')][string]$Choice, [switch]$NameInput, [switch]$Inspect, [ValidateRange(0,30)][int]$Index = 0)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'env_d.ps1')
$taskAdb = Join-Path $env:ANDROID_HOME 'platform-tools\adb.exe'
$taskUiPath = Join-Path $taskProjectRoot '.runtime\temp\quizora-ui.xml'
$taskDump = & $taskAdb -s emulator-5554 shell uiautomator dump /sdcard/quizora-ui.xml
if ($LASTEXITCODE -ne 0 -or ($taskDump -join '') -notmatch 'UI hierchary dumped') {
    throw 'Android belum siap menghasilkan hierarki UI; tunggu lalu ulangi.'
}
& $taskAdb -s emulator-5554 exec-out cat /sdcard/quizora-ui.xml | Set-Content -LiteralPath $taskUiPath -Encoding UTF8
[xml]$taskUi = Get-Content -LiteralPath $taskUiPath -Raw -Encoding UTF8
if ($Inspect -and -not $Label -and -not $Choice -and -not $NameInput) {
    $taskUi.SelectNodes('//node') | Where-Object { $_.'content-desc' -or $_.text -or $_.class -eq 'android.widget.EditText' } | Select-Object class,text,'content-desc',selected,bounds
    exit 0
}
$taskNode = $taskUi.SelectNodes('//node') | Where-Object {
    if ($NameInput) { $_.class -eq 'android.widget.EditText' }
    elseif ($Choice) { $_.'content-desc' -match "^Pilihan ${Choice}:" }
    else { $_.'content-desc' -eq $Label -or $_.text -eq $Label }
} | Select-Object -Skip $Index -First 1
if (-not $taskNode) { throw "Kontrol belum terlihat: $Label" }
if ($Inspect) { $taskNode | Select-Object 'content-desc',selected,bounds; exit 0 }
$taskBounds = [regex]::Match($taskNode.bounds, '^\[(\d+),(\d+)\]\[(\d+),(\d+)\]$')
if (-not $taskBounds.Success) { throw 'Bounds Android tidak valid.' }
$taskTapX = [int](([int]$taskBounds.Groups[1].Value + [int]$taskBounds.Groups[3].Value) / 2)
$taskTapY = [int](([int]$taskBounds.Groups[2].Value + [int]$taskBounds.Groups[4].Value) / 2)
& $taskAdb -s emulator-5554 shell input tap $taskTapX $taskTapY
Write-Output "Tapped: $($taskNode.'content-desc')"
