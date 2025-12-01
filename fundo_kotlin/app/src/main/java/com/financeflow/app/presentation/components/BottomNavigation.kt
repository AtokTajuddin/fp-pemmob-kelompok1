package com.financeflow.app.presentation.components

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.navigation.NavController
import androidx.navigation.compose.currentBackStackEntryAsState
import com.financeflow.app.presentation.navigation.Screen

sealed class BottomNavItem(
    val route: String,
    val icon: ImageVector,
    val label: String
) {
    data object Home : BottomNavItem(Screen.Home.route, Icons.Default.Home, "Home")
    data object Activity : BottomNavItem(Screen.Activity.route, Icons.Default.List, "Activity")
    data object AddFinance : BottomNavItem(Screen.AddFinance.route, Icons.Default.Add, "Add")
    data object Summary : BottomNavItem(Screen.Summary.route, Icons.Default.Analytics, "Summary")
    data object Maps : BottomNavItem(Screen.Maps.route, Icons.Default.LocationOn, "Maps")
}

val bottomNavItems = listOf(
    BottomNavItem.Home,
    BottomNavItem.Activity,
    BottomNavItem.AddFinance,
    BottomNavItem.Summary,
    BottomNavItem.Maps
)

@Composable
fun BottomNavigationBar(navController: NavController) {
    NavigationBar {
        val navBackStackEntry by navController.currentBackStackEntryAsState()
        val currentRoute = navBackStackEntry?.destination?.route
        
        bottomNavItems.forEach { item ->
            NavigationBarItem(
                icon = { Icon(item.icon, contentDescription = item.label) },
                label = { Text(item.label) },
                selected = currentRoute == item.route,
                onClick = {
                    navController.navigate(item.route) {
                        popUpTo(navController.graph.startDestinationId)
                        launchSingleTop = true
                    }
                }
            )
        }
    }
}