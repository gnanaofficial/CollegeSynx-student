# CollegeSynx Student App

A robust Flutter application designed for students, rebranded as **CollegeSynx**. This app provides a seamless interface for students to manage their academic life, view events, track disciplinary cases, and verify their identity, powered by **Firebase Firestore** for real-time data integration.

## 🚀 Key Features

- **Authentication & Security**:
  - Secure login with Student ID/Email.
  - **MPIN & Biometric Security**: Enforced MPIN setup and biometric authentication for quick and secure access.
- **Dynamic Student Dashboard**:
  - **Home**: Real-time view of attendance, earned credits, ongoing cases, and upcoming events.
  - **Pull-to-Refresh**: Keep data up-to-date with a simple swipe gesture across Home, Profile, Cases, and Events screens.
- **Event Management**:
  - **Browse & Register**: View upcoming campus events fetched dynamically from Firestore.
  - **Instant Registration**: Register for events directly within the app with capacity handling.
  - **Status Tracking**: See "Registered" status for events you are attending.
- **Case Tracking**:
  - **Ongoing Cases**: View detailed information about disciplinary or administrative cases.
  - **Status Indicators**: Visual cues for Pending, Approved, or Rejected statuses.
- **Profile Management**:
  - View personal and academic details (Program, Department, Batch).
  - Digital ID verification.

## 🛠️ Architecture & Tech Stack

The project follows a **Clean Architecture** principle to ensure scalability, testability, and maintainability.

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: `flutter_riverpod` (v2)
- **Backend**: Firebase Firestore (Real-time Database)
- **Routing**: `go_router`
- **Fonts**: Google Fonts (Outfit)
- **UI Components**: Material 3 Design
- **Structure**:
  - `presentation`: UI Widgets, Screens, and Riverpod Providers.
  - `domain`: Entities, Use Cases, and Repository Interfaces.
  - `data`: Firestore Repository implementations and Models.
  - `core`: Shared configuration, themes, and utilities.

## 🏁 Getting Started

1.  **Prerequisites**:
    - Flutter SDK (3.10.4 or higher)
    - Dart SDK
    - Firebase Project configured (google-services.json present)

2.  **Installation**:

    ```bash
    git clone https://github.com/gnanaofficial/CollegeSynx-student.git
    cd svce-student-student
    flutter pub get
    ```

3.  **Run the App**:

    ```bash
    flutter run
    ```

4.  **Analysis**:
    To ensure code quality, run:
    ```bash
    flutter analyze
    ```

## 📱 Project Structure

```
lib/
├── core/                   # Global configs, routing, theme
├── domain/                 # Business Logic & Entities
├── data/                   # Firestore Repositories & DTOs
├── features/
│   ├── auth/               # Login, MPIN, Biometrics
│   ├── cases/              # Ongoing cases module
│   ├── events/             # Events and Updates module
│   ├── student_home/       # Dashboard and Stats
│   ├── student_main/       # Bottom Navigation Shell
│   └── student_profile/    # Profile management
└── main.dart               # Entry point
```

## 🔑 Test Credentials

The app includes fallback logic for development to ensure UI elements are visible even without specific authentication states.

- **Default Test ID**: `24BFA33L12` (Used for mock/fallback data fetching)
