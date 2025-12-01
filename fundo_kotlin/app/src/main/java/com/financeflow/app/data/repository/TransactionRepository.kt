package com.financeflow.app.data.repository

import com.financeflow.app.data.local.TransactionDao
import com.financeflow.app.data.model.Transaction
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class TransactionRepository @Inject constructor(
    private val transactionDao: TransactionDao
) {
    fun getAllTransactions(): Flow<List<Transaction>> {
        return transactionDao.getAllTransactions()
    }
    
    fun getTransactionsByType(type: String): Flow<List<Transaction>> {
        return transactionDao.getTransactionsByType(type)
    }
    
    suspend fun insertTransaction(transaction: Transaction) {
        transactionDao.insertTransaction(transaction)
    }
    
    suspend fun updateTransaction(transaction: Transaction) {
        transactionDao.updateTransaction(transaction)
    }
    
    suspend fun deleteTransaction(transaction: Transaction) {
        transactionDao.deleteTransaction(transaction)
    }
    
    suspend fun deleteAllTransactions() {
        transactionDao.deleteAllTransactions()
    }
}