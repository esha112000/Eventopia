# Eventopia 🎉

[![GitHub Repo](https://img.shields.io/badge/GitHub-esha112000/Eventopia-blue?logo=github)](https://github.com/esha112000/Eventopia.git)

A modern, cross-platform Flutter app for seamless event management — discover, book, and manage events with ease! Integrated with Firebase, Stripe payments, and rich native support for Android, iOS, macOS, and Windows.

---

## 🚀 Features

- **Multi-platform Flutter app**: Android, iOS, macOS, Windows support  
- **Firebase integration**: Authentication, Firestore, Cloud Functions, Analytics  
- **Stripe payments**: Secure event booking and payment processing  
- **Email notifications**: Powered by Firebase Functions  
- **User-friendly UI**: Dashboard, event details, favorites, bookings, profile, FAQ, and support  
- **Secure storage**: Session and token management with flutter_secure_storage  
- **Splash & launch screens**: Native iOS and Android assets configured  
- **State management**: Bloc pattern for reactive UI updates  
- **Localization ready**: Structured for future i18n support  

---

## 📦 Tech Stack

- **Flutter** (Dart 3.5.4, stable channel)  
- **Firebase** (Auth, Firestore, Functions, Analytics)  
- **Stripe** (flutter_stripe package)  
- **Razorpay** (flutter_razorpay for payments)  
- **State Management**: flutter_bloc  
- **Secure Storage**: flutter_secure_storage  
- **HTTP Client**: http package  
- **Environment Config**: flutter_dotenv for `.env` support  
- **Platform-specific**: CocoaPods (iOS), CMake (Windows), Xcode projects (iOS/macOS)  

---

## ⚙️ Requirements

- Flutter SDK (stable channel, 3.7+ recommended)  
- Dart SDK >= 3.5.4  
- Firebase CLI (for deployment and emulators)  
- Xcode (for iOS/macOS builds)  
- Android Studio / SDK (for Android builds)  
- CocoaPods (for iOS dependency management)  
- Windows SDK (for Windows builds)  

---

## 📋 Quickstart

### 1. Clone the repo

```bash
git clone https://github.com/esha112000/Eventopia.git
cd Eventopia
```

### 2. Install dependencies

```bash
flutter pub get
cd ios && pod install && cd ..
```

### 3. Setup environment variables

- Copy `.env.example` to `.env` (not committed to Git)  
- Fill in Firebase config, Stripe keys, and other secrets  

### 4. Run the app

- **Android/iOS**  
  ```bash
  flutter run
  ```
- **macOS**  
  ```bash
  flutter run -d macos
  ```
- **Windows**  
  ```bash
  flutter run -d windows
  ```

### 5. Run tests

```bash
flutter test
```

---

## 🔧 Configuration

### Firebase

- Firebase projects configured in `.firebaserc`  
- Use `firebase.json` and Cloud Functions for backend logic  
- iOS: `GoogleService-Info.plist` included in Xcode project  
- Android: `google-services.json` (not shown here, add manually)  

### Stripe

- Configure Stripe keys in `.env`  
- Payment flows handled in Flutter UI and Firebase Functions  

### Environment Variables

| Variable                | Description                      |
|------------------------|---------------------------------|
| `FIREBASE_API_KEY`      | Firebase API key                 |
| `FIREBASE_AUTH_DOMAIN`  | Firebase Auth domain             |
| `STRIPE_PUBLISHABLE_KEY`| Stripe publishable key           |
| `STRIPE_SECRET_KEY`     | Stripe secret key (server only) |
| ...                    | Other Firebase & app configs     |

---

## 📁 Folder Structure (key highlights)

```
/lib
  /view                # UI screens: dashboard, events, profile, support
  /bloc                # State management blocs and events
  /services            # API clients, payment handlers, auth
  /models              # Data models (Event, User, Booking, etc.)
  /utils               # Helpers, constants, session management

/ios
  Runner.xcodeproj     # iOS Xcode project config
  Assets.xcassets      # App icons and launch images

/macos
  Runner.xcodeproj     # macOS Xcode project config
  Assets.xcassets      # macOS app icons and menus

/windows
  flutter              # Windows Flutter build scripts and plugin registrant

/functions
  index.js             # Firebase Cloud Functions (Stripe payments, emails)

/test
  Unit and widget tests
```

---

## 🧪 Testing

- Unit and widget tests located under `/test`  
- Run all tests with `flutter test`  
- Firebase emulators recommended for local backend testing  

---

## 📜 License

MIT License © Eventopia Contributors

---

## 🙌 Acknowledgements

- Flutter & Dart teams  
- Firebase & Stripe SDKs  
- Open source community packages: flutter_bloc, flutter_secure_storage, flutter_dotenv, razorpay_flutter, flutter_stripe  

---

Made with ❤️ by the Eventopia team — your gateway to unforgettable events!
