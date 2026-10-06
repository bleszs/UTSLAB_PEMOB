# Quizora

Aplikasi kuis Flutter berbahasa Indonesia untuk UTS Laboratorium Pemrograman Mobile. Desain ungu dan kuning, font Nunito lokal, ilustrasi edukasi dan piala 3D, serta dukungan terang/gelap.

## Fitur

- Welcome dengan validasi nama.
- 10 soal pengetahuan umum, empat pilihan per soal.
- Progress, revisi jawaban, dan lanjut sesi aktif.
- State tetap tersimpan saat rotasi dan pergantian tema.
- Hasil personal dengan skor, jumlah benar/salah, dan Main Lagi.
- Pembahasan semua jawaban setelah kuis.
- Layout responsif untuk portrait, landscape, dan pratinjau web.

## Menjalankan

Prasyarat: Flutter SDK, Android SDK untuk Android, atau Chrome untuk web. Proyek dibuat memakai Flutter 3.35.7 / Dart 3.9.2.

```powershell
cd D:\UTSLABPEMMOB
flutter pub get
flutter run
```

Pratinjau web:

```powershell
flutter run -d chrome
```

## Pengujian dan build

```powershell
flutter analyze
flutter test
flutter build web --release
flutter build apk --debug
```

Output web: `build/web/`. Output APK debug jika build berhasil: `build/app/outputs/flutter-apk/app-debug.apk`. APK debug untuk pengujian; distribusi resmi memerlukan signing release milik pemilik proyek.

Jika cache Gradle global bermasalah, build dengan cache proyek terpisah:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tool/build_android.ps1 -IsolatedCache
```

Capture dengan renderer pengujian Flutter:

```powershell
flutter test tool/capture_test.dart --update-goldens
```

Capture tersebut bukan pengganti pemeriksaan perangkat Android. Bukti dan batas validasi dicatat dalam [docs/testing.md](docs/testing.md).

## Dokumentasi

| Dokumen | Isi |
|---|---|
| [prd.md](prd.md) | Tujuan, fitur, alur, kriteria penerimaan |
| [srs.md](srs.md) | Requirement fungsional/nonfungsional dan traceability |
| [todo.md](todo.md) | Checklist pekerjaan dan pengembangan lanjutan |
| [PRODUCT.md](PRODUCT.md) | Konteks produk dan keputusan/asumsi |
| [DESIGN.md](DESIGN.md) | Token dan panduan desain hasil implementasi |
| [docs/architecture.md](docs/architecture.md) | Struktur folder, state, navigasi, responsivitas |
| [docs/testing.md](docs/testing.md) | Hasil verifikasi dan skenario manual |
| [docs/assets.md](docs/assets.md) | Sumber aset, lisensi font, prompt ilustrasi |
| [docs/git-workflow.md](docs/git-workflow.md) | Histori lokal dan cara push GitHub |

## Mengubah konten

Bank soal berada di `lib/data/questions.dart`. Gunakan id unik, empat opsi, correctIndex 0–3, dan penjelasan. Ubah label topik pada QuizScreen bila bank soal diganti. Jumlah soal dan skor menyesuaikan otomatis.

## Batasan

State sesi berada di memori: rotasi aman, tetapi memuat ulang web atau menutup paksa aplikasi memulai sesi baru. Belum ada backend, akun, leaderboard, penyimpanan histori, atau target iOS. Repository Git tersedia lokal; remote GitHub belum ditentukan.
