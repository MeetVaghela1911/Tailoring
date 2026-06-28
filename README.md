# ✂️ Stitch — Digital Tailoring Management

A modern Flutter application that helps tailors and garment businesses manage their customers, orders, measurements, and shop — all from their phone. Built with clean architecture, offline-first storage, and multi-language support for tailors across India.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Storage-FFCA28?logo=firebase)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)
![License](https://img.shields.io/badge/License-Proprietary-red)

---

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Supported Languages](#-supported-languages)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Configuration](#-configuration)
- [Screenshots](#-screenshots)
- [Contributing](#-contributing)

---

## ✨ Features

### 🔐 Authentication
- Email/Password sign-up and login
- Google Sign-In integration
- Persistent authentication with auto-redirect

### 👥 Customer Management
- Add, edit, and delete customer profiles
- Store customer contact details and location
- Search and browse customer list

### 📦 Order Tracking
- Multi-step order creation wizard:
  1. **Select Customer** — choose or add a customer
  2. **Add Items** — select garment types for the order
  3. **Take Measurements** — record body measurements per garment
  4. **Schedule** — set delivery and pickup dates
  5. **Payment** — capture pricing and payment details
- View order details and manage order lifecycle
- Update and delete orders

### 📐 Measurement Templates
- Create reusable garment templates (e.g., Shirt, Trouser, Blouse)
- Define custom measurement fields per template
- Set base pricing, categories, and icons
- View and manage template details

### 🏪 Shop Onboarding
- Guided shop setup flow for first-time users
- Role selection (Tailor, Boutique, etc.)
- Shop details configuration (name, address, location via GPS)
- Profile management and shop settings

### 📊 Dashboard
- Central home screen with quick access to all features
- Overview of customers, orders, and templates

### ☁️ Cloud Sync
- Automatic data synchronization across devices
- Firebase Firestore for cloud storage
- Supabase integration for extended backend capabilities
- Isar local database for offline-first experience

### 🌙 Theming
- Light and dark theme support
- System theme auto-detection
- Custom color scheme with premium UI design

### 🔒 Privacy & Security
- Built-in privacy policy screen
- Secure authentication flow
- User data protection

---

## 🏗 Architecture

The project follows **Clean Architecture** principles with a clear separation of concerns:

```
Feature/
├── data/              # Data layer
│   ├── datasources/   # Remote & local data sources
│   ├── models/        # Data models (serialization)
│   └── repositories/  # Repository implementations
├── domain/            # Domain layer
│   ├── entities/      # Business entities
│   ├── repositories/  # Repository contracts (abstract)
│   └── usecases/      # Business logic use cases
└── presentation/      # Presentation layer
    ├── bloc/          # BLoC state management
    ├── screens/       # UI screens
    └── widgets/       # Reusable widgets
```

### State Management
- **flutter_bloc** — Primary state management for Auth, Customers, Orders, and Templates
- **flutter_riverpod** — Used for additional reactive state needs

### Dependency Injection
- **get_it** — Service locator for registering and resolving all dependencies

### Navigation
- **go_router** — Declarative routing with auth-based redirects and animated page transitions

---

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter (Dart 3.10+) |
| **State Management** | BLoC, Riverpod |
| **Navigation** | GoRouter |
| **Auth** | Firebase Auth, Google Sign-In |
| **Cloud Database** | Firebase Firestore, Supabase |
| **Local Database** | Isar |
| **Storage** | Firebase Storage |
| **Location** | Geolocator, Geocoding |
| **Media** | Image Picker |
| **DI** | GetIt |
| **Functional** | Dartz (Either type) |
| **Fonts** | Google Fonts |
| **Localization** | Flutter Intl (ARB-based) |
| **Testing** | flutter_test, Mocktail |

---

## 🌐 Supported Languages

Stitch supports **10 Indian languages** plus English, making it accessible to tailors across India:

| Language | Code |
|---|---|
| English | `en` |
| हिन्दी (Hindi) | `hi` |
| বাংলা (Bengali) | `bn` |
| ગુજરાતી (Gujarati) | `gu` |
| ಕನ್ನಡ (Kannada) | `kn` |
| मराठी (Marathi) | `mr` |
| ਪੰਜਾਬੀ (Punjabi) | `pa` |
| தமிழ் (Tamil) | `ta` |
| తెలుగు (Telugu) | `te` |
| اردو (Urdu) | `ur` |

---

## 📂 Project Structure

```
lib/
├── main.dart                  # App entry point
├── firebase_options.dart      # Firebase configuration
├── routes/
│   └── app_router.dart        # GoRouter route definitions
├── l10n/                      # Localization (ARB files + generated code)
├── core/
│   ├── database/              # Isar database setup
│   ├── error/                 # Failure classes
│   ├── locale/                # Locale provider
│   ├── service/               # Auth & storage services
│   ├── theme/                 # App theme, colors, common methods
│   ├── usecase/               # Base use case contract
│   ├── utility/               # DI setup, Supabase config, helpers
│   └── widgets/               # Shared widgets
└── features/
    ├── auth/                  # Authentication (login, signup, bloc)
    ├── customers/             # Customer management (CRUD)
    ├── dashboard/             # Home screen
    ├── onboarding/            # Shop setup, role selection, language
    ├── orders/                # Order management (multi-step creation)
    ├── splash/                # Splash & welcome screens
    ├── sync/                  # Cloud sync service
    └── templates/             # Measurement templates
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel stable, Dart ≥ 3.10.1)
- A Firebase project (for Auth, Firestore, and Storage)
- A Supabase project (for extended backend)
- Android Studio / VS Code with Flutter plugins

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/tailoring_flutter.git
   cd tailoring_flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Isar schemas:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Generate localization files:**
   ```bash
   flutter gen-l10n
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

---

## ⚙️ Configuration

### Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password + Google Sign-In)
3. Enable **Cloud Firestore** and **Firebase Storage**
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
5. Place them in the appropriate platform directories
6. Update `lib/firebase_options.dart` using the FlutterFire CLI:
   ```bash
   flutterfire configure
   ```

### Supabase Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Update the Supabase URL and anon key in `lib/core/utility/supabase_config.dart`

---

## 📸 Screenshots

> *Coming soon — screenshots of the app's key screens.*

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is proprietary. All rights reserved.

---

<p align="center">
  Built with ❤️ using Flutter
</p>
