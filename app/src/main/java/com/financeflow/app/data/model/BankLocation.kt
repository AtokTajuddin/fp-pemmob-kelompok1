package com.financeflow.app.data.model

import com.google.android.gms.maps.model.LatLng

data class BankLocation(
    val id: String,
    val name: String,
    val bankType: BankType,
    val position: LatLng,
    val address: String,
    val isOpen: Boolean = true,
    val rating: Float = 0f
)

enum class BankType(val displayName: String, val color: Long, val icon: String) {
    MANDIRI("Bank Mandiri", 0xFF0066A1, "🏦"),
    BCA("Bank BCA", 0xFF003D7A, "🏦"),
    BRI("Bank BRI", 0xFF003D7A, "🏦"),
    BNI("Bank BNI", 0xFFFF6600, "🏦"),
    CIMB("CIMB Niaga", 0xFFDC143C, "🏦"),
    MAYBANK("Maybank", 0xFFFFD700, "🏦"),
    JAGO("Bank Jago", 0xFF00C9B7, "🏦"),
    SEABANK("Seabank", 0xFF00A6ED, "🏦"),
    ALL("All Banks", 0xFF6200EE, "🏦")
}

