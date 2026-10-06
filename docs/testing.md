# Pengujian dan bukti verifikasi

Tanggal: 6 Oktober 2026. Toolchain: Flutter 3.35.7, Dart 3.9.2, Windows.

## Hasil otomatis

| Pemeriksaan | Hasil | Cakupan |
|---|---|---|
| Unit test | Lulus, 5 skenario | Validasi nama/soal, blok lanjut, revisi, skor, reset |
| Widget test | Lulus, 3 skenario | Alur lengkap, tema/rotasi/back, teks besar |
| Capture renderer | Lulus setelah font dan image decode disiapkan | Welcome, quiz, result, review; terang/gelap |
| Build web release | Berhasil setelah font final | Kompilasi web; belum klaim browser E2E |
| Analyze akhir | Lulus, No issues found | Semua file Dart dan tool capture |
| Build APK debug | Menunggu percobaan cache terpisah | Percobaan awal gagal karena metadata cache Gradle global |

Tidak ada klaim pengujian perangkat fisik. Android API 35 emulator berhasil terhubung; pengujian aplikasi di emulator menunggu APK selesai.

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

## Checklist manual Android

- Instal APK, masukkan nama dan kerjakan kuis.
- Pilih jawaban lalu putar perangkat; cek soal dan pilihan tetap sama.
- Coba keyboard pada Welcome, nama panjang, kembali sistem, dan lanjut sesi.
- Buka hasil serta pembahasan; pastikan Main Lagi menghapus seluruh state.
- Uji tema terang/gelap dan font scale 1.3 atau lebih.
- Uji SafeArea, status/navigation bars dan gesture Back pada perangkat asli.
- Matikan/muat ulang aplikasi: sesi baru adalah perilaku yang didokumentasikan.

## Masalah lingkungan awal

Gradle global versi 8.12 gagal membaca beberapa `transforms/*/metadata.bin`. Percobaan perbaikan menggunakan `.gradle-local` sebagai `GRADLE_USER_HOME`, dengan cache dependensi global hanya dibaca. Cache global tidak dihapus. Folder cache lokal masuk `.gitignore`.
Percobaan berikutnya terhenti karena batas sumber daya dan daemon Gradle menghilang. Heap Gradle kemudian dibatasi 1536 MB, metaspace 512 MB, worker dua, dan Kotlin daemon 512 MB. Build terisolasi dapat diulang dengan `powershell -NoProfile -ExecutionPolicy Bypass -File tool/build_android.ps1 -IsolatedCache`. Script menghasilkan `build/android-build-result.json` beserta exit code.

AVD Pixel_7_Claude menunjuk system image yang tidak ada. AVD Pixel_8_2 memakai image Android API 35 yang tersedia. AVD milik pengguna tidak dimodifikasi.
