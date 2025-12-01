package com.financeflow.app.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.financeflow.app.data.model.Transaction
import com.financeflow.app.data.repository.TransactionRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.util.Calendar
import java.util.Date
import java.util.concurrent.TimeUnit
import javax.inject.Inject

@HiltViewModel
class TransactionViewModel @Inject constructor(
    private val repository: TransactionRepository
) : ViewModel() {
    
    private val _transactions = MutableStateFlow<List<Transaction>>(emptyList())
    val transactions: StateFlow<List<Transaction>> = _transactions.asStateFlow()
    
    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()
    
    init {
        loadTransactions()
    }
    
    private fun loadTransactions() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                repository.getAllTransactions().collect { transactions ->
                    _transactions.value = transactions
                }
            } catch (e: Exception) {
                // Handle error
            } finally {
                _isLoading.value = false
            }
        }
    }
    
    fun addTransaction(transaction: Transaction) {
        viewModelScope.launch {
            try {
                repository.insertTransaction(transaction)
            } catch (e: Exception) {
                // Handle error
            }
        }
    }
    
    fun updateTransaction(transaction: Transaction) {
        viewModelScope.launch {
            try {
                repository.updateTransaction(transaction)
            } catch (e: Exception) {
                // Handle error
            }
        }
    }
    
    fun deleteTransaction(transaction: Transaction) {
        viewModelScope.launch {
            try {
                repository.deleteTransaction(transaction)
            } catch (e: Exception) {
                // Handle error
            }
        }
    }
    
    fun getTotalIncome(): Double {
        return _transactions.value
            .filter { it.type == "income" }
            .sumOf { it.amount }
    }
    
    fun getTotalExpenses(): Double {
        return _transactions.value
            .filter { it.type == "expense" }
            .sumOf { it.amount }
    }
    
    fun getNetBalance(): Double {
        return getTotalIncome() - getTotalExpenses()
    }

    fun getFilteredTransactions(filter: String): List<Transaction> {
        val all = _transactions.value
        if (filter == "All") return all
        val cal = Calendar.getInstance()
        val now = cal.time
        return when (filter) {
            "Today" -> all.filter { isSameDay(it.date, now) }
            "Week" -> all.filter { daysBetween(it.date, now) < 7 }
            "Month" -> all.filter { isSameMonth(it.date, now) }
            "Year" -> all.filter { isSameYear(it.date, now) }
            else -> all
        }
    }

    private fun isSameDay(d1: Date, d2: Date): Boolean {
        val c1 = Calendar.getInstance().apply { time = d1 }
        val c2 = Calendar.getInstance().apply { time = d2 }
        return c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR) &&
            c1.get(Calendar.DAY_OF_YEAR) == c2.get(Calendar.DAY_OF_YEAR)
    }
    private fun isSameMonth(d1: Date, d2: Date): Boolean {
        val c1 = Calendar.getInstance().apply { time = d1 }
        val c2 = Calendar.getInstance().apply { time = d2 }
        return c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR) &&
            c1.get(Calendar.MONTH) == c2.get(Calendar.MONTH)
    }
    private fun isSameYear(d1: Date, d2: Date): Boolean {
        val c1 = Calendar.getInstance().apply { time = d1 }
        val c2 = Calendar.getInstance().apply { time = d2 }
        return c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR)
    }
    private fun daysBetween(d1: Date, d2: Date): Long {
        val diff = d2.time - d1.time
        return TimeUnit.MILLISECONDS.toDays(diff)
    }

    fun relativeLabel(date: Date): String {
        val now = Date()
        val days = daysBetween(date, now)
        return when (days) {
            0L -> "Today"
            1L -> "Yesterday"
            in 2..6 -> "$days days ago"
            in 7..13 -> "1 week ago"
            else -> android.text.format.DateFormat.format("dd MMM", date).toString()
        }
    }
}