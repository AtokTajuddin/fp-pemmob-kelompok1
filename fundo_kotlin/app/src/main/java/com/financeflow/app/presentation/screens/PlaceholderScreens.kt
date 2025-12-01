package com.financeflow.app.presentation.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.financeflow.app.presentation.components.BottomNavigationBar
import com.financeflow.app.ui.theme.*

// Placeholder screens for navigation structure
@Composable
fun PlaceholderScreen(title: String, navController: NavController) {
    Scaffold(
        bottomBar = { BottomNavigationBar(navController) }
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .background(
                    Brush.verticalGradient(
                        colors = listOf(
                            BackgroundGradientStart,
                            BackgroundGradientMiddle,
                            BackgroundGradientEnd
                        )
                    )
                ),
            contentAlignment = Alignment.Center
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = title,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    color = TextPrimary
                )
                Text(
                    text = "Coming Soon!",
                    fontSize = 16.sp,
                    color = TextSecondary
                )
            }
        }
    }
}