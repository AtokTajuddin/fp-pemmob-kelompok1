package com.financeflow.app.di

import android.content.Context
import androidx.room.Room
import com.financeflow.app.data.local.FinanceFlowDatabase
import com.financeflow.app.data.local.TransactionDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {
    
    @Provides
    @Singleton
    fun provideFinanceFlowDatabase(
        @ApplicationContext context: Context
    ): FinanceFlowDatabase {
        return Room.databaseBuilder(
            context,
            FinanceFlowDatabase::class.java,
            "financeflow_database"
        ).build()
    }
    
    @Provides
    fun provideTransactionDao(
        database: FinanceFlowDatabase
    ): TransactionDao {
        return database.transactionDao()
    }
}