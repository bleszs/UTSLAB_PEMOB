# Pengujian dan bukti verifikasi

Pengujian otomatis: 6 Oktober 2026. Pemeriksaan Android dan konfigurasi drive D: 7 Oktober 2026. Toolchain: Flutter 3.35.7, Dart 3.9.2, Windows.

## Hasil otomatis

| Pemeriksaan | Hasil | Cakupan |
|---|---|---|
| Unit test | Lulus, 5 skenario | Validasi nama/soal, blok lanjut, revisi, skor, reset |
| Widget test | Lulus, 3 skenario | Alur lengkap, tema/rotasi/back, teks besar |
| Capture renderer | Lulus setelah font dan image decode disiapkan | Welcome, quiz, result, review; terang/gelap |
| Build web release | Berhasil setelah font final | Kompilasi web; belum klaim browser E2E |
| Analyze akhir | Lulus, No issues found | Semua file Dart dan tool capture |
| Build APK debug | Berhasil, exitCode 0 | build/app/outputs/flutter-apk/app-debug.apk, universal debug |

Tidak ada klaim pengujian perangkat fisik. Pemeriksaan native menggunakan emulator Pixel_8_2, Android API 35, dengan APK debug yang telah dibangun dan dipasang.

## Skenario unit

1. Nama spasi ditolak, nama panjang ditolak, trim nama berhasil.
2. Lanjut tanpa pilihan tidak mengubah indeks; indeks opsi invalid ditolak.
3. Kembali dan mengubah jawaban tidak menggandakan jumlah jawaban.
4. Delapan benar menghasilkan 80; selesai tidak dapat dihitung dua kali.
5. Nol benar menghasilkan 0; seluruh benar menghasilkan 100.
6. Reset mengosongkan nama dan answers serta mengembalikan indeks.
7. Bank soal memiliki id dan opsi unik; empat opsi pada setiap soal.

Poin di atas dikelompokkan dalam lima unit test pada `test/quiz_controller_test.dart`.

## Skenario widget

- Alur lengkap di 390×844: input kosong, isi nama, 10 soal benar, hasil 100, pembahasan, kembali dan main lagi dengan input kosong.
- Rotasi dari 320×568 ke 844×390: pilihan tetap aktif; tema gelap dan navigasi kembali mempertahankan jawaban.
- Landscape kecil 568×320 dengan skala teks 1.5: konten digulir untuk memilih jawaban dan tidak menghasilkan overflow.

Ukuran di atas menggunakan logical pixel, devicePixelRatio 1 pada test binding. Tes layout mendeteksi exception Flutter, bukan pemeriksaan semua kombinasi perangkat.

## Screenshot

File dalam `docs/screenshots/` dihasilkan dengan Flutter test renderer melalui `tool/capture_test.dart`. Bank soal dan skor pada capture berasal dari controller: contoh 8 benar dari 10 menghasilkan 80. Screenshot renderer ini diberi nama menurut layar dan viewport; gambar ZIP pengguna berada terpisah sebagai referensi.

| File | Viewport |
|---|---|
| welcome-phone.png | 390×844 |
| welcome-wide.png | 1280×800 |
| quiz-phone.png | 390×844 |
| quiz-landscape-dark.png | 844×390 |
| result-phone.png | 390×844 |
| result-phone-dark.png | 390×844 |
| review-phone.png | 390×844 |

## Pemeriksaan native Android

APK dijalankan pada Pixel_8_2 melalui Android SDK dan data AVD di D. Ukuran phone 1080 × 2400, density 420; landscape 2400 × 1080. Simulasi tablet memakai override 1600 × 2560, density 320. Metadata per capture berada di file JSON dengan nama yang sama dalam `docs/screenshots/android/`.

- Nama `Dzakwan`, delapan jawaban benar dan dua salah menghasilkan skor 80, statistik 10 soal / 8 benar / 2 salah.
- Pilihan B (Mars) pada soal pertama tetap terpilih sesudah rotasi portrait ke landscape dan kembali. Layout landscape dapat digulir untuk mencapai opsi di bawah viewport; tombol lanjut tetap tersedia.
- Mode terang/gelap diuji pada APK. Font scale Android 1.3 diuji pada soal pertama dengan jawaban dipilih.
- Hasil dan pembahasan dibuka pada Android. Main Lagi mengembalikan Welcome dengan input nama kosong dan tanpa tombol lanjut sesi.
- Pemeriksaan native menemukan pesan validasi nama ikut muncul setelah reset. Welcome diperbaiki agar validasi dimulai saat submit; regression assertion ditambahkan pada widget test dan APK dibangun ulang.
- Welcome diperiksa dengan keyboard Android terbuka. Screenshot memperlihatkan area input dan inset keyboard.

| Capture native | Keadaan |
|---|---|
| welcome-phone.png | Welcome terang, input kosong |
| quiz-phone.png | Soal 1, Mars dipilih, gelap |
| quiz-landscape-dark.png | Rotasi landscape, state pilihan dipertahankan |
| quiz-font-large-dark.png | Font scale 1.3, portrait |
| result-phone.png | Hasil 80, terang |
| result-phone-dark.png | Hasil 80, gelap |
| review-phone-dark.png | Pembahasan, gelap |
| result-tablet-dark.png | Hasil pada ukuran tablet simulasi |
| welcome-reset-phone.png | Welcome setelah Main Lagi |
| welcome-keyboard-phone.png | Input nama dengan keyboard Android |

Capture dibuat dengan `tool/android_screenshot.ps1` menggunakan `adb screencap`, terpisah dari screenshot renderer. Aset dan transisi dibiarkan selesai sebelum capture. Font scale, rotasi otomatis, serta override ukuran/density dikembalikan setelah pengujian. Pemeriksaan ini tidak mencakup setiap model Android, perangkat fisik, atau seluruh perilaku predictive Back.

## Checklist perangkat fisik sebelum distribusi

- Instal APK, masukkan nama dan kerjakan kuis.
- Pilih jawaban lalu putar perangkat; cek soal dan pilihan tetap sama.
- Coba keyboard pada Welcome, nama panjang, kembali sistem, dan lanjut sesi.
- Buka hasil serta pembahasan; pastikan Main Lagi menghapus seluruh state.
- Uji tema terang/gelap dan font scale 1.3 atau lebih.
- Uji SafeArea, status/navigation bars dan gesture Back pada perangkat asli.
- Matikan/muat ulang aplikasi: sesi baru adalah perilaku yang didokumentasikan.

## Masalah lingkungan awal

Gradle global versi 8.12 gagal membaca beberapa `transforms/*/metadata.bin`. Percobaan perbaikan menggunakan `.gradle-local` sebagai `GRADLE_USER_HOME`, dengan cache dependensi global hanya dibaca. Cache global tidak dihapus. Folder cache lokal masuk `.gitignore`.
Percobaan berikutnya terhenti karena batas sumber daya dan daemon Gradle menghilang. Konfigurasi final: heap Gradle 1024 MB, metaspace 512 MB, satu worker, SerialGC, Kotlin compiler dalam proses yang sama, dan Jetifier nonaktif karena dependensi menggunakan AndroidX. Proses Java pendukung termasuk jmod juga dibatasi 512 MB melalui JAVA_TOOL_OPTIONS lokal. Perintah jmod yang sebelumnya gagal berhasil dengan batas ini, lalu build APK selesai. Build terisolasi dapat diulang dengan `powershell -NoProfile -ExecutionPolicy Bypass -File tool/build_android.ps1 -IsolatedCache`. Script menghasilkan `build/android-build-result.json` beserta exit code; konfigurasi Java global tidak diubah.

AVD Pixel_7_Claude menunjuk system image yang tidak ada. AVD Pixel_8_2 memakai image Android API 35 yang tersedia. Override ukuran/density hanya digunakan saat pengujian lalu direset.

Konfigurasi akhir `tool/env_d.ps1` memakai cache Pub, Gradle, JDK, TEMP/TMP, konfigurasi Flutter, Android SDK dan AVD di D. `flutter pub get --offline` dan `flutter analyze` berhasil setelah package cache disalin ke D; `.dart_tool/package_config.json` tidak memiliki referensi package `file:///C:`. File/cache lama di C tetap ada. Lihat `docs/drive-d.md`.

Build ulang 7 Oktober sempat gagal dengan `Native memory allocation (malloc) failed` ketika emulator masih aktif. Emulator ditutup sementara untuk membebaskan memori, kemudian build diulang dengan cache dan JDK D yang sama. Lokasi paging serta pengaturan memori Windows tidak diubah.

Build ulang terakhir berhasil dalam 61.4 detik dengan exitCode 0. APK terbaru dipasang kembali; alur 8 benar / 2 salah menghasilkan 80 dan Main Lagi tidak menampilkan error nama. Hash SHA-256 serta urutan jawaban disimpan di `docs/screenshots/android/session.json`. Emulator dibuka kembali dan dibiarkan pada Welcome untuk dicoba pengguna.

Review antarmuka native akhir menghasilkan `disposition: ship` tanpa material fixes. Reviewer pengganti melakukan review penuh terhadap sepuluh capture native dan metadata, bukan hanya skor perbaikan; hasil berada di `.impeccable/review/finish-review.md`. Dua capture terbaru memiliki garis hijau tipis di tepi layar yang tidak ditemukan pada source aplikasi; penyebabnya tidak diklaim. DESIGN.md serta sidecar schemaVersion 2 diperiksa kembali oleh documenter dan tidak memerlukan perubahan.
