# 🧪 Firebase Authentication Testing Guide

## ✅ Pre-Testing Checklist

Before you can test with your Google account, complete these steps:

### 1. 🔥 Download google-services.json

**CRITICAL:** Without this file, Firebase will NOT work!

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create a new one)
3. Click the gear icon ⚙️ → **Project Settings**
4. Scroll to **Your apps** section
5. If you don't have an Android app, click **Add app** → **Android**
   - **Android package name**: `com.fundo.fundo_flutter`
   - **App nickname**: Fundo Flutter (optional)
   - Click **Register app**
6. Click **Download google-services.json**
7. **Place the file here**: `android/app/google-services.json`

### 2. 🔐 Get Your SHA-1 Fingerprint

Open PowerShell in the project directory:

```powershell
cd android
./gradlew signingReport
```

Look for the **SHA-1** under "Variant: debug" - it looks like:

```
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
```

Copy this entire string!

**Alternative method (if gradlew fails):**

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### 3. 📝 Add SHA-1 to Firebase

1. Go back to Firebase Console → Project Settings → Your Android app
2. Scroll down to **SHA certificate fingerprints**
3. Click **Add fingerprint**
4. Paste your SHA-1 fingerprint
5. Click **Save**
6. **IMPORTANT**: Download the `google-services.json` again (it updates with your SHA-1)
7. Replace the old file in `android/app/google-services.json`

### 4. ✅ Enable Authentication Methods

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Email/Password**:
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"
3. Enable **Google**:
   - Click on "Google"
   - Toggle "Enable"
   - Select a **support email** (your email)
   - Click "Save"

---

## 🚀 Running the App

### Method 1: Using VS Code / Android Studio

1. Connect your Android phone via USB or start an emulator
2. Press `F5` or click "Run"

### Method 2: Using Terminal

```powershell
flutter run
```

**Note:** Google Sign-In works best on **real devices**. Emulators may have issues.

---

## 🧪 Test Scenarios

### Test 1: ✉️ Register with Email/Password

1. App opens to **Login Screen**
2. Click **"Don't have an account? Register"**
3. Fill in the form:
   - **Full Name**: Your Name
   - **Email**: `yourname@gmail.com` (use your real email)
   - **Password**: `test123456` (at least 6 characters)
   - **Confirm Password**: `test123456`
4. Click **"Register"** button
5. **Expected Result**: ✅
   - Loading indicator appears
   - You're redirected to the Home Screen
   - See welcome message with your name

**If you see an error:**

- "Email already in use" → Use a different email or go to Firebase Console → Authentication → Users → Delete the user
- "Network error" → Check your internet connection
- "Firebase error" → Make sure `google-services.json` is in place

### Test 2: 🔐 Sign Out

1. On the Home Screen, click the **logout icon** (top right)
2. **Expected Result**: ✅
   - You're redirected back to Login Screen

### Test 3: 📧 Sign In with Email/Password

1. On Login Screen, enter:
   - **Email**: The email you registered with
   - **Password**: The password you used
2. Click **"Sign In"**
3. **Expected Result**: ✅
   - Loading indicator appears
   - You're redirected to Home Screen
   - See your user info

**If you see errors:**

- "Wrong password" → Check your password
- "User not found" → Use the email you registered with

### Test 4: 🔴 Google Sign-In

**IMPORTANT:** This requires completing ALL the setup steps above!

1. On Login Screen, click **"Sign in with Google"** button
2. Google account picker appears
3. Select **your Google account**
4. Grant permissions if asked
5. **Expected Result**: ✅
   - You're redirected to Home Screen
   - See your Google account name and email
   - Profile picture may appear (if configured)

**If you see errors:**

| Error                               | Solution                                                |
| ----------------------------------- | ------------------------------------------------------- |
| "PlatformException: sign_in_failed" | SHA-1 not added to Firebase or wrong SHA-1              |
| "ApiException: 10"                  | `google-services.json` missing or package name mismatch |
| "DEVELOPER_ERROR"                   | SHA-1 doesn't match. Re-download `google-services.json` |
| Google picker doesn't appear        | Try on a real device instead of emulator                |

### Test 5: 🔄 Auto Login

1. After signing in successfully, close the app completely
2. Reopen the app
3. **Expected Result**: ✅
   - App opens directly to Home Screen (skips login)
   - You're still logged in

### Test 6: ❌ Wrong Password Test

1. On Login Screen, enter:
   - **Email**: Your registered email
   - **Password**: `wrongpassword`
2. Click "Sign In"
3. **Expected Result**: ✅
   - Red error message appears: "Wrong password"

### Test 7: ✉️ Email Already in Use

1. Try to register with the same email twice
2. **Expected Result**: ✅
   - Error message: "Email already in use"

---

## 🎯 What You Should See

### Login Screen

- ✅ Email field
- ✅ Password field
- ✅ "Sign In" button
- ✅ "Sign in with Google" button
- ✅ "Don't have an account? Register" link

### Register Screen

- ✅ Full Name field
- ✅ Email field
- ✅ Password field (with helper text)
- ✅ Confirm Password field
- ✅ "Register" button
- ✅ "Sign up with Google" button
- ✅ "Already have an account? Sign in" link

### Home Screen (After Login)

- ✅ App bar with logout button
- ✅ Green check icon
- ✅ "You are logged in!" message
- ✅ Your name/email displayed
- ✅ Your UID (Firebase user ID)
- ✅ "Sign Out" button

---

## 🐛 Troubleshooting

### App won't start / Firebase error on launch

**Problem:** Missing `google-services.json`

**Solution:**

1. Make sure file exists at: `android/app/google-services.json`
2. Verify it's the latest version from Firebase Console
3. Run: `flutter clean && flutter run`

### Google Sign-In button does nothing

**Problem:** Missing SHA-1 or wrong configuration

**Solution:**

1. Get your SHA-1: `cd android && ./gradlew signingReport`
2. Add it to Firebase Console
3. Re-download `google-services.json`
4. Replace the file in `android/app/`
5. Restart the app

### "ApiException: 10"

**Problem:** Package name mismatch or Google Services not configured

**Solution:**

1. Verify package name in Firebase Console matches: `com.fundo.fundo_flutter`
2. Check `android/app/build.gradle.kts` has: `applicationId = "com.fundo.fundo_flutter"`
3. Ensure `google-services.json` is in `android/app/`

### Email/Password works but Google doesn't

**Solution:**

- This is usually an SHA-1 issue
- Make sure you added the SHA-1 fingerprint
- Download the updated `google-services.json`
- Test on a real device, not emulator

---

## ✅ Success Criteria

You've successfully tested Firebase Auth when:

- [x] You can register with email/password
- [x] You can sign in with email/password
- [x] You can sign out
- [x] You can sign in with Google
- [x] App remembers you after closing/reopening
- [x] Error messages display correctly
- [x] User info displays on home screen

---

## 📱 Your Test Account

Use your own Google account or create a test account:

**Email/Password Test:**

- Email: `yourname@gmail.com`
- Password: `test123456`

**Google Sign-In Test:**

- Use your personal Google account
- OR create a test Gmail account

---

## 📊 Firebase Console Verification

After testing, check Firebase Console:

1. Go to **Authentication** → **Users**
2. You should see your test users listed
3. Check the **Sign-in method** column (shows "Google" or "Email")
4. Click on a user to see details

---

## 🎉 Next Steps After Testing

Once everything works:

1. ✅ Authentication is fully functional
2. You can start building your main app features
3. User data is automatically saved to Firebase
4. You can add more sign-in methods (Apple, Facebook, etc.)

---

## 💡 Tips

- **Always test on a real device** for Google Sign-In
- **Keep your SHA-1 updated** when switching between debug/release builds
- **Check Firebase Console** to verify users are being created
- **Use different emails** for testing multiple accounts
- **Clear app data** if you need to test the first-time experience again

---

## 📞 Need Help?

If you're stuck:

1. Check the error message carefully
2. Review `GOOGLE_SIGNIN_SETUP.md` for configuration steps
3. Verify all files are in the correct locations
4. Make sure `google-services.json` is up to date
5. Try `flutter clean && flutter run`

**Common file locations:**

- `android/app/google-services.json` ✅
- `android/app/build.gradle.kts` (has Google Services plugin)
- `lib/main.dart` (Firebase initialized)

---

## 🎯 Quick Test Command

```powershell
# Clean and run
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

Good luck with testing! 🚀
