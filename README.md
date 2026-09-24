# MAPID Mobile Developer Case Study

Flutter mobile application for displaying GEO MAPID tourism data on an OpenFreeMap basemap.

## Features

- OpenFreeMap basemap
- GEO MAPID tourism layer
- Interactive tourism points
- Feature information popup
- Current user location
- Loading and error handling
- Retry mechanism

## Tech Stack

- Flutter
- Dart
- BLoC
- Clean Architecture
- GetIt
- Dio
- Flutter Dotenv
- MapLibre GL
- OpenFreeMap
- Permission Handler

## Architecture

The project uses a lightweight Clean Architecture approach.

The application uses BLoC to separate UI from application state and business flow.

The domain layer does not depend on Flutter, Dio, MapLibre or Geolocator.

The data layer handles external API and device location implementations.

MapLibre-specific rendering and interaction remain inside the presentation layer.

## Environment Setup

Create a .env file in the project root:

```bash
MAPID_API_KEY=YOUR_API_KEY
MAPID_LAYER_ID=YOUR_LAYER_ID
MAPID_PROJECT_ID=YOUR_PROJECT_ID
```

## Run
```bash
flutter pub get
flutter run
```

## Build APK
```bash
flutter clean
flutter pub get
flutter analyze
flutter build apk --release
```
