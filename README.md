# Library Locator App

A Flutter application to help locate books in a library with detailed location information.

## Features

- **Search**: Search books by title or author
- **Book List**: View all available books in a clean list
- **Book Details**: View detailed information including:
  - Title
  - Author
  - Rack location
  - Shelf number
  - Row number
  - Position

## Platform Support

- ✅ Flutter Web (Primary)
- 📱 Mobile responsive (works on phone browsers)

## Design

- Material 3 design system
- Minimal UI for easy navigation
- Clean, user-friendly interface

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- For Android: Android Studio and Android SDK
- For Web: Chrome browser

### Installation

1. Navigate to the project directory:
```bash
cd library_locator_app
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:

For Web:
```bash
flutter run -d chrome
```

For Android:
```bash
flutter run -d android
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── book.dart            # Book data model
├── data/
│   └── sample_books.dart    # Sample book data
└── screens/
    ├── search_screen.dart   # Search and list view
    └── book_detail_screen.dart  # Book detail view
```

## Usage

1. **Search**: Use the search bar to find books by title or author
2. **Browse**: Scroll through the list of available books
3. **View Details**: Tap on any book to see its complete location information
