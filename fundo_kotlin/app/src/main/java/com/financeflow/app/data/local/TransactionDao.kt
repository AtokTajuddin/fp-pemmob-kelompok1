package com.financeflow.app.data.local

import androidx.room.*
import com.financeflow.app.data.model.Transaction
import kotlinx.coroutines.flow.Flow
import java.util.Date

@Dao
interface TransactionDao {
    @Query("SELECT * FROM transactions ORDER BY date DESC")
    fun getAllTransactions(): Flow<List<Transaction>>
    
    @Query("SELECT * FROM transactions WHERE type = :type ORDER BY date DESC")
    fun getTransactionsByType(type: String): Flow<List<Transaction>>
    
    @Query("SELECT * FROM transactions WHERE date >= :startDate AND date <= :endDate ORDER BY date DESC")
    fun getTransactionsByDateRange(startDate: Date, endDate: Date): Flow<List<Transaction>>
    
    @Insert
    suspend fun insertTransaction(transaction: Transaction)
    
    @Update
    suspend fun updateTransaction(transaction: Transaction)
    
    @Delete
    suspend fun deleteTransaction(transaction: Transaction)
    
    @Query("DELETE FROM transactions")
    suspend fun deleteAllTransactions()
}