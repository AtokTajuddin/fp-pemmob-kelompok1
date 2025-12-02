# 🛠️ Fundo Tech Stack & Architecture

> **For the Team:** This document defines the tools, libraries, and architectural patterns we are using to build Fundo. Please do not add new libraries without discussing it first with the team to avoid "Dependency Hell."

## 📱 Core Environment

| Component        | Choice                       | Why?                                                                               |
| ---------------- | ---------------------------- | ---------------------------------------------------------------------------------- |
| **Framework**    | **Flutter** (Stable Channel) | Allows us to build for Android & iOS simultaneously from a single codebase.        |
| **Language**     | **Dart 3.x**                 | The language of Flutter. We use modern features like Records and Pattern Matching. |
| **IDE**          | **VS Code**                  | Lightweight, runs on all our laptops, and has great Flutter extensions.            |
| **Java Version** | **Java 17**                  | Required for the latest Android builds.                                            |

## 🏗️ Architecture: "Feature-First"

We are using a **Feature-First** directory structure combined with **Riverpod** for state management. This makes our code modular; if the "Chat" feature breaks, the "Transactions" feature still works.

### **The "Feature-First" Folder Structure**

Every major feature (Auth, Chat, Transactions) gets its own folder with 3 layers:

1. **Presentation:** Widgets, Screens, and UI logic (Providers).
2. **Domain:** Pure Dart classes (Models/Entities).
3. **Data:** Repositories that talk to Firebase/APIs.

```
root/
├── assets/                   # 🎨 Static files (Must be listed in pubspec.yaml)
│   ├── icons/                # .svg files (e.g., food.svg, transport.svg)
│   └── images/               # .png/.jpg files (e.g., logo.png)
│
├── lib/
│   ├── main.dart             # 🚀 Entry Point: Initializes Firebase & Dependencies
│   ├── app.dart              # 🛠️ App Setup: Theme, Routing (GoRouter), Locales
│   │
│   ├── core/                 # 🧱 Shared Code (Used by multiple features)
│   │   ├── constants/        # (e.g., api_keys.dart, firebase_paths.dart)
│   │   ├── theme/            # (e.g., app_colors.dart, text_styles.dart)
│   │   └── utils/            # (e.g., currency_formatter.dart, date_helper.dart)
│   │
│   └── features/             # ✨ The Features (Logic lives here)
│       ├── auth/             # Login & Register
│       ├── maps/             # Map Display Logic
│       ├── chatbot/          # Gemini AI Logic
│       │
│       └── transactions/     # 💰 EXAMPLE: How a feature looks inside
│           ├── data/         # 🔌 Data Layer (Talks to outside world)
│           │   ├── transaction_repository.dart  # Functions: add(), delete()
│           │   └── transaction_dto.dart         # Data Transfer Object (JSON)
│           │
│           ├── domain/       # 🧠 Domain Layer (Pure Dart)
│           │   └── transaction_model.dart       # The Class (amount, date, note)
│           │
│           └── presentation/ # 📱 UI Layer (Widgets & State)
│               ├── screens/
│               │   ├── add_transaction_screen.dart
│               │   └── transaction_list_screen.dart
│               └── providers/
│                   └── transaction_provider.dart # Riverpod Logic
```

## ☁️ Backend (Firebase)

We are using **Firebase** "Serverless" backend. We do not maintain our own server.

- **Authentication:** `Firebase Auth` (Google Sign-In & Email/Password).
- **Database:** `Cloud Firestore` (NoSQL, Real-time data syncing).
- **Storage:** `Firebase Storage` (For storing receipt images).

## 📦 Key Dependencies (The "Fundo" Stack)

These are the specific packages we use. **Do not use alternatives** (e.g., don't use `GetX` or `Provider`, we are using `Riverpod`).

### **1. Core Logic**

|Package|Name in `pubspec.yaml`|Purpose|
|---|---|---|
|**State Management**|`flutter_riverpod`|Manages app state (e.g., "Is the user logged in?", "What is the total balance?").|
|**Navigation**|`go_router`|Handles moving between screens using URLs (e.g., `/home`, `/details/123`).|
|**Code Generation**|`freezed` & `json_serializable`|Automatically generates `toString`, `equals`, and JSON parsing code for our Models.|

### **2. Features**

| Feature         | Package                | Why this one?                                                                                                  |
| --------------- | ---------------------- | -------------------------------------------------------------------------------------------------------------- |
| **AI Chatbot**  | `google_generative_ai` | The official SDK for Google Gemini. Free tier is generous and easy to implement.                               |
| **Maps**        | `flutter_map`          | Uses **OpenStreetMap** (Free). **IMPORTANT:** We are NOT using Google Maps to avoid credit card billing risks. |
| **Geolocation** | `geolocator`           | Gets the phone's GPS coordinates (Latitude/Longitude) to tag transactions.                                     |
| **Charts**      | `fl_chart`             | Creates the Pie Charts and Bar Graphs for the "Analysis" screen.                                               |
| **Camera**      | `image_picker`         | Opens the native camera or gallery to pick receipt images.                                                     |
| Geocoding       | geocoding              | Converts Latitude/Longitude (Numbers) into an Address (Text).                                                  |

### **3. Utilities**

| Utility           | Package                | Purpose                                                                         |
| ----------------- | ---------------------- | ------------------------------------------------------------------------------- |
| **Formatting**    | `intl`                 | Formats currency (`Rp 50.000`) and dates (`12 Oct 2025`) for Indonesian locale. |
| **Local Storage** | `shared_preferences`   | Saves simple settings like "Dark Mode: On" or "Show Balance: Off".              |
| **Icons**         | `font_awesome_flutter` | Provides high-quality financial icons better than the default set.              |
| **UUID**          | `uuid`                 | Generates unique IDs for transactions (e.g., `tx-550e8400-e29b`).               |
| **Typogrraphy**   | `google_fonts`         | **Text Style**. Makes our text look like "Poppins" (Modern).                    |

## 📱 Device Permissions & Hardware

Since we access the user's hardware, we must declare permissions. **If you forget this, the app will crash.**

### **1. Geolocation (GPS)**

We use `geolocator` to get coordinates, which we then show on `flutter_map`.

- **Android (`android/app/src/main/AndroidManifest.xml`):**

    ```
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    ```

- **iOS (`ios/Runner/Info.plist`):**

    ```
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Fundo needs your location to tag where this transaction happened.</string>
    ```

### **2. Camera & Gallery**

Used by `image_picker` for receipts.

- **Android (`android/app/src/main/AndroidManifest.xml`):**

    ```
    <uses-permission android:name="android.permission.CAMERA" />
    <!-- Devices running Android 12 or lower -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <!-- Devices running Android 13+ -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    ```

- **iOS (`ios/Runner/Info.plist`):**

    ```
    <key>NSPhotoLibraryUsageDescription</key>
    <string>We need access to photos to upload receipt images.</string>
    <key>NSCameraUsageDescription</key>
    <string>We need access to the camera to take pictures of receipts.</string>
    ```

## 🔌 VS Code Extensions (Required)

All team members must install these extensions to ensure we see the same errors and formatting.

1. **Flutter** (Dart support)
2. **Flutter Riverpod Snippets** (Faster coding)
3. **Error Lens** (Highlights bugs directly in the code line)
4. **Thunder Client** (For testing APIs if needed)
5. **GitHub Pull Requests** (To review code inside VS Code)

## 🚀 How to Add a New Library

1. **Stop.** Do you really need it?
2. Check if an existing package (like `intl` or `flutter_riverpod`) already does what you need.
3. If not, propose it in the WhatsApp Group Chat.
4. If approved, run `flutter pub add package_name`.