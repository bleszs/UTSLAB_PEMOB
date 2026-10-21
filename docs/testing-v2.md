# Pengujian Quizora Quest v2

Tanggal: 7 Oktober 2026. Implementasi Quest commit 575c0a9, perbaikan aksesibilitas final c7654ff; dokumentasi/evidence dilengkapi setelah verifikasi. Bukti versi 1 di testing.md tidak digunakan untuk menyatakan v2 lulus.

## Otomatis

- `flutter analyze`: no issues found.
- `flutter test --reporter expanded`: 13 tes lulus, 7 unit/controller + 6 widget.
- `flutter test tool/capture_test.dart --update-goldens`: 1 harness capture lulus; bukan tes native.

Cakupan: evaluator tujuh tipe, jawaban tidak lengkap/duplikat/ID tidak dikenal, filter misi, profil, snapshot immutable, submit ganda, accuracy vs poin/combo/petunjuk, 12 benar = 1470 poin, latihan subset gagal, reset, clock pause/resume/timeout/late submit/bonus waktu, full UI 12 puzzle/pembahasan/replay, drag kode, rotasi/tema/back-resume, semua tipe pada 568×320 skala teks 1.5.

Tes tambahan setelah review memanggil SemanticsAction.tap melalui SemanticsOwner pada hotspot, multi-select dan skenario: aksi benar-benar mengubah draft, dan aksi tap/enabled dihapus saat jawaban terkunci. Pengujian golden tanpa update sesudah perbaikan lulus, membuktikan capture renderer tetap sesuai. Ini menguji aksi semantik Flutter, bukan sesi TalkBack fisik.

## Renderer Flutter

Dua putaran inspeksi terbatas. Putaran pertama menemukan CTA Welcome di bawah fold; perbaikan memindahkannya ke footer. Putaran konfirmasi menunjukkan CTA terlihat. Capture di `screenshots/quest/`: welcome, missions, sequence, hotspot, matching, categorize, multiSelect, codeBuilder, scenario, code-landscape-dark, feedback, result. Font Nunito, MaterialIcons, dan kedua gambar dimuat sebelum capture. Ukuran phone 390×844; landscape 844×390. Capture per tipe memakai subset satu puzzle untuk menampilkan interaksi, bukan bukti sesi native.

## Build

Web release berhasil; compiler mencatat peringatan keluarga CupertinoIcons yang tidak dibundel, tetapi aplikasi menggunakan ikon Material. WASM hanya dry-run, bukan target runtime yang sudah diuji. Verifikasi web terbatas pada build dan renderer Flutter, belum sesi browser penuh.

APK debug v2 berhasil dibangun (Gradle 63,3 detik), kemudian dipasang melalui adb install -r dan dibuka pada Pixel_8_2 API 35. Package id.ac.quizora.quizora, versionName 2.0.0, versionCode 2. APK 142.141.202 byte, SHA256 `4FFAD4E0EBF0847C0E37B48E6B083E640B0A8FC5CC37BDC108118C263CB2813D`.

## Android native

Capture memakai adb screencap, bukan renderer test. Phone: 1080×2400, density 420; landscape 2400×1080. Tablet: override pada emulator yang sama, 1600×2560 density 320; bukan perangkat fisik/tablet terpisah. Metadata ukuran, density, SDK, font scale dan rotation disimpan sebagai JSON per PNG di `screenshots/quest/android/`.

Skenario maraton memakai profil Adit/Detektif dalam mode Santai. Seluruh 12 puzzle dioperasikan melalui kontrol UI: delapan pertama benar; puzzle kode benar dengan petunjuk; dua berikutnya benar; terakhir sengaja salah. Hasil aktual 11/12, 92%, 1.220 poin, combo terbaik 8, petunjuk 1, sesuai perhitungan. Pembahasan dibuka; latihan hanya berisi satu puzzle gagal dan menghasilkan 1/1, 100%, 100 poin. Main Lagi mengosongkan nama serta sesi.

Kode parsial 2/4 tetap tersimpan setelah back ke Welcome, lanjut sesi, rotasi ke landscape dan pergantian tema. Font scale 1.3 menunjukkan teks membungkus dan konten bergulir. Tombol suara beralih ke keadaan mati. Seluruh 19 capture native dibuka untuk memastikan file menunjukkan state sesuai nama. Beberapa frame memiliki garis hijau tipis pada tepi emulator, sebagaimana capture v1; bukan token UI yang ditentukan aplikasi.

Timer diuji secara deterministik pada unit tests; skenario native memakai Santai dan tidak menjadi bukti timeout Android. Pengaturan size/density, rotation, font scale dan handwriting emulator dikembalikan sesudah pengujian. Emulator dibiarkan terbuka dengan aplikasi siap dimainkan.

Otomasi native: `tool/android_quest_smoke.ps1` dalam dua tahap Tablet/Phone, dimulai dari MissionScreen dengan profil valid. Script mengoperasikan kontrol aktual melalui hierarki UI, mengecek feedback, lalu merekam capture. Koneksi adb sempat terputus pada capture hotspot; dipulihkan dan capture/metadata diganti sebelum review. Helper capture menolak metadata tidak lengkap. UI keyboard Gboard awal memakai handwriting; pengaturan emulator sementara dimatikan untuk capture keyboard standar, lalu dikembalikan setelah pemeriksaan.

## Batas bukti

Belum menguji perangkat Android fisik, TalkBack, distribusi signing release, process death recovery, sesi web browser penuh, atau multiplayer. State saat process death memang tidak dipertahankan oleh versi ini.
