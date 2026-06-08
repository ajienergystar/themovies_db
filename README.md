# themovies_db

A native iOS application that displays movie information using data from [The Movie Database (TMDb) API](https://www.themoviedb.org/documentation/api). Users can browse official genres, discover films by genre, view movie details, read user reviews, play YouTube trailers directly in the app, and scroll endlessly through movie and review lists via pagination.

**Repository:** [https://github.com/ajienergystar/themovies_db](https://github.com/ajienergystar/themovies_db)

---

## Table of Contents

- [About the Project](#about-the-project)
- [Key Features](#key-features)
- [Technologies Used](#technologies-used)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Application Flow](#application-flow)
- [Prerequisites](#prerequisites)
- [Tutorial: From Clone to Running](#tutorial-from-clone-to-running)
- [TMDb API Key Configuration](#tmdb-api-key-configuration)
- [Running the Application](#running-the-application)
- [Running Unit Tests](#running-unit-tests)
- [API Endpoints Used](#api-endpoints-used)
- [Error Handling](#error-handling)
- [License](#license)

---

## About the Project

**themovies_db** is a native iOS mobile application built with **Swift** and **UIKit**. It consumes the TMDb REST API to display a real-time movie catalog, complete with posters, backdrops, movie metadata, user reviews, and video trailers.

This project is designed as an example of a modern iOS application with:

- **VIPER** architecture (View, Interactor, Presenter, Entity, Router) for clear separation of concerns
- **async/await** networking with `URLSession`
- Programmatic UI without Storyboards for main screens (except Launch Screen)
- Reusable UI components
- Consistent loading, empty, and error state handling across all screens

The app supports **iOS 16.6** and above and is optimized for iPhone.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Genre List** | Displays all official TMDb movie genres in a grid layout |
| **Discover Movies by Genre** | Shows a list of movies based on the user's selected genre |
| **Movie Detail** | Full information: title, poster, backdrop, rating, release date, runtime, genres, and overview |
| **About & Reviews Tabs** | Two tabs on the detail page: movie information and user reviews |
| **YouTube Trailer** | Plays official movie trailers directly in the app via `WKWebView` embed |
| **Infinite Scroll** | Automatic pagination when the user scrolls near the end of movie or review lists |
| **State Management** | Loading, empty state, and error views with a retry button on every screen |
| **Image Caching** | Posters and backdrops are cached using the Kingfisher library |

---

## Technologies Used

| Category | Technology |
|----------|------------|
| Language | Swift 5 |
| UI Framework | UIKit (programmatic UI) |
| Minimum iOS | 16.6 |
| Networking | URLSession + async/await |
| Image Loading | [Kingfisher](https://github.com/onevcat/Kingfisher) 8.9.0 |
| Video Player | WKWebView (YouTube embed) |
| Dependency Manager | Swift Package Manager (SPM) |
| Testing | Swift Testing framework |
| Linting | SwiftLint |

---

## Architecture

The application uses the **VIPER** pattern with three main modules:

```
┌─────────────────────────────────────────────────────────┐
│                        VIPER Module                      │
├──────────┬───────────┬────────────┬──────────┬──────────┤
│   View   │ Presenter │ Interactor │  Entity  │  Router  │
│ (VC)     │ (Logic)   │ (Data)     │ (Model)  │ (Nav)    │
└──────────┴───────────┴────────────┴──────────┴──────────┘
```

### Application Modules

1. **GenreList** — Initial screen displaying the list of movie genres
2. **MovieList** — Movie list for the selected genre (with pagination)
3. **MovieDetail** — Movie details, YouTube trailer, and reviews (with pagination)

Each module has its own contract (protocol) files to facilitate testing and dependency injection.

### Additional Layers

- **Core/Network** — `APIClient`, `TMDBEndpoint`, and networking protocols
- **Core/Error** — `AppError` enum with user-friendly error messages
- **Core/Constants** — TMDb base URL and API key configuration
- **Components** — Reusable views (`StateView`, `MoviePosterCell`, `ReviewCardView`, etc.)
- **Models** — Codable structs for API responses (`Genre`, `Movie`, `MovieDetail`, `Review`, `Video`)

---

## Project Structure

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

## Application Flow

```
Genre List  →  Movie List (per genre)  →  Movie Detail
                                              ├── About Tab (overview + trailer)
                                              └── Reviews Tab (reviews + pagination)
```

1. When the app launches, `SceneDelegate` loads the **GenreList** module as the root view controller
2. User selects a genre → navigates to **MovieList**
3. User selects a movie → navigates to **MovieDetail**
4. On the detail page, the user can switch between About and Reviews tabs, and play the YouTube trailer

---

## Prerequisites

Before getting started, ensure your machine meets the following requirements:

| Requirement | Minimum Version |
|-------------|-----------------|
| macOS | Ventura 13.0 or later |
| Xcode | 15.0 or later |
| iOS Simulator / Device | iOS 16.6 or later |
| TMDb Account | Free — required to obtain an API Key |
| Git | Latest version |
| Internet Connection | Required when running the application |

---

## Tutorial: From Clone to Running

### Step 1 — Clone the Repository

Open Terminal and run the following commands:

```bash
git clone https://github.com/ajienergystar/themovies_db.git
cd themovies_db
```

### Step 2 — Open the Project in Xcode

```bash
open TheMovies.xcodeproj
```

Or open Xcode manually, then select **File → Open** and navigate to `TheMovies.xcodeproj`.

### Step 3 — Resolve Swift Package Dependencies

When you first open the project, Xcode will automatically download Swift Package Manager dependencies (Kingfisher). If they have not been downloaded yet:

1. In Xcode, go to **File → Packages → Resolve Package Versions**
2. Wait for the process to complete (progress indicator at the top of Xcode)

### Step 4 — Configure TMDb API Key

See the [TMDb API Key Configuration](#tmdb-api-key-configuration) section below.

### Step 5 — Select Target & Simulator

1. In the Xcode toolbar, ensure the **TheMovies** scheme is selected
2. Choose an iPhone simulator (e.g. **iPhone 16**) or a connected physical device

### Step 6 — Build & Run

Press **⌘ + R** or click the **Run** (▶) button in the Xcode toolbar.

The app will be built and launched on the selected simulator or device.

---

## TMDb API Key Configuration

The application requires a TMDb API Key to access movie data.

### Obtaining an API Key

1. Create a free account at [https://www.themoviedb.org/signup](https://www.themoviedb.org/signup)
2. Log in, then go to **Settings → API** in your account dashboard
3. Request an API Key (select the **Developer** type)
4. Copy the provided **API Key (v3 auth)**

### Adding the API Key to the Project

Open `TheMovies/Core/Constants/TMDBConstants.swift` and replace the `apiKey` value with your API Key:

```swift
enum TMDBConstants {
    static let apiKey = "YOUR_API_KEY_HERE"
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let backdropBaseURL = "https://image.tmdb.org/t/p/w780"
    static let youtubeEmbedBaseURL = "https://www.youtube.com/embed/"
}
```

> **Security note:** Do not commit your personal API Key to a public repository. For further development, consider moving the key to an ignored configuration file (e.g. `Config.xcconfig` or `Secrets.plist` listed in `.gitignore`).

---

## Running the Application

### Via Xcode (Recommended)

```bash
# Open the project
open TheMovies.xcodeproj

# Build & Run: press ⌘ + R
```

### Via Command Line

```bash
# Build for simulator
xcodebuild -scheme TheMovies \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build

# Build and run on simulator
xcodebuild -scheme TheMovies \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -derivedDataPath build \
  build

xcrun simctl boot "iPhone 16" 2>/dev/null || true
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/TheMovies.app
xcrun simctl launch booted Owner.TheMovies
```

> Replace `iPhone 16` with a simulator name available on your machine. List available simulators with: `xcrun simctl list devices available`

---

## Running Unit Tests

### Via Xcode

Press **⌘ + U** to run all tests, or right-click the test target and select **Run**.

### Via Command Line

```bash
xcodebuild test \
  -scheme TheMovies \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## API Endpoints Used

| TMDb Endpoint | Used In | Purpose |
|---------------|---------|---------|
| `GET /genre/movie/list` | GenreList | Fetch the list of movie genres |
| `GET /discover/movie` | MovieList | Discover movies by genre (with pagination) |
| `GET /movie/{id}` | MovieDetail | Full details for a movie |
| `GET /movie/{id}/reviews` | MovieDetail | User reviews for a movie (with pagination) |
| `GET /movie/{id}/videos` | MovieDetail | Available videos/trailers for a movie |

All requests include the `api_key` parameter and use the base URL `https://api.themoviedb.org/3`.

---

## Error Handling

The application handles various error scenarios through the `AppError` enum:

| Error | User Message |
|-------|--------------|
| `networkUnavailable` | No internet connection |
| `invalidResponse` | Invalid server response |
| `decodingFailed` | Failed to process data from the server |
| `serverError(statusCode)` | Server error with HTTP status code |
| `emptyData` | No data available |

Every screen displays a `StateView` with a **Retry** button when an error occurs, so users can reload data without leaving the screen.

---

## License

This project is created for educational purposes and as a demonstration of TMDb API integration in a native iOS application.

---

## Contributors

Developed by **Aji Prakosa** — [GitHub: ajienergystar](https://github.com/ajienergystar)
