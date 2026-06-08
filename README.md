# themovies_db

Aplikasi iOS native yang menampilkan informasi film menggunakan data dari [The Movie Database (TMDb) API](https://www.themoviedb.org/documentation/api). Pengguna dapat menjelajahi genre resmi, menemukan film berdasarkan genre, melihat detail film, membaca ulasan pengguna, memutar trailer YouTube langsung di dalam aplikasi, serta men-scroll daftar film dan ulasan tanpa batas melalui pagination.

**Repository:** [https://github.com/ajienergystar/themovies_db](https://github.com/ajienergystar/themovies_db)

---

## Daftar Isi

- [Tentang Projek](#tentang-projek)
- [Fitur Utama](#fitur-utama)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Arsitektur](#arsitektur)
- [Struktur Projek](#struktur-projek)
- [Alur Aplikasi](#alur-aplikasi)
- [Prasyarat](#prasyarat)
- [Tutorial: Dari Clone hingga Menjalankan](#tutorial-dari-clone-hingga-menjalankan)
- [Konfigurasi API Key TMDb](#konfigurasi-api-key-tmdb)
- [Menjalankan Aplikasi](#menjalankan-aplikasi)
- [Menjalankan Unit Test](#menjalankan-unit-test)
- [Endpoint API yang Digunakan](#endpoint-api-yang-digunakan)
- [Penanganan Error](#penanganan-error)
- [Lisensi](#lisensi)

---

## Tentang Projek

**themovies_db** adalah aplikasi mobile iOS yang dibangun dengan **Swift** dan **UIKit**. Aplikasi ini mengonsumsi REST API TMDb untuk menampilkan katalog film secara real-time, lengkap dengan poster, backdrop, metadata film, ulasan pengguna, dan trailer video.

Projek ini dirancang sebagai contoh implementasi aplikasi iOS modern dengan:

- Arsitektur **VIPER** (View, Interactor, Presenter, Entity, Router) untuk pemisahan tanggung jawab yang jelas
- Networking berbasis **async/await** dengan `URLSession`
- UI programmatic tanpa Storyboard untuk layar utama (kecuali Launch Screen)
- Komponen UI yang dapat digunakan kembali (reusable components)
- Penanganan state loading, empty, dan error yang konsisten di seluruh layar

Aplikasi mendukung **iOS 16.6** ke atas dan dioptimalkan untuk iPhone.

---

## Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| **Daftar Genre** | Menampilkan seluruh genre film resmi dari TMDb dalam tampilan grid |
| **Discover Film per Genre** | Menampilkan daftar film berdasarkan genre yang dipilih pengguna |
| **Detail Film** | Informasi lengkap: judul, poster, backdrop, rating, tanggal rilis, durasi, genre, dan sinopsis |
| **Tab About & Reviews** | Dua tab pada halaman detail: informasi film dan daftar ulasan pengguna |
| **Trailer YouTube** | Memutar trailer resmi film langsung di dalam aplikasi via `WKWebView` embed |
| **Infinite Scroll** | Pagination otomatis saat pengguna scroll mendekati akhir daftar film maupun ulasan |
| **State Management** | Tampilan loading, empty state, dan error dengan tombol retry di setiap layar |
| **Caching Gambar** | Poster dan backdrop di-cache menggunakan library Kingfisher |

---

## Teknologi yang Digunakan

| Kategori | Teknologi |
|----------|-----------|
| Bahasa | Swift 5 |
| UI Framework | UIKit (programmatic UI) |
| Minimum iOS | 16.6 |
| Networking | URLSession + async/await |
| Image Loading | [Kingfisher](https://github.com/onevcat/Kingfisher) 8.9.0 |
| Video Player | WKWebView (YouTube embed) |
| Dependency Manager | Swift Package Manager (SPM) |
| Testing | Swift Testing framework |
| Linting | SwiftLint |

---

## Arsitektur

Aplikasi menggunakan pola **VIPER** dengan tiga modul utama:

```
┌─────────────────────────────────────────────────────────┐
│                        VIPER Module                      │
├──────────┬───────────┬────────────┬──────────┬──────────┤
│   View   │ Presenter │ Interactor │  Entity  │  Router  │
│ (VC)     │ (Logic)   │ (Data)     │ (Model)  │ (Nav)    │
└──────────┴───────────┴────────────┴──────────┴──────────┘
```

### Modul Aplikasi

1. **GenreList** — Layar awal yang menampilkan daftar genre film
2. **MovieList** — Daftar film berdasarkan genre terpilih (dengan pagination)
3. **MovieDetail** — Detail film, trailer YouTube, dan ulasan (dengan pagination)

Setiap modul memiliki file kontrak (protocol) sendiri untuk memudahkan testing dan dependency injection.

### Layer Tambahan

- **Core/Network** — `APIClient`, `TMDBEndpoint`, dan protokol networking
- **Core/Error** — `AppError` enum dengan pesan error yang user-friendly
- **Core/Constants** — Konfigurasi base URL dan API key TMDb
- **Components** — Reusable views (`StateView`, `MoviePosterCell`, `ReviewCardView`, dll.)
- **Models** — Struct Codable untuk response API (`Genre`, `Movie`, `MovieDetail`, `Review`, `Video`)

---

## Struktur Projek

```
themovies_db/
├── TheMovies/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Core/
│   │   ├── Constants/TMDBConstants.swift
│   │   ├── Error/AppError.swift
│   │   └── Network/
│   │       ├── APIClient.swift
│   │       ├── APIClientProtocol.swift
│   │       └── TMDBEndpoint.swift
│   ├── Models/
│   │   ├── Genre.swift
│   │   ├── Movie.swift
│   │   ├── MovieDetail.swift
│   │   ├── Review.swift
│   │   └── Video.swift
│   ├── Modules/
│   │   ├── GenreList/
│   │   ├── MovieList/
│   │   └── MovieDetail/
│   ├── Components/
│   │   ├── Layout/
│   │   ├── Theme/
│   │   └── Views/
│   └── Helper/
├── TheMoviesTests/
├── TheMoviesUITests/
├── TheMovies.xcodeproj/
├── .swiftlint.yml
└── README.md
```

---

## Alur Aplikasi

```
Genre List  →  Movie List (per genre)  →  Movie Detail
                                              ├── Tab About (sinopsis + trailer)
                                              └── Tab Reviews (ulasan + pagination)
```

1. Saat aplikasi dibuka, `SceneDelegate` memuat modul **GenreList** sebagai root view controller
2. Pengguna memilih genre → navigasi ke **MovieList**
3. Pengguna memilih film → navigasi ke **MovieDetail**
4. Di halaman detail, pengguna dapat beralih antara tab About dan Reviews, serta memutar trailer YouTube

---

## Prasyarat

Sebelum memulai, pastikan perangkat Anda memenuhi persyaratan berikut:

| Persyaratan | Versi Minimum |
|-------------|---------------|
| macOS | Ventura 13.0 atau lebih baru |
| Xcode | 15.0 atau lebih baru |
| iOS Simulator / Device | iOS 16.6 atau lebih baru |
| Akun TMDb | Gratis — untuk mendapatkan API Key |
| Git | Versi terbaru |
| Koneksi Internet | Diperlukan saat menjalankan aplikasi |

---

## Tutorial: Dari Clone hingga Menjalankan

### Langkah 1 — Clone Repository

Buka Terminal dan jalankan perintah berikut:

```bash
git clone https://github.com/ajienergystar/themovies_db.git
cd themovies_db
```

### Langkah 2 — Buka Projek di Xcode

```bash
open TheMovies.xcodeproj
```

Atau buka Xcode secara manual, lalu pilih **File → Open** dan arahkan ke file `TheMovies.xcodeproj`.

### Langkah 3 — Resolve Swift Package Dependencies

Saat pertama kali membuka projek, Xcode akan otomatis mengunduh dependensi Swift Package Manager (Kingfisher). Jika belum terunduh:

1. Di Xcode, buka menu **File → Packages → Resolve Package Versions**
2. Tunggu hingga proses selesai (indikator progress di bagian atas Xcode)

### Langkah 4 — Konfigurasi API Key TMDb

Lihat bagian [Konfigurasi API Key TMDb](#konfigurasi-api-key-tmdb) di bawah.

### Langkah 5 — Pilih Target & Simulator

1. Di toolbar Xcode, pastikan scheme **TheMovies** terpilih
2. Pilih simulator iPhone (misalnya **iPhone 16**) atau perangkat fisik yang terhubung

### Langkah 6 — Build & Run

Tekan **⌘ + R** atau klik tombol **Run** (▶) di toolbar Xcode.

Aplikasi akan di-build dan diluncurkan di simulator atau perangkat yang dipilih.

---

## Konfigurasi API Key TMDb

Aplikasi memerlukan API Key dari TMDb untuk mengakses data film.

### Mendapatkan API Key

1. Buat akun gratis di [https://www.themoviedb.org/signup](https://www.themoviedb.org/signup)
2. Login, lalu buka **Settings → API** di dashboard akun Anda
3. Ajukan permohonan API Key (pilih tipe **Developer**)
4. Salin **API Key (v3 auth)** yang diberikan

### Memasang API Key ke Projek

Buka file `TheMovies/Core/Constants/TMDBConstants.swift` dan ganti nilai `apiKey` dengan API Key Anda:

```swift
enum TMDBConstants {
    static let apiKey = "MASUKKAN_API_KEY_ANDA_DI_SINI"
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let backdropBaseURL = "https://image.tmdb.org/t/p/w780"
    static let youtubeEmbedBaseURL = "https://www.youtube.com/embed/"
}
```

> **Catatan keamanan:** Jangan commit API Key pribadi ke repository publik. Untuk pengembangan lanjutan, pertimbangkan memindahkan key ke file konfigurasi yang di-ignore (misalnya `Config.xcconfig` atau `Secrets.plist` yang sudah tercantum di `.gitignore`).

---

## Menjalankan Aplikasi

### Via Xcode (Disarankan)

```bash
# Buka projek
open TheMovies.xcodeproj

# Build & Run: tekan ⌘ + R
```

### Via Command Line

```bash
# Build untuk simulator
xcodebuild -scheme TheMovies \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build

# Build dan jalankan di simulator
xcodebuild -scheme TheMovies \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -derivedDataPath build \
  build

xcrun simctl boot "iPhone 16" 2>/dev/null || true
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/TheMovies.app
xcrun simctl launch booted Owner.TheMovies
```

> Ganti `iPhone 16` dengan nama simulator yang tersedia di mesin Anda. Cek daftar simulator dengan: `xcrun simctl list devices available`

---

## Menjalankan Unit Test

### Via Xcode

Tekan **⌘ + U** untuk menjalankan semua test, atau klik kanan pada target test dan pilih **Run**.

### Via Command Line

```bash
xcodebuild test \
  -scheme TheMovies \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Endpoint API yang Digunakan

| Endpoint TMDb | Digunakan di | Fungsi |
|---------------|--------------|--------|
| `GET /genre/movie/list` | GenreList | Mengambil daftar genre film |
| `GET /discover/movie` | MovieList | Mencari film berdasarkan genre (dengan pagination) |
| `GET /movie/{id}` | MovieDetail | Detail lengkap sebuah film |
| `GET /movie/{id}/reviews` | MovieDetail | Ulasan pengguna untuk film (dengan pagination) |
| `GET /movie/{id}/videos` | MovieDetail | Video/trailer yang tersedia untuk film |

Semua request menyertakan parameter `api_key` dan menggunakan base URL `https://api.themoviedb.org/3`.

---

## Penanganan Error

Aplikasi menangani berbagai skenario error melalui enum `AppError`:

| Error | Pesan ke Pengguna |
|-------|-------------------|
| `networkUnavailable` | Tidak ada koneksi internet |
| `invalidResponse` | Response server tidak valid |
| `decodingFailed` | Gagal memproses data dari server |
| `serverError(statusCode)` | Error server dengan kode HTTP |
| `emptyData` | Tidak ada data tersedia |

Setiap layar menampilkan `StateView` dengan tombol **Retry** saat terjadi error, sehingga pengguna dapat mencoba memuat ulang data tanpa harus keluar dari layar.

---

## Lisensi

Projek ini dibuat untuk keperluan pembelajaran dan demonstrasi integrasi TMDb API pada aplikasi iOS native.

---

## Kontributor

Dikembangkan oleh **Aji Prakosa** — [GitHub: ajienergystar](https://github.com/ajienergystar)
