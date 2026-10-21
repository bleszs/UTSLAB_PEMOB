# Arsitektur Quizora Quest v2

## Struktur

```text
lib/
  main.dart                         # Root, theme, observer lifecycle
  controllers/quiz_controller.dart  # Draft, attempts, scoring, timer
  models/question.dart              # Mission, PuzzleItem, Question, PuzzleAttempt
  data/questions.dart               # 3 misi dan 12 puzzle fiksi
  screens/
    welcome_screen.dart             # Form, nama, avatar, mode
    mission_screen.dart             # Misi dan maraton
    quiz_screen.dart                # Editor, PuzzleFeedback, navigasi
    result_screen.dart              # Akurasi, poin, latihan, reset
    review_screen.dart              # Pembahasan attempts
  widgets/
    puzzle_interactor.dart          # 7 renderer dengan alternatif drag/tap
    custom_primary_button.dart
    app_header.dart
    quiz_artwork.dart
    responsive_page.dart
  utils/app_theme.dart
test/                               # Evaluator/controller dan UI
tool/                               # Lingkungan D, build, capture
docs/                               # Spesifikasi dan bukti
```

## Tanggung jawab dan state

Model menentukan bentuk jawaban serta evaluasinya. Data menyusun cerita, petunjuk, dan kunci. Controller memegang profil, bank immutable, subset misi, draft per ID, attempt immutable, hint, combo, dan deadline. Layar menyampaikan tindakan ke controller; widget menggambar interaksi sesuai tipe.

QuizController dibuat sekali di State root. Route menerima referensi yang sama, sehingga rebuild akibat rotasi atau tema tidak mereset sesi. Welcome menggunakan TextEditingController/Form; listener membersihkan nama/validasi saat reset. QuizScreen mengatur pause navigasi; root WidgetsBindingObserver mengatur pause lifecycle. Timer, observer, controller, dan listener dibuang melalui dispose.

## Navigasi

Welcome push MissionScreen; pilihan misi pushReplacement QuizScreen. Quiz selesai pushReplacement ResultScreen; pembahasan push ReviewScreen. Latihan mengganti hasil dengan QuizScreen setelah subset gagal diinisialisasi sebagai sesi baru. Back kuis menuju root sambil menyimpan draft/attempt. Main Lagi reset dan popUntil root.

Jawaban yang sudah dikirim terkunci. Pengguna dapat keluar/resume, tetapi tidak mengganti jawaban setelah feedback membocorkan kunci. Memulai profil baru membersihkan sesi lama.

## Jawaban dan penilaian

Draft memakai ID stabil, tidak memakai indeks pilihan. Untuk matching/kategori, posisi daftar merepresentasikan item yang dipasangkan; nilainya target ID. Sequence dan code mempertimbangkan urutan, multi-select membandingkan set. isComplete memisahkan kelengkapan dari benar/salah. submit menyimpan snapshot immutable agar update/submit berulang tidak mengubah skor.

Akurasi dihitung dari attempt benar. Poin dihitung dari seluruh attempt; bonus combo dan waktu tercatat terpisah. Hint menurunkan base benar menjadi 70 dan memutus combo. Latihan memilih daftar incorrect dari sesi selesai sebelum mereset attempts.

## Clock

Mode Tantangan memakai deadline dan sisa Duration. Timer 250 ms hanya memberi notifikasi saat detik tampil berubah. Navigasi/lifecycle pause mengubah deadline menjadi sisa waktu; resume membentuk deadline baru. Submit selalu memeriksa waktu, sehingga timeout tidak dapat dilangkahi oleh draft benar. Feedback tidak menghabiskan waktu puzzle berikutnya.

## Responsivitas dan akses

ResponsivePage: SafeArea, konten scroll, maxWidth 1040, padding 24 di layar <600 dan 40 selebihnya. Welcome/Quiz dua kolom pada lebar konten ≥720. Footer Welcome/Quiz tetap terlihat. Token/chip memakai Wrap; teks tidak dikunci satu baris. Reorder memiliki tombol naik/turun, matching/kategori pilihan chip, dan kode bisa diisi dengan tap. Tema dari ColorScheme serta Nunito lokal.

## Mengembangkan bank

Tambahkan Question pada lib/data/questions.dart, isi missionId, tipe, items/targets dan answerKey yang lengkap. Seluruh ID unik dalam lingkupnya. Tambahkan kasus evaluator dan skenario UI bila aturan tipe berubah. Untuk jenis baru, perluas QuestionType, isComplete/evaluate/describe, serta PuzzleInteractor. Penyimpanan permanen dan backend belum menjadi lapisan sistem ini.
