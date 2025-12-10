<div align="center">

# 🥑 MacroMate

### *Your AI-Powered Nutrition Companion*

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI%20Powered-4285F4?logo=google&logoColor=white)](https://ai.google.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Linux-blue)](https://flutter.dev)

**MacroMate** is a premium, AI-powered macro tracking application that revolutionizes the way you monitor nutrition, weight, and daily habits. Built with Flutter and powered by Google Gemini AI, it offers a sleek, modern dark-mode interface with intelligent food logging capabilities.

[Features](#-features) • [Demo](#-demo) • [Installation](#-installation--setup) • [Configuration](#-configuration)

</div>

---

## 📋 Table of Contents

- [✨ Features](#-features)
- [🎬 Demo](#-demo)
- [🔧 Prerequisites](#-prerequisites)
- [⚡ Installation & Setup](#-installation--setup)
- [🔑 Configuration](#-configuration)
  - [Firebase Database Setup](#1-firebase-database-setup)
  - [Google Gemini AI Setup](#2-google-gemini-ai-setup)
  - [Alternative: ChatGPT API](#alternative-chatgpt-api-integration)
- [🚀 Running the Application](#-running-the-application)
- [📱 Building for Release](#-building-for-release)
- [🏗️ Project Structure](#️-project-structure)
- [🛠️ Tech Stack](#️-tech-stack)
- [❓ Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## ✨ Features

### 🤖 AI-Powered Features
- **🍔 AI Food Logging**: Simply snap a photo or type a description (e.g., "Oatmeal with blueberries") and get instant macro analysis using Google Gemini AI
- **💬 AI Nutrition Coach**: Chat with your personal AI nutritionist for personalized advice, meal suggestions, and dietary guidance

### 📊 Tracking & Analytics
- **📈 Smart Dashboard**: Real-time tracking of Calories, Protein, Carbs, and Fat against your personalized TDEE targets
- **⚖️ Weight Tracker**: Log your weight daily and visualize trends over time with beautiful interactive charts
- **💧 Habit Tracking**: Track daily water intake with quick-add buttons and visual progress indicators
- **📉 Trends & Insights**: Analyze your nutrition patterns with detailed charts powered by fl_chart

### 🍽️ Meal Planning
- **🗓️ Weekly Meal Planner**: Plan your entire week with organized meals (Breakfast, Lunch, Dinner, Snacks)
- **🛒 Smart Shopping List**: Automatically generate a checklist of ingredients from your meal plan
- **📸 Barcode Scanner**: Quickly log packaged foods by scanning barcodes (Mobile only)

### 🎨 Premium Design
- **🌙 Dark Mode Interface**: Beautiful, modern dark-themed UI designed for extended use
- **🎯 Intuitive UX**: Smooth animations and responsive design across all platforms
- **📱 Cross-Platform**: Seamlessly works on Windows, Android, iOS, Web, macOS, and Linux

---

## 🎬 Demo

### Application Walkthrough

https://github.com/user-attachments/assets/141a32b7-cc3b-4e3b-8932-39ede3e6de2f

*Main dashboard, AI food logging, and tracking features*

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/8c90719b-2e04-42fb-97b4-08a0c2e2dc11" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/5e1df4ca-2cea-4fe8-930b-0335dba6449a" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0026b38d-e077-409d-a840-74000ed81bcd" />

*Firebase images with store data*

> **Note**: Demo videos showcase the application's key features including AI-powered food logging, real-time macro tracking, weight trends, meal planning, and the AI nutrition coach.

---

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
- **Flutter SDK** (version 3.0.0 or higher)
  - [Download Flutter](https://flutter.dev/docs/get-started/install)
  - Verify installation: `flutter --version`
  
- **Dart SDK** (comes with Flutter)

- **Git** (for cloning the repository)
  - [Download Git](https://git-scm.com/downloads)

### Platform-Specific Requirements

| Platform | Requirements |
|----------|-------------|
| **Windows** | Windows 10/11, Visual Studio 2022 with C++ tools |
| **Android** | Android Studio, Android SDK (API 21+) |
| **iOS** | macOS, Xcode 14+, CocoaPods |
| **macOS** | macOS 10.14+, Xcode 14+ |
| **Linux** | Linux development packages, GTK 3.0+ |
| **Web** | Chrome browser (for testing) |

### Required Accounts
- **Firebase Account** (free tier available)
  - [Create Firebase Account](https://console.firebase.google.com)
  
- **Google AI Studio Account** (for Gemini API)
  - [Get Gemini API Key](https://aistudio.google.com/)

---

## ⚡ Installation & Setup

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/macro_tracker_ai.git

# Navigate to project directory
cd macro_tracker_ai
```

### Step 2: Install Dependencies

```bash
# Install Flutter packages
flutter pub get

# Run code generation for Riverpod and JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Verify Flutter Installation

```bash
# Check for any issues
flutter doctor

# List available devices
flutter devices
```

> **Tip**: If `flutter doctor` shows any issues, follow the suggested fixes before proceeding.

---

## 🔑 Configuration

MacroMate requires two main configurations: Firebase for data storage and Google Gemini AI for intelligent food logging.

### 1. Firebase Database Setup

Firebase is used for user authentication and storing all user data.

#### A. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project (e.g., "MacroMate-AI")
3. Enable **Authentication** (Email/Password) and **Cloud Firestore**

#### B. Update Configuration

The project comes with placeholder credentials in `lib/firebase_options.dart`. You need to replace them with your own:

1. In Firebase Console, go to **Project Settings** → **Your apps**
2. Add apps for the platforms you want to support (Web, Android, iOS, etc.)
3. Open `lib/firebase_options.dart`
4. Replace the dummy values (e.g., `YOUR_WEB_API_KEY_HERE`) with your actual credentials from Firebase Console

**Note**: For Android/iOS, you also need to download `google-services.json` / `GoogleService-Info.plist` and place them in the respective folders.

---

### 2. Google Gemini AI Setup

The AI food logging and nutrition coach features require a Google Gemini API key.

#### A. Get Your API Key

1. Visit [Google AI Studio](https://aistudio.google.com/)
2. Sign in with your Google account
3. Click **"Get API Key"** in the top navigation
4. Click **"Create API key"**
5. Select your Google Cloud project (or create a new one)
6. Copy the generated API key

#### B. Configure in MacroMate

**Option 1: Configure in App (Recommended)**
1. Launch MacroMate
2. Navigate to **Settings** page (bottom navigation)
3. Find **"Gemini API Key"** section
4. Paste your API key
5. Click **"Save"**
6. API key is securely stored locally on your device

**Option 2: Environment Variables (Advanced)**
```bash
# Windows PowerShell
$env:GEMINI_API_KEY="your-api-key-here"
flutter run

# macOS/Linux
export GEMINI_API_KEY="your-api-key-here"
flutter run
```

> **Security Note**: Never commit API keys to version control. They are stored locally using `shared_preferences` and never transmitted except to Google AI services.

#### C. Verify AI Features

1. Go to the **Dashboard**
2. Click **"Add Food"** → **"AI Analysis"**
3. Type a food description or take a photo
4. If configured correctly, you'll see macro analysis results

---

### Alternative: ChatGPT API Integration

> **⚠️ Current Status**: MacroMate currently uses Google Gemini AI. ChatGPT integration would require code modifications.

If you want to use OpenAI's ChatGPT instead:

**What You'll Need:**
1. OpenAI API Key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Replace `google_generative_ai` package with `dart_openai` in `pubspec.yaml`
3. Modify the AI service implementation in `lib/services/`

**Steps for Integration:**
```yaml
# In pubspec.yaml, replace:
google_generative_ai: ^0.4.6

# With:
dart_openai: ^5.1.0
```

Then update the AI service to use OpenAI's API. If you need help with this integration, feel free to open an issue!

---

## 🚀 Running the Application

### Run on Specific Platform

Once configuration is complete, you can run MacroMate on any platform:

```bash
# Windows
flutter run -d windows

# Android (with device/emulator connected)
flutter run -d android

# iOS (macOS only, with simulator/device)
flutter run -d ios

# Web
flutter run -d chrome

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### Select Device Interactively

```bash
# List all available devices
flutter devices

# Run and select device
flutter run
```

### Hot Reload During Development

While the app is running:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

---

## 📱 Building for Release

### Android APK/Bundle

```bash
# Build APK (for direct installation)
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS (requires macOS)
flutter build ios --release

# Open in Xcode for signing and distribution
open ios/Runner.xcworkspace
```

### Windows Executable

```bash
# Build Windows executable
flutter build windows --release

# Output: build\windows\runner\Release\
```

### Web

```bash
# Build for web deployment
flutter build web --release

# Output: build/web/
```

### macOS

```bash
# Build for macOS
flutter build macos --release
```

---

## 🏗️ Project Structure

```
macro_tracker_ai/
├── lib/
│   ├── core/              # Core utilities and constants
│   ├── features/          # Feature modules (dashboard, meals, weight, etc.)
│   │   ├── auth/         # Authentication screens
│   │   ├── dashboard/    # Main dashboard
│   │   ├── food/         # Food logging and AI analysis
│   │   ├── meals/        # Meal planning
│   │   ├── trends/       # Charts and analytics
│   │   ├── weight/       # Weight tracking
│   │   └── settings/     # App settings
│   ├── models/           # Data models (Food, User, Meal, etc.)
│   ├── providers/        # Riverpod state providers
│   ├── services/         # API services (Firebase, Gemini AI, etc.)
│   ├── firebase_options.dart  # Firebase configuration
│   └── main.dart         # App entry point
├── android/              # Android-specific code
├── ios/                  # iOS-specific code
├── windows/              # Windows-specific code
├── web/                  # Web-specific code
├── macos/                # macOS-specific code
├── linux/                # Linux-specific code
└── pubspec.yaml          # Dependencies
```

### Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Application entry point, Firebase initialization |
| `lib/firebase_options.dart` | Firebase platform configurations |
| `lib/services/gemini_service.dart` | Google Gemini AI integration |
| `lib/services/firebase_service.dart` | Firebase Firestore operations |
| `lib/providers/` | Riverpod state management |
| `lib/models/` | Data models with JSON serialization |

---

## 🛠️ Tech Stack

### Core Framework
- **[Flutter](https://flutter.dev)** `^3.0.0` - Cross-platform UI framework
- **[Dart](https://dart.dev)** `^3.0.0` - Programming language

### State Management
- **[flutter_riverpod](https://pub.dev/packages/flutter_riverpod)** `^2.5.1` - Reactive state management
- **[riverpod_annotation](https://pub.dev/packages/riverpod_annotation)** `^2.3.5` - Code generation for Riverpod

### Backend & Database
- **[firebase_core](https://pub.dev/packages/firebase_core)** `^4.2.1` - Firebase initialization
- **[firebase_auth](https://pub.dev/packages/firebase_auth)** `^6.1.2` - User authentication
- **[cloud_firestore](https://pub.dev/packages/cloud_firestore)** `^6.1.0` - NoSQL database

### AI & Machine Learning
- **[google_generative_ai](https://pub.dev/packages/google_generative_ai)** `^0.4.6` - Gemini AI integration

### UI & Visualization
- **[fl_chart](https://pub.dev/packages/fl_chart)** `^0.68.0` - Interactive charts
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)** `^1.0.6` - iOS-style icons

### Utilities
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** `^2.2.3` - Local data persistence
- **[image_picker](https://pub.dev/packages/image_picker)** `^1.0.7` - Camera/gallery access
- **[mobile_scanner](https://pub.dev/packages/mobile_scanner)** `^5.1.0` - Barcode scanning
- **[openfoodfacts](https://pub.dev/packages/openfoodfacts)** `^3.4.0` - Food database API
- **[http](https://pub.dev/packages/http)** `^1.1.0` - HTTP requests
- **[intl](https://pub.dev/packages/intl)** `^0.19.0` - Internationalization
- **[uuid](https://pub.dev/packages/uuid)** `^4.4.0` - Unique ID generation

### Development Tools
- **[build_runner](https://pub.dev/packages/build_runner)** `^2.4.9` - Code generation
- **[freezed](https://pub.dev/packages/freezed)** `^2.5.2` - Immutable data classes
- **[json_serializable](https://pub.dev/packages/json_serializable)** `^6.8.0` - JSON serialization

---

## ❓ Troubleshooting

### Common Issues

<details>
<summary><b>🔴 Build failed: "Plugin not found"</b></summary>

**Solution:**
```bash
# Clean Flutter
flutter clean

# Remove existing symlinks (Windows only)
Remove-Item -Recurse -Force windows/flutter/ephemeral

# Reinstall dependencies
flutter pub get

# Rebuild
flutter run
```

</details>

<details>
<summary><b>🔴 Firebase not initialized</b></summary>

**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution:**
1. Verify `firebase_options.dart` exists in `lib/`
2. Check that `Firebase.initializeApp()` is called in `main.dart`
3. Ensure platform-specific files are in place:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

</details>

<details>
<summary><b>🔴 Gemini API not working</b></summary>

**Symptoms**: AI food analysis returns errors or nothing happens

**Solutions:**
1. Verify API key is correct in Settings
2. Check API key has Gemini API enabled in Google Cloud Console
3. Ensure you haven't exceeded free tier quota
4. Test API key independently: [Gemini API Docs](https://ai.google.dev/tutorials/rest_quickstart)

</details>

<details>
<summary><b>🔴 Charts not displaying</b></summary>

**Solution:**
1. Ensure you have data logged (weight, meals)
2. Try pulling down to refresh
3. Check date range filters
4. Restart the app

</details>

<details>
<summary><b>🔴 Barcode scanner not working</b></summary>

**Solution:**
1. Grant camera permissions in device settings
2. Barcode scanner only works on mobile (Android/iOS)
3. Ensure `mobile_scanner` plugin is properly installed

</details>

<details>
<summary><b>🔴 Windows build issues</b></summary>

**Error**: C++ build tools not found

**Solution:**
1. Install Visual Studio 2022 with "Desktop development with C++"
2. Run `flutter doctor` to verify
3. May need to restart terminal/IDE after installation

</details>

### Getting Help

If you encounter other issues:

1. **Check Flutter Doctor**: Run `flutter doctor -v` for diagnostic info
2. **Review logs**: Use `flutter run --verbose` for detailed output
3. **Search issues**: Check [GitHub Issues](https://github.com/yourusername/macro_tracker_ai/issues)
4. **Ask for help**: Open a new issue with:
   - Flutter version (`flutter --version`)
   - Platform (Windows, Android, etc.)
   - Error logs
   - Steps to reproduce

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
5. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request**

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Add comments for complex logic
- Test on multiple platforms before submitting
- Update documentation as needed

### Areas for Contribution

- 🌍 Multi-language support
- 🍎 Recipe database integration
- 🏋️ Exercise tracking
- 📊 More chart types and analytics
- 🎨 Theme customization
- 🔔 Notifications and reminders
- 🌐 Social features (meal sharing, challenges)

---

## 📄 License

This project is licensed under the **MIT License**.


---

<div align="center">

### Made with ❤️ using Flutter

**MacroMate** - *Transform your nutrition journey with AI*

[⬆ Back to Top](#-macromate)

</div>
