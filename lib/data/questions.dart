import '../models/question.dart';

const missions = [
  Mission(
    'presentation',
    'Selamatkan Presentasi',
    'Rapikan alur, periksa biaya, dan siapkan tim sebelum tampil.',
  ),
  Mission(
    'schedule',
    'Detektif Jadwal',
    'Temukan bentrok dan pisahkan bukti dari dugaan.',
  ),
  Mission(
    'lab',
    'Kunci Ruang Lab',
    'Gabungkan petunjuk untuk merakit kode dan membuka terminal.',
  ),
];
const questions = <Question>[
  Question(
    id: 'q01',
    missionId: 'presentation',
    type: QuestionType.sequence,
    title: 'Alur file yang tertukar',
    context:
        'File presentasi berada di dalam ZIP. ZIP harus diunduh sebelum diekstrak. Font diperiksa setelah presentasi dibuka.',
    instruction:
        'Susun kartu dari langkah pertama sampai terakhir. Geser atau gunakan panah.',
    items: [
      PuzzleItem('open', 'Buka presentasi'),
      PuzzleItem('font', 'Periksa font'),
      PuzzleItem('download', 'Unduh file'),
      PuzzleItem('extract', 'Ekstrak ZIP'),
    ],
    answerKey: ['download', 'extract', 'open', 'font'],
    hint: 'File presentasi belum tersedia sebelum ZIP diekstrak.',
    explanation:
        'Unduh file → Ekstrak ZIP → Buka presentasi → Periksa font. Setiap langkah menggunakan hasil langkah sebelumnya.',
  ),
  Question(
    id: 'q02',
    missionId: 'presentation',
    type: QuestionType.hotspot,
    title: 'Satu angka yang salah',
    context:
        'Tiga biaya item sudah dikonfirmasi benar. Satu bagian rincian biaya berikut perlu diperbaiki.',
    instruction: 'Ketuk bagian rincian biaya yang salah.',
    items: [
      PuzzleItem('print', 'Cetak', detail: 'Rp50.000'),
      PuzzleItem('folder', 'Map', detail: 'Rp25.000'),
      PuzzleItem('transport', 'Transport', detail: 'Rp15.000'),
      PuzzleItem('total', 'Total', detail: 'Rp95.000'),
    ],
    answerKey: ['total'],
    hint: 'Jumlahkan hanya tiga biaya item.',
    explanation:
        '50.000 + 25.000 + 15.000 = 90.000. Total tertulis 95.000, sehingga bagian itulah yang salah.',
  ),
  Question(
    id: 'q03',
    missionId: 'presentation',
    type: QuestionType.matching,
    title: 'Siapa membawa apa?',
    context:
        'Ari, Bela dan Cika membawa barang berbeda. Bela membawa adaptor. Ari tidak membawa laptop. Tidak ada barang yang dibawa dua orang.',
    instruction:
        'Pasangkan setiap orang dengan barangnya. Ketuk pilihan atau tarik label barang.',
    items: [
      PuzzleItem('ari', 'Ari'),
      PuzzleItem('bela', 'Bela'),
      PuzzleItem('cika', 'Cika'),
    ],
    targets: [
      PuzzleItem('laptop', 'Laptop'),
      PuzzleItem('adapter', 'Adaptor'),
      PuzzleItem('flash', 'Flashdisk'),
    ],
    answerKey: ['flash', 'adapter', 'laptop'],
    hint: 'Singkirkan adaptor dari pilihan Ari terlebih dahulu.',
    explanation:
        'Bela membawa adaptor. Ari bukan pembawa laptop, jadi ia membawa flashdisk. Laptop menjadi barang Cika.',
  ),
  Question(
    id: 'q04',
    missionId: 'presentation',
    type: QuestionType.scenario,
    title: 'Rencana dua menit',
    context:
        'Baterai laptop 5%. Presentasi mulai dua menit lagi. File sudah tersedia. Charger kompatibel ada di meja dan bisa dipasang dalam 15 detik. Tujuan: mendapat pasokan daya sebelum tampil.',
    instruction: 'Pilih tindakan yang memenuhi tujuan dan batas waktu.',
    items: [
      PuzzleItem(
        'charge',
        'Pasang charger',
        detail: '15 detik · daya tersedia',
      ),
      PuzzleItem('download', 'Unduh ulang file', detail: '3 menit'),
      PuzzleItem('borrow', 'Pinjam laptop', detail: '5 menit'),
      PuzzleItem('wait', 'Tunggu saja', detail: 'Tidak menyediakan daya'),
    ],
    answerKey: ['charge'],
    hint: 'Bandingkan durasi tindakan dengan dua menit yang tersedia.',
    explanation:
        'Memasang charger menyediakan daya dalam 15 detik. File sudah tersedia; tindakan lain tidak memenuhi tujuan dalam dua menit.',
  ),
  Question(
    id: 'q05',
    missionId: 'schedule',
    type: QuestionType.multiSelect,
    title: 'Temukan jadwal bentrok',
    context:
        'Semua kegiatan pada hari yang sama. Berakhir tepat ketika kegiatan berikutnya mulai tidak dianggap bentrok.',
    instruction: 'Tandai tepat dua kegiatan yang waktunya tumpang tindih.',
    items: [
      PuzzleItem('a', 'Kegiatan A', detail: '09.00–10.00'),
      PuzzleItem('b', 'Kegiatan B', detail: '09.30–10.30'),
      PuzzleItem('c', 'Kegiatan C', detail: '10.30–11.00'),
      PuzzleItem('d', 'Kegiatan D', detail: '11.00–12.00'),
    ],
    answerKey: ['a', 'b'],
    hint: 'Periksa kegiatan yang berlangsung pada pukul 09.45.',
    explanation:
        'Pada 09.45, A dan B sama-sama berlangsung. B/C dan C/D hanya berbagi batas waktu.',
  ),
  Question(
    id: 'q06',
    missionId: 'schedule',
    type: QuestionType.categorize,
    title: 'Bukti atau dugaan?',
    context:
        'Aturan kasus: catatan yang menyebut dokumen atau data tercatat masuk Terverifikasi. Kalimat perkiraan masuk Belum terverifikasi.',
    instruction: 'Tempatkan setiap catatan pada kelompok yang sesuai.',
    items: [
      PuzzleItem('email', 'Email konfirmasi ruangan diterima'),
      PuzzleItem('lecturer', 'Dosen mungkin datang terlambat'),
      PuzzleItem('attendance', 'Daftar hadir berisi 12 nama'),
      PuzzleItem('projector', 'Sepertinya proyektor akan rusak'),
    ],
    targets: [
      PuzzleItem('verified', 'Terverifikasi'),
      PuzzleItem('unverified', 'Belum terverifikasi'),
    ],
    answerKey: ['verified', 'unverified', 'verified', 'unverified'],
    hint: 'Kata “mungkin” dan “sepertinya” menunjukkan perkiraan.',
    explanation:
        'Email dan daftar hadir menyebut bukti tercatat. Dugaan tentang dosen dan proyektor belum didukung bukti pada cerita.',
  ),
  Question(
    id: 'q07',
    missionId: 'schedule',
    type: QuestionType.sequence,
    title: 'Antrean ruang rapat',
    context:
        'Empat tim menggunakan ruang rapat hari ini. Rapikan timeline menurut waktu mulai.',
    instruction: 'Susun kegiatan dari waktu mulai paling awal.',
    items: [
      PuzzleItem('review', 'Review', detail: '13.15'),
      PuzzleItem('briefing', 'Briefing', detail: '12.30'),
      PuzzleItem('evaluation', 'Evaluasi', detail: '14.00'),
      PuzzleItem('simulation', 'Simulasi', detail: '13.00'),
    ],
    answerKey: ['briefing', 'simulation', 'review', 'evaluation'],
    hint: '12.30 lebih awal daripada semua kegiatan pada pukul 13.',
    explanation:
        'Briefing 12.30 → Simulasi 13.00 → Review 13.15 → Evaluasi 14.00.',
  ),
  Question(
    id: 'q08',
    missionId: 'schedule',
    type: QuestionType.hotspot,
    title: 'Reservasi yang melanggar aturan',
    context:
        'Lab A hanya boleh dipesan mulai pukul 10.00. Lab B tidak mempunyai batas mulai pada kasus ini.',
    instruction: 'Ketuk kartu reservasi yang harus dipindahkan waktunya.',
    items: [
      PuzzleItem('a', 'Reservasi A', detail: 'Lab A · 10.00'),
      PuzzleItem('b', 'Reservasi B', detail: 'Lab B · 09.00'),
      PuzzleItem('c', 'Reservasi C', detail: 'Lab A · 09.30'),
      PuzzleItem('d', 'Reservasi D', detail: 'Lab A · 11.00'),
    ],
    answerKey: ['c'],
    hint: 'Aturan berlaku untuk Lab A saja.',
    explanation:
        'Reservasi C dimulai sebelum 10.00 di Lab A. Lab B pukul 09.00 tidak melanggar aturan kasus ini.',
  ),
  Question(
    id: 'q09',
    missionId: 'lab',
    type: QuestionType.codeBuilder,
    title: 'Rakit kode tiga digit',
    context:
        'Token 1, 2, 3, 4 hanya boleh dipakai sekali. Digit pertama genap dan bukan 4. Digit kedua adalah token terbesar. Digit terakhir satu lebih besar dari digit pertama.',
    instruction: 'Isi tiga slot kode dengan mengetuk atau menarik token.',
    items: [
      PuzzleItem('1', '1'),
      PuzzleItem('2', '2'),
      PuzzleItem('3', '3'),
      PuzzleItem('4', '4'),
    ],
    answerKey: ['2', '4', '3'],
    hint: 'Digit pertama hanya bisa 2.',
    explanation:
        'Digit pertama 2, digit kedua 4, dan digit terakhir 2 + 1 = 3. Kode yang memenuhi semua aturan adalah 243.',
  ),
  Question(
    id: 'q10',
    missionId: 'lab',
    type: QuestionType.multiSelect,
    title: 'Dua dokumen yang muat',
    context:
        'Pengiriman wajib tepat 5 halaman, ukuran total paling besar 12 MB, dan tepat dua dokumen.',
    instruction: 'Pilih dua dokumen yang memenuhi ketiga aturan.',
    items: [
      PuzzleItem('a', 'Dokumen A', detail: '2 halaman · 6 MB'),
      PuzzleItem('b', 'Dokumen B', detail: '4 halaman · 10 MB'),
      PuzzleItem('c', 'Dokumen C', detail: '1 halaman · 2 MB'),
    ],
    answerKey: ['b', 'c'],
    hint: 'Periksa jumlah halaman sebelum ukuran file.',
    explanation:
        'B+C berisi 5 halaman dan 12 MB. A+B melebihi batas; A+C hanya berisi 3 halaman.',
  ),
  Question(
    id: 'q11',
    missionId: 'lab',
    type: QuestionType.matching,
    title: 'Cocokkan terminal',
    context:
        'Tiga terminal memakai kode berbeda. Biru memakai 312. Merah memakai kode yang diawali angka 4. Setiap kode dipakai sekali.',
    instruction: 'Pasangkan terminal dengan kode aksesnya.',
    items: [
      PuzzleItem('red', 'Terminal Merah'),
      PuzzleItem('blue', 'Terminal Biru'),
      PuzzleItem('green', 'Terminal Hijau'),
    ],
    targets: [
      PuzzleItem('243', '243'),
      PuzzleItem('312', '312'),
      PuzzleItem('421', '421'),
    ],
    answerKey: ['421', '312', '243'],
    hint: 'Terminal Merah tidak memakai 243.',
    explanation:
        'Merah memakai 421, Biru memakai 312, sehingga Hijau memakai kode yang tersisa: 243.',
  ),
  Question(
    id: 'q12',
    missionId: 'lab',
    type: QuestionType.scenario,
    title: 'Buka terminal terakhir',
    context:
        'Terminal Hijau terkunci dan memiliki kode 243. Aturan: tiga digit harus dimasukkan sebelum Konfirmasi ditekan.',
    instruction: 'Pilih rangkaian tindakan yang membuka terminal.',
    items: [
      PuzzleItem('unlock', 'Masukkan 243 → Konfirmasi'),
      PuzzleItem('early', 'Konfirmasi → Masukkan 243'),
      PuzzleItem('delete', 'Masukkan 243 → Hapus'),
      PuzzleItem('wrong', 'Masukkan 312 → Konfirmasi'),
    ],
    answerKey: ['unlock'],
    hint: 'Kode harus cocok dan urutan tindakan juga harus benar.',
    explanation:
        'Masukkan kode 243 terlebih dahulu, kemudian Konfirmasi. Kode dan urutan tindakan harus sama-sama memenuhi aturan.',
  ),
];
