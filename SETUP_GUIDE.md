# 💻 Fundo Developer Setup Guide

**Welcome to the Fundo Team!** 👋 Follow this guide step-by-step to set up your laptop. If you skip a step, the app _will_ crash.

## 🛠️ Phase 1: Install the Tools

Before you code, you need these installed.

### 1. Visual Studio Code (VS Code)

Download and install [VS Code](https://code.visualstudio.com/ "null").

- **Why?** It's fast and has the extensions we need.
- **Extensions to Install:** Open VS Code, click the "Blocks" icon on the left (Extensions), and install these:
    - `Flutter` (by Dart Code)
    - `Dart` (by Dart Code)
    - `Flutter Riverpod Snippets` (by Robert Brunhage)
    - `Error Lens` (by Alexander) - _Makes errors show up in red text automatically._

### 2. The Flutter SDK

**Windows Users:**

1. Download the stable zip from [flutter.dev](https://docs.flutter.dev/get-started/install/windows "null").
2. Extract it to `C:\src\flutter` (Do **NOT** put it in `Program Files`).
3. Search for "Edit environment variables for your account" in Windows Search.
4. Edit the `Path` variable and add `C:\src\flutter\bin`.
5. Open a new Terminal and type `flutter doctor`.

> [!NOTE]
> You can see [this](https://youtu.be/1KidD72q87s) for a tutorial on downloading the Flutter SDK

**Mac Users:**

1. Download the zip from [flutter.dev](https://docs.flutter.dev/get-started/install/macos "null").
2. Extract it to your home folder (`~/development/flutter`).
3. Add it to your path (follow the instructions on the website).
4. Run `flutter doctor`.

### 3. Git

Download [Git](https://www.google.com/search?q=https://git-scm.com/downloads "null") if you don't have it. You need this to download our code.

## 🏗️ Phase 2: Install Android Tools (One-Time Setup)

> **Read Carefully:** You need to install the "Android SDK" so your computer knows how to speak "Android". The easiest way to get these files is to install Android Studio.

1. Download & Install [Android Studio](https://developer.android.com/studio "null").
2. Open it **once** to let it download the SDK components.
3. **Create your Virtual Phone (AVD):**
    - **Method A (Easy):** On the Android Studio Welcome Screen, click **More Actions** -> **Virtual Device Manager**.
        - Click **Create Device** -> Choose **Pixel 7** (This is our standard test phone) -> Next.
        - **System Image:** Click the "Download" arrow next to **API 34** (Android 14). This is a large download (~1.5GB).
        - Click **Finish**.
    - **Method B (VS Code - Try this first!):**
        - Open VS Code -> Press `Ctrl+Shift+P` -> Type `Flutter: Create Android Emulator`.
        - If it lets you choose "Pixel 7" and "API 34" and works, great!
        - If it gives an error, use Method A.
4. **CLOSE ANDROID STUDIO.** You don't need it anymore. 👋

## ⚙️ Phase 3: Install Flutter SDK

1. **Windows:** Download the [ZIP File](https://docs.flutter.dev/install/manual). Extract it to `C:\src\flutter`.
2. **Mac:** Download the [ZIP File](https://docs.flutter.dev/install/manual). Unzip it to your home folder.
3. **Add to Path**
4. Open a terminal and run `flutter doctor`. Fix any red checkboxes it shows.

> [!NOTE]
> Check [this](https://youtu.be/1KidD72q87s?si=Fr17K_mJ7gpI3aj2) video out for the detailed installation guide 

## 🚀 Phase 4: Get the Project

1. **Clone the Repository:**

    ```
    git clone [https://github.com/AtokTajuddin/projek-mobile-programming.git](https://github.com/AtokTajuddin/projek-mobile-programming.git)
    cd projek-mobile-programming
    
    ```

2. **Install Dependencies:** Download all the libraries (Riverpod, Firebase, etc.) we use:

    ```
    flutter pub get
    
    ```

## 🔑 Phase 5: Add Secret Keys (CRITICAL)

The app will **crash** if you skip this. We do not upload passwords to GitHub.

1. **API Keys File:**
    - Go to `lib/core/constants/`.
    - Create a new file named **`api_keys.dart`**.
    - Paste the code below (Ask **Jonathan** for the real keys in WhatsApp)

        ```
        class ApiKeys {
          static const String geminiApiKey = "AIzaSy..."; 
        }
        
        ```

2. **Firebase Config:**
    - **Android:** Ask Jonathan for `google-services.json` and put it in `android/app/`.
    - **iOS:** Ask Jonathan for `GoogleService-Info.plist` and put it in `ios/Runner/`.

## 🎮 Phase 6: Daily Workflow (VS Code Only)

**This is how you will work every day.** No Android Studio required!

1. **Open VS Code.**
2. **Open `lib/main.dart`** (This wakes up the Flutter tools).
3. **Launch the Emulator:**
    - Look at the **Bottom Right Corner** of the VS Code window (The Status Bar).
    - You should see `{ } Dart` and maybe `No Device` or `Windows`.
    - **Click on that device name.**
    - A menu will pop up at the top. Select **Start Pixel 7 API 34** (or whatever you named your phone in Phase 2).
    - _Magic!_ The emulator window will launch automatically. 📱
4. **Run the App:**
    - Press **F5** (or Run -> Start Debugging).
    - The app will compile and open inside that emulator window.

## 🆘 Troubleshooting: "I don't see the Device Button!"

If the bottom-right corner is empty:

1. **Use the Command Palette:**
    - Press `Ctrl + Shift + P` (Windows) or `Cmd + Shift + P` (Mac).
    - Type **`Flutter: Select Device`** and press Enter.
    - If it works, select your emulator.
2. **Check your Folder:**
    - Did you open the _Main Folder_?
    - Go to **File -> Open Folder...** and make sure you select the folder that contains `pubspec.yaml` (the `projek-mobile-programming` folder).
3. **Check Flutter Doctor:**
    - Open the Terminal in VS Code (`Ctrl + ~`).
    - Type `flutter doctor`.
    - If it says "Flutter not found", your Path Setup (Phase 3) is wrong. Ask Jonathan for help!