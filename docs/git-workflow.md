# Git dan penyerahan

Repository Git lokal dibuat dengan commit bertahap: setup, komponen/state, alur v1, dokumentasi, perbaikan reset/config D, bukti native v1, lalu konsep Quest dan implementasi v2. Commit `201f435` menyimpan konsep yang kemudian disetujui; `575c0a9` menerapkan tiga misi, tujuh interaksi, timer, poin dan latihan. Dokumentasi/evidence v2 dicatat setelah pengujian. Tidak ada remote GitHub yang diberikan sehingga proyek belum dipush.

Lihat riwayat dan kondisi kerja:

Perbaikan aksesibilitas v2 disimpan terpisah dalam `c7654ff`, bersama tes aksi semantik dan jawaban terkunci.

```powershell
git log --oneline
git status --short
```

Setelah membuat repository GitHub sendiri, gunakan URL milik Anda:

```powershell
git remote add origin https://github.com/USERNAME/REPOSITORY.git
git push -u origin main
```

Jangan membuat ulang commit sekaligus untuk menyamarkan kronologi. Commit yang dibuat agen menggunakan identitas lokal `Codex <codex@local>` melalui opsi per perintah; konfigurasi Git global tidak diubah. Gunakan identitas sendiri untuk perubahan berikutnya.

Build output, cache, konfigurasi SDK lokal, dan log emulator tidak masuk Git. Sertakan APK secara terpisah bila diminta dosen. Screenshot dan dokumentasi dapat menjadi bukti dalam laporan UTS; pemeriksaan rubric resmi tetap perlu dilakukan jika kemudian diberikan.
