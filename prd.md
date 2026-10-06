# Product Requirements Document — Quizora

Versi 1.0 · 6 Oktober 2026 · Bahasa Indonesia

## 1. Tujuan

Membangun aplikasi kuis Flutter untuk tugas UTS laboratorium pemrograman mobile. Aplikasi membawa pengguna dari pengisian nama hingga skor personal melalui antarmuka modern, responsif, dan mudah dipahami.

## 2. Sumber kebutuhan

- Brief pengguna di percakapan merupakan sumber kebutuhan utama.
- ZIP referensi memuat satu gambar mockup halaman hasil; gambar dipakai sebagai acuan warna, piala, dan hierarki skor.
- Teks atau simbol di dalam gambar tidak dianggap sebagai instruksi tambahan. Nama pada mockup bukan identitas yang diwajibkan di aplikasi.
- Nama produk **Quizora**, bank 10 soal pengetahuan umum, serta halaman pembahasan adalah pilihan implementasi. Topik dapat diganti melalui `lib/data/questions.dart`.

## 3. Pengguna dan masalah

Pengguna ingin mengerjakan kuis singkat tanpa akun dan memahami hasilnya. Penguji tugas perlu melihat navigasi, input, state management, aset, custom font, reusable widgets, dan responsivitas yang benar-benar bekerja.

## 4. Ruang lingkup versi 1

| Prioritas | Fitur | Perilaku |
|---|---|---|
| Wajib | Welcome | Ilustrasi edukasi 3D, nama, tombol Mulai Kuis |
| Wajib | Validasi nama | Nama setelah trim berisi 1–30 karakter |
| Wajib | Kuis | Empat opsi per soal, satu pilihan aktif |
| Wajib | Progress | Posisi soal dan jumlah jawaban terisi |
| Wajib | Navigasi | Lanjut setelah memilih, kembali untuk revisi |
| Wajib | State | Pilihan tidak hilang saat rotasi |
| Wajib | Hasil | Piala 3D, nama dinamis, skor dan ringkasan |
| Wajib | Main lagi | Kembali ke Welcome dan bersihkan sesi |
| Wajib | Desain | Ungu/kuning, Nunito lokal, komponen reusable |
| Tambahan | Tema | Ikuti tema sistem; pengguna dapat beralih terang/gelap |
| Tambahan | Pembahasan | Jawaban pengguna, kunci, dan penjelasan |
| Tambahan | Lanjut sesi | Jika kembali ke Welcome, sesi aktif bisa dilanjutkan |

## 5. Alur pengguna

1. Buka aplikasi dan isi nama.
2. Tekan Mulai Kuis; input kosong menampilkan pesan yang dapat diperbaiki.
3. Pilih satu dari empat opsi; jawaban tidak langsung dibocorkan.
4. Tekan Selanjutnya. Tombol kembali membuka soal sebelumnya beserta pilihan tersimpan.
5. Pada soal terakhir, tekan Lihat Hasil.
6. Baca skor dan pilih pembahasan atau Main Lagi.

## 6. Aturan skor

Setiap soal bernilai sama. `skor = round(jumlah benar / jumlah soal × 100)`. Ringkasan menampilkan jumlah soal, benar, dan salah. Tidak ada penalti waktu, timer, atau pengacakan. Untuk 10 soal, delapan jawaban benar menghasilkan skor 80.

## 7. Prinsip pengalaman

- Satu tindakan utama pada tiap tahapan.
- Opsi aktif ditandai dengan isi warna dan ikon centang.
- Pesan kesalahan memberi langkah perbaikan dalam bahasa Indonesia.
- Layout satu kolom pada layar sempit; dua kolom pada ruang kerja lebar.
- Area konten dapat digulir dan menggunakan SafeArea.
- Skor aktual menjadi pusat halaman hasil; tidak ada data peringkat rekaan.

## 8. Kriteria penerimaan

- Keempat layar dapat diakses melalui alur yang berfungsi.
- Input nama kosong atau spasi ditolak.
- Selanjutnya nonaktif sampai ada pilihan.
- Jawaban tersimpan setelah rotasi, pergantian tema, dan navigasi kembali.
- Seluruh soal harus dijawab untuk mencapai hasil.
- Main Lagi menghapus nama, pilihan, progress, dan status selesai.
- Skor 0, 80, dan 100 dihitung dengan benar.
- Tidak ada overflow pada ukuran yang dicatat di `docs/testing.md`.
- `flutter analyze` dan pengujian otomatis lulus.
- Dokumentasi dan histori Git tersedia secara lokal.

## 9. Batas produk

Data sesi disimpan di memori selama aplikasi berjalan. Menutup paksa aplikasi atau memuat ulang web memulai sesi baru. Tidak ada login, backend, leaderboard, penyimpanan permanen, analytics, atau sinkronisasi. Web adalah pratinjau tambahan; Android adalah target utama. iOS belum dibuat.

## 10. Risiko dan tindak lanjut

Bank soal harus ditinjau ketika topik diganti. Pengujian pada Android fisik diperlukan sebelum distribusi resmi. Nilai tugas ditentukan dosen; desain lengkap tidak merupakan jaminan nilai tertentu. Publikasi GitHub membutuhkan remote yang ditentukan pemilik proyek.
