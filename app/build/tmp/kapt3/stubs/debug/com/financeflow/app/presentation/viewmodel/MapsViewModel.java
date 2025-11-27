package com.financeflow.app.presentation.viewmodel;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\t\n\u0002\u0010\b\n\u0002\b\u000b\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u0010\u0010%\u001a\u00020\n2\u0006\u0010&\u001a\u00020\nH\u0002J\u0018\u0010\'\u001a\u00020(2\u0006\u0010)\u001a\u00020\u00132\u0006\u0010*\u001a\u00020\u0013H\u0002J\u0006\u0010+\u001a\u00020,J\b\u0010-\u001a\u00020,H\u0002J\u001a\u0010.\u001a\u00020\n2\u0006\u0010/\u001a\u00020\u00132\n\b\u0002\u00100\u001a\u0004\u0018\u00010\u0013J\u001e\u00101\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\u0006\u0010#\u001a\u00020\u00132\b\b\u0002\u00102\u001a\u00020(J\u0018\u00103\u001a\u00020,2\u0006\u00104\u001a\u00020\u00132\b\b\u0002\u00105\u001a\u000206J\u0010\u00107\u001a\u00020,2\b\u00108\u001a\u0004\u0018\u00010\bJ\u000e\u00109\u001a\u00020,2\u0006\u0010:\u001a\u00020\u0011J\u000e\u0010;\u001a\u00020,2\u0006\u0010<\u001a\u00020\nJ\u000e\u0010=\u001a\u00020,2\u0006\u0010<\u001a\u00020\nJ\u000e\u0010>\u001a\u00020,2\u0006\u00104\u001a\u00020\u0013J\u0010\u0010?\u001a\u00020,2\u0006\u0010&\u001a\u00020\nH\u0002J\u000e\u0010@\u001a\u00020,2\u0006\u00104\u001a\u00020\u0013R\u001a\u0010\u0005\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0016\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u001a\u0010\u000b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\f\u001a\b\u0012\u0004\u0012\u00020\r0\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\n0\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0016\u0010\u000f\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00110\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0016\u0010\u0012\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00130\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u001d\u0010\u0014\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0019\u0010\u0018\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0017R\u001d\u0010\u001a\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0017R\u0017\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\r0\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0017R\u0017\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\n0\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0017R\u0019\u0010\u001f\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b \u0010\u0017R\u0017\u0010!\u001a\b\u0012\u0004\u0012\u00020\u00110\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u0017R\u0019\u0010#\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00130\u0015\u00a2\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0017\u00a8\u0006A"}, d2 = {"Lcom/financeflow/app/presentation/viewmodel/MapsViewModel;", "Landroidx/lifecycle/ViewModel;", "bankLocationRepository", "Lcom/financeflow/app/data/repository/BankLocationRepository;", "(Lcom/financeflow/app/data/repository/BankLocationRepository;)V", "_bankLocations", "Lkotlinx/coroutines/flow/MutableStateFlow;", "", "Lcom/financeflow/app/data/model/BankLocation;", "_errorMessage", "", "_filteredBankLocations", "_isLoading", "", "_searchQuery", "_selectedBank", "_selectedBankType", "Lcom/financeflow/app/data/model/BankType;", "_userLocation", "Lcom/google/android/gms/maps/model/LatLng;", "bankLocations", "Lkotlinx/coroutines/flow/StateFlow;", "getBankLocations", "()Lkotlinx/coroutines/flow/StateFlow;", "errorMessage", "getErrorMessage", "filteredBankLocations", "getFilteredBankLocations", "isLoading", "searchQuery", "getSearchQuery", "selectedBank", "getSelectedBank", "selectedBankType", "getSelectedBankType", "userLocation", "getUserLocation", "buildTypedQuery", "area", "calculateDistance", "", "start", "end", "clearError", "", "filterBanks", "getDirectionsUrl", "destination", "origin", "getNearbyBanks", "radiusKm", "loadNearbyBanks", "location", "radius", "", "onBankSelected", "bank", "onBankTypeSelected", "type", "onSearchQueryChange", "query", "onSearchQueryChanged", "onUserLocationChanged", "performAreaSearch", "updateUserLocation", "app_debug"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class MapsViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.financeflow.app.data.repository.BankLocationRepository bankLocationRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.financeflow.app.data.model.BankType> _selectedBankType = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.financeflow.app.data.model.BankType> selectedBankType = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.String> _searchQuery = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.lang.String> searchQuery = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.google.android.gms.maps.model.LatLng> _userLocation = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.google.android.gms.maps.model.LatLng> userLocation = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.financeflow.app.data.model.BankLocation> _selectedBank = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.financeflow.app.data.model.BankLocation> selectedBank = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Boolean> _isLoading = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> isLoading = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.String> _errorMessage = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.lang.String> errorMessage = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.util.List<com.financeflow.app.data.model.BankLocation>> _bankLocations = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.util.List<com.financeflow.app.data.model.BankLocation>> bankLocations = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.util.List<com.financeflow.app.data.model.BankLocation>> _filteredBankLocations = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.util.List<com.financeflow.app.data.model.BankLocation>> filteredBankLocations = null;
    
    @javax.inject.Inject()
    public MapsViewModel(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.repository.BankLocationRepository bankLocationRepository) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.financeflow.app.data.model.BankType> getSelectedBankType() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.String> getSearchQuery() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.google.android.gms.maps.model.LatLng> getUserLocation() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.financeflow.app.data.model.BankLocation> getSelectedBank() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Boolean> isLoading() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.String> getErrorMessage() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.util.List<com.financeflow.app.data.model.BankLocation>> getBankLocations() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.util.List<com.financeflow.app.data.model.BankLocation>> getFilteredBankLocations() {
        return null;
    }
    
    public final void onUserLocationChanged(@org.jetbrains.annotations.NotNull()
    com.google.android.gms.maps.model.LatLng location) {
    }
    
    public final void loadNearbyBanks(@org.jetbrains.annotations.NotNull()
    com.google.android.gms.maps.model.LatLng location, int radius) {
    }
    
    private final java.lang.String buildTypedQuery(java.lang.String area) {
        return null;
    }
    
    public final void onSearchQueryChanged(@org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    public final void onSearchQueryChange(@org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    private final void performAreaSearch(java.lang.String area) {
    }
    
    public final void onBankTypeSelected(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.model.BankType type) {
    }
    
    public final void onBankSelected(@org.jetbrains.annotations.Nullable()
    com.financeflow.app.data.model.BankLocation bank) {
    }
    
    public final void updateUserLocation(@org.jetbrains.annotations.NotNull()
    com.google.android.gms.maps.model.LatLng location) {
    }
    
    private final void filterBanks() {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<com.financeflow.app.data.model.BankLocation> getNearbyBanks(@org.jetbrains.annotations.NotNull()
    com.google.android.gms.maps.model.LatLng userLocation, double radiusKm) {
        return null;
    }
    
    private final double calculateDistance(com.google.android.gms.maps.model.LatLng start, com.google.android.gms.maps.model.LatLng end) {
        return 0.0;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getDirectionsUrl(@org.jetbrains.annotations.NotNull()
    com.google.android.gms.maps.model.LatLng destination, @org.jetbrains.annotations.Nullable()
    com.google.android.gms.maps.model.LatLng origin) {
        return null;
    }
    
    public final void clearError() {
    }
}