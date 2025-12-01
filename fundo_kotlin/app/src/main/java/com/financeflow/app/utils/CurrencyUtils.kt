package com.financeflow.app.utils

import java.text.NumberFormat
import java.util.*

object CurrencyUtils {
    private val idrFormat: NumberFormat by lazy {
        NumberFormat.getCurrencyInstance(Locale("id", "ID"))
    }
    
    fun formatIDR(amount: Double): String {
        return idrFormat.format(amount).replace("Rp", "Rp ")
    }
    
    fun formatIDR(amount: Int): String {
        return idrFormat.format(amount).replace("Rp", "Rp ")
    }
    
    // Currency conversion rates (mock data)
    private val conversionRates = mapOf(
        "IDR-USD" to 0.000067,
        "IDR-EUR" to 0.000062,
        "IDR-SAR" to 0.00025,
        "IDR-MYR" to 0.00031,
        "IDR-JPY" to 0.0098,
        "USD-IDR" to 14925.0,
        "EUR-IDR" to 16129.0,
        "SAR-IDR" to 4000.0,
        "MYR-IDR" to 3225.0,
        "JPY-IDR" to 102.0
    )
    
    fun convertCurrency(amount: Double, fromCurrency: String, toCurrency: String): Double {
        if (fromCurrency == toCurrency) return amount
        
        val rateKey = "$fromCurrency-$toCurrency"
        val rate = conversionRates[rateKey] ?: 1.0
        return amount * rate
    }
    
    fun getCurrencySymbol(currency: String): String {
        return when (currency) {
            "USD" -> "$"
            "EUR" -> "€"
            "SAR" -> "﷼"
            "MYR" -> "RM"
            "JPY" -> "¥"
            "IDR" -> "Rp"
            else -> "Rp"
        }
    }
    
    fun formatCurrency(amount: Double, currency: String): String {
        val symbol = getCurrencySymbol(currency)
        return when (currency) {
            "USD", "EUR", "SAR", "MYR" -> "$symbol ${String.format("%.6f", amount)}"
            "JPY" -> "$symbol ${amount.toInt()}"
            "IDR" -> formatIDR(amount.toInt())
            else -> "$symbol $amount"
        }
    }
}