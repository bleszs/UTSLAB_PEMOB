# Aset dan sumber

## Referensi pengguna

`references/images/Gemini_Generated_Image_h7fhevh7fhevh7fh.jpeg` diekstrak dari ZIP yang diberikan pengguna. Referensi menunjukkan halaman hasil dengan piala 3D, panel ungu, angka skor kuning, dan tombol main lagi. Gambar tidak digunakan sebagai screenshot aplikasi yang sudah dibuat.

## Font

Nunito variable font diunduh dari repositori resmi Google Fonts:

- https://github.com/google/fonts/tree/main/ofl/nunito
- `assets/fonts/Nunito-Variable.ttf`
- `assets/fonts/OFL.txt` — lisensi SIL Open Font License.

Font dibundel secara lokal; aplikasi tidak memanggil Google Fonts saat berjalan.
Bobot statis Regular 400, Bold 700, ExtraBold 800, dan Black 900 diturunkan dari sumber variabel menggunakan `tool/prepare_fonts.py` (fontTools). File sumber serta lisensi tetap disimpan. Bobot statis membuat rendering antartarget lebih konsisten.

## Ilustrasi

Tool imagegen bawaan menghasilkan satu sprite sheet transparan. Dua bagian dipisahkan dan diubah ukurannya dengan FFmpeg tanpa menghapus alpha:

- `assets/images/education.png`: topi wisuda, buku, lampu, dan bintang.
- `assets/images/trophy.png`: piala emas, pedestal ungu, dan confetti.

Sumber asli tetap tersimpan di direktori generated_images Codex. Salinan yang dipakai aplikasi berada di workspace. Aset generated ini bukan materi dari ZIP pengguna.

### Prompt final

```text
Use case: stylized-concept. Asset type: two separate Flutter mobile quiz application illustrations in one wide 2:1 transparent sprite sheet. LEFT HALF: a friendly glossy violet and lavender 3D graduation cap resting on two rounded education books, small golden lightbulb and tiny golden star above it. RIGHT HALF: one elegant gold 3D trophy with two handles, a violet pedestal, one purple star above it, sparse small purple and gold confetti. Each composition centered in its own half with generous clear transparent padding, objects never cross center boundary. Soft polished studio rendering, smooth clean shapes, sophisticated vibrant purple #7338EA and golden yellow #FFCF32 palette. No text, letters, numbers, logos, watermarks, phone frames, UI or background. Real alpha transparency.
```

Ikon UI menggunakan Material Icons Flutter. Launcher icon bawaan Flutter masih digunakan; ilustrasi bukan launcher icon.
