param([ValidateSet('Profile','Tablet','Phone')][string]$Stage = 'Tablet', [Alias('ResumeAtHotspot')][switch]$ResumeAtSecondQuestion)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'env_d.ps1')
$taskAdb = Join-Path $env:ANDROID_HOME 'platform-tools\adb.exe'
$taskScenario = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'quest_smoke_scenario.json') -Raw -Encoding UTF8 | ConvertFrom-Json
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
function Scroll-ContentTop {
    $taskDimensions = [regex]::Matches(((& $taskAdb -s emulator-5554 shell wm size) -join ''), '(\d+)x(\d+)') | Select-Object -Last 1
    $taskScreenW = [int]$taskDimensions.Groups[1].Value
    $taskScreenH = [int]$taskDimensions.Groups[2].Value
    for ($taskScroll = 0; $taskScroll -lt 2; $taskScroll++) {
        & $taskAdb -s emulator-5554 shell input swipe ([int]($taskScreenW*.55)) ([int]($taskScreenH*.32)) ([int]($taskScreenW*.55)) ([int]($taskScreenH*.72)) 350 | Out-Null
    }
}
function Capture([string]$Name) { & (Join-Path $PSScriptRoot 'android_screenshot.ps1') -Quest16 -Name $Name }
function Submit-Next([bool]$ExpectedCorrect = $true, [bool]$Last = $false) {
    Tap 'Kirim Jawaban'
    $taskUi = Read-Ui
    $taskMessage = if ($ExpectedCorrect) { 'Buktinya cocok!' } else { 'Belum tepat' }
    if (-not $taskUi.OuterXml.Contains($taskMessage)) { throw "Unexpected feedback: $taskMessage" }
    if ($Last) { Tap 'Lihat Hasil' } else { Tap 'Soal Berikutnya' }
}
if ($Stage -eq 'Profile') {
    Capture 'welcome-phone'
    & (Join-Path $PSScriptRoot 'android_action.ps1') -NameInput
    & $taskAdb -s emulator-5554 shell input text Adit | Out-Null
    Capture 'keyboard-phone'
    & $taskAdb -s emulator-5554 shell input keyevent 4 | Out-Null
    Tap 'Detektif'
    Tap 'Pilih Misi'
    Capture 'missions-phone'
} else {
    if ($Stage -eq 'Tablet') {
        & $taskAdb -s emulator-5554 shell wm size 1600x2560 | Out-Null
        & $taskAdb -s emulator-5554 shell wm density 320 | Out-Null
        Start-Sleep -Seconds 2
        if (-not $ResumeAtSecondQuestion) { Tap "Maraton $($taskScenario.total) Soal" }
        $taskFirst = if ($ResumeAtSecondQuestion) { 2 } else { 1 }
        $taskLast = 8
    } else {
        & $taskAdb -s emulator-5554 shell wm size reset | Out-Null
        & $taskAdb -s emulator-5554 shell wm density reset | Out-Null
        Start-Sleep -Seconds 2
        $taskFirst = 9
        $taskLast = $taskScenario.total
    }
    foreach ($taskClassic in ($taskScenario.classicQuestions | Where-Object { $_.position -ge $taskFirst -and $_.position -le $taskLast })) {
        Scroll-ContentTop
        $taskUi = Read-Ui
        $taskPosition = "Soal $($taskClassic.position) / $($taskScenario.total)"
        if (-not $taskUi.OuterXml.Contains($taskPosition)) { throw "Wrong question position: $taskPosition" }
        if ($taskScenario.hintQuestionIds -contains $taskClassic.id) { Tap 'Buka Petunjuk' }
        $taskWrong = $taskScenario.wrongChoices.PSObject.Properties[$taskClassic.id]
        $taskChosen = if ($taskWrong) { $taskWrong.Value } else { $taskClassic }
        Tap "Pilih opsi $($taskChosen.choice), $($taskChosen.label)" -Prefix
        Capture "multiple-choice-$($taskClassic.id)-$($Stage.ToLower())"
        Submit-Next -ExpectedCorrect (-not [bool]$taskWrong) -Last ($taskClassic.position -eq $taskScenario.total)
    }
    if ($Stage -eq 'Tablet') {
        Write-Output 'PASS: first eight multiple-choice questions; question 9 next.'
        return
    }
    Capture 'result-phone'
    $taskUi = Read-Ui
    $taskExpected = $taskScenario.expected
    if (-not $taskUi.OuterXml.Contains("$($taskExpected.accuracy)%") -or
        -not $taskUi.OuterXml.Contains("$($taskExpected.points)") -or
        -not $taskUi.OuterXml.Contains("$($taskExpected.correct) dari $($taskExpected.total) soal benar")) {
        throw 'Native result mismatch with quest_smoke_scenario.json'
    }
    Tap 'Lihat Pembahasan'
    Capture 'review-phone'
    & $taskAdb -s emulator-5554 shell input keyevent 4 | Out-Null
    Tap 'Latih yang Belum Tepat'
    Capture 'practice-phone'
    $taskUi = Read-Ui
    if (-not $taskUi.OuterXml.Contains('Soal 1 / 1')) { throw 'Practice subset mismatch' }
    $taskPracticeId = ($taskScenario.wrongChoices.PSObject.Properties | Select-Object -First 1).Name
    $taskPractice = $taskScenario.classicQuestions | Where-Object { $_.id -eq $taskPracticeId } | Select-Object -First 1
    Tap "Pilih opsi $($taskPractice.choice), $($taskPractice.label)" -Prefix
    Submit-Next -Last $true
    Capture 'practice-result-phone'
    $taskUi = Read-Ui
    if (-not $taskUi.OuterXml.Contains('100%')) { throw 'Practice result mismatch' }
    Tap 'Main Lagi'
    Capture 'reset-phone'
    $taskUi = Read-Ui
    $taskName = $taskUi.SelectNodes('//node') | Where-Object { $_.class -eq 'android.widget.EditText' } | Select-Object -First 1
    if (-not $taskName -or $taskName.text) { throw 'Replay name not empty' }
    Write-Output "PASS: $($taskExpected.correct)/$($taskExpected.total) correct, $($taskExpected.accuracy)%, $($taskExpected.points) points; practice 1/1; reset empty."
}
