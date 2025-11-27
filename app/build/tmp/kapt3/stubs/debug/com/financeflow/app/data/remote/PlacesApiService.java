package com.financeflow.app.data.remote;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\b\bf\u0018\u00002\u00020\u0001JH\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0001\u0010\u0005\u001a\u00020\u00062\b\b\u0001\u0010\u0007\u001a\u00020\b2\b\b\u0003\u0010\t\u001a\u00020\u00062\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\u00062\b\b\u0001\u0010\u000b\u001a\u00020\u0006H\u00a7@\u00a2\u0006\u0002\u0010\fJ@\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0001\u0010\u000e\u001a\u00020\u00062\n\b\u0003\u0010\u0005\u001a\u0004\u0018\u00010\u00062\n\b\u0003\u0010\u0007\u001a\u0004\u0018\u00010\b2\b\b\u0001\u0010\u000b\u001a\u00020\u0006H\u00a7@\u00a2\u0006\u0002\u0010\u000f\u00a8\u0006\u0010"}, d2 = {"Lcom/financeflow/app/data/remote/PlacesApiService;", "", "getNearbyBanks", "Lretrofit2/Response;", "Lcom/financeflow/app/data/remote/PlacesResponse;", "location", "", "radius", "", "type", "keyword", "apiKey", "(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "searchBanks", "query", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "app_debug"})
public abstract interface PlacesApiService {
    
    @retrofit2.http.GET(value = "nearbysearch/json")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object getNearbyBanks(@retrofit2.http.Query(value = "location")
    @org.jetbrains.annotations.NotNull()
    java.lang.String location, @retrofit2.http.Query(value = "radius")
    int radius, @retrofit2.http.Query(value = "type")
    @org.jetbrains.annotations.NotNull()
    java.lang.String type, @retrofit2.http.Query(value = "keyword")
    @org.jetbrains.annotations.Nullable()
    java.lang.String keyword, @retrofit2.http.Query(value = "key")
    @org.jetbrains.annotations.NotNull()
    java.lang.String apiKey, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super retrofit2.Response<com.financeflow.app.data.remote.PlacesResponse>> $completion);
    
    @retrofit2.http.GET(value = "textsearch/json")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object searchBanks(@retrofit2.http.Query(value = "query")
    @org.jetbrains.annotations.NotNull()
    java.lang.String query, @retrofit2.http.Query(value = "location")
    @org.jetbrains.annotations.Nullable()
    java.lang.String location, @retrofit2.http.Query(value = "radius")
    @org.jetbrains.annotations.Nullable()
    java.lang.Integer radius, @retrofit2.http.Query(value = "key")
    @org.jetbrains.annotations.NotNull()
    java.lang.String apiKey, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super retrofit2.Response<com.financeflow.app.data.remote.PlacesResponse>> $completion);
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 3, xi = 48)
    public static final class DefaultImpls {
    }
}