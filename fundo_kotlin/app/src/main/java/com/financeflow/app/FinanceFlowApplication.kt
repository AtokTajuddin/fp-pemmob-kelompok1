package com.financeflow.app

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class FinanceFlowApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Initialize any app-wide dependencies here
    }
}