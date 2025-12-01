package com.financeflow.app.data.preferences

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.map
import java.io.IOException

private const val THEME_PREFS_NAME = "financeflow_theme_prefs"
private val Context.dataStore by preferencesDataStore(name = THEME_PREFS_NAME)

object ThemePreferencesKeys {
    val DARK_MODE = booleanPreferencesKey("dark_mode_enabled")
}

class ThemePreferences(private val context: Context) {
    val isDarkMode: Flow<Boolean> = context.dataStore.data
        .catch { e -> if (e is IOException) emit(emptyPreferences()) else throw e }
        .map { prefs -> prefs[ThemePreferencesKeys.DARK_MODE] ?: false }

    suspend fun setDarkMode(enabled: Boolean) {
        context.dataStore.edit { prefs ->
            prefs[ThemePreferencesKeys.DARK_MODE] = enabled
        }
    }
}

