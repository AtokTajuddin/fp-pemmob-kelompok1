package com.financeflow.app.utils;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\b\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002J\u001e\u0010\r\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u00062\u0006\u0010\u000f\u001a\u00020\u00052\u0006\u0010\u0010\u001a\u00020\u0005J\u0016\u0010\u0011\u001a\u00020\u00052\u0006\u0010\u000e\u001a\u00020\u00062\u0006\u0010\u0012\u001a\u00020\u0005J\u000e\u0010\u0013\u001a\u00020\u00052\u0006\u0010\u000e\u001a\u00020\u0006J\u000e\u0010\u0013\u001a\u00020\u00052\u0006\u0010\u000e\u001a\u00020\u0014J\u000e\u0010\u0015\u001a\u00020\u00052\u0006\u0010\u0012\u001a\u00020\u0005R\u001a\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u001b\u0010\u0007\u001a\u00020\b8BX\u0082\u0084\u0002\u00a2\u0006\f\n\u0004\b\u000b\u0010\f\u001a\u0004\b\t\u0010\n\u00a8\u0006\u0016"}, d2 = {"Lcom/financeflow/app/utils/CurrencyUtils;", "", "()V", "conversionRates", "", "", "", "idrFormat", "Ljava/text/NumberFormat;", "getIdrFormat", "()Ljava/text/NumberFormat;", "idrFormat$delegate", "Lkotlin/Lazy;", "convertCurrency", "amount", "fromCurrency", "toCurrency", "formatCurrency", "currency", "formatIDR", "", "getCurrencySymbol", "app_debug"})
public final class CurrencyUtils {
    @org.jetbrains.annotations.NotNull()
    private static final kotlin.Lazy idrFormat$delegate = null;
    @org.jetbrains.annotations.NotNull()
    private static final java.util.Map<java.lang.String, java.lang.Double> conversionRates = null;
    @org.jetbrains.annotations.NotNull()
    public static final com.financeflow.app.utils.CurrencyUtils INSTANCE = null;
    
    private CurrencyUtils() {
        super();
    }
    
    private final java.text.NumberFormat getIdrFormat() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String formatIDR(double amount) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String formatIDR(int amount) {
        return null;
    }
    
    public final double convertCurrency(double amount, @org.jetbrains.annotations.NotNull()
    java.lang.String fromCurrency, @org.jetbrains.annotations.NotNull()
    java.lang.String toCurrency) {
        return 0.0;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getCurrencySymbol(@org.jetbrains.annotations.NotNull()
    java.lang.String currency) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String formatCurrency(double amount, @org.jetbrains.annotations.NotNull()
    java.lang.String currency) {
        return null;
    }
}