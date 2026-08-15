# MovieApp (iOS)

A modern, fluid iOS movie application built using **SwiftUI**, **Swift Concurrency (`async/await`)**, and **MVVM + Clean Architecture**, powered by The Movie Database (TMDb) API.

---

## 🚀 Setup & Installation

### Requirements
- **macOS**: Sonoma 14.0 or later
- **Xcode**: 16.0+
- **iOS Deployment Target**: iOS 18.0+
- **Simulator / Device**: iPhone Simulator or physical iOS device

### Dependencies
- **Zero Third-Party Dependencies**: Built 100% with native Apple frameworks (`SwiftUI`, `Observation`, `WebKit`, `UIKit`, `Foundation`).

### TMDb API Key Configuration
The app uses TMDb API v3. An API key is pre-configured in [`NetworkEndpoint.swift`](file:///Users/harshal/Documents/Projects/iOS/MovieApp/MovieApp/Core/Network/NetworkEndpoint.swift):
```swift
// MovieApp/Core/Network/NetworkEndpoint.swift
var APIKey: String {
    "0a45c058ffff0ff4fa6c3a9c73bd38d9" // Replace with your own TMDb API key if desired
}
```

### Build & Run Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd MovieApp
   ```
2. Open the project in Xcode:
   ```bash
   open MovieApp.xcodeproj
   ```
3. Select the `MovieApp` scheme and an iOS Simulator (e.g. `iPhone 16 Pro`).
4. Press `Cmd + R` to build and run, or build via the terminal:
   ```bash
   xcodebuild -scheme MovieApp -destination 'generic/platform=iOS Simulator' build
   ```

---

## 📌 Architecture & Design Decisions

The application follows **Clean Architecture** with a unidirectional data flow and strict separation of concerns:

- **Core Layer**:
  - `NetworkClient`: Generic concurrency client managing `URLSession` data tasks, HTTP response status verification, JSON decoding, and standard `CancellationError` normalization.
  - `ImageCache` & `CachedAsyncImage`: In-memory `NSCache` image store with synchronous 0ms frame-0 cache lookup (eliminating placeholder flicker) and automatic memory-pressure purging.
  - `FavoritesStore`: Reactive `@Observable @MainActor` store backed by `UserDefaults` to decouple persistence from the UI.
  - `FlowLayout`: Custom SwiftUI `Layout` protocol component for dynamic multi-line tag/chip wrapping.
  - `ShimmerModifier`: `TimelineView(.animation)` hardware-accelerated linear gradient shimmer using relative `UnitPoint` coordinates to prevent scroll hitching.
- **Domain Layer**:
  - `Movie`, `MovieDetails`, `CastMember`, `Genre`, `Video`: Plain Swift `Codable` and `Identifiable` data models with computed helper formatters.
  - `MovieRepository`: Abstract data repository protocol and its concrete implementation `DefaultMovieRepository`.
- **Feature Layer**:
  - `Home`: `HomeViewModel` (keystroke debouncing, silent cancellations) and `HomeView` (animated search transitions, 4-item skeleton loading, inline "Try Again" error card).
  - `Detail`: `DetailViewModel` (instant title display, async details & trailer fetching) and `DetailView` (scroll-driven navigation title transition, 16:9 YouTube trailer embed, cast carousel, inline "Try Again" error card).

---

## ✨ Implemented Features

### 1. Popular Movies Feed
- Fetches and displays popular movies from TMDb on view appearance.
- Renders high-quality cached poster cards, movie title, star rating badge, and release year.
- **Inline Error Handling**: Replaces disruptive alert popups with a centered "Try Again" retry card on network failure.

### 2. Real-Time Debounced Search
- Integrated native `.searchable` search bar, displayed once movies are successfully loaded.
- **350ms Keystroke Debouncing**: Cancels previous in-flight network tasks as the user types.
- **Silent Cancellation**: Discarded search requests do not trigger disruptive error alerts.
- **Smooth Result Animations**: `.animation(.easeInOut(duration: 0.25))` ensures fluid row insertions, deletions, and state cross-fades between results and empty states.

### 3. Persistent Favorites Synchronization
- Interactive heart button on both list rows and the detail toolbar with haptic feedback (`.sensoryFeedback`).
- Real-time cross-screen synchronization between Home and Detail views.
- Automatic disk persistence using `UserDefaults` across app launches.

### 4. Movie Detail Screen
- **Instant Title Display**: Displays the movie title immediately upon transition using summary data while full details load in the background.
- **16:9 Embedded YouTube Trailer Player**: Custom `WKWebView` iframe embed loading the official TMDb YouTube trailer with active loading shimmer and 0.8s fallback navigation timeout.
- **Backdrop Fallback**: Displays the wide backdrop image if no trailer is available.
- **Dynamic Multi-Line Wrapping Genre Chips**: Uses custom `FlowLayout` to automatically wrap chips onto new lines without horizontal clipping or scrollbars.
- **Storyline & Cast Carousel**: Displays plot summary and a horizontal scrollable cast list with fixed-size photo cards and tight 2pt typography spacing.
- **Error State Handling**: Clear inline error card with a dedicated "Try Again" retry action.

### 5. Interactive Scroll-Driven Navigation Title
- Powered by Apple's native `.onScrollGeometryChange(for:of:action:)` API.
- Hides the navigation title when the user is at the top of the detail screen.
- Smoothly reveals, slides (`offset(y: 6 -> 0)`), and fades in (`opacity: 0 -> 1`) the middle title in the navigation bar as the in-body title merges past the top navigation bar threshold (`offset > 160pt`).

### 6. Zero-Flicker In-Memory Image Cache
- Thread-safe `NSCache<NSURL, UIImage>` service with a 150-image count limit and 80MB memory cap.
- Listens to `UIApplication.didReceiveMemoryWarningNotification` to automatically flush bitmaps under memory pressure.
- Synchronous `init` lookup eliminates the 1-frame blank/shimmer flash during list scrolling.

### 7. Fluid Skeleton Shimmer Loaders
- `TimelineView(.animation)`-based linear shimmer synchronized across all visible components at 60/120 FPS.
- Uniform rectangular shimmers (`.rectangleShimmer(...)`) for text lines and metadata badges with inline icons.

---

## 💡 Assumptions

1. **TMDb API Availability**: Assumes an active internet connection to communicate with `https://api.themoviedb.org/3/`.
2. **YouTube Video Embeds**: Assumes all video keys returned by the TMDb `/videos` endpoint are hosted on YouTube.
3. **In-Memory Image Caching**: In-memory caching via `NSCache` is sufficient for image performance during an active session, avoiding persistent disk cache overhead.
4. **Favorites Storage**: `UserDefaults` with JSON encoding is suitable for storing lightweight favorite movie ID sets (`Set<Int>`).

---

## ⚠️ Known Limitations

1. **Single-Page Fetching**: Currently fetches the first page (20 movies) for popular movies and search results. Infinite scroll pagination can be added if multi-page browsing is needed.
2. **Offline Mode**: Video trailers require an active internet connection for YouTube iframe playback; cached posters are available in-memory while the app is alive.
3. **Restricted Video Playback**: Certain YouTube videos with embedding restrictions set by content owners may require opening externally in the YouTube app.
