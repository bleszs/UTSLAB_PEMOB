---
name: Quizora
description: Kuis Indonesia yang cerah, membulat, dan mudah diikuti.
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
  option-marker: "10px"
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
  panel-padding: "28px"
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
  option:
    backgroundColor: "{colors.white}"
    textColor: "{colors.ink}"
    typography: "{typography.title-medium}"
    rounded: "{rounded.field-and-option}"
    padding: "18px"
  option-selected:
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
    padding: "28px"
---

# Design System: Quizora

## Overview

**Creative North Star: "Rasa ingin tahu, bertemu tantangan."**

Quizora memakai ungu cerah, kuning hangat, Nunito membulat, dan ilustrasi edukasi serta piala 3D sesuai brief pengguna. Permukaan tenang memberi ruang untuk pertanyaan, nama pengguna, dan satu tindakan berikutnya. Tampilan tetap ramah ketika pengguna mempelajari jawaban yang salah.

Sistem berasal dari implementasi Flutter Material 3, bukan dari perkiraan mockup. Token di atas mencatat nilai eksplisit dalam `lib/utils/app_theme.dart` dan komponen; satuan px mewakili logical pixel Flutter sebelum skala teks perangkat. Varian komponen frontmatter menunjukkan mode terang. Mode gelap memakai pemetaan warna semantik di bawah, sedangkan panel skor mempertahankan identitas ungu/kuning. Sidecar berisi terjemahan HTML untuk pratinjau komponen, bukan pengganti rendering Flutter.

**Key Characteristics:**

- Ungu untuk identitas, pilihan aktif, dan progress; kuning untuk tindakan utama dan skor.
- Nunito lokal dengan judul tebal dan teks isi berjarak lega.
- Permukaan membulat, outline lembut, dan bayangan Material terbatas pada tombol utama.
- Tata letak satu kolom yang berubah menjadi dua kolom saat ruang konten mencukupi.
- Mode terang dan gelap dengan label serta indikator status yang tetap terbaca.

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

**The Purple Selection Rule.** Pilihan aktif memakai primary dan onPrimary dari tema; ikon centang dan state semantik ikut menyatakan pilihan.

**The Yellow Action Rule.** Tindakan utama memakai kuning dengan tinta gelap; panel hasil memakai kuning untuk angka skor dan ungu tetap untuk latarnya.

Warna error tetap mengikuti `ColorScheme.fromSeed` milik Material 3. Divider khusus panel hasil dan lapisan alpha merupakan detail lokal, bukan perluasan palet primitif.

## Typography

**Display Font:** Nunito lokal.
**Body Font:** Nunito lokal.

**Character:** Bentuk huruf membulat mendukung nada ramah, sementara bobot tebal memisahkan pertanyaan dan tindakan dari teks penjelasan. `pubspec.yaml` memasang berkas bobot regular, bold, extra bold, dan black; tidak ada font display sistem yang menggantikan identitas.

### Hierarchy

- **Display**: angka skor akhir, menggunakan `display`.
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

Welcome, Quiz, dan Result memakai `SafeArea`, kontainer terpusat dengan lebar maksimal (1040 logical px), dan gutter horizontal (24 logical px) ketika lebar viewport kurang dari (600 logical px), lalu (40 logical px). Header berada di atas area isi yang dapat digulir; footer Quiz tetap di bawah area isi dan memiliki batas lebar (560 logical px). Hindari tinggi tetap untuk teks dan isi yang dapat bertambah akibat skala teks.

Welcome dan Quiz beralih ke dua kolom ketika lebar konten yang sudah dikurangi gutter mencapai (720 logical px). Jarak kolom Welcome (56 logical px), Quiz (48 logical px). Result tetap satu kolom dengan batas lebar (640 logical px). Review memakai daftar scroll dengan kontainer maksimal (800 logical px) dan gutter tetap (24 logical px). Ini adalah ukuran area konten, bukan pemeriksaan orientasi perangkat.

Ritme menggunakan spacing frontmatter; opsi berjarak `option-gap`, header berpadding vertikal `section-small`, dan panel skor memakai `panel-padding`. Welcome menempatkan ilustrasi di atas teks pada layout sempit; layout lebar menempatkan ilustrasi di samping form. Ilustrasi menggunakan `BoxFit.contain` dan tidak dipotong.

## Elevation & Depth

Depth terutama berasal dari perbedaan warna kanvas, permukaan, dan outline. Opsi dan panel skor tidak memakai box shadow khusus. `CustomPrimaryButton` memakai elevation Material (3) saat aktif, warna bayangan kuning dengan alpha (.25), serta elevation (0) ketika disabled. Ini adalah elevation Flutter, bukan token CSS box-shadow yang dapat disalin persis. Respons sentuhan, fokus, hover, dan navigasi diwarisi dari Material 3; implementasi tidak menetapkan kurva atau durasi animasi tersendiri.

## Shapes

Sudut lunak membentuk field, opsi, tombol, dan panel. Gunakan radius berdasarkan peran di frontmatter, bukan satu radius untuk semua permukaan. Marker huruf opsi berukuran (34 × 34 logical px) dengan radius `option-marker`; tanda merek header berukuran (40 × 40 logical px) dengan radius `brand-mark`. Progress memiliki tinggi minimum (8 logical px) dan radius `progress`.

Opsi tak terpilih memiliki outline (1 logical px); opsi terpilih memakai outline primary (2 logical px). Field normal beroutline (1 logical px), fokus beroutline primary (2 logical px). InkWell dipotong mengikuti bentuk kartu.

## Components

### Buttons

Tombol utama hangat dan mudah ditemukan. `button-primary` membentang mengikuti ruang tersedia, tinggi minimum sesuai token `height`, dan boleh membesar ketika label membutuhkan ruang. Label berpusat, diikuti ikon (20 logical px) dengan jarak (12 logical px). Disabled mengganti latar dengan onSurface beralpha (.10), warna teks muted, dan menghapus elevation. Tombol teks memakai primary tema dengan target minimum (48 × 48 logical px); gunakan untuk melanjutkan sesi atau membuka pembahasan.

### Cards / Containers

Kartu opsi memakai `option` atau `option-selected`. Marker huruf di kiri, jawaban yang dapat membungkus di tengah, dan radio/centang (22 logical px) di kanan. Marker tak terpilih memakai primary beralpha (.08); marker terpilih memakai warna foreground beralpha (.15). Tidak ada shadow kartu. Widget menyatakan `selected` dan `inMutuallyExclusiveGroup` melalui Semantics.

### Inputs / Fields

Field nama memakai `name-field`, ikon person, hint muted, dan focus outline primary. Label terpisah berada di atas field. Pesan validasi ditampilkan melalui `TextFormField`, memakai state error Material; panjang nama maksimal (30 karakter). Validasi dimulai saat submit lalu diperbarui ketika pengguna mengetik. Main Lagi membersihkan input dan error. Terjemahan HTML sidecar mencontohkan state fokus, bukan seluruh validator aplikasi.

### Navigation

Header berupa row dengan judul yang mengambil ruang tersisa. Welcome memakai tanda merek; halaman yang menerima `onBack` menampilkan tombol kembali. Tombol tema berada di kanan, menggunakan ikon dan tooltip bahasa Indonesia. Target ikon minimum (48 × 48 logical px); ukuran dan warna ikon mengikuti tema. Tidak ada tab bar atau bottom navigation.

### Score Panel

Panel skor memakai `score-panel` dengan display kuning, denominator putih, jumlah benar, divider lokal, dan tiga kolom statistik. Panel tetap ungu pada kedua mode tema. Label serta ikon statistik ikut menjelaskan nilai; skor memiliki label Semantics tersendiri. Piala adalah aset raster dekoratif yang dikecualikan dari Semantics.

### Progress

Indikator linear memakai primary tema di atas track primary beralpha (.12). Teks jumlah soal dan jumlah terjawab menyertai bar; Semantics menyampaikan jumlah jawaban. Progress tidak memakai animasi khusus aplikasi.

## Do's and Don'ts

### Do:

- **Do** gunakan primary dan onPrimary tema untuk opsi terpilih, termasuk mode gelap.
- **Do** gunakan Nunito lokal dan peran tipografi frontmatter pada layar tambahan.
- **Do** pertahankan teks, ikon status, dan Semantics bersama warna pilihan serta skor.
- **Do** beri ruang untuk wrapping, skala teks, dan scroll di dalam SafeArea.
- **Do** pertahankan ilustrasi edukasi dan piala tanpa crop yang merusak bentuknya.

### Don't:

- **Don't** gunakan teks putih pada tombol kuning; gunakan tinta gelap.
- **Don't** hardcode ungu terang untuk kontrol tema gelap yang sudah memiliki primary semantik.
- **Don't** tambahkan shadow kartu atau animasi khusus sebagai aturan sistem tanpa implementasi yang mendasarinya.
- **Don't** menyebut screenshot renderer pengujian sebagai bukti emulator atau perangkat fisik.

Dokumentasi ini diturunkan dari kode dan brief yang tersedia. Tidak ada cacat craft yang dikukuhkan menjadi aturan sistem; nilai tema Material yang diwarisi dan detail satu kali tetap dibedakan dari token aplikasi.
