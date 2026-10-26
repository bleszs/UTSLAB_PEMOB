$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'env_d.ps1')
Push-Location -LiteralPath (Join-Path $taskProjectRoot 'android')
try {
    & .\gradlew.bat --version
    if ($LASTEXITCODE -ne 0) { throw 'Tidak dapat membaca versi Gradle wrapper.' }
    & .\gradlew.bat help --console=plain
    if ($LASTEXITCODE -ne 0) { throw 'Konfigurasi Gradle Android gagal.' }
}
finally {
    Pop-Location
}
