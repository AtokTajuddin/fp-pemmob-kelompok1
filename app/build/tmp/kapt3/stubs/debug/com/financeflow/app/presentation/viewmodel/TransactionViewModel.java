package com.financeflow.app.presentation.viewmodel;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0006\n\u0002\b\n\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u000e\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\nJ\u0018\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0016H\u0002J\u000e\u0010\u0018\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\nJ\u0014\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\n0\t2\u0006\u0010\u001a\u001a\u00020\u001bJ\u0006\u0010\u001c\u001a\u00020\u001dJ\u0006\u0010\u001e\u001a\u00020\u001dJ\u0006\u0010\u001f\u001a\u00020\u001dJ\u0018\u0010 \u001a\u00020\u00072\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0016H\u0002J\u0018\u0010!\u001a\u00020\u00072\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0016H\u0002J\u0018\u0010\"\u001a\u00020\u00072\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0016H\u0002J\b\u0010#\u001a\u00020\u0011H\u0002J\u000e\u0010$\u001a\u00020\u001b2\u0006\u0010%\u001a\u00020\u0016J\u000e\u0010&\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\nR\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u001a\u0010\b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t0\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00070\f\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\rR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u001d\u0010\u000e\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t0\f\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\r\u00a8\u0006\'"}, d2 = {"Lcom/financeflow/app/presentation/viewmodel/TransactionViewModel;", "Landroidx/lifecycle/ViewModel;", "repository", "Lcom/financeflow/app/data/repository/TransactionRepository;", "(Lcom/financeflow/app/data/repository/TransactionRepository;)V", "_isLoading", "Lkotlinx/coroutines/flow/MutableStateFlow;", "", "_transactions", "", "Lcom/financeflow/app/data/model/Transaction;", "isLoading", "Lkotlinx/coroutines/flow/StateFlow;", "()Lkotlinx/coroutines/flow/StateFlow;", "transactions", "getTransactions", "addTransaction", "", "transaction", "daysBetween", "", "d1", "Ljava/util/Date;", "d2", "deleteTransaction", "getFilteredTransactions", "filter", "", "getNetBalance", "", "getTotalExpenses", "getTotalIncome", "isSameDay", "isSameMonth", "isSameYear", "loadTransactions", "relativeLabel", "date", "updateTransaction", "app_debug"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class TransactionViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.financeflow.app.data.repository.TransactionRepository repository = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.util.List<com.financeflow.app.data.model.Transaction>> _transactions = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.util.List<com.financeflow.app.data.model.Transaction>> transactions = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Boolean> _isLoading = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> isLoading = null;
    
    @javax.inject.Inject()
    public TransactionViewModel(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.repository.TransactionRepository repository) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.util.List<com.financeflow.app.data.model.Transaction>> getTransactions() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> isLoading() {
        return null;
    }
    
    private final void loadTransactions() {
    }
    
    public final void addTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction) {
    }
    
    public final void updateTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction) {
    }
    
    public final void deleteTransaction(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.Transaction transaction) {
    }
    
    public final double getTotalIncome() {
        return 0.0;
    }
    
    public final double getTotalExpenses() {
        return 0.0;
    }
    
    public final double getNetBalance() {
        return 0.0;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<com.financeflow.app.data.model.Transaction> getFilteredTransactions(@org.jetbrains.annotations.NotNull()
    java.lang.String filter) {
        return null;
    }
    
    private final boolean isSameDay(java.util.Date d1, java.util.Date d2) {
        return false;
    }
    
    private final boolean isSameMonth(java.util.Date d1, java.util.Date d2) {
        return false;
    }
    
    private final boolean isSameYear(java.util.Date d1, java.util.Date d2) {
        return false;
    }
    
    private final long daysBetween(java.util.Date d1, java.util.Date d2) {
        return 0L;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String relativeLabel(@org.jetbrains.annotations.NotNull()
    java.util.Date date) {
        return null;
    }
}