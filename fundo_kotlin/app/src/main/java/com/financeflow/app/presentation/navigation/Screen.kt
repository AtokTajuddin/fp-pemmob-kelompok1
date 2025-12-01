package com.financeflow.app.presentation.navigation

sealed class Screen(val route: String) {
    data object Home : Screen("home")
    data object Activity : Screen("activity")
    data object AddFinance : Screen("add_finance")
    data object Summary : Screen("summary")
    data object Maps : Screen("maps")
}