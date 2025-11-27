package com.financeflow.app.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.financeflow.app.data.preferences.ThemePreferences
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject
import android.content.Context
import dagger.hilt.android.qualifiers.ApplicationContext

@HiltViewModel
class ThemeViewModel @Inject constructor(
    @ApplicationContext private val context: Context
) : ViewModel() {
    private val prefs = ThemePreferences(context)

    private val _darkMode = MutableStateFlow(false)
    val darkMode: StateFlow<Boolean> = _darkMode.asStateFlow()

    init {
        viewModelScope.launch {
            prefs.isDarkMode.collect { enabled -> _darkMode.value = enabled }
        }
    }

    fun toggleDarkMode() {
        viewModelScope.launch { prefs.setDarkMode(!_darkMode.value) }
    }

    fun setDark(enabled: Boolean) {
        viewModelScope.launch { prefs.setDarkMode(enabled) }
    }
}

