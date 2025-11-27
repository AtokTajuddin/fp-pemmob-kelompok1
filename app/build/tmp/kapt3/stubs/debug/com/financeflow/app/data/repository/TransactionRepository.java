package com.financeflow.app.data.repository;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u000e\u0010\u0005\u001a\u00020\u0006H\u0086@\u00a2\u0006\u0002\u0010\u0007J\u0016\u0010\b\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\nH\u0086@\u00a2\u0006\u0002\u0010\u000bJ\u0012\u0010\f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\u000e0\rJ\u001a\u0010\u000f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\u000e0\r2\u0006\u0010\u0010\u001a\u00020\u0011J\u0016\u0010\u0012\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\nH\u0086@\u00a2\u0006\u0002\u0010\u000bJ\u0016\u0010\u0013\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\nH\u0086@\u00a2\u0006\u0002\u0010\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u0014"}, d2 = {"Lcom/financeflow/app/data/repository/TransactionRepository;", "", "transactionDao", "Lcom/financeflow/app/data/local/TransactionDao;", "(Lcom/financeflow/app/data/local/TransactionDao;)V", "deleteAllTransactions", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deleteTransaction", "transaction", "Lcom/financeflow/app/data/model/Transaction;", "(Lcom/financeflow/app/data/model/Transaction;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getAllTransactions", "Lkotlinx/coroutines/flow/Flow;", "", "getTransactionsByType", "type", "", "insertTransaction", "updateTransaction", "app_debug"})
public final class TransactionRepository {
    @org.jetbrains.annotations.NotNull()
    private final com.financeflow.app.data.local.TransactionDao transactionDao = null;
    
    @javax.inject.Inject()
    public TransactionRepository(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.local.TransactionDao transactionDao) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<java.util.List<com.financeflow.app.data.model.Transaction>> getAllTransactions() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<java.util.List<com.financeflow.app.data.model.Transaction>> getTransactionsByType(@org.jetbrains.annotations.NotNull()
    java.lang.String type) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object insertTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object updateTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object deleteTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object deleteAllTransactions(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
}