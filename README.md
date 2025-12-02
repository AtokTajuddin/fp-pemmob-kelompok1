# FP Pemrograman Mobile Kelompok-1

# 💸 Fundo: Smart Financial Management

**Fundo** is a smart mobile application designed to help students manage their finances. Unlike traditional expense trackers, Fundo uses **AI (Gemini)** to act as a personal financial advisor and **Geolocation** to tag where your money goes.

## 🚀 Getting Started

> **New Team Member?** Start here! 👇

- **💻** [**Setup Guide**](./SETUP_GUIDE.md)**:** How to install Flutter, VS Code, and set up your environment.
- **🛠️** [**Tech Stack**](./TECH_STACK.md)**:** The libraries and tools we use (Riverpod, Gemini, etc.).
- **📂** [**Project Structure**](./PROJECT_STRUCTURE.md)**:** Where to find files and where to put your code.
- **🤝** [**Contribution Guidelines**](./CONTRIBUTING.md)**:** How to make a Pull Request and the "Golden Rule" of Git.
- 🤖 [System Prompt](AI_PROMPT.md): Context Priming AI Prompts whenever using an AI.

## ✨ Key Features

1. **🤖 AI Financial Advisor:** Chat with Fundo (powered by Google Gemini) to get advice on saving and budgeting based on your real data.
2. **📍 Geo-Tagging:** Automatically tag transactions with your location. View your spending on an interactive map.
3. **📸 Receipt Scanning:** Snap a photo of your bill to attach it to a transaction.
4. **📊 Smart Analysis:** Visualize your spending habits with intuitive pie charts and graphs.

## 👥 The Team (Kelompok 1)

| Role                      | Member             | NRP                                         | Responsibilities                                        |
| ------------------------- | ------------------ | ------------------------------------------- | ------------------------------------------------------- |
| **Project Manager**       | Jonathan Zelig S.  | 5027241047                                  | Architecture, Repo Management, Integrations, Desigining |
| **Creative Lead (UI/UX)** | _(Assign Name)_    | Design System, Assets, Quality Assurance    | Design System, Assets, Quality Assurance                |
| **Frontend A (Core)**     | _(Assign Name)_    | Dashboard, Transaction Flows, Charts        | Dashboard, Transaction Flows, Charts                    |
| **Frontend B (Features)** | _(Assign Name)_    | Maps, Camera, Settings                      | Maps, Camera, Settings                                  |
| **Backend Engineer**      | _(Assign Name)_    | Firebase Auth, Firestore Database, Security | Firebase Auth, Firestore Database, Security             |
| **AI Specialist**         | Theodorus Aaron U. | Gemini API Integration, Prompt Engineering  | Gemini API Integration, Prompt Engineering              |

## 📱 Screenshots

_(Screenshots will be added here as we develop)_

|Dashboard|Add Transaction|AI Chat|
|---|---|---|
||||

## ⚖️ License

This project is for educational purposes at **Institut Teknologi Sepuluh Nopember (ITS)**.

---

## Team Member

| Nama                        | NRP        |
| --------------------------- | ---------- |
| Aras Rizky Ananta           | 5027221053 |
| Christiano Ronaldo Silalahi | 5027241025 |
| Jonathan Zelig Sutopo       | 5027241047 |
| Theodorus Aaron Ugraha      | 5027241056 |
| Mochammad Atha Tajuddin     | 5027241093 |
| Raynard Carlent             | 5027241109 |

---

##  Project Structure

```text
Project Structure
├── app/
│   ├── src/main/java/com/financeflow/app/
│   │   ├── MainActivity.kt               # Entry point
│   │   ├── presentation/
│   │   │   ├── screens/                  # All UI screens
│   │   │   │   ├── HomeScreen.kt         # Dashboard
│   │   │   │   ├── ActivityScreen.kt     # Transaction history
│   │   │   │   ├── AddFinanceScreen.kt   # Add transactions
│   │   │   │   ├── SummaryScreen.kt      # Analytics & currency converter
│   │   │   │   └── MapsScreen.kt         # Financial services locator
│   │   │   ├── components/               # Reusable UI components
│   │   │   │   └── BottomNavigation.kt   # Navigation bar
│   │   │   ├── navigation/               # Navigation setup
│   │   │   └── viewmodel/                # ViewModels
│   │   ├── data/                         # Data layer
│   │   │   ├── model/                    # Data models
│   │   │   ├── local/                    # Database (Room)
│   │   │   └── repository/               # Repository pattern
│   │   ├── di/                           # Dependency injection
│   │   ├── ui/                           # Theme and design system
│   │   ├── utils/                        # Utility helpers
│   │   └── FinanceFlowApplication.kt     # Application class
│   ├── src/main/res/                     # Android resources
│   └── build.gradle.kts                  # Module build config
├── build.gradle.kts                      # Project build config
├── settings.gradle.kts                   # Project settings
└── README.md                             # Documentation
```
