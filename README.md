# Quizora Quest

Aplikasi kuis Flutter berbahasa Indonesia untuk UTS Laboratorium Pemrograman Mobile. Inti sesuai tema: pengguna memasukkan nama, menjawab serangkaian soal **pilihan ganda**, lalu melihat skor akhir. Versi 2 memperkaya kuis menjadi permainan penyelidikan kampus: 4 misi, 16 puzzle, dan 8 bentuk interaksi (termasuk satu misi khusus **Kuis Pilihan Ganda** klasik A/B/C/D). Ungu/kuning, Nunito lokal, ilustrasi edukasi/piala 3D, dan tema terang/gelap tetap mengikuti brief pengguna.

## Fitur

- Profil lokal: nama, avatar Penjelajah/Detektif/Perakit, mode Santai atau Tantangan.
- Misi Selamatkan Presentasi, Detektif Jadwal, Kunci Ruang Lab, dan Kuis Pilihan Ganda; masing-masing 4 puzzle. Maraton menggabungkan seluruh 16 puzzle.
- Pilihan ganda klasik (pilih satu jawaban A/B/C/D), susun urutan, pilih bukti pada dokumen, pasangkan informasi, kelompokkan catatan, pilih beberapa jawaban, rakit kode, dan putuskan langkah skenario.
- Drag-and-drop tersedia pada urutan, pasangan, kategori, dan kode; tombol/tap menyediakan alternatif.
- Kirim jawaban sekali, lalu baca feedback dan penjelasan. Jawaban terkirim dikunci.
- Poin, combo, petunjuk, suara klik yang dapat dimatikan, serta timer 90 detik/puzzle dalam mode Tantangan.
- Akurasi terpisah dari poin permainan. Latihan ulang hanya memuat puzzle yang belum tepat.
- Rotasi, tema, dan kembali ke Welcome mempertahankan sesi. Timer dijeda saat meninggalkan kuis/aplikasi.
- Pembahasan, Main Lagi dengan reset bersih, layout responsif, dan konten bergulir.

Semua cerita dan data puzzle adalah fiksi. Petunjuk yang dibutuhkan tersedia di layar; tidak bergantung pada hafalan pengetahuan umum.

## Menjalankan dari drive D

Flutter 3.35.7 / Dart 3.9.2 digunakan pada mesin ini.

```powershell
cd D:\UTSLABPEMMOB
. .\tool\env_d.ps1
flutter pub get
flutter run
```

Pratinjau web: `flutter run -d chrome`. Script mengarahkan cache, TEMP/TMP, JDK, serta data Android ke D dalam sesi PowerShell. Rincian: [docs/drive-d.md](docs/drive-d.md).

## Verifikasi dan build

```powershell
. .\tool\env_d.ps1
flutter analyze
flutter test
flutter build web --release
powershell -NoProfile -ExecutionPolicy Bypass -File tool/build_android.ps1
```

Tutup emulator sebelum build APK pada mesin ini untuk mengurangi kebutuhan RAM. Output APK debug: `build/app/outputs/flutter-apk/app-debug.apk`. Output web: `build/web/`. Hasil aktual versi 2 dicatat di [docs/testing-v2.md](docs/testing-v2.md); [pengujian versi 1](docs/testing.md) disimpan sebagai riwayat.

Capture renderer Flutter, terpisah dari bukti emulator:

```powershell
flutter test tool/capture_test.dart --update-goldens
powershell -NoProfile -ExecutionPolicy Bypass -File tool/android_screenshot.ps1 -Quest -Name welcome-phone
```

## Aturan permainan

Jawaban benar: 100 poin, atau 70 jika memakai petunjuk. Combo tanpa petunjuk memberi bonus +10 pada jawaban benar beruntun ketiga, +20 pada keempat, dan +30 mulai kelima. Salah, waktu habis, atau petunjuk memutus combo. Tantangan memberi bonus waktu 0–20 untuk jawaban benar. Akurasi dihitung dari benar/jumlah puzzle, dibulatkan ke persen; bonus tidak mengubah akurasi. Semua 12 benar dalam mode Santai tanpa petunjuk menghasilkan 100% dan 1.470 poin.

## Dokumentasi

| Dokumen | Isi |
|---|---|
| [prd.md](prd.md) | Tujuan, ruang lingkup, alur, kriteria penerimaan v2 |
| [srs.md](srs.md) | Requirement dan ketertelusuran implementasi |
| [todo.md](todo.md) | Checklist implementasi dan penyerahan |
| [PRODUCT.md](PRODUCT.md) | Konteks dan keputusan produk |
| [DESIGN.md](DESIGN.md) | Token dan komponen desain |
| [docs/quizora-quest-concept.md](docs/quizora-quest-concept.md) | Konsep Quest yang disetujui pengguna |
| [docs/question-system-v2.md](docs/question-system-v2.md) | Bentuk jawaban dan seluruh 12 puzzle |
| [docs/architecture.md](docs/architecture.md) | Model, controller, lifecycle, navigasi |
| [docs/testing-v2.md](docs/testing-v2.md) | Bukti verifikasi versi 2 |
| [docs/assets.md](docs/assets.md) | Sumber, lisensi font, dan prompt ilustrasi |
| [docs/git-workflow.md](docs/git-workflow.md) | Histori lokal dan petunjuk GitHub |

## Mengubah puzzle

Edit `lib/data/questions.dart`. Setiap puzzle memiliki ID unik, tipe, missionId, konteks, instruksi, items/targets dengan ID stabil, answerKey, hint, dan explanation. Kunci menyimpan ID, bukan posisi visual. Validasi model dan controller menolak kunci tidak lengkap/ID tidak sah. Jalankan tes setelah mengubah aturan atau bank.

## Batasan

Android merupakan target utama; web merupakan pratinjau tambahan. Sesi tersimpan di memori, sehingga process death atau reload web memulai sesi baru. Tidak ada akun, backend, multiplayer/room online, leaderboard, histori permanen, atau integrasi Quizizz/Wayground. Bunyi menggunakan klik sistem, bukan soundtrack. Repository Git tersedia lokal; remote GitHub belum diberikan. APK debug untuk pengujian; signing distribusi resmi belum disiapkan.
