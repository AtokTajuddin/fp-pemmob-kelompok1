package com.financeflow.app.data.local

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.financeflow.app.data.model.Transaction

@Database(
    entities = [Transaction::class],
    version = 1,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class FinanceFlowDatabase : RoomDatabase() {
    abstract fun transactionDao(): TransactionDao
}