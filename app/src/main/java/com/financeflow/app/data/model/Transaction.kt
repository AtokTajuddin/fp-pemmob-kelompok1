package com.financeflow.app.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.Date

@Entity(tableName = "transactions")
data class Transaction(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val type: String, // "income" or "expense"
    val amount: Double,
    val category: String,
    val description: String,
    val date: Date = Date(),
    val icon: String = ""
)

// Transaction categories
val incomeCategories = listOf(
    TransactionCategory("salary", "Salary", "💰"),
    TransactionCategory("freelance", "Freelance", "💻"),
    TransactionCategory("investment", "Investment", "📈"),
    TransactionCategory("business", "Business", "🏢"),
    TransactionCategory("other", "Other", "💵")
)

val expenseCategories = listOf(
    TransactionCategory("food", "Food & Dining", "🍽️"),
    TransactionCategory("transport", "Transportation", "🚌"),
    TransactionCategory("shopping", "Shopping", "🛍️"),
    TransactionCategory("entertainment", "Entertainment", "🎬"),
    TransactionCategory("education", "Education", "📚"),
    TransactionCategory("healthcare", "Healthcare", "🏥"),
    TransactionCategory("utilities", "Utilities", "⚡"),
    TransactionCategory("other", "Other", "📝")
)

data class TransactionCategory(
    val id: String,
    val name: String,
    val icon: String
)