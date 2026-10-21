param([ValidateSet('Profile','Tablet','Phone')][string]$Stage = 'Tablet', [switch]$ResumeAtHotspot)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'env_d.ps1')
$taskAdb = Join-Path $env:ANDROID_HOME 'platform-tools\adb.exe'
function Read-Ui {
    for ($taskRetry = 0; $taskRetry -lt 3; $taskRetry++) {
        $taskDump = & $taskAdb -s emulator-5554 shell uiautomator dump /sdcard/quizora-ui.xml
        if ($LASTEXITCODE -eq 0 -and ($taskDump -join '') -match 'UI hierchary dumped') {
            return [xml]((& $taskAdb -s emulator-5554 exec-out cat /sdcard/quizora-ui.xml) -join '')
        }
        Start-Sleep -Seconds 1
    }
    throw 'No fresh hierarchy'
}
function Tap([string]$Label, [switch]$Prefix) {
    for ($taskTry = 0; $taskTry -lt 7; $taskTry++) {
        $taskUi = Read-Ui
        $taskNode = $taskUi.SelectNodes('//node') | Where-Object {
            if ($Prefix) { $_.'content-desc'.StartsWith($Label) -and $_.class -eq 'android.widget.Button' }
            else { $_.'content-desc' -eq $Label -or $_.text -eq $Label }
        } | Select-Object -First 1
        if ($taskNode) {
            $taskBounds = [regex]::Match($taskNode.bounds, '^\[(\d+),(\d+)\]\[(\d+),(\d+)\]$')
            $taskX = [int](([int]$taskBounds.Groups[1].Value + [int]$taskBounds.Groups[3].Value) / 2)
            $taskY = [int](([int]$taskBounds.Groups[2].Value + [int]$taskBounds.Groups[4].Value) / 2)
            & $taskAdb -s emulator-5554 shell input tap $taskX $taskY | Out-Null
            Write-Output "Tap $Label"
            Start-Sleep -Milliseconds 350
            return
        }
        # Swipe in the content area, above the fixed footer.
        $taskSizeMatch = [regex]::Matches(((& $taskAdb -s emulator-5554 shell wm size) -join ''),'(\d+)x(\d+)') | Select-Object -Last 1
        $taskW = [int]$taskSizeMatch.Groups[1].Value
        $taskH = [int]$taskSizeMatch.Groups[2].Value
        & $taskAdb -s emulator-5554 shell input swipe ([int]($taskW*.55)) ([int]($taskH*.72)) ([int]($taskW*.55)) ([int]($taskH*.32)) 400 | Out-Null
    }
    throw "Missing visible control: $Label"
}
function Capture([string]$Name) { & (Join-Path $PSScriptRoot 'android_screenshot.ps1') -Quest -Name $Name }
function Submit-Next {
    Tap 'Kirim Jawaban'
    $taskUi = Read-Ui
    if ($taskUi.OuterXml -notmatch 'Buktinya cocok!') { throw 'Expected correct feedback' }
    Tap 'Puzzle Berikutnya'
}
if ($Stage -eq 'Profile') {
    & $taskAdb -s emulator-5554 shell settings put secure stylus_handwriting_enabled 0 | Out-Null
    Capture 'welcome-phone'
    & (Join-Path $PSScriptRoot 'android_action.ps1') -NameInput
    & $taskAdb -s emulator-5554 shell input text Adit | Out-Null
    Capture 'keyboard-phone'
    & $taskAdb -s emulator-5554 shell input keyevent 4 | Out-Null
    Tap 'Detektif'
    Tap 'Pilih Misi'
    Capture 'missions-phone'
} elseif ($Stage -eq 'Tablet') {
    & $taskAdb -s emulator-5554 shell wm size 1600x2560 | Out-Null
    & $taskAdb -s emulator-5554 shell wm density 320 | Out-Null
    Start-Sleep -Seconds 2
    if (-not $ResumeAtHotspot) {
        Tap 'Maraton 12 Puzzle'
        Capture 'sequence-tablet'
        Tap 'Naikkan Unduh file'
        Tap 'Naikkan Unduh file'
        Tap 'Naikkan Ekstrak ZIP'
        Tap 'Naikkan Ekstrak ZIP'
        Submit-Next
    }
    Capture 'hotspot-tablet'
    Tap 'Pilih Total: Rp95.000'
    Submit-Next
    Capture 'matching-tablet'
    Tap 'Flashdisk'
    Tap 'Adaptor'
    Tap 'Laptop'
    Submit-Next
    Capture 'scenario-tablet'
    Tap 'Pilih Pasang charger' -Prefix
    Submit-Next
    Capture 'multiselect-tablet'
    Tap 'Pilih Kegiatan A' -Prefix
    Tap 'Pilih Kegiatan B' -Prefix
    Submit-Next
    Tap 'Email konfirmasi ruangan diterima'
    Tap 'Dosen mungkin datang terlambat'
    Tap 'Dosen mungkin datang terlambat'
    Tap 'Daftar hadir berisi 12 nama'
    Tap 'Sepertinya proyektor akan rusak'
    Tap 'Sepertinya proyektor akan rusak'
    Capture 'categorize-tablet'
    Submit-Next
    Tap 'Naikkan Briefing'
    Tap 'Naikkan Simulasi'
    Tap 'Naikkan Simulasi'
    Submit-Next
    Tap 'Pilih Reservasi C:' -Prefix
    Submit-Next
    Write-Output 'PASS: first eight puzzles correct; code builder next.'
} else {
    & $taskAdb -s emulator-5554 shell wm size reset | Out-Null
    & $taskAdb -s emulator-5554 shell wm density reset | Out-Null
    Start-Sleep -Seconds 2
    Tap 'Buka Petunjuk'
    Tap '2'
    Tap '4'
    Capture 'code-partial-phone'
    Tap 'Matikan suara'
    Tap 'Kembali'
    Tap 'Lanjutkan misi sebelumnya'
    & $taskAdb -s emulator-5554 shell settings put system accelerometer_rotation 0 | Out-Null
    & $taskAdb -s emulator-5554 shell settings put system user_rotation 1 | Out-Null
    Start-Sleep -Seconds 2
    Tap 'Aktifkan mode gelap'
    Capture 'code-landscape-dark-phone'
    $taskUi = Read-Ui
    if ($taskUi.OuterXml -notmatch 'Slot 1: 2' -or $taskUi.OuterXml -notmatch 'Slot 2: 4') { throw 'Rotation lost partial code' }
    Tap 'Aktifkan mode terang'
    & $taskAdb -s emulator-5554 shell settings put system user_rotation 0 | Out-Null
    & $taskAdb -s emulator-5554 shell settings put system accelerometer_rotation 1 | Out-Null
    Start-Sleep -Seconds 2
    & $taskAdb -s emulator-5554 shell settings put system font_scale 1.3 | Out-Null
    Capture 'code-large-font-phone'
    & $taskAdb -s emulator-5554 shell settings put system font_scale 1.0 | Out-Null
    Tap '3'
    Tap 'Kirim Jawaban'
    Capture 'feedback-hint-phone'
    $taskUi = Read-Ui
    if ($taskUi.OuterXml -notmatch 'Buktinya cocok!' -or $taskUi.OuterXml -notmatch '70 poin') { throw 'Hint score wrong' }
    Tap 'Puzzle Berikutnya'
    Tap 'Pilih Dokumen B' -Prefix
    Tap 'Pilih Dokumen C' -Prefix
    Submit-Next
    Tap '421'
    Tap '312'
    Tap '243'
    Submit-Next
    Tap 'Pilih Masukkan 312' -Prefix
    Tap 'Kirim Jawaban'
    Capture 'feedback-wrong-phone'
    Tap 'Lihat Hasil'
    Capture 'result-phone'
    $taskUi = Read-Ui
    if ($taskUi.OuterXml -notmatch '92%' -or $taskUi.OuterXml -notmatch '1220') { throw 'Native result mismatch' }
    Tap 'Lihat Pembahasan'
    Capture 'review-phone'
    & $taskAdb -s emulator-5554 shell input keyevent 4 | Out-Null
    Tap 'Latih yang Belum Tepat'
    Capture 'practice-phone'
    $taskUi = Read-Ui
    if ($taskUi.OuterXml -notmatch 'Puzzle 1 / 1') { throw 'Practice subset mismatch' }
    Tap 'Pilih Masukkan 243' -Prefix
    Tap 'Kirim Jawaban'
    Tap 'Lihat Hasil'
    Capture 'practice-result-phone'
    $taskUi = Read-Ui
    if ($taskUi.OuterXml -notmatch '100%') { throw 'Practice result mismatch' }
    Tap 'Main Lagi'
    Capture 'reset-phone'
    $taskUi = Read-Ui
    $taskName = $taskUi.SelectNodes('//node') | Where-Object { $_.class -eq 'android.widget.EditText' } | Select-Object -First 1
    if (-not $taskName -or $taskName.text) { throw 'Replay name not empty' }
    Write-Output 'PASS: 11/12 correct, 1220 points, hint; practice 1/1 correct; reset empty.'
}
