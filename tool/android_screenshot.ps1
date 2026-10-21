param(
    [ValidatePattern('^[A-Za-z0-9_.:-]+$')][string]$Serial = 'emulator-5554',
    [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9_-]+$')][string]$Name,
    [switch]$Quest
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'env_d.ps1')
$taskAdb = Join-Path $env:ANDROID_HOME 'platform-tools\adb.exe'
# Allow navigation, theme transitions and asset decoding to settle.
Start-Sleep -Milliseconds 1500
$taskCaptureDir = if ($Quest) { Join-Path $taskProjectRoot 'docs\screenshots\quest\android' } else { Join-Path $taskProjectRoot 'docs\screenshots\android' }
New-Item -ItemType Directory -Force -Path $taskCaptureDir | Out-Null
$taskOutput = Join-Path $taskCaptureDir "$Name.png"
$taskProcessInfo = [System.Diagnostics.ProcessStartInfo]::new()
$taskProcessInfo.FileName = $taskAdb
$taskProcessInfo.Arguments = "-s $Serial exec-out screencap -p"
$taskProcessInfo.UseShellExecute = $false
$taskProcessInfo.RedirectStandardOutput = $true
$taskProcessInfo.CreateNoWindow = $true
$taskProcess = [System.Diagnostics.Process]::Start($taskProcessInfo)
$taskStream = [System.IO.File]::Create($taskOutput)
try { $taskProcess.StandardOutput.BaseStream.CopyTo($taskStream) }
finally { $taskStream.Dispose() }
$taskProcess.WaitForExit()
if ($taskProcess.ExitCode -ne 0) { throw 'Gagal menangkap layar Android.' }
$taskCaptureMetadata = @{
    capture = 'Android adb screencap'
    serial = $Serial
    size = (& $taskAdb -s $Serial shell wm size) -join "`n"
    density = (& $taskAdb -s $Serial shell wm density) -join "`n"
    sdk = (& $taskAdb -s $Serial shell getprop ro.build.version.sdk) -join ''
    fontScale = (& $taskAdb -s $Serial shell settings get system font_scale) -join ''
    rotation = (& $taskAdb -s $Serial shell settings get system user_rotation) -join ''
}
if (-not $taskCaptureMetadata.sdk -or -not $taskCaptureMetadata.density -or -not $taskCaptureMetadata.fontScale -or -not $taskCaptureMetadata.rotation) {
    throw 'Metadata capture Android tidak lengkap; koneksi perlu dipulihkan lalu capture diulang.'
}
[System.IO.File]::WriteAllText((Join-Path $taskCaptureDir "$Name.json"), ($taskCaptureMetadata | ConvertTo-Json), [System.Text.UTF8Encoding]::new($false))
Write-Output $taskOutput
