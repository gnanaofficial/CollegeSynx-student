# CollegeSynx Student App

A robust Flutter application designed for students of SVCE (Sri Venkateswara College of Engineering), now rebranded as **CollegeSynx**. This app provides a seamless interface for students to manage their academic life, view events, track cases, and verify their identity.

## 🚀 Key Features

- **Authentication**:
  - Secure login with College ID and Password.
  - **MPIN & Biometric Security**: Enforced MPIN setup and biometric authentication for quick and secure access.
- **Student Dashboard**:
  - **Home**: At-a-glance view of attendance, CGPA, ongoing cases, and upcoming events.
  - **Events**: Browse campus events, register for them, and receive real-time updates.
  - **Cases**: Track discipline or administrative cases (e.g., OD Requests, Bonafide Certificates) with status indicators.
  - **Profile**: View personal and academic details.
- **Navigation**:
  - Smooth routing using **GoRouter** with guarded routes for unauthorized access prevention.

## 🛠️ Architecture & Tech Stack

The project follows a **Clean Architecture** principle to ensure scalability, testability, and maintainability.

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: `flutter_riverpod` (v2)
- **Routing**: `go_router`
- **Fonts**: Google Fonts (Outfit)
- **Structure**:
  - `presentation`: UI Widgets, Screens, and Providers.
  - `domain`: Entities and Business Logic interfaces.
  - `data`: Repositories implementations and Data sources.
  - `core`: Shared configuration, themes, and utilities.

## 🔑 Mock Credentials (For Testing)

Use these credentials to test the application's login flow:

- **Login**: Any non-empty string (Mock Auth)
- **MPIN**: Required to be set on first login (e.g., `1234`).

> **Note**: The app uses mock repositories for data simulation, so no backend connection is required for basic UI testing.

## 🏁 Getting Started

1.  **Prerequisites**:
    - Flutter SDK (3.10.4 or higher)
    - Dart SDK

2.  **Installation**:

    ```bash
    git clone https://github.com/gnanaofficial/Codesynx-student.git
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
├── features/
│   ├── auth/               # Login, MPIN, Biometrics
│   ├── cases/              # Ongoing cases module
│   ├── events/             # Events and Updates module
│   ├── student_home/       # Dashboard and Stats
│   ├── student_main/       # Bottom Navigation Shell
│   └── student_profile/    # Profile management
└── main.dart               # Entry point
```

## Login Credentials:

Username: gnana123
Password: password
