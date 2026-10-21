---
name: Quizora Quest
description: Puzzle kampus Indonesia yang cerah, membulat, dan mudah diikuti.
colors:
  purple: "#7338EA"
  yellow: "#FFCF32"
  ink: "#211638"
  navy: "#121529"
  white: "#FFFFFF"
  canvas-light: "#FAF8FF"
  surface-dark: "#1C2038"
  primary-dark: "#BFA1FF"
  text-dark: "#F5F0FF"
  muted-light: "#686174"
  muted-dark: "#C4C1D5"
  outline-light: "#E5DFF0"
  outline-dark: "#3F435E"
typography:
  display:
    fontFamily: Nunito
    fontSize: "72px"
    fontWeight: 900
    lineHeight: 1.05
  headline-large:
    fontFamily: Nunito
    fontSize: "36px"
    fontWeight: 900
    lineHeight: 1.18
  headline-medium:
    fontFamily: Nunito
    fontSize: "28px"
    fontWeight: 800
    lineHeight: 1.25
  title-large:
    fontFamily: Nunito
    fontSize: "22px"
    fontWeight: 800
    lineHeight: 1.3
  title-medium:
    fontFamily: Nunito
    fontSize: "17px"
    fontWeight: 700
    lineHeight: 1.4
  body-large:
    fontFamily: Nunito
    fontSize: "16px"
    lineHeight: 1.5
  body-medium:
    fontFamily: Nunito
    fontSize: "14px"
    lineHeight: 1.5
  label-large:
    fontFamily: Nunito
    fontSize: "16px"
    fontWeight: 800
rounded:
  progress: "12px"
  brand-mark: "13px"
  field-and-option: "16px"
  primary-button: "18px"
  score-panel: "24px"
spacing:
  icon-gap: "8px"
  option-gap: "12px"
  inline-gap: "14px"
  section-small: "16px"
  field-padding: "18px"
  section-medium: "20px"
  page-mobile: "24px"
  page-wide: "40px"
components:
  button-primary:
    backgroundColor: "{colors.yellow}"
    textColor: "{colors.ink}"
    typography: "{typography.label-large}"
    rounded: "{rounded.primary-button}"
    padding: "16px 24px"
    height: "58px"
    width: "100%"
  button-text:
    textColor: "{colors.purple}"
    typography: "{typography.label-large}"
  name-field:
    backgroundColor: "{colors.white}"
    textColor: "{colors.ink}"
    rounded: "{rounded.field-and-option}"
    padding: "18px 20px"
  puzzle-choice:
    backgroundColor: "{colors.white}"
    textColor: "{colors.ink}"
    typography: "{typography.title-medium}"
    rounded: "{rounded.field-and-option}"
    padding: "18px"
  puzzle-choice-selected:
    backgroundColor: "{colors.purple}"
    textColor: "{colors.white}"
    typography: "{typography.title-medium}"
    rounded: "{rounded.field-and-option}"
    padding: "18px"
  header:
    textColor: "{colors.ink}"
    typography: "{typography.title-large}"
    padding: "16px 0"
  score-panel:
    backgroundColor: "{colors.purple}"
    textColor: "{colors.white}"
    rounded: "{rounded.score-panel}"
    padding: "24px"
  mission-card:
    backgroundColor: "{colors.white}"
    textColor: "{colors.ink}"
    typography: "{typography.title-large}"
    rounded: "{rounded.field-and-option}"
    padding: "22px"
  puzzle-feedback:
    rounded: "{rounded.field-and-option}"
    padding: "22px"
---

# Design System: Quizora Quest

## Overview

**Creative North Star: "Rasa ingin tahu, bertemu tantangan."**

Quizora Quest mempertahankan ungu cerah, kuning hangat, Nunito membulat, dan ilustrasi edukasi serta piala 3D sesuai brief pengguna. Permukaan tenang memberi ruang untuk cerita, petunjuk, dan benda kerja puzzle. Tampilan tetap ramah ketika pengguna mempelajari jawaban yang belum tepat.

Sistem berasal dari implementasi Flutter Material 3, bukan dari perkiraan mockup. Token di atas mencatat nilai eksplisit dalam `lib/utils/app_theme.dart` dan komponen; satuan px mewakili logical pixel Flutter sebelum skala teks perangkat. Varian komponen frontmatter menunjukkan mode terang. Mode gelap memakai pemetaan warna semantik di bawah, sedangkan panel skor mempertahankan identitas ungu/kuning. Sidecar berisi terjemahan HTML untuk pratinjau komponen, bukan pengganti rendering Flutter.

**Key Characteristics:**

- Ungu untuk identitas, pilihan aktif, dan progress; kuning untuk tindakan utama dan skor.
- Nunito lokal dengan judul tebal dan teks isi berjarak lega.
- Permukaan membulat, outline lembut, dan bayangan Material terbatas pada tombol utama.
- Tata letak satu kolom yang berubah menjadi dua kolom saat ruang konten mencukupi.
- Mode terang dan gelap dengan label serta indikator status yang tetap terbaca.
- Pilihan, token, baris dokumen, dan slot menyatakan tindakan serta status melalui teks dan ikon.

## Colors

Palet menggabungkan ungu hidup dan kuning hangat dengan netral berona ungu pada mode terang, serta navy pada mode gelap. Nilai frontmatter adalah sumber normatif.

### Primary

- **Ungu Quizora (`purple`)**: identitas, pilihan terpilih, progress, dan panel skor.
- **Lavender terang (`primary-dark`)**: pengganti primary untuk kontrol di mode gelap; label terpilih memakai `ink`.

### Secondary

- **Kuning perayaan (`yellow`)**: tombol utama, angka skor, dan ikon statistik hasil. Teks pada tombol memakai `ink`.

### Neutral

- **Tinta ungu (`ink`)**, **putih (`white`)**, dan **kanvas terang (`canvas-light`)**: teks utama, permukaan, dan latar mode terang.
- **Navy malam (`navy`)**, **permukaan malam (`surface-dark`)**, dan **teks malam (`text-dark`)**: latar, permukaan, dan teks utama mode gelap.
- **Teks lembut (`muted-light`, `muted-dark`)**: bantuan, instruksi pendek, dan teks penjelasan.
- **Outline lembut (`outline-light`, `outline-dark`)**: batas field, opsi tak terpilih, serta divider.

### Named Rules

**The Purple Selection Rule.** Kartu pilihan aktif memakai primary dan onPrimary dari tema; ikon centang dan state semantik ikut menyatakan pilihan. Baris dokumen dan chip memakai state container Material yang diwarisi dari tema.

**The Yellow Action Rule.** Tindakan utama memakai kuning dengan tinta gelap; panel hasil memakai kuning untuk angka skor dan ungu tetap untuk latarnya.

Warna error, primaryContainer/onPrimaryContainer, errorContainer/onErrorContainer, dan state chip tetap mengikuti `ColorScheme.fromSeed` milik Material 3. Feedback benar memakai container primary, feedback belum tepat atau waktu habis memakai container error. Divider khusus panel hasil dan lapisan alpha merupakan detail lokal, bukan perluasan palet primitif. Sumber: `lib/utils/app_theme.dart`, `lib/widgets/puzzle_interactor.dart`, dan `lib/screens/quiz_screen.dart`.

## Typography

**Display Font:** Nunito lokal.
**Body Font:** Nunito lokal.

**Character:** Bentuk huruf membulat mendukung nada ramah, sementara bobot tebal memisahkan pertanyaan dan tindakan dari teks penjelasan. `pubspec.yaml` memasang berkas bobot regular, bold, extra bold, dan black; tidak ada font display sistem yang menggantikan identitas.

### Hierarchy

- **Display**: persentase akurasi akhir, menggunakan `display`.
- **Headline large**: sapaan Welcome, menggunakan `headline-large`.
- **Headline medium**: pertanyaan dan sapaan hasil, menggunakan `headline-medium`.
- **Title large**: nama aplikasi, judul header, dan pertanyaan pada pembahasan.
- **Title medium**: label form, teks opsi, progress tekstual, serta status pembahasan.
- **Body large**: pengantar dan jawaban pembahasan; bobot diwarisi dari tema Material.
- **Body medium**: bantuan dan penjelasan; memakai warna muted kecuali di panel skor.
- **Label large**: tindakan utama dan tombol teks, menggunakan `label-large`.

### Named Rules

**The One Family Rule.** Semua teks antarmuka memakai Nunito; hierarki berasal dari ukuran, bobot, dan warna semantik.

## Layout

Semua layar memakai `ResponsivePage` (`lib/widgets/responsive_page.dart`): `SafeArea`, kontainer terpusat dengan lebar maksimal (1040 logical px), dan gutter horizontal (24 logical px) ketika lebar viewport kurang dari (600 logical px), lalu (40 logical px). Header berada di atas area isi yang dapat digulir. Footer Welcome, Mission, dan Quiz tetap di bawah scroll, mengikuti lebar konten, dengan ruang atas (16 logical px) dan bawah (20 logical px). Tidak ada batas footer tambahan. Hindari tinggi tetap untuk teks dan isi yang dapat bertambah akibat skala teks.

Welcome (`lib/screens/welcome_screen.dart`) dan Quiz (`lib/screens/quiz_screen.dart`) beralih ke dua kolom ketika lebar konten yang sudah dikurangi gutter mencapai (720 logical px). Jarak kolom Welcome (56 logical px), Quiz (40 logical px). Result (`lib/screens/result_screen.dart`) tetap satu kolom dengan batas lebar (640 logical px). Mission dan Review mengikuti kontainer `ResponsivePage`; kartu misi dan pembahasan tersusun vertikal. Ini adalah ukuran area konten, bukan pemeriksaan orientasi perangkat.

Ritme menggunakan spacing frontmatter; kartu pilihan berjarak `option-gap`, header berpadding vertikal `section-small`, dan panel akurasi memakai `page-mobile`. Welcome menempatkan ilustrasi di atas teks pada layout sempit; layout lebar menempatkan ilustrasi di samping form. Quiz memisahkan cerita dan area kerja pada layout lebar. Chip, statistik, dan metadata memakai `Wrap` agar dapat pindah baris. Ilustrasi di `lib/widgets/quiz_artwork.dart` menggunakan `BoxFit.contain` dan tidak dipotong.

## Elevation & Depth

Depth terutama berasal dari perbedaan warna kanvas, permukaan, dan outline. Kartu pilihan, misi, dan panel akurasi tidak memakai box shadow khusus. `CustomPrimaryButton` (`lib/widgets/custom_primary_button.dart`) memakai elevation Material (3) saat aktif, warna bayangan kuning dengan alpha (.25), serta elevation (0) ketika disabled. Ini adalah elevation Flutter, bukan token CSS box-shadow yang dapat disalin persis. Respons sentuhan, fokus, hover, dan navigasi diwarisi dari Material 3. `QuizScreen` mengganti area kerja dengan feedback melalui `AnimatedSwitcher` (240 ms); durasi menjadi nol ketika perangkat meminta animasi dikurangi. Tidak ada kurva animasi aplikasi yang ditetapkan.

## Shapes

Sudut lunak membentuk field, kartu pilihan, dokumen, misi, feedback, tombol, dan panel. Gunakan radius berdasarkan peran di frontmatter, bukan satu radius untuk semua permukaan. Kartu puzzle tidak memiliki marker huruf. Tanda merek header berukuran (40 × 40 logical px) dengan radius `brand-mark`. Progress memiliki tinggi minimum (8 logical px) dan radius `progress`.

Kartu pilihan tak terpilih memiliki outlineVariant (1 logical px); pilihan aktif memakai outline primary dengan lebar yang sama. Field normal beroutline (1 logical px), fokus beroutline primary (2 logical px). InkWell dipotong mengikuti bentuk kartu. Chip dan tombol slot mewarisi bentuk serta state Material 3, bukan radius baru yang ditetapkan aplikasi.

## Components

### Buttons

Tombol utama hangat dan mudah ditemukan. `CustomPrimaryButton` di `lib/widgets/custom_primary_button.dart` memakai `button-primary`, membentang mengikuti ruang tersedia, tinggi minimum sesuai token `height`, dan boleh membesar ketika label membutuhkan ruang. Label berpusat, diikuti ikon (20 logical px) dengan jarak (12 logical px). Disabled mengganti latar dengan onSurface beralpha (.10), warna teks muted, dan menghapus elevation. Tombol teks memakai primary tema dengan target minimum (48 × 48 logical px); gunakan untuk melanjutkan sesi, membuka petunjuk, atau membaca pembahasan.

### Cards / Containers

`PuzzleChoice` di `lib/widgets/puzzle_interactor.dart` memakai `puzzle-choice` atau `puzzle-choice-selected`. Label dan detail yang dapat membungkus berada di kiri, radio/kotak pilihan atau centang berada di kanan dengan jarak (12 logical px). Tidak ada marker huruf maupun shadow kartu. Widget menyatakan button, selected, enabled, label lengkap, serta aksi onTap melalui Semantics luar; detail anak dikecualikan agar tidak dibaca dua kali. Ketika jawaban terkunci, enabled menjadi false dan aksi tap dihapus. Scenario memakai satu pilihan, multiSelect memakai jumlah pilihan yang dinyatakan di atas daftar.

### Chips / Profile Choices

`WelcomeScreen` memakai ChoiceChip untuk avatar Penjelajah, Detektif, dan Perakit serta mode Santai/Tantangan. Avatar menampilkan ikon (20 logical px), padding chip (8 logical px), dan jarak wrap (8 logical px). Warna, bentuk, fokus, dan disabled diwarisi dari Material 3. `PuzzleInteractor` memakai ActionChip untuk token yang dapat diketuk atau ditarik, serta ChoiceChip untuk pasangan dan kategori. Label tetap terlihat pada semua state; chip terpilih menunjukkan assignment yang aktif.

### Inputs / Fields

Field nama memakai `name-field`, ikon person, hint muted, dan focus outline primary. Label terpisah berada di atas field. Pesan validasi ditampilkan melalui `TextFormField`, memakai state error Material; panjang nama maksimal (30 karakter). Validasi dimulai saat submit lalu diperbarui ketika pengguna mengetik. Main Lagi membersihkan input dan error. Terjemahan HTML sidecar mencontohkan state fokus, bukan seluruh validator aplikasi.

### Navigation / Sticky Actions

`AppHeader` (`lib/widgets/app_header.dart`) berupa row dengan judul yang mengambil ruang tersisa. Welcome memakai tanda merek; halaman yang menerima `onBack` menampilkan tombol kembali. Tombol tema berada di kanan, menggunakan ikon dan tooltip bahasa Indonesia. Target ikon minimum (48 × 48 logical px); ukuran dan warna ikon mengikuti tema. Tidak ada tab bar atau bottom navigation.

Welcome menempatkan Pilih Misi dan, bila ada sesi, Lanjutkan misi sebelumnya di footer. `MissionScreen` menempatkan Maraton 12 Puzzle di footer. Quiz menempatkan Kirim Jawaban di footer; tombol disabled ketika assignment belum lengkap. Sesudah submit, label menjadi Puzzle Berikutnya atau Lihat Hasil. Tombol dan footer berasal dari widget bersama, tetap di luar area scroll.

### MissionScreen

`lib/screens/mission_screen.dart` menampilkan tiga kartu misi dari `lib/data/questions.dart`, masing-masing empat puzzle. Kartu memakai `mission-card`, ikon primary (32 logical px), judul, deskripsi, jumlah puzzle, dan panah. Seluruh kartu dapat diketuk untuk memulai misi; tidak ada state terkunci atau progres misi yang direka. Tombol footer memulai semua 12 puzzle.

### PuzzleInteractor

`lib/widgets/puzzle_interactor.dart` merender tujuh tipe dari `lib/models/question.dart` dengan jawaban milik `QuizController` (`lib/controllers/quiz_controller.dart`). Interaksi tidak bergantung pada drag saja:

- **sequence:** baris bernomor dapat disusun melalui drag handle atau tombol Naikkan/Turunkan ber-tooltip. Tombol di ujung daftar disabled sesuai arah yang tidak tersedia.
- **hotspot:** dokumen berjudul dengan divider; ketuk satu baris untuk memilih bukti. Baris terpilih memakai primaryContainer dan ikon centang, dengan Semantics luar yang membawa selected, enabled, label baris lengkap, serta aksi onTap. Setelah submit, enabled menjadi false dan aksi tap dihapus.
- **matching:** token target mengisi slot kosong melalui ketukan atau drop; ChoiceChip per item juga memilih atau menghapus pasangan. Assignment target unik.
- **categorize:** token catatan dapat ditarik ke kelompok atau dipilih melalui chip kategori per item. Kelompok memakai primaryContainer dengan alpha (.5), radius field-and-option, dan padding (16 logical px).
- **multiSelect:** PuzzleChoice dengan indikator kotak pilihan, count terpilih, dan batas jumlah yang diminta puzzle. Pilihan dapat diubah sebelum submit.
- **codeBuilder:** token mengisi slot kosong melalui ketukan atau drop; ketuk slot untuk mengosongkan. Slot berlabel Semantics, digit unik, dan instruksi ketuk terlihat di bawahnya.
- **scenario:** PuzzleChoice untuk satu keputusan dengan detail alasan/konteks.

### PuzzleFeedback

`PuzzleFeedback` di `lib/screens/quiz_screen.dart` mengganti area kerja setelah submit atau timer habis. Container memakai `puzzle-feedback`, warna container semantik sesuai hasil, ikon status (40 logical px), judul, poin, bonus bila ada, jawaban pengguna, penyelesaian benar bila diperlukan, dan penjelasan. Semantics liveRegion mengumumkan perubahan. Teks menyatakan jawaban sudah terkunci; pengguna membaca feedback sebelum lanjut. Controller menolak perubahan dan submit ulang pada attempt yang telah tersimpan.

Petunjuk dapat dibuka satu kali sebelum submit; teks biaya bantuan terlihat setelah dibuka. Quiz menampilkan poin, combo, serta timer hanya pada mode Tantangan. Timer berubah ke error pada sisa (10 detik) dan memakai label sisa waktu serta liveRegion. Timer dijeda saat aplikasi tidak aktif atau pengguna keluar dari layar puzzle. Jawaban dan attempt berada di controller tingkat aplikasi sehingga perubahan ukuran/orientasi tidak membuat state lokal baru. Haptic mengikuti status benar/belum tepat; suara click sistem dapat dimatikan.

### Score Panel

`ResultScreen` di `lib/screens/result_screen.dart` memakai `score-panel` dengan display persentase kuning, label Akurasi percobaan pertama, jumlah puzzle benar, divider lokal, dan statistik wrap untuk Poin permainan, Combo terbaik, serta Petunjuk. Akurasi dihitung dari attempt benar terhadap jumlah puzzle, terpisah dari poin beserta bonus. Panel tetap ungu pada kedua mode tema; setiap nilai disertai label. Avatar dan nama mengaitkan hasil dengan pemain. Piala adalah aset raster dekoratif yang dikecualikan dari Semantics.

Jika ada puzzle belum tepat, Latih yang Belum Tepat memulai sesi baru dari puzzle tersebut; hasil latihan diberi label terpisah dari sesi sebelumnya. Lihat Pembahasan membuka `lib/screens/review_screen.dart` dengan status, poin, jawaban pengguna, penyelesaian, dan penjelasan per puzzle. Main Lagi mengembalikan pengguna ke Welcome dan membersihkan input nama serta validasi.

### Progress

Indikator linear pada `QuizScreen` memakai primary tema di atas track primary beralpha (.12). Label Puzzle x / total menyertai bar; Semantics Progress misi menyampaikan jumlah attempt terkirim terhadap total. Progress mengukur submit, bukan jumlah draft pilihan. Progress tidak memakai animasi khusus aplikasi.

## Do's and Don'ts

### Do:

- **Do** gunakan primary dan onPrimary tema untuk opsi terpilih, termasuk mode gelap.
- **Do** gunakan Nunito lokal dan peran tipografi frontmatter pada layar tambahan.
- **Do** pertahankan teks, ikon status, dan Semantics bersama warna pilihan serta skor.
- **Do** beri ruang untuk wrapping, skala teks, dan scroll di dalam SafeArea, dengan tindakan footer tetap dapat dijangkau.
- **Do** sediakan ketukan atau tombol sebagai alternatif drag untuk assignment dan pengurutan puzzle.
- **Do** pertahankan ilustrasi edukasi dan piala tanpa crop yang merusak bentuknya.

### Don't:

- **Don't** gunakan teks putih pada tombol kuning; gunakan tinta gelap.
- **Don't** hardcode ungu terang untuk kontrol tema gelap yang sudah memiliki primary semantik.
- **Don't** tambahkan shadow kartu, palet feedback baru, atau motion di luar perilaku yang telah diimplementasikan.
- **Don't** samakan persentase akurasi dengan poin permainan atau tampilkan draft sebagai attempt terkirim.
- **Don't** menyebut screenshot renderer pengujian sebagai bukti emulator atau perangkat fisik.

Dokumentasi ini diturunkan dari kode dan brief yang tersedia. Tidak ada cacat craft yang dikukuhkan menjadi aturan sistem; nilai tema Material yang diwarisi dan detail satu kali tetap dibedakan dari token aplikasi.
