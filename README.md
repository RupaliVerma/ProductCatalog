# ProductCatalog

A SwiftUI-based iOS app showcasing a product catalog with filtering and favorites functionality, built to demonstrate clean architecture and modern iOS development practices.

## Features
- **Catalog**: Displays products (title, category, price, image) fetched from `https://api.escuelajs.co/api/v1/products`.
- **Filters**: Filter by category (e.g., Clothes, Electronics) or price range ($0-50, $50+).
- **Favorites**: Toggle favorites with a star button, persisted using `UserDefaults`.
- **Responsive UI**: Smooth scrolling, async image loading, and error handling.

## Architecture
- **MVVM**: Separates UI (`CatalogView`) from business logic (`CatalogViewModel`).
- **NetworkService**: Handles async API calls with GCD for non-blocking fetches.
- **Thread-Safe**: Main thread updates for UI consistency.
- **Data Persistence**: Favorites stored as `[String: Bool]` in `UserDefaults`.

## Requirements
- Xcode 16+
- iOS 18+
- Internet connection for API

## Setup
1. Clone the repository.
2. Open `ProductCatalog.xcodeproj` in Xcode.
4. No additional dependencies required.

## Usage
- Launch the app to view the product list.
- Tap "Filter" to select categories or price ranges.
- Tap the star icon to toggle favorites, persisted across sessions.

## Notes
- Built for a test to demonstrate capability: clean code, MVVM, and SwiftUI best practices.
- Uses lightweight MVVM to balance simplicity and structure.
- Error handling ensures robust API interactions.
- Two `for` loops in filtering logic as per requirement.

---

**Author**: Rupali Verma
