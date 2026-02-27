# METRA

A premium, high-precision BPM (Beats Per Minute) tracking application built with Flutter. Designed with a modern glassmorphism aesthetic, it provides real-time tempo analysis with statistical accuracy feedback.

![METRA Logo](assets/images/logo.png)

## Features
- **High-Precision Analysis**: Averages the last 25 taps for high stability.
- **Accuracy HUD**: Real-time display of ± Standard Deviation and Accuracy % (Coefficient of Variation).
- **Intelligent Inactivity Detection**: Auto-finalizes measurements after 2 seconds of inactivity.
- **Premium UI**: Dark mode with smooth glassmorphism effects and reactive animations.
- **Multi-Language Support**: Fully localized into 12 languages (English, Spanish, Catalan, Portuguese, French, German, Italian, Polish, Japanese, Chinese Simplified, Hindi, Russian).
- **Persistent History**: Keeps the latest 20 measurements with swipe-to-delete support.
- **Smart Ad Integration**: Environment-aware AdMob implementation (Test ads in debug, Real ads in release).

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel)
- Android Studio / VS Code with Flutter extension
- An Android Emulator or physical device

### Installation
1.  **Fetch dependencies**:
    ```bash
    flutter pub get
    ```
2.  **Generate Assets**:
    Generate the app icons and native splash screen:
    ```bash
    flutter pub run flutter_launcher_icons
    flutter pub run flutter_native_splash:create
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

---

## Maintenance Guide

### Asset Generation
If you update `assets/images/logo.png`, run these to update the app:
- **App Icons**: `flutter pub run flutter_launcher_icons`
- **Splash Screen**: `flutter pub run flutter_native_splash:create`

### Localization
To apply changes made to the `.arb` files or add new languages:
```bash
flutter gen-l10n
```

### Testing & Verification
METRA includes a comprehensive test suite to ensure the accuracy of the rhythm engine and UI stability.

1.  **Run all tests**:
    ```bash
    flutter test
    ```

**Test Coverage:**
-   **Unit Tests**: Mathematically verifies the `BPMCalculator`'s plateau, exponential decay, and recovery logic.
-   **Config Tests**: Verifies history limits and localization registration.
-   **Widget Tests**: UI smoke tests with mocked dependencies.

### Creating Builds

#### Android
- **APK (for direct install)**:
    ```bash
    flutter build apk --release
    ```
- **App Bundle (for Google Play)**:
    ```bash
    flutter build appbundle
    ```

#### iOS
- **iOS Build**:
    ```bash
    flutter build ios --release
    ```
    *Note: Final archiving must be done in Xcode.*

---

## Project Structure & Architecture

The project follows a **Feature-First Clean Architecture** with **Riverpod** for state management.

### [Core](lib/core)
-   `theme/`: Design system (colors, typography).
-   `ads/`: Centralized `AdHelper` for environment-based AdMob IDs.
-   `widgets/`: Shared UI components (GlassContainer, BannerAdWidget).

### [Features](lib/features)
#### 1. [Tracker](lib/features/tracker)
-   Core engine for rolling averages and statistical accuracy.
-   Main tapping interface with real-time feedback.

#### 2. [History](lib/features/history)
-   Local storage implementation for persistent records.
-   List view with swipe-to-delete functionality.

#### 3. [Settings](lib/features/settings)
-   App preferences, haptics control, and developer links.
