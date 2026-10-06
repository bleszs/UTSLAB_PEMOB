# Lokasi kerja di drive D

Arahan pengguna pada 7 Oktober 2026: jalankan di D karena ruang C hampir habis.

## Konfigurasi proyek

| Kebutuhan | Lokasi |
|---|---|
| Proyek, kode, aset, dokumentasi | D:\UTSLABPEMMOB |
| APK dan web build | D:\UTSLABPEMMOB\build |
| Cache Gradle | D:\UTSLABPEMMOB\.gradle-local |
| Cache package Dart/Flutter | D:\UTSLABPEMMOB\.runtime\pub-cache |
| File sementara TEMP/TMP | D:\UTSLABPEMMOB\.runtime\temp |
| Konfigurasi Flutter lokal | D:\UTSLABPEMMOB\.runtime\appdata |
| JDK 17 lokal | D:\UTSLABPEMMOB\.runtime\jdk-17 |
| Flutter SDK | D:\flutter |
| Android SDK | D:\Android\Sdk |
| Emulator dan datanya | D:\AndroidAVD |

Aktifkan konfigurasi dalam PowerShell yang digunakan menjalankan aplikasi:

```powershell
cd D:\UTSLABPEMMOB
. .\tool\env_d.ps1
flutter pub get --offline
flutter run
```

Konfigurasi ini hanya berlaku pada shell dan proses anaknya. Pengaturan Windows dan cache proyek lain tidak diubah. File/cache lama di C tidak dihapus. Salinan JDK dan package yang sudah diperlukan dibuat di D untuk menghindari unduhan ulang.

File sistem Windows seperti `C:\pagefile.sys` berada di luar konfigurasi proyek. Lokasi paging Windows tidak diubah oleh script ini.

`.runtime` dan `.gradle-local` tidak dimasukkan ke Git. Bila checkout dipindahkan ke komputer lain, siapkan JDK 17 pada lokasi di tabel dan gunakan `flutter pub get` tanpa `--offline` pada penggunaan pertama.
