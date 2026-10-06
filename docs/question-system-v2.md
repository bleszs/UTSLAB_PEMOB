# Sistem pertanyaan v2 — puzzle berbasis misi

Status: spesifikasi dan bank contoh untuk konsep Quizora Quest, belum menjadi fitur APK. Seluruh situasi adalah fiksi. Tema sementara: logika kehidupan kampus.

## Struktur data dan interaksi

| Tipe | Payload | Jawaban draft | Penilaian |
|---|---|---|---|
| `sequence` | Kartu ber-ID dan aturan urutan | Daftar ID terurut | Sama dengan urutan kunci |
| `hotspot` | Bagian visual ber-ID dan label | ID bagian | Sama dengan ID kunci |
| `matching` | Item kiri/kanan ber-ID | Peta kiri ke kanan | Semua pasangan sama dengan kunci |
| `categorize` | Item dan kelompok ber-ID | Peta item ke kelompok | Semua item masuk kelompok yang benar |
| `multiSelect` | Item ber-ID dan kendala | Himpunan ID | Himpunan sama dengan kunci, urutan diabaikan |
| `codeBuilder` | Token tersedia dan slot | Token per slot | Urutan token sama dengan kunci |
| `scenario` | Situasi, tindakan dan konsekuensi | ID tindakan | Tindakan memenuhi tujuan/kendala |

Setiap soal memiliki `id`, `missionId`, `type`, `title`, `context`, `instruction`, `difficulty`, `payload`, `answerKey`, `hint` dan `explanation`. Evaluator menerima jawaban berdasarkan ID stabil, bukan indeks tampilan. Opsi boleh diacak sekali pada awal sesi; susunan acak ikut disimpan pada controller. Teks bebas tidak digunakan untuk jawaban yang memerlukan penilaian subjektif.

## Misi 1 — Selamatkan Presentasi

### Q01 — Alur file yang tertukar (`sequence`)

**Situasi:** Empat kartu: Unduh file, Ekstrak ZIP, Buka presentasi, Periksa font. ZIP harus diunduh sebelum diekstrak, presentasi berada di dalam ZIP, dan font diperiksa setelah presentasi dibuka.

**Instruksi:** Susun empat kartu menjadi alur yang bisa dijalankan.

**Kunci:** Unduh file → Ekstrak ZIP → Buka presentasi → Periksa font.

**Petunjuk:** File presentasi belum tersedia sebelum ZIP diekstrak.

**Penjelasan:** Setiap langkah menggunakan hasil langkah sebelumnya. Kontrol memakai kartu yang dapat dipindahkan atau tombol naik/turun.

### Q02 — Satu angka yang salah (`hotspot`)

**Situasi:** Panel rincian biaya: Cetak Rp50.000, Map Rp25.000, Transport Rp15.000, Total Rp95.000. Tiga biaya item sudah dikonfirmasi benar.

**Instruksi:** Ketuk bagian yang perlu diperbaiki.

**Kunci:** Bagian Total Rp95.000.

**Petunjuk:** Jumlahkan hanya tiga biaya item.

**Penjelasan:** Total seharusnya Rp90.000. Diagram dibangun dari komponen Flutter; setiap bagian mempunyai label yang sama pada alternatif daftar aksesibel.

### Q03 — Sambungkan orang dan barang (`matching`)

**Situasi:** Ari, Bela dan Cika membawa satu dari laptop, adaptor dan flashdisk. Bela membawa adaptor. Ari tidak membawa laptop. Tidak ada barang yang dibawa dua orang.

**Instruksi:** Sambungkan setiap orang dengan barangnya.

**Kunci:** Bela–adaptor; Ari–flashdisk; Cika–laptop.

**Petunjuk:** Singkirkan adaptor dari pilihan Ari terlebih dahulu.

**Penjelasan:** Sesudah Bela mendapat adaptor, Ari hanya bisa mendapat flashdisk dan Cika mendapat barang yang tersisa.

### Q04 — Rencana dua menit (`scenario`)

**Situasi:** Laptop tersisa baterai 5%. Presentasi mulai dua menit lagi. Charger kompatibel tersedia di meja dan dapat dipasang dalam 15 detik; file sudah berada di laptop. Pilihan tindakan: Pasang charger, Unduh ulang file selama tiga menit, Pergi meminjam laptop selama lima menit, Menunggu tanpa melakukan apa pun. Tujuan: mendapatkan pasokan daya sebelum presentasi dimulai.

**Instruksi:** Pilih tindakan yang memenuhi tujuan dan batas waktu.

**Kunci:** Pasang charger.

**Petunjuk:** Bandingkan durasi tindakan dengan dua menit yang tersedia.

**Penjelasan:** Hanya memasang charger yang menyediakan daya dalam batas waktu. Penilaian mengikuti informasi fiksi yang diberikan, bukan menebak durasi di dunia nyata.

## Misi 2 — Detektif Jadwal

### Q05 — Temukan pasangan bentrok (`multiSelect`)

**Situasi:** Kalender mempunyai empat kegiatan di hari yang sama: A 09.00–10.00, B 09.30–10.30, C 10.30–11.00, D 11.00–12.00. Berakhir dan mulai pada menit yang sama tidak dianggap bentrok.

**Instruksi:** Tandai dua kegiatan yang waktunya tumpang tindih.

**Kunci:** A dan B.

**Petunjuk:** Periksa pukul 09.45.

**Penjelasan:** Pada 09.45, A dan B sama-sama berlangsung. B/C dan C/D hanya berbagi batas waktu.

### Q06 — Bukti atau dugaan? (`categorize`)

**Situasi:** Beri dua kelompok: Terverifikasi dan Belum terverifikasi. Empat catatan: “Email konfirmasi ruangan diterima”, “Dosen mungkin datang terlambat”, “Daftar hadir berisi 12 nama”, “Sepertinya proyektor akan rusak”. Aturan: catatan yang menyebut dokumen atau data tercatat masuk Terverifikasi; perkiraan masuk Belum terverifikasi.

**Instruksi:** Pindahkan tiap catatan ke kelompoknya.

**Kunci:** Email dan daftar hadir → Terverifikasi; dugaan dosen dan proyektor → Belum terverifikasi.

**Petunjuk:** Kata “mungkin” dan “sepertinya” menunjukkan perkiraan.

**Penjelasan:** Aturan pengelompokan diberikan secara eksplisit; pemain membedakan jenis bukti dalam cerita.

### Q07 — Antrean ruang rapat (`sequence`)

**Situasi:** Empat kartu bernama Review 13.15, Briefing 12.30, Evaluasi 14.00, Simulasi 13.00.

**Instruksi:** Susun kegiatan dari yang mulai paling awal.

**Kunci:** Briefing → Simulasi → Review → Evaluasi.

**Petunjuk:** 12.30 lebih awal daripada semua kegiatan pada pukul 13.

**Penjelasan:** Pengguna memindahkan kegiatan pada timeline, bukan memilih empat opsi urutan tertulis.

### Q08 — Kartu yang melanggar aturan (`hotspot`)

**Situasi:** Aturan ruangan: Lab A hanya boleh dipesan mulai pukul 10.00. Tampilkan kartu: A Lab A 10.00, B Lab B 09.00, C Lab A 09.30, D Lab A 11.00. Lab B tidak mempunyai batas mulai pada cerita ini.

**Instruksi:** Ketuk reservasi yang harus dipindahkan waktunya.

**Kunci:** Kartu C, Lab A 09.30.

**Petunjuk:** Aturan berlaku untuk Lab A saja.

**Penjelasan:** 09.30 berada sebelum batas 10.00; Lab B 09.00 tidak melanggar aturan yang diberikan.

## Misi 3 — Kunci Ruang Lab

### Q09 — Rakit kode tiga digit (`codeBuilder`)

**Situasi:** Token tersedia 1, 2, 3 dan 4; setiap token hanya boleh digunakan sekali. Kode mempunyai tiga digit. Digit pertama genap dan bukan 4. Digit kedua adalah token terbesar. Digit terakhir satu lebih besar daripada digit pertama.

**Instruksi:** Letakkan token pada tiga slot kunci.

**Kunci:** 2–4–3.

**Petunjuk:** Digit pertama hanya bisa 2.

**Penjelasan:** Aturan pertama menentukan 2, aturan kedua menentukan 4, dan aturan terakhir menentukan 3. Urutan 243 adalah satu-satunya solusi.

### Q10 — Dua dokumen yang muat (`multiSelect`)

**Situasi:** A berisi 2 halaman/6 MB; B 4 halaman/10 MB; C 1 halaman/2 MB. Pengiriman wajib tepat 5 halaman, ukuran total paling besar 12 MB, dan tepat dua dokumen.

**Instruksi:** Pilih dua dokumen untuk dikirim.

**Kunci:** B dan C.

**Petunjuk:** Periksa jumlah halaman sebelum ukuran file.

**Penjelasan:** B+C menghasilkan tepat 5 halaman dan 12 MB. A+B menghasilkan 6 halaman/16 MB; A+C hanya 3 halaman/8 MB.

### Q11 — Cocokkan terminal (`matching`)

**Situasi:** Ada terminal Merah, Biru dan Hijau, serta kode 243, 312 dan 421. Biru memakai 312. Merah memakai kode yang diawali angka 4. Setiap kode dipakai sekali.

**Instruksi:** Pasangkan terminal dengan kode akses yang sesuai.

**Kunci:** Biru–312; Merah–421; Hijau–243.

**Petunjuk:** Terminal Merah tidak memakai 243.

**Penjelasan:** Dua petunjuk menentukan pasangan pertama dan kedua; pasangan Hijau berasal dari kode yang tersisa.

### Q12 — Tantangan penutup (`scenario`)

**Situasi:** Terminal Hijau memiliki kode 243 dan sedang terkunci; informasi ini ditampilkan kembali pada layar. Aturan: tiga angka harus dimasukkan sebelum Konfirmasi ditekan. Panel menawarkan empat rangkaian tindakan: masukkan 243 lalu Konfirmasi; Konfirmasi lalu 243; masukkan 243 lalu Hapus; masukkan 312 lalu Konfirmasi.

**Instruksi:** Pilih rangkaian yang membuka terminal sesuai aturan.

**Kunci:** Masukkan 243 lalu Konfirmasi.

**Petunjuk:** Kode harus cocok dan urutan tindakan juga harus benar.

**Penjelasan:** Tantangan menggabungkan dua syarat. Kode ditampilkan kembali agar pemain yang salah pada Q11 tetap mempunyai informasi yang cukup.

## Kontrak sesi dan evaluasi

- Draft boleh diubah sebelum Kirim Jawaban; setelah submit, jawabannya dikunci dan evaluator hanya berjalan sekali.
- Sequence lengkap berisi setiap ID kartu tepat sekali; matching menggunakan semua pasangan; categorize menempatkan semua item; codeBuilder mengisi semua slot sesuai aturan pemakaian token.
- Multi-select memerlukan jumlah pilihan sesuai instruksi; keputusan salah tidak diketahui sebelum submit.
- Hotspot memakai ID bagian visual dan koordinat yang mengikuti ukuran komponen, bukan koordinat piksel layar yang tetap.
- Nilai dasar setiap soal sama. Untuk contoh ini, pasangan/urutan yang baru sebagian benar tidak mendapat nilai penuh; feedback menandai bagian yang sudah benar untuk belajar.
- Hint yang terpakai disimpan per soal. Poin, combo dan status submit tidak boleh direset oleh rotasi, tema atau rebuild widget.
- Latihan ulang adalah sesi baru dengan ID baru dan ringkasan sendiri; tidak menambah skor sesi pertama.
- Soal berbasis waktu menyimpan tenggat serta sisa waktu pada controller, bukan mengurangi angka dari build method. Waktu saat aplikasi tidak aktif dijeda sesuai mode yang dipilih.

## Validasi isi sebelum implementasi

Semua contoh di atas memiliki kunci eksplisit. Q03/Q09/Q11 menggunakan aturan eksklusif sehingga tidak memiliki dua solusi. Q05 menyebut aturan batas interval untuk menghindari tafsir berbeda. Q10 menyebut target halaman, ukuran dan jumlah dokumen. Q12 menampilkan kembali bukti agar tidak bergantung pada keberhasilan soal sebelumnya.

Tiap evaluator perlu diuji untuk solusi benar, salah, jawaban tidak lengkap, ID invalid/duplikat dan submit berulang. Widget per tipe perlu diuji pada portrait, landscape, skala teks besar dan metode input alternatif selain drag.
