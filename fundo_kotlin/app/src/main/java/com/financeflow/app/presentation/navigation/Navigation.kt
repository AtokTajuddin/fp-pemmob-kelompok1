package com.financeflow.app.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.financeflow.app.presentation.screens.*
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color

@Composable
fun FinanceFlowNavigation(
    navController: NavHostController = rememberNavController(),
    isDark: Boolean = false,
    onToggleTheme: () -> Unit = {}
) {
    NavHost(
        navController = navController,
        startDestination = Screen.Home.route
    ) {
        composable(route = Screen.Home.route) {
            HomeScreen(navController, isDark = isDark, onToggleTheme = onToggleTheme)
        }
        composable(route = Screen.Activity.route) {
            ActivityScreen(navController, isDark = isDark)
        }
        composable(route = Screen.AddFinance.route) {
            AddFinanceScreen(navController, isDark = isDark)
        }
        composable(route = Screen.Summary.route) {
            SummaryScreen(navController, isDark = isDark)
        }
        composable(route = Screen.Maps.route) {
            MapsScreen(navController, isDark = isDark)
        }
    }
}