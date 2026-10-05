import '../models/question.dart';

const questions = <Question>[
  Question(id: 'planet', category: 'Sains', text: 'Planet apa yang dikenal sebagai Planet Merah?', options: ['Venus', 'Mars', 'Jupiter', 'Saturnus'], correctIndex: 1, explanation: 'Mars terlihat kemerahan karena oksida besi pada permukaannya.'),
  Question(id: 'proklamasi', category: 'Sejarah', text: 'Pada tanggal berapa Indonesia memproklamasikan kemerdekaan?', options: ['17 Agustus 1945', '10 November 1945', '1 Juni 1945', '28 Oktober 1928'], correctIndex: 0, explanation: 'Proklamasi kemerdekaan Indonesia dibacakan pada 17 Agustus 1945.'),
  Question(id: 'multiply', category: 'Matematika', text: 'Berapa hasil dari 7 × 8?', options: ['48', '54', '64', '56'], correctIndex: 3, explanation: 'Tujuh kelompok yang masing-masing berisi delapan menghasilkan 56.'),
  Question(id: 'photosynthesis', category: 'Sains', text: 'Apa nama proses tumbuhan membuat makanan dengan bantuan cahaya?', options: ['Respirasi', 'Evaporasi', 'Fotosintesis', 'Fermentasi'], correctIndex: 2, explanation: 'Fotosintesis menggunakan energi cahaya untuk membuat makanan dari air dan karbon dioksida.'),
  Question(id: 'ocean', category: 'Geografi', text: 'Samudra manakah yang paling luas di Bumi?', options: ['Samudra Atlantik', 'Samudra Pasifik', 'Samudra Hindia', 'Samudra Arktik'], correctIndex: 1, explanation: 'Samudra Pasifik merupakan samudra terluas di Bumi.'),
  Question(id: 'water', category: 'Sains', text: 'Apa rumus kimia air?', options: ['CO₂', 'O₂', 'NaCl', 'H₂O'], correctIndex: 3, explanation: 'Satu molekul air terdiri dari dua atom hidrogen dan satu atom oksigen: H₂O.'),
  Question(id: 'language', category: 'Bahasa', text: 'Kata mana yang merupakan sinonim dari “cerdas”?', options: ['Pandai', 'Lambat', 'Ragu', 'Lelah'], correctIndex: 0, explanation: 'Pandai dan cerdas memiliki makna yang berdekatan, yaitu mampu memahami atau mempelajari sesuatu dengan baik.'),
  Question(id: 'triangle', category: 'Matematika', text: 'Berapa jumlah sudut dalam sebuah segitiga pada bidang datar?', options: ['90°', '270°', '180°', '360°'], correctIndex: 2, explanation: 'Pada geometri bidang datar, jumlah ketiga sudut dalam segitiga adalah 180°.'),
  Question(id: 'device', category: 'Teknologi', text: 'Perangkat mana yang digunakan untuk memasukkan teks ke komputer?', options: ['Monitor', 'Keyboard', 'Speaker', 'Printer'], correctIndex: 1, explanation: 'Keyboard adalah perangkat input untuk mengetik teks dan perintah.'),
  Question(id: 'pancasila', category: 'Kewarganegaraan', text: 'Berapa jumlah sila dalam Pancasila?', options: ['Tiga', 'Empat', 'Enam', 'Lima'], correctIndex: 3, explanation: 'Pancasila terdiri dari lima sila yang menjadi dasar negara Indonesia.'),
];
