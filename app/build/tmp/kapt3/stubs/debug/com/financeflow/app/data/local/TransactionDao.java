package com.financeflow.app.data.local;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0003\bg\u0018\u00002\u00020\u0001J\u000e\u0010\u0002\u001a\u00020\u0003H\u00a7@\u00a2\u0006\u0002\u0010\u0004J\u0016\u0010\u0005\u001a\u00020\u00032\u0006\u0010\u0006\u001a\u00020\u0007H\u00a7@\u00a2\u0006\u0002\u0010\bJ\u0014\u0010\t\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00070\u000b0\nH\'J$\u0010\f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00070\u000b0\n2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u000eH\'J\u001c\u0010\u0010\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00070\u000b0\n2\u0006\u0010\u0011\u001a\u00020\u0012H\'J\u0016\u0010\u0013\u001a\u00020\u00032\u0006\u0010\u0006\u001a\u00020\u0007H\u00a7@\u00a2\u0006\u0002\u0010\bJ\u0016\u0010\u0014\u001a\u00020\u00032\u0006\u0010\u0006\u001a\u00020\u0007H\u00a7@\u00a2\u0006\u0002\u0010\b\u00a8\u0006\u0015"}, d2 = {"Lcom/financeflow/app/data/local/TransactionDao;", "", "deleteAllTransactions", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deleteTransaction", "transaction", "Lcom/financeflow/app/data/model/Transaction;", "(Lcom/financeflow/app/data/model/Transaction;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getAllTransactions", "Lkotlinx/coroutines/flow/Flow;", "", "getTransactionsByDateRange", "startDate", "Ljava/util/Date;", "endDate", "getTransactionsByType", "type", "", "insertTransaction", "updateTransaction", "app_debug"})
@androidx.room.Dao()
public abstract interface TransactionDao {
    
    @androidx.room.Query(value = "SELECT * FROM transactions ORDER BY date DESC")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<com.financeflow.app.data.model.Transaction>> getAllTransactions();
    
    @androidx.room.Query(value = "SELECT * FROM transactions WHERE type = :type ORDER BY date DESC")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<com.financeflow.app.data.model.Transaction>> getTransactionsByType(@org.jetbrains.annotations.NotNull()
    java.lang.String type);
    
    @androidx.room.Query(value = "SELECT * FROM transactions WHERE date >= :startDate AND date <= :endDate ORDER BY date DESC")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<com.financeflow.app.data.model.Transaction>> getTransactionsByDateRange(@org.jetbrains.annotations.NotNull()
    java.util.Date startDate, @org.jetbrains.annotations.NotNull()
    java.util.Date endDate);
    
    @androidx.room.Insert()
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object insertTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Update()
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object updateTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Delete()
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object deleteTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Query(value = "DELETE FROM transactions")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object deleteAllTransactions(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
}