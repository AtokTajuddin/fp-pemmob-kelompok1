package com.financeflow.app.data.remote

import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Query

interface PlacesApiService {
    @GET("nearbysearch/json")
    suspend fun getNearbyBanks(
        @Query("location") location: String,
        @Query("radius") radius: Int,
        @Query("type") type: String = "bank",
        @Query("keyword") keyword: String? = null,
        @Query("key") apiKey: String
    ): Response<PlacesResponse>

    @GET("textsearch/json")
    suspend fun searchBanks(
        @Query("query") query: String,
        @Query("location") location: String? = null,
        @Query("radius") radius: Int? = null,
        @Query("key") apiKey: String
    ): Response<PlacesResponse>
}

data class PlacesResponse(
    val results: List<PlaceResult>,
    val status: String,
    val error_message: String? = null,
    val next_page_token: String? = null
)

data class PlaceResult(
    val place_id: String,
    val name: String,
    val vicinity: String,
    val geometry: PlaceGeometry,
    val rating: Double? = null,
    val user_ratings_total: Int? = null,
    val business_status: String? = null,
    val types: List<String>? = null,
    val opening_hours: OpeningHours? = null
)

data class PlaceGeometry(
    val location: PlaceLocation
)

data class PlaceLocation(
    val lat: Double,
    val lng: Double
)

data class OpeningHours(
    val open_now: Boolean? = null
)

