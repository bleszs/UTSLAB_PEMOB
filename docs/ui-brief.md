# Alur kuis — brief antarmuka

Mode: Operate. Platform utama: Android Material 3. Scope: Welcome, Quiz, Result, Review. Sumber estetika: brief pengguna dan mockup hasil dalam ZIP. Tidak ada opsi desain baru yang memerlukan penggantian arah brief.

## Direction contract

THESIS: Pengguna melihat tindakan berikutnya secara jelas, mengerjakan satu soal setiap kali, kemudian mendapat hasil personal yang dapat dipelajari.

OWN-WORLD: Ungu cerah untuk identitas dan pilihan, kuning untuk tombol utama dan skor, Nunito membulat, ilustrasi edukasi/piala 3D, tombol Material dan kartu opsi dengan centang.

STORY: Masukkan nama → pilih/revisi jawaban → lihat skor → baca pembahasan atau main lagi. Tidak ada peringkat atau klaim nilai akademik rekaan.

FIRST VIEWPORT: Welcome portrait menempatkan ilustrasi di atas sapaan dan form, dengan Mulai Kuis tepat sesudah input. Kuis menempatkan progress di atas pertanyaan, empat opsi di bawahnya, dan tombol lanjut pada footer. Landscape memisahkan pertanyaan dan opsi. Hasil menampilkan nama, piala, panel skor ungu/kuning, lalu Main Lagi.

FORM: Brief dan mockup pengguna menentukan arah; seed 89807a87 telah dijalankan, arahan terpin pengguna mengunggulinya. Implementasi langsung dari referensi pengguna, tanpa comp baru atau keputusan workflow permanen yang diasumsikan.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance

## Batas bukti

Screenshot renderer Flutter harus berisi font dan aset yang sudah dimuat. Capture emulator diberi nama tersendiri; keduanya tidak boleh disamakan. Pengujian perangkat fisik belum dilakukan.
