package com.financeflow.app.data.repository

import android.util.Log
import com.financeflow.app.data.model.BankLocation
import com.financeflow.app.data.model.BankType
import com.financeflow.app.data.remote.PlacesApiService
import com.google.android.gms.maps.model.LatLng
import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

@Singleton
class BankLocationRepository @Inject constructor(private val placesApiService: PlacesApiService) {
    private val apiKey = "YOUR_API_KEY_YA"

    // Search for banks near user's location
    suspend fun searchNearbyBanks(
            userLocation: LatLng,
            radius: Int = 50000, // 50km radius
            bankType: BankType? = null
    ): Result<List<BankLocation>> =
            withContext(Dispatchers.IO) {
                try {
                    val keyword =
                            when (bankType) {
                                BankType.MANDIRI -> "Bank Mandiri"
                                BankType.BCA -> "Bank BCA"
                                BankType.BRI -> "Bank BRI"
                                BankType.BNI -> "Bank BNI"
                                BankType.CIMB -> "CIMB Niaga"
                                BankType.MAYBANK -> "Maybank"
                                BankType.JAGO -> "Bank Jago"
                                BankType.SEABANK -> "Seabank"
                                else -> null
                            }

                    val location = "${userLocation.latitude},${userLocation.longitude}"
                    val response =
                            placesApiService.getNearbyBanks(
                                    location = location,
                                    radius = radius,
                                    keyword = keyword,
                                    apiKey = apiKey
                            )

                    if (response.isSuccessful && response.body()?.status == "OK") {
                        val banks =
                                response.body()?.results?.mapNotNull { result ->
                                    val detectedBankType = detectBankType(result.name)
                                    if (bankType == null ||
                                                    bankType == BankType.ALL ||
                                                    detectedBankType == bankType
                                    ) {
                                        BankLocation(
                                                id = result.place_id,
                                                name = result.name,
                                                bankType = detectedBankType,
                                                position =
                                                        LatLng(
                                                                result.geometry.location.lat,
                                                                result.geometry.location.lng
                                                        ),
                                                address = result.vicinity,
                                                isOpen = result.opening_hours?.open_now ?: true,
                                                rating = result.rating?.toFloat() ?: 0f
                                        )
                                    } else null
                                }
                                        ?: emptyList()

                        Result.success(banks)
                    } else {
                        val status = response.body()?.status ?: "UNKNOWN"
                        Log.e(
                                "BankLocationRepo",
                                "API Error: $status - ${response.body()?.error_message}"
                        )

                        // If REQUEST_DENIED or API error, return mock data
                        if (status == "REQUEST_DENIED" || status == "INVALID_REQUEST") {
                            Log.w("BankLocationRepo", "API key issue detected, using mock data")
                            Result.success(getMockBankData(userLocation, bankType))
                        } else {
                            Result.failure(Exception("Failed to fetch banks: $status"))
                        }
                    }
                } catch (e: Exception) {
                    Log.e("BankLocationRepo", "Exception: ${e.message}", e)
                    // Return mock data on exception
                    Log.w("BankLocationRepo", "Using mock data due to exception")
                    Result.success(getMockBankData(userLocation, bankType))
                }
            }

    // Search banks across Indonesia by query
    suspend fun searchBanksByQuery(
            query: String,
            userLocation: LatLng? = null
    ): Result<List<BankLocation>> =
            withContext(Dispatchers.IO) {
                try {
                    val location = userLocation?.let { "${it.latitude},${it.longitude}" }
                    val response =
                            placesApiService.searchBanks(
                                    query = "$query bank Indonesia",
                                    location = location,
                                    radius =
                                            if (location != null) 100000
                                            else null, // 100km if location provided
                                    apiKey = apiKey
                            )

                    if (response.isSuccessful && response.body()?.status == "OK") {
                        val banks =
                                response.body()?.results?.map { result ->
                                    BankLocation(
                                            id = result.place_id,
                                            name = result.name,
                                            bankType = detectBankType(result.name),
                                            position =
                                                    LatLng(
                                                            result.geometry.location.lat,
                                                            result.geometry.location.lng
                                                    ),
                                            address = result.vicinity,
                                            isOpen = result.opening_hours?.open_now ?: true,
                                            rating = result.rating?.toFloat() ?: 0f
                                    )
                                }
                                        ?: emptyList()

                        Result.success(banks)
                    } else {
                        val status = response.body()?.status ?: "UNKNOWN"
                        Log.w("BankLocationRepo", "Search API error: $status, using mock data")
                        // Fallback to mock data
                        Result.success(
                                userLocation?.let { getMockBankData(it, null) } ?: emptyList()
                        )
                    }
                } catch (e: Exception) {
                    Log.w("BankLocationRepo", "Search exception, using mock data: ${e.message}")
                    Result.success(userLocation?.let { getMockBankData(it, null) } ?: emptyList())
                }
            }

    // Search specific bank type across all Indonesia
    suspend fun searchBankTypeInIndonesia(bankType: BankType): Result<List<BankLocation>> {
        return when (bankType) {
            BankType.MANDIRI -> searchBanksByQuery("Bank Mandiri")
            BankType.BCA -> searchBanksByQuery("Bank BCA")
            BankType.BRI -> searchBanksByQuery("Bank BRI")
            BankType.BNI -> searchBanksByQuery("Bank BNI")
            BankType.CIMB -> searchBanksByQuery("CIMB Niaga")
            BankType.MAYBANK -> searchBanksByQuery("Maybank Indonesia")
            BankType.JAGO -> searchBanksByQuery("Bank Jago")
            BankType.SEABANK -> searchBanksByQuery("Seabank Indonesia")
            BankType.ALL -> searchBanksByQuery("bank")
        }
    }

    // Flexible search function that accepts raw query
    suspend fun searchPlacesFlexible(rawQuery: String): Result<List<BankLocation>> =
            withContext(Dispatchers.IO) {
                try {
                    val response =
                            placesApiService.searchBanks(
                                    query = rawQuery.trim(),
                                    location = null,
                                    radius = null,
                                    apiKey = apiKey
                            )
                    if (response.isSuccessful && response.body()?.status == "OK") {
                        val banks =
                                response.body()?.results?.map { result ->
                                    BankLocation(
                                            id = result.place_id,
                                            name = result.name,
                                            bankType = detectBankType(result.name),
                                            position =
                                                    LatLng(
                                                            result.geometry.location.lat,
                                                            result.geometry.location.lng
                                                    ),
                                            address = result.vicinity,
                                            isOpen = result.opening_hours?.open_now ?: true,
                                            rating = result.rating?.toFloat() ?: 0f
                                    )
                                }
                                        ?: emptyList()
                        Result.success(banks)
                    } else {
                        val status = response.body()?.status ?: "UNKNOWN"
                        Log.w(
                                "BankLocationRepo",
                                "Flexible search API error: $status, returning empty list"
                        )
                        Result.success(emptyList())
                    }
                } catch (e: Exception) {
                    Log.w("BankLocationRepo", "Flexible search exception: ${e.message}")
                    Result.success(emptyList())
                }
            }

    private fun detectBankType(name: String): BankType {
        return when {
            name.contains("Mandiri", ignoreCase = true) -> BankType.MANDIRI
            name.contains("BCA", ignoreCase = true) -> BankType.BCA
            name.contains("BRI", ignoreCase = true) -> BankType.BRI
            name.contains("BNI", ignoreCase = true) -> BankType.BNI
            name.contains("CIMB", ignoreCase = true) -> BankType.CIMB
            name.contains("Maybank", ignoreCase = true) -> BankType.MAYBANK
            name.contains("Jago", ignoreCase = true) -> BankType.JAGO
            name.contains("Seabank", ignoreCase = true) ||
                    name.contains("Sea Bank", ignoreCase = true) -> BankType.SEABANK
            else -> BankType.ALL
        }
    }

    // Mock data for fallback when API is unavailable
    private fun getMockBankData(userLocation: LatLng, bankType: BankType?): List<BankLocation> {
        val mockBanks =
                listOf(
                        BankLocation(
                                id = "mock_mandiri_1",
                                name = "Bank Mandiri - Surabaya Center",
                                bankType = BankType.MANDIRI,
                                position =
                                        LatLng(
                                                userLocation.latitude + 0.01,
                                                userLocation.longitude + 0.01
                                        ),
                                address = "Jl. Pemuda No. 1-3, Surabaya",
                                isOpen = true,
                                rating = 4.5f
                        ),
                        BankLocation(
                                id = "mock_bca_1",
                                name = "BCA KCU Surabaya",
                                bankType = BankType.BCA,
                                position =
                                        LatLng(
                                                userLocation.latitude - 0.01,
                                                userLocation.longitude + 0.01
                                        ),
                                address = "Jl. Basuki Rahmat No. 98-104, Surabaya",
                                isOpen = true,
                                rating = 4.3f
                        ),
                        BankLocation(
                                id = "mock_bri_1",
                                name = "Bank BRI Cabang Surabaya",
                                bankType = BankType.BRI,
                                position =
                                        LatLng(
                                                userLocation.latitude + 0.015,
                                                userLocation.longitude - 0.01
                                        ),
                                address = "Jl. Raya Darmo No. 135, Surabaya",
                                isOpen = true,
                                rating = 4.4f
                        ),
                        BankLocation(
                                id = "mock_bni_1",
                                name = "Bank BNI Kantor Cabang Surabaya",
                                bankType = BankType.BNI,
                                position =
                                        LatLng(
                                                userLocation.latitude - 0.012,
                                                userLocation.longitude - 0.015
                                        ),
                                address = "Jl. Tunjungan No. 52, Surabaya",
                                isOpen = true,
                                rating = 4.2f
                        ),
                        BankLocation(
                                id = "mock_cimb_1",
                                name = "CIMB Niaga Surabaya",
                                bankType = BankType.CIMB,
                                position =
                                        LatLng(
                                                userLocation.latitude + 0.008,
                                                userLocation.longitude + 0.012
                                        ),
                                address = "Jl. HR Muhammad No. 2-4, Surabaya",
                                isOpen = true,
                                rating = 4.1f
                        ),
                        BankLocation(
                                id = "mock_jago_1",
                                name = "Bank Jago Digital",
                                bankType = BankType.JAGO,
                                position =
                                        LatLng(
                                                userLocation.latitude - 0.008,
                                                userLocation.longitude + 0.008
                                        ),
                                address = "Pakuwon Mall, Surabaya",
                                isOpen = true,
                                rating = 4.6f
                        )
                )

        return if (bankType == null || bankType == BankType.ALL) {
            mockBanks
        } else {
            mockBanks.filter { it.bankType == bankType }
        }
    }
}
