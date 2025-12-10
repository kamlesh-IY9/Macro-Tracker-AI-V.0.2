# 🔒 Firebase Security Setup Guide

This guide explains how to set up Firebase credentials securely for MacroMate without exposing your API keys in version control.

## 🎯 Overview

**The Problem**: Firebase credentials contain API keys that should not be committed to public repositories.

**The Solution**: We use a template-based approach:
- `firebase_options.dart.template` → Committed to Git (with placeholders)
- `firebase_options.dart` → Your real credentials (gitignored, NOT committed)

---

## 📝 Setup Instructions

### For New Users Cloning the Repository

If you cloned this repository and need to set up Firebase:

#### Step 1: Copy the Template

```powershell
# Navigate to the lib directory
cd lib

# Copy the template to create your real config file
copy firebase_options.dart.template firebase_options.dart
```

#### Step 2: Get Your Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project (or create a new one)
3. Click the **Settings** gear icon → **Project settings**
4. Scroll down to **Your apps**
5. For each platform you want to support, add an app and copy the credentials

#### Step 3: Update Your Configuration

Open `lib/firebase_options.dart` and replace the placeholder values:

**For Web/Windows**:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSy...',              // From Firebase Console
  appId: '1:1234567890:web:...',   // From Firebase Console  
  messagingSenderId: '1234567890',  // From Firebase Console
  projectId: 'your-project-id',     // Your Firebase project ID
  authDomain: 'your-project.firebaseapp.com',
  storageBucket: 'your-project.firebasestorage.app',
  measurementId: 'G-...',           // From Firebase Console
);
```

**For Android**:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSy...',
  appId: '1:1234567890:android:...',
  messagingSenderId: '1234567890',
  projectId: 'your-project-id',
  storageBucket: 'your-project.firebasestorage.app',
);
```

Also download `google-services.json` and place in `android/app/`

**For iOS/macOS**:
Similar to Android, plus download `GoogleService-Info.plist` for `ios/Runner/`

#### Step 4: Verify Setup

```powershell
# The file should be ignored by Git
git status

# firebase_options.dart should NOT appear in the list
# If it does, check your .gitignore file
```

---

## 🔐 For Project Maintainers

### Your Current Setup (Before Pushing to GitHub)

Your `firebase_options.dart` currently contains real credentials. Here's the safe approach:

#### Option 1: Keep Real Credentials (Recommended for Private Repo)

If your repository will be **private**:

1. **Update .gitignore** (already done ✅):
   ```gitignore
   # This protects your credentials
   lib/firebase_options.dart
   ```

2. **Keep the template**:
   - The template file is safe to commit
   - Others can copy it to create their own config

3. **Push to GitHub**:
   - Your real `firebase_options.dart` stays local
   - Template goes to GitHub
   - Other developers copy template and add their own credentials

#### Option 2: Reset Firebase Project (For Public Repo)

If your repository will be **public** and credentials are already exposed:

1. **Regenerate Firebase API Keys**:
   - Go to Firebase Console → Project Settings
   - Regenerate/restrict API keys
   - Update your local `firebase_options.dart`

2. **Start Fresh**:
   ```powershell
   # Remove from Git history (if already committed)
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch lib/firebase_options.dart" \
     --prune-empty --tag-name-filter cat -- --all
   ```

3. **Add to .gitignore and use template approach**

---

## 📋 What Gets Committed vs Ignored

### ✅ Committed to Git (Safe):
- `lib/firebase_options.dart.template` (with placeholders)
- `.gitignore` (protects real credentials)
- `README.md` (setup instructions)
- `FIREBASE_SECURITY_SETUP.md` (this file)

### ❌ Ignored by Git (Protected):
- `lib/firebase_options.dart` (your real credentials)
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- Any other files containing secrets

---

## 🚨 Security Best Practices

### 1. API Key Restrictions (Highly Recommended)

Even with gitignore, restrict your API keys:

**Firebase Console → Project Settings → API Keys**:
- **Web API Key**: Restrict to your domain
  - Example: `your-app.web.app`, `localhost:*`
  
- **Android**: Restrict to your app's SHA-1 fingerprint
  
- **iOS**: Restrict to your bundle ID

### 2. Firestore Security Rules

Ensure your Firestore rules protect user data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write their own data
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
    }
  }
}
```

### 3. Environment-Specific Configs

For production deployments, consider:
- Different Firebase projects for dev/staging/prod
- Environment variables in CI/CD pipelines
- GitHub Secrets for Actions

---

## 🔄 Alternative: Environment Variables (Advanced)

For even more security, you can use environment variables:

### Step 1: Install flutter_dotenv

```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

### Step 2: Create .env file

```bash
# .env (add to .gitignore!)
FIREBASE_WEB_API_KEY=AIzaSy...
FIREBASE_WEB_APP_ID=1:1234567890:web:...
FIREBASE_PROJECT_ID=your-project-id
```

### Step 3: Update firebase_options.dart

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

static FirebaseOptions get web => FirebaseOptions(
  apiKey: dotenv.env['FIREBASE_WEB_API_KEY']!,
  appId: dotenv.env['FIREBASE_WEB_APP_ID']!,
  projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
  // ...
);
```

### Step 4: Load in main.dart

```dart
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // ... rest of initialization
}
```

---

## ✅ Verification Checklist

Before pushing to GitHub, verify:

- [ ] `lib/firebase_options.dart` is in `.gitignore`
- [ ] Real credentials are NOT in `firebase_options.dart.template`
- [ ] Run `git status` and confirm `firebase_options.dart` doesn't appear
- [ ] README explains setup process for new users
- [ ] Firebase API keys have restrictions enabled
- [ ] Firestore security rules are in place

---

## 🆘 Troubleshooting

### "Firebase not initialized" error after cloning

**Solution**: You forgot to copy the template!
```powershell
copy lib/firebase_options.dart.template lib/firebase_options.dart
# Then edit with your credentials
```

### Firebase credentials in Git history

**Solution**: Remove from history
```powershell
# Nuclear option (rewrites history)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch lib/firebase_options.dart" \
  --prune-empty --tag-name-filter cat -- --all
  
# Force push (be careful!)
git push origin --force --all
```

### git status still shows firebase_options.dart

**Solution**: Clear Git cache
```powershell
git rm --cached lib/firebase_options.dart
git commit -m "Remove firebase_options.dart from Git tracking"
```

---

## 📚 Additional Resources

- [Firebase Security Best Practices](https://firebase.google.com/docs/projects/api-keys)
- [Securing API Keys in Flutter](https://docs.flutter.dev/deployment/security)
- [Git Filter-Branch Documentation](https://git-scm.com/docs/git-filter-branch)
- [GitHub Secrets for CI/CD](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

## 🎯 Quick Reference Commands

```powershell
# Setup for new users
copy lib/firebase_options.dart.template lib/firebase_options.dart

# Verify file is ignored
git status

# Check what will be committed
git add .
git status

# Remove from Git tracking if needed
git rm --cached lib/firebase_options.dart
```

---

**Stay Secure! 🔒** Your API keys are precious - treat them like passwords!
