# 🚀 Fundo Flutter - Firebase Authentication

Mobile app with Firebase authentication (Email/Password + Google Sign-In)

## Current Status

✅ Authentication UI ready  
✅ Google OAuth Client ID configured  
⚠️ **Firebase project not connected** (using demo credentials)

---

## 🔥 Quick Setup (15 minutes)

### Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "**Add project**" → Name it → Create

### Step 2: Add Android App

1. Click **Android icon** → Package name: `com.fundo.fundo_flutter`
2. **Download `google-services.json`**
3. Place in: `android/app/google-services.json`

### Step 3: Get SHA-1 Certificate

```powershell
.\get_sha1.ps1
```

Copy the SHA-1 value (looks like `AA:BB:CC:...`)

### Step 4: Add SHA-1 to Firebase

1. Firebase Console → **⚙️ Project Settings** → Your apps
2. Click **"Add fingerprint"** → Paste SHA-1 → Save

### Step 5: Enable Authentication

1. Firebase Console → **Authentication** → Get started
2. **Enable Email/Password** (toggle on)
3. **Enable Google** (toggle on, select support email)

### Step 6: Add Web App

1. Click **Web icon** (`</>`) → Register app
2. **Copy the config values**:

```javascript
apiKey, authDomain, projectId, storageBucket, messagingSenderId, appId;
```

### Step 7: Provide Firebase Secrets via env file

1. Copy `env/firebase.env.example` → `env/firebase.env`.
2. Fill every key with the values from Firebase console / `google-services.json` (see hints below).
3. Keep `env/firebase.env` private — it is already excluded via `.gitignore`.

**Finding values from `google-services.json`:**

- `project_id` → `FIREBASE_PROJECT_ID`
- `mobilesdk_app_id` → `FIREBASE_ANDROID_APP_ID`
- `current_key` → `FIREBASE_ANDROID_API_KEY`
- `project_number` → `FIREBASE_MESSAGING_SENDER_ID`

For web/iOS values, use the config snippet that Firebase shows after registering each platform. All entries map directly to the env variable names.

### Step 8: Run the App

```powershell
flutter run --dart-define-from-file=env/firebase.env -d chrome
```

Use the same `--dart-define-from-file` flag for `flutter test`, `flutter build`, or platform-specific commands so every build receives the secrets.

---

## ✅ Test Authentication

**Email/Password:**

1. Click "Register" → Create account
2. Login with credentials
3. ✅ Should see home screen!

**Google Sign-In:**

1. Click "Sign in with Google"
2. Select Google account
3. ✅ Signed in!

**Verify**: Check Firebase Console → Authentication → Users

---

## 🔧 Troubleshooting

**"Error during Google sign in"**  
→ Add SHA-1 to Firebase (Steps 3-4)

**"No user found"**  
→ Register first, then login

**Blank screen**  
→ Ensure `env/firebase.env` exists and you passed it via `--dart-define-from-file`

---

## 📦 Tech Stack

- Flutter 3.35.2, Dart 3.9.0
- Firebase: `firebase_core`, `firebase_auth`, `google_sign_in`
- State Management: `flutter_riverpod`
- Architecture: Clean Architecture with Repository pattern

## 🔑 OAuth Client ID

```
415208406640-iqdsluhi1rq8ghu5ed85f4uehori5nej.apps.googleusercontent.com
```

✅ Already configured

---

**Need help?** Click the **"Setup Help"** button in the app for step-by-step instructions!
