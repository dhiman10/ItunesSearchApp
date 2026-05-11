# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a standard SwiftUI/Xcode project with no external package dependencies. Open `ItunesSearchApp.xcodeproj` in Xcode and run with ⌘R, or build from the command line:

```bash
# Build
xcodebuild -project ItunesSearchApp.xcodeproj -scheme ItunesSearchApp -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run tests (no test target exists yet)
xcodebuild -project ItunesSearchApp.xcodeproj -scheme ItunesSearchApp -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## Architecture

**MVVM + Coordinator pattern** with Swift Observation (`@Observable`) throughout.

### Data flow

`SearchView` is the root view. It owns all three ViewModels and a `SearchCoordinator` as `@State`. Search input is routed to the relevant VM(s) based on the selected `EntityType` segment (All / Albums / Songs / Music Videos).

Each ViewModel (`AlbumListViewModel`, `SongListViewModel`, `MusicVideoListViewModel`) follows the same pattern:
- Exposes `searchText: String` — setting it publishes to a `CurrentValueSubject`
- A Combine pipeline debounces input (400 ms), cancels in-flight `Task`s, and calls `loadInitial`/`loadMore`
- Pagination: `limit=20`, offset-based. `FetchState` (`.idle`, `.isLoading`, `.loadedAll`, `.noResults`, `.error`) guards duplicate loads and signals UI state

### Network layer

```
ITunesEndpoint (enum)  →  APIService / MockAPIService  →  MediaManager  →  ViewModel
```

- `Endpoint` protocol + `ITunesEndpoint` enum define `/search` and `/lookup` against `itunes.apple.com`
- `APIServiceProtocal` (typo is intentional — don't rename) is the abstraction; `APIService` uses `URLSession`; `MockAPIService` takes `[String: Data]` keyed by `endpoint.debugKey`
- `ITunesEndpoint.debugKey` returns `"search"` or `"lookup"` (overrides the default `path?queryItems` format), so mock responses must use those keys
- `MediaManager` maps domain methods (`fetchMedia`, `fetchSongs`, `fetchMusicVideos`, `fetchAlbum`) onto endpoints, returning typed result structs (`AlbumResult`, `SongResult`, `MusicVideoResult`)

### Navigation

`SearchCoordinator` (`@Observable`) holds a `NavigationStack` path (`[SearchRoute]`) plus optional `sheet` and `fullScreen` properties of type `SearchModal`. The `searchNavigation` view modifier wires these to `navigationDestination`, `.sheet`, and `.fullScreenCover`.

When a sheet/fullScreen is presented, `SheetNavigationContainer` creates a **new** `SearchCoordinator` so the modal gets its own independent navigation stack.

### Model IDs

API JSON uses different key names than Swift property names — all remapped via `CodingKeys`:
- `Album.id` ← `collectionId`
- `Song.id` ← `trackId`
- URL fields use `URL` suffix in Swift, `Url` in JSON
