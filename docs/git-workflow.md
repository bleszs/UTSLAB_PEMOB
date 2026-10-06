# Git dan penyerahan

Repository Git lokal sudah dibuat dan perkembangan dikelompokkan dalam commit bermakna: setup, komponen/state, alur aplikasi, kemudian dokumentasi dan verifikasi. Tidak ada remote GitHub yang diberikan sehingga proyek belum dipush.

Lihat riwayat dan kondisi kerja:

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
