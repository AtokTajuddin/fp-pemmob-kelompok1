# FinanceFlow - Build Instructions

## ✅ All Build Issues Fixed!

### What Was Fixed:
1. ✅ **Created gradlew.bat** - Missing Gradle wrapper for Windows
2. ✅ **Fixed strings.xml** - Escaped `&` character (`&amp;`)
3. ✅ **Fixed themes.xml** - Removed invalid statusBarColor
4. ✅ **Created launcher icons** - Added required app icons
5. ✅ **All Kotlin errors fixed** - No compilation errors

## 🚀 How to Build

### Method 1: Using the Build Script (Easiest)
Just double-click or run:
```cmd
build.bat
```

### Method 2: Using Gradle Commands
```cmd
# Clean the project
.\gradlew.bat clean

# Build debug APK
.\gradlew.bat assembleDebug

# Build and install on connected device
.\gradlew.bat installDebug
```

### Method 3: Using Android Studio
1. Open Android Studio
2. Click **Build > Clean Project**
3. Click **Build > Rebuild Project**
4. Click **Run** button (▶️) or press `Shift + F10`

## 📱 Installing the APK

After building, your APK will be at:
```
app\build\outputs\apk\debug\app-debug.apk
```

**To install on device:**
```cmd
.\gradlew.bat installDebug
```

**Or manually:**
1. Connect your phone via USB
2. Enable Developer Options & USB Debugging
3. Run: `adb install app\build\outputs\apk\debug\app-debug.apk`

## ⚠️ Troubleshooting

### "gradlew.bat not recognized"
Make sure you're in the project directory:
```cmd
cd F:\Belajar-android\keluang-its
```

Then use `.\gradlew.bat` (with dot-slash) in PowerShell:
```powershell
.\gradlew.bat clean
.\gradlew.bat assembleDebug
```

### "Permission denied"
In PowerShell, you may need to set execution policy:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### "JAVA_HOME not set"
Make sure Java/JDK is installed and JAVA_HOME is set:
```cmd
echo %JAVA_HOME%
```

If not set, Android Studio's JDK is usually at:
```
C:\Program Files\Android\Android Studio\jbr
```

## 🎉 Your App is Ready!

Everything is fixed and ready to build. Just run:
```cmd
.\gradlew.bat clean assembleDebug
```

Or simply double-click `build.bat`!

