# Quizora Quest — brief antarmuka

Mode: Operate. Platform utama Android Material 3. Scope: Welcome, Missions, Quiz/Feedback, Result, Review. Identitas mengikuti brief pengguna; pengembangan misi disetujui melalui “coba kerjakan”.

## Direction contract

THESIS: Pengguna memecahkan petunjuk kampus melalui tujuh bentuk interaksi, lalu memahami hasil dan melatih bagian yang belum tepat.

OWN-WORLD: Ungu cerah, kuning CTA/skor, Nunito membulat, ilustrasi edukasi/piala 3D. Dokumen anggaran/reservasi, token, catatan dan slot merupakan benda kerja interaktif yang terkait cerita.

STORY: Nama/avatar/mode → pilih misi atau maraton → kerjakan/kirim puzzle → feedback → hasil akurasi dan poin → pembahasan/latihan/reset. Cerita fiksi; tidak ada peringkat atau statistik rekaan.

FIRST VIEWPORT: Welcome menunjukkan ilustrasi dan ajakan menyelidiki, form dapat digulir, Pilih Misi tetap di footer. Quiz menunjukkan progress, cerita/petunjuk, area kerja sesuai tipe, dan Kirim di footer. Landscape memisahkan petunjuk dan area kerja. Hasil menunjukkan nama, piala, akurasi serta poin/combo/petunjuk; tindakan latihan, pembahasan dan Main Lagi berada setelah ringkasan.

FORM: Extension kode dari dunia v1, bukan penggantian visual. Brief ungu/kuning terpin mengungguli seed 89807a87. Tidak ada approved comp baru; mockup pengguna menjadi referensi kritik hasil. Spesifikasi Quest: docs/quizora-quest-concept.md dan docs/question-system-v2.md.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance

## Bukti

Renderer Flutter dan emulator Android dipisahkan. Capture v2 berada di docs/screenshots/quest; native di subfolder android. Semua capture harus benar-benar memuat font/aset dan menunjukkan state sesuai nama. Native tidak menjalankan detektor HTML/CSS. Android fisik belum diuji.
