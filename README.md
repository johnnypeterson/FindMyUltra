# FindMyUltra

FindMyUltra is an iOS application that helps ultra marathon runners discover races nearby. The project is organised as a standard Xcode project and includes several SwiftUI views, a lightweight networking layer and a small collection of unit tests.

## Project Structure

```
FindMyUltra/           - Application source code
|-- Helpers/           - Shared constants and utilities
|-- Model/             - Codable models and view models
|-- Network/           - Networking client used to fetch race data
|-- Views/             - SwiftUI views
|   |-- MapViews/      - Map view and its view model
|   |-- RaceList/      - List view of upcoming races
|   |-- RaceDetails/   - Race detail view
|   |-- FilterView/    - UI for filtering search results
|-- Home.swift         - Main tab view
|-- FindMyUltraApp.swift - App entry point

FindMyUltraTests/      - Unit tests
```

### Key Components

- **Networking** – `Network/` defines `GenericApi` and `Client` used to perform network requests. `ApiError` enumerates possible error states.
- **Models** – `Model/` contains data structures for events, locations and search filters. Many models conform to `Codable` so data from the API can be decoded easily.
- **Map and List** – `MapView` and `RaceList` provide map and list based browsing of races. Both rely on `MapViewModel` which manages fetching events, requesting user location and applying filters.
- **Filtering** – `FilterView` allows users to search for an address and adjust difficulty, distance and month filters. It uses `MapViewModel` to update results.
- **Unit Tests** – Basic tests live in `FindMyUltraTests/` and cover parts of the networking code and query creation in `MapViewModel`.

## Running the App

Open `FindMyUltra.xcodeproj` in Xcode and run the `FindMyUltra` scheme on an iOS simulator or device. Location services must be enabled to view races relative to your current position.

## Running Tests

The repository contains unit tests located in `FindMyUltraTests`. Run them using Xcode's **Product → Test** menu. Command line testing via `xcodebuild` is also possible on macOS environments that have Xcode installed.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests if you find bugs or would like to add features.

