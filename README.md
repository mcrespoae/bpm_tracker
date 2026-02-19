# BPM Tracker

A premium, high-precision BPM (Beats Per Minute) tracking application built with Flutter. Designed with a modern glassmorphism aesthetic, it provides real-time tempo analysis with statistical accuracy feedback.

## Features
- **High-Precision Analysis**: Averages the last 25 taps for high stability.
- **Accuracy HUD**: Real-time display of ± Standard Deviation and Accuracy % (Coefficient of Variation).
- **Intelligent Inactivity Detection**: Auto-finalizes measurements after 2 seconds of inactivity.
- **Premium UI**: Dark mode with smooth glassmorphism effects and reactive animations.
- **Persistent History**: Keeps the latest 10 measurements with swipe-to-delete support.
- **Tactile Feedback**: Haptic confirmation for every tap and measurement completion.

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel)
- Android Studio / VS Code with Flutter extension
- An Android Emulator or physical device

### Installation
1.  **Clone the project** or copy the folder to your computer.
2.  **Fetch dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Generate Native Splash**:
    This is required to set up the black startup screen:
    ```bash
    flutter pub run flutter_native_splash:create
    ```
4.  **Run the app**:
    ```bash
    flutter run
    ```

---

## Developer Guide

### Debugging
-   **Hot Reload**: Press `r` in the terminal or use your IDE's lightning icon to apply UI changes instantly.
-   **Debug Console**: View real-time logs and standard deviation updates.

### Creating Builds
-   **Android APK**:
    ```bash
    flutter build apk --release
    ```
-   **Android App Bundle (for Play Store)**:
    ```bash
    flutter build appbundle
    ```

---

## Project Structure & Architecture

The project follows a **Feature-First Clean Architecture** with **Riverpod** for state management.

### [Core](file:///c:/Users/Mario/Documents/bpm_tracker/lib/core)
-   `theme/`: Contains `app_theme.dart` and `app_colors.dart` for the global design system.
-   `widgets/`: Shared UI components like `glass_container.dart`.

### [Features](file:///c:/Users/Mario/Documents/bpm_tracker/lib/features)
#### 1. [Tracker (Main Engine)](file:///c:/Users/Mario/Documents/bpm_tracker/lib/features/tracker)
-   `domain/bpm_calculator.dart`: The core logic for rolling averages and statistical accuracy.
-   `presentation/providers/bpm_provider.dart`: Reactive state management for the tapping session.
-   `presentation/pages/tracker_page.dart`: The main UI with animations and status feedback.

#### 2. [History (Persistence)](file:///c:/Users/Mario/Documents/bpm_tracker/lib/features/history)
-   `domain/bpm_record.dart`: The data model for saved measurements (BPM + Accuracy + Timestamp).
-   `data/history_repository.dart`: Handles `shared_preferences` storage and the 10-item limit logic.
-   `presentation/history_page.dart`: List view with swipe-to-delete (Right-to-Left) and color-coded accuracy.

---

## TODO List
- [ ] **Builds**: Finalize iOS build configuration and icons.
- [ ] **Logos**: Replace temporary black splash with a branded high-res logo.
- [ ] **Publicity**: Integrate AdMob banner in the reserved 80px space at the bottom of `TrackerPage`.
