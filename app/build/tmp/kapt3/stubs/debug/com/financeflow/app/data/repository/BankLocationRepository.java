package com.financeflow.app.data.repository;

@javax.inject.Singleton()
@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\b\n\u0002\b\u0007\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0006H\u0002J \u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\u0006\u0010\r\u001a\u00020\u000e2\b\u0010\u000f\u001a\u0004\u0018\u00010\bH\u0002J*\u0010\u0010\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u000b0\u00112\u0006\u0010\u000f\u001a\u00020\bH\u0086@\u00f8\u0001\u0000\u00f8\u0001\u0001\u00a2\u0006\u0004\b\u0012\u0010\u0013J6\u0010\u0014\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u000b0\u00112\u0006\u0010\u0015\u001a\u00020\u00062\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000eH\u0086@\u00f8\u0001\u0000\u00f8\u0001\u0001\u00a2\u0006\u0004\b\u0016\u0010\u0017J@\u0010\u0018\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u000b0\u00112\u0006\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u0019\u001a\u00020\u001a2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\bH\u0086@\u00f8\u0001\u0000\u00f8\u0001\u0001\u00a2\u0006\u0004\b\u001b\u0010\u001cJ*\u0010\u001d\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u000b0\u00112\u0006\u0010\u001e\u001a\u00020\u0006H\u0086@\u00f8\u0001\u0000\u00f8\u0001\u0001\u00a2\u0006\u0004\b\u001f\u0010 R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082D\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0002\b!\n\u0005\b\u00a1\u001e0\u0001\u00a8\u0006!"}, d2 = {"Lcom/financeflow/app/data/repository/BankLocationRepository;", "", "placesApiService", "Lcom/financeflow/app/data/remote/PlacesApiService;", "(Lcom/financeflow/app/data/remote/PlacesApiService;)V", "apiKey", "", "detectBankType", "Lcom/financeflow/app/data/model/BankType;", "name", "getMockBankData", "", "Lcom/financeflow/app/data/model/BankLocation;", "userLocation", "Lcom/google/android/gms/maps/model/LatLng;", "bankType", "searchBankTypeInIndonesia", "Lkotlin/Result;", "searchBankTypeInIndonesia-gIAlu-s", "(Lcom/financeflow/app/data/model/BankType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "searchBanksByQuery", "query", "searchBanksByQuery-0E7RQCE", "(Ljava/lang/String;Lcom/google/android/gms/maps/model/LatLng;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "searchNearbyBanks", "radius", "", "searchNearbyBanks-BWLJW6A", "(Lcom/google/android/gms/maps/model/LatLng;ILcom/financeflow/app/data/model/BankType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "searchPlacesFlexible", "rawQuery", "searchPlacesFlexible-gIAlu-s", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "app_debug"})
public final class BankLocationRepository {
    @org.jetbrains.annotations.NotNull()
    private final com.financeflow.app.data.remote.PlacesApiService placesApiService = null;
    @org.jetbrains.annotations.NotNull()
    private final java.lang.String apiKey = "AIzaSyAKSi7o_HPc5-RHAiK8Hg1a--ZdUgNKqdg";
    
    @javax.inject.Inject()
    public BankLocationRepository(@org.jetbrains.annotations.NotNull()
    com.financeflow.app.data.remote.PlacesApiService placesApiService) {
        super();
    }
    
    private final com.financeflow.app.data.model.BankType detectBankType(java.lang.String name) {
        return null;
    }
    
    private final java.util.List<com.financeflow.app.data.model.BankLocation> getMockBankData(com.google.android.gms.maps.model.LatLng userLocation, com.financeflow.app.data.model.BankType bankType) {
        return null;
    }
}