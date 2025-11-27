package com.financeflow.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.financeflow.app.presentation.navigation.FinanceFlowNavigation
import com.financeflow.app.ui.theme.FinanceFlowTheme
import dagger.hilt.android.AndroidEntryPoint
import androidx.hilt.navigation.compose.hiltViewModel
import com.financeflow.app.presentation.viewmodel.ThemeViewModel
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val themeViewModel: ThemeViewModel = hiltViewModel()
            val isDark by themeViewModel.darkMode.collectAsState()
            FinanceFlowTheme(darkTheme = isDark) {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    FinanceFlowNavigation(isDark = isDark, onToggleTheme = { themeViewModel.toggleDarkMode() })
                }
            }
        }
    }
}