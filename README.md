# FP Pemrograman Mobile Kelompok-1

| Nama                        | NRP        |
| --------------------------- | ---------- |
| Aras Rizky Ananta           | 5027221053 |
| Christiano Ronaldo Silalahi | 5027241025 |
| Jonathan Zelig Sutopo       | 5027241047 |
| Theodorus Aaron Ugraha      | 5027241056 |
| Mochammad Atha Tajuddin     | 5027241093 |
| Raynard Carlent             | 5027241109 |

---

# Project Structure

├── app/
│ ├── src/main/java/com/financeflow/app/
│ │ ├── MainActivity.kt # Entry point
│ │ ├── presentation/
│ │ │ ├── screens/ # All UI screens
│ │ │ │ ├── HomeScreen.kt # Dashboard
│ │ │ │ ├── ActivityScreen.kt # Transaction history
│ │ │ │ ├── AddFinanceScreen.kt # Add transactions
│ │ │ │ ├── SummaryScreen.kt # Analytics & currency converter
│ │ │ │ └── MapsScreen.kt # Financial services locator
│ │ │ ├── components/ # Reusable UI components
││ │ │ │ └── BottomNavigation.kt # Navigation bar
│ │ │ ├── navigation/ # Navigation setup
│ │ │ └── viewmodel/ # ViewModels
│ │ ├── data/ # Data layer
│ │ │ ├── model/ # Data models
│ │ │ ├── local/ # Database (Room)
│ │ │ └── repository/ # Repository pattern
│ │ ├── di/ # Dependency injection
│ │ ├── ui/ # Theme and design
│ │ └── utils/ # Utility functions
│ │ └── FinanceFlowApplication.kt # Application class
│ ├── src/main/res/ # Android resources
│ └── build.gradle.kts # Module build config
├── build.gradle.kts # Project build config
├── settings.gradle.kts # Project settings
└── README.md # Documentation
