import '../models/question.dart';

const missions = [
  Mission(
    'presentation',
    'Selamatkan Presentasi',
    'Analisis alur, biaya, dan keputusan tim lewat empat soal pilihan ganda.',
  ),
  Mission(
    'schedule',
    'Detektif Jadwal',
    'Pilih jawaban berdasarkan jadwal, aturan ruangan, dan bukti yang tersedia.',
  ),
  Mission(
    'lab',
    'Kunci Ruang Lab',
    'Pecahkan petunjuk kode dan pilih satu solusi yang memenuhi aturan.',
  ),
  Mission(
    'quiz',
    'Kuis Pilihan Ganda',
    'Jawab empat soal pilihan ganda: baca cerita, pilih satu jawaban benar.',
  ),
];
const questions = <Question>[
  Question(
    id: "q01",
    missionId: "presentation",
    type: QuestionType.multipleChoice,
    title: "Alur file yang tertukar",
    context:
        "Presentasi tim berada di dalam ZIP. ZIP harus diunduh sebelum diekstrak. Presentasi dibuka sesudah ekstraksi, lalu font diperiksa.",
    instruction: "Urutan mana yang memenuhi semua petunjuk?",
    items: [
      PuzzleItem("open_first", "Buka → Unduh → Ekstrak → Periksa font"),
      PuzzleItem("flow_correct", "Unduh → Ekstrak → Buka → Periksa font"),
      PuzzleItem("font_first", "Periksa font → Unduh → Ekstrak → Buka"),
      PuzzleItem("extract_first", "Ekstrak → Unduh → Buka → Periksa font"),
    ],
    answerKey: ["flow_correct"],
    hint: "Presentasi belum tersedia sebelum ZIP diekstrak.",
    explanation:
        "Unduh ZIP terlebih dahulu, ekstrak isinya, buka presentasi, lalu periksa font. Setiap langkah membutuhkan hasil langkah sebelumnya.",
  ),
  Question(
    id: "q02",
    missionId: "presentation",
    type: QuestionType.multipleChoice,
    title: "Satu angka yang salah",
    context:
        "Tiga biaya sudah dikonfirmasi: cetak Rp50.000, map Rp25.000, dan transport Rp15.000. Laporan menuliskan total Rp95.000.",
    instruction: "Bagian laporan mana yang harus diperbaiki?",
    items: [
      PuzzleItem("print", "Cetak: Rp50.000"),
      PuzzleItem("folder", "Map: Rp25.000"),
      PuzzleItem("transport", "Transport: Rp15.000"),
      PuzzleItem("total", "Total: Rp95.000"),
    ],
    answerKey: ["total"],
    hint: "Jumlahkan ketiga biaya yang sudah dikonfirmasi.",
    explanation:
        "Rp50.000 + Rp25.000 + Rp15.000 = Rp90.000. Ketiga biaya item benar; angka total Rp95.000 yang perlu diperbaiki.",
  ),
  Question(
    id: "q03",
    missionId: "presentation",
    type: QuestionType.multipleChoice,
    title: "Siapa membawa apa?",
    context:
        "Ari, Bela, dan Cika masing-masing membawa satu barang berbeda: laptop, adaptor, atau flashdisk. Bela membawa adaptor. Ari tidak membawa laptop.",
    instruction: "Pasangan orang dan barang mana yang sesuai?",
    items: [
      PuzzleItem("correct", "Ari–flashdisk; Bela–adaptor; Cika–laptop"),
      PuzzleItem("ari_laptop", "Ari–laptop; Bela–adaptor; Cika–flashdisk"),
      PuzzleItem("bela_laptop", "Ari–adaptor; Bela–laptop; Cika–flashdisk"),
      PuzzleItem("cika_adaptor", "Ari–flashdisk; Bela–laptop; Cika–adaptor"),
    ],
    answerKey: ["correct"],
    hint: "Setelah adaptor milik Bela, tersisa laptop dan flashdisk.",
    explanation:
        "Bela membawa adaptor. Ari bukan pembawa laptop, sehingga Ari membawa flashdisk dan Cika mendapat laptop yang tersisa.",
  ),
  Question(
    id: "q04",
    missionId: "presentation",
    type: QuestionType.multipleChoice,
    title: "Dua menit sebelum tampil",
    context:
        "Presentasi dimulai dua menit lagi. Baterai laptop tinggal 5%, tetapi file sudah tersedia. Charger yang kompatibel ada di meja dan dapat dipasang dalam 15 detik. Mengunduh ulang perlu tiga menit; meminjam laptop perlu lima menit.",
    instruction: "Tindakan mana yang memenuhi tujuan dan batas waktu?",
    items: [
      PuzzleItem("download", "Unduh ulang file selama tiga menit"),
      PuzzleItem("borrow", "Pinjam laptop selama lima menit"),
      PuzzleItem("charger", "Pasang charger yang tersedia"),
      PuzzleItem("wait", "Tunggu hingga baterai habis"),
    ],
    answerKey: ["charger"],
    hint: "Cari tindakan yang menyediakan daya sebelum dua menit berlalu.",
    explanation:
        "Memasang charger hanya perlu 15 detik dan langsung menyediakan daya. Mengunduh ulang tidak diperlukan, meminjam laptop terlambat, dan menunggu tidak menyelesaikan masalah.",
  ),
  Question(
    id: "q05",
    missionId: "schedule",
    type: QuestionType.multipleChoice,
    title: "Pasangan jadwal yang bentrok",
    context:
        "Pada hari yang sama: kegiatan A pukul 09.00–10.00, B 09.30–10.30, C 10.30–11.00, dan D 11.00–12.00. Dua kegiatan tidak dianggap bentrok jika yang satu berakhir tepat saat yang lain dimulai.",
    instruction: "Pasangan kegiatan mana yang benar-benar bertumpang tindih?",
    items: [
      PuzzleItem("bc", "B dan C"),
      PuzzleItem("ab", "A dan B"),
      PuzzleItem("ac", "A dan C"),
      PuzzleItem("cd", "C dan D"),
    ],
    answerKey: ["ab"],
    hint: "Periksa kegiatan yang berlangsung bersamaan pada pukul 09.45.",
    explanation:
        "A dan B berlangsung bersamaan dari 09.30 sampai 10.00. B/C dan C/D hanya bertemu pada batas waktu, sehingga tidak dianggap bentrok.",
  ),
  Question(
    id: "q06",
    missionId: "schedule",
    type: QuestionType.multipleChoice,
    title: "Bukti atau dugaan?",
    context:
        "Tim mencatat empat hal: email konfirmasi ruangan diterima; dosen mungkin terlambat; daftar hadir berisi 12 nama; dan sepertinya proyektor akan rusak. Aturannya: dokumen atau data tercatat adalah bukti; perkiraan belum terverifikasi.",
    instruction: "Pasangan catatan mana yang sama-sama terverifikasi?",
    items: [
      PuzzleItem("assumptions", "Dugaan dosen terlambat dan proyektor rusak"),
      PuzzleItem("mixed_one", "Email konfirmasi dan dugaan proyektor rusak"),
      PuzzleItem("mixed_two", "Daftar hadir dan dugaan dosen terlambat"),
      PuzzleItem("evidence", "Email konfirmasi dan daftar hadir"),
    ],
    answerKey: ["evidence"],
    hint:
        "Cari dua catatan yang merujuk dokumen atau data yang sudah tercatat.",
    explanation:
        "Email konfirmasi dan daftar hadir adalah bukti tercatat. Kata 'mungkin' dan 'sepertinya' menunjukkan perkiraan yang belum diverifikasi.",
  ),
  Question(
    id: "q07",
    missionId: "schedule",
    type: QuestionType.multipleChoice,
    title: "Antrean ruang rapat",
    context:
        "Empat kegiatan akan memakai ruangan: Review mulai 13.15, Briefing 12.30, Evaluasi 14.00, dan Simulasi 13.00.",
    instruction: "Urutan kegiatan dari waktu mulai paling awal adalah…",
    items: [
      PuzzleItem("review_first", "Review → Briefing → Simulasi → Evaluasi"),
      PuzzleItem("simulation_first", "Simulasi → Briefing → Review → Evaluasi"),
      PuzzleItem("timeline", "Briefing → Simulasi → Review → Evaluasi"),
      PuzzleItem("evaluation_first", "Evaluasi → Review → Simulasi → Briefing"),
    ],
    answerKey: ["timeline"],
    hint:
        "Mulai dengan kegiatan pukul 12.30, lalu bandingkan dua kegiatan pukul 13.",
    explanation:
        "Urutan waktu mulai adalah 12.30, 13.00, 13.15, lalu 14.00: Briefing, Simulasi, Review, dan Evaluasi.",
  ),
  Question(
    id: "q08",
    missionId: "schedule",
    type: QuestionType.multipleChoice,
    title: "Reservasi yang melanggar aturan",
    context:
        "Lab A hanya boleh dipesan mulai pukul 10.00. Lab B tidak memiliki batas waktu pada cerita ini. Ada empat reservasi yang perlu diperiksa.",
    instruction: "Reservasi mana yang harus dipindahkan waktunya?",
    items: [
      PuzzleItem("a", "Lab A pada pukul 10.00"),
      PuzzleItem("c", "Lab A pada pukul 09.30"),
      PuzzleItem("b", "Lab B pada pukul 09.00"),
      PuzzleItem("d", "Lab A pada pukul 11.00"),
    ],
    answerKey: ["c"],
    hint: "Aturan hanya membatasi Lab A, dengan awal pemesanan pukul 10.00.",
    explanation:
        "Lab A pukul 09.30 melanggar batas mulai 10.00. Lab A pukul 10.00 dan 11.00 diperbolehkan; aturan tersebut tidak berlaku untuk Lab B.",
  ),
  Question(
    id: "q09",
    missionId: "lab",
    type: QuestionType.multipleChoice,
    title: "Kode dari tiga petunjuk",
    context:
        "Token yang tersedia adalah 1, 2, 3, dan 4; masing-masing hanya boleh dipakai sekali. Kode terdiri dari tiga digit. Digit pertama genap tetapi bukan 4. Digit kedua adalah token terbesar. Digit terakhir satu lebih besar dari digit pertama.",
    instruction: "Kode mana yang memenuhi ketiga petunjuk?",
    items: [
      PuzzleItem("243", "243"),
      PuzzleItem("234", "234"),
      PuzzleItem("423", "423"),
      PuzzleItem("241", "241"),
    ],
    answerKey: ["243"],
    hint:
        "Digit pertama hanya mungkin 2. Tentukan dua digit berikutnya dari petunjuk.",
    explanation:
        "Digit pertama adalah 2, digit kedua 4 sebagai token terbesar, dan digit terakhir 3 karena satu lebih besar dari 2. Jadi kodenya 243.",
  ),
  Question(
    id: "q10",
    missionId: "lab",
    type: QuestionType.multipleChoice,
    title: "Dua dokumen yang muat",
    context:
        "Dokumen A berisi 2 halaman/6 MB, B 4 halaman/10 MB, dan C 1 halaman/2 MB. Pengiriman harus memuat tepat dua dokumen, tepat lima halaman, dan paling besar 12 MB.",
    instruction: "Paket dokumen mana yang memenuhi semua syarat?",
    items: [
      PuzzleItem("ab", "A + B: 6 halaman, 16 MB"),
      PuzzleItem("ac", "A + C: 3 halaman, 8 MB"),
      PuzzleItem("bc", "B + C: 5 halaman, 12 MB"),
      PuzzleItem("b", "B saja: 4 halaman, 10 MB"),
    ],
    answerKey: ["bc"],
    hint:
        "Syarat jumlah dokumen, halaman, dan ukuran harus dipenuhi sekaligus.",
    explanation:
        "B + C berisi dua dokumen, tepat lima halaman, dan total 12 MB. Ketiga paket lainnya melanggar setidaknya satu syarat.",
  ),
  Question(
    id: "q11",
    missionId: "lab",
    type: QuestionType.multipleChoice,
    title: "Kode untuk tiga terminal",
    context:
        "Terminal Merah, Biru, dan Hijau memakai kode berbeda dari 243, 312, dan 421. Biru memakai 312. Merah memakai kode yang diawali angka 4. Setiap kode hanya digunakan satu kali.",
    instruction: "Pemetaan terminal dan kode mana yang benar?",
    items: [
      PuzzleItem("swap_red_blue", "Merah 312 · Biru 421 · Hijau 243"),
      PuzzleItem("wrong_red", "Merah 243 · Biru 312 · Hijau 421"),
      PuzzleItem("wrong_blue", "Merah 421 · Biru 243 · Hijau 312"),
      PuzzleItem("mapping", "Merah 421 · Biru 312 · Hijau 243"),
    ],
    answerKey: ["mapping"],
    hint: "Petunjuk menentukan kode Biru dan Merah secara langsung.",
    explanation:
        "Biru memakai 312. Satu-satunya kode yang diawali 4 adalah 421, jadi itu milik Merah. Kode 243 yang tersisa menjadi milik Hijau.",
  ),
  Question(
    id: "q12",
    missionId: "lab",
    type: QuestionType.multipleChoice,
    title: "Buka terminal terakhir",
    context:
        "Terminal Hijau terkunci dan memiliki kode 243. Tiga digit harus dimasukkan terlebih dahulu, kemudian tombol Konfirmasi ditekan.",
    instruction: "Rangkaian tindakan mana yang membuka terminal?",
    items: [
      PuzzleItem("unlock", "Masukkan 243 → Konfirmasi"),
      PuzzleItem("early", "Konfirmasi → Masukkan 243"),
      PuzzleItem("delete", "Masukkan 243 → Hapus"),
      PuzzleItem("wrong", "Masukkan 312 → Konfirmasi"),
    ],
    answerKey: ["unlock"],
    hint: "Kode dan urutan tindakan harus sama-sama mengikuti aturan.",
    explanation:
        "Masukkan kode 243, lalu tekan Konfirmasi. Konfirmasi terlalu awal, menghapus kode, atau memakai kode 312 tidak memenuhi aturan.",
  ),
  Question(
    id: 'q13',
    missionId: 'quiz',
    type: QuestionType.multipleChoice,
    title: 'Widget yang bisa berubah',
    context:
        'Tim membuat layar kuis yang skornya berubah saat pengguna menjawab. Nilai skor harus disimpan dan tampilannya diperbarui ketika berubah.',
    instruction: 'Pilih satu jawaban yang benar.',
    items: [
      PuzzleItem('stateless', 'StatelessWidget'),
      PuzzleItem('stateful', 'StatefulWidget'),
      PuzzleItem('inherited', 'InheritedWidget'),
      PuzzleItem('builder', 'LayoutBuilder'),
    ],
    answerKey: ['stateful'],
    hint: 'Widget mana yang menyimpan state dan memanggil setState?',
    explanation:
        'StatefulWidget menyimpan data yang berubah dan memperbarui tampilan melalui setState. StatelessWidget tidak menyimpan state yang berubah.',
  ),
  Question(
    id: 'q14',
    missionId: 'quiz',
    type: QuestionType.multipleChoice,
    title: 'Pindah antar halaman',
    context:
        'Setelah mengisi nama di halaman awal, pengguna harus dibawa ke halaman soal. Aplikasi memakai navigasi berbasis tumpukan (stack).',
    instruction: 'Pilih satu jawaban yang benar.',
    items: [
      PuzzleItem('navigator', 'Navigator.push'),
      PuzzleItem('setstate', 'setState'),
      PuzzleItem('print', 'debugPrint'),
      PuzzleItem('pop', 'Navigator.pop'),
    ],
    answerKey: ['navigator'],
    hint: 'Untuk membuka halaman baru, bukan menutup halaman.',
    explanation:
        'Navigator.push menambahkan halaman baru ke tumpukan. Navigator.pop justru menutup halaman dan kembali ke sebelumnya.',
  ),
  Question(
    id: 'q15',
    missionId: 'quiz',
    type: QuestionType.multipleChoice,
    title: 'Ukuran yang menyesuaikan layar',
    context:
        'Tampilan harus tetap rapi di ponsel kecil maupun tablet. Tim ingin mengambil lebar layar untuk menghitung tata letak, bukan memakai angka tetap.',
    instruction: 'Pilih satu jawaban yang benar.',
    items: [
      PuzzleItem('hardcode', 'Menulis lebar tetap 400 piksel'),
      PuzzleItem('mediaquery', 'MediaQuery.of(context).size'),
      PuzzleItem('color', 'Theme warna'),
      PuzzleItem('string', 'String nama layar'),
    ],
    answerKey: ['mediaquery'],
    hint: 'Yang mana membaca ukuran perangkat saat runtime?',
    explanation:
        'MediaQuery memberi ukuran layar perangkat sehingga tata letak dapat menyesuaikan. Nilai piksel tetap membuat tampilan tidak responsif.',
  ),
  Question(
    id: 'q16',
    missionId: 'quiz',
    type: QuestionType.multipleChoice,
    title: 'Menyimpan data lokal sederhana',
    context:
        'Soal kuis cukup disimpan sebagai data contoh di dalam aplikasi. Tidak ada server dan tidak perlu basis data.',
    instruction: 'Pilih satu jawaban yang benar.',
    items: [
      PuzzleItem('sql', 'Basis data SQL di server'),
      PuzzleItem('cloud', 'Penyimpanan cloud online'),
      PuzzleItem('dummy', 'Daftar data dummy di dalam kode'),
      PuzzleItem('camera', 'Sensor kamera perangkat'),
    ],
    answerKey: ['dummy'],
    hint: 'Soal meminta data lokal atau dummy, bukan database.',
    explanation:
        'Data dummy lokal di dalam kode sudah cukup untuk kuis ini, sesuai ketentuan tanpa basis data.',
  ),
];
