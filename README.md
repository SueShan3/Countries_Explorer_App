# Countries Explorer

A Flutter application for browsing countries, viewing detailed information, and managing a personal list of favorite countries with notes — powered by the [REST Countries API](https://countries.dev/).

## Features

- **Browse countries** — view a scrollable list of countries with flag, name, and capital
- **Search** — filter countries by name in real time
- **Filter by region** — narrow the list down using a region dropdown, combinable with search
- **Country details** — population, area, currencies, languages, and bordering countries, with tap-to-navigate between related countries
- **Favorites** — save and remove favorite countries with a single tap
- **Notes** — attach a personal note to any favorite country
- **Local persistence** — favorites and notes are saved locally and remain available after restarting the app
- **Error handling** — write operations (add/remove favorite, save note) roll back local state on failure, so the UI never drifts out of sync with what's actually saved

## Architecture

The app follows a Provider-based architecture with a clear separation of concerns:

```
lib
|
├── models          # Data structures
│   ├── country_info_item.dart
|   ├── country.dart
│   └── favorite_country.dart
│
├── services         # External concerns — API calls & local storage
│   ├── api_service.dart
│   └── storage_service.dart
│
├── providers         # State management & business logic
│   ├── base_provider.dart
│   ├── country_provider.dart
│   └── favourite_provider.dart
│
├── constants         # Shared enums/constants
│   └── favorite_error_type.dart
│
├── screens           # Full-page UI
│   ├── countries_list_screen.dart
│   ├── country_detail_screen.dart
│   ├── favorites_screen.dart
│   ├── favorites_note_screen.dart
|   └── main_screen.dart
│
└── widgets           # Reusable UI components
    ├── country_card.dart
    ├── country_dropdown.dart
    ├── country_search_bar.dart
    ├── country_info.dart
    └── border_country_tile.dart
```

- **Models** define the shape of data used throughout the app.
- **Services** handle all external I/O — fetching countries from the REST Countries API, and reading/writing favorites via local storage (SharedPreferences).
- **Providers** (using `ChangeNotifier`) manage application state and business logic, including error state and rollback-on-failure for write operations.
- **Screens & widgets** stay focused purely on presentation, reacting to provider state rather than containing logic themselves.

## Tech Stack

- **Flutter** / Dart
- **Provider** — state management
- **REST Countries API** — country data source
- **SharedPreferences** — local persistence for favorites and notes

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- An emulator/simulator or physical device
- Internet connection (required for fetching country data)

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd countries_explorer_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Project Structure Notes

- `FavouriteProvider` manages favorites state independently from `CountryProvider`, since favorites use a lighter-weight `FavoriteCountry` model containing only the fields needed (code, name, capital, flag, note) rather than the full `Country` model.
- Errors are represented with a `FavoriteErrorType` enum so each failed action (add, remove, note save) surfaces a specific, relevant message rather than one generic error.
- All favorite write operations snapshot state before mutating, and roll back to the snapshot if persistence fails — keeping in-memory state and local storage consistent even when a save fails.

## License

This project was built for educational purposes.