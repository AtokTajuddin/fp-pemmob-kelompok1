package com.financeflow.app.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.financeflow.app.data.model.BankLocation
import com.financeflow.app.data.model.BankType
import com.financeflow.app.data.repository.BankLocationRepository
import com.google.android.gms.maps.model.LatLng
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MapsViewModel @Inject constructor(
    private val bankLocationRepository: BankLocationRepository
) : ViewModel() {

    private val _selectedBankType = MutableStateFlow<BankType>(BankType.ALL)
    val selectedBankType: StateFlow<BankType> = _selectedBankType.asStateFlow()

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private val _userLocation = MutableStateFlow<LatLng?>(null)
    val userLocation: StateFlow<LatLng?> = _userLocation.asStateFlow()

    private val _selectedBank = MutableStateFlow<BankLocation?>(null)
    val selectedBank: StateFlow<BankLocation?> = _selectedBank.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage.asStateFlow()

    private val _bankLocations = MutableStateFlow<List<BankLocation>>(emptyList())
    val bankLocations: StateFlow<List<BankLocation>> = _bankLocations.asStateFlow()

    private val _filteredBankLocations = MutableStateFlow<List<BankLocation>>(emptyList())
    val filteredBankLocations: StateFlow<List<BankLocation>> = _filteredBankLocations.asStateFlow()

    // Load banks when user location is available
    fun onUserLocationChanged(location: LatLng) {
        _userLocation.value = location
        loadNearbyBanks(location)
    }

    // Load nearby banks based on user location
    fun loadNearbyBanks(location: LatLng, radius: Int = 50000) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null

            val result = bankLocationRepository.searchNearbyBanks(
                userLocation = location,
                radius = radius,
                bankType = if (_selectedBankType.value == BankType.ALL) null else _selectedBankType.value
            )

            result.onSuccess { banks ->
                _bankLocations.value = banks
                filterBanks()
            }.onFailure { error ->
                _errorMessage.value = error.message ?: "Failed to load banks"
            }

            _isLoading.value = false
        }
    }

    private fun buildTypedQuery(area: String): String {
        val type = _selectedBankType.value
        return if (type == BankType.ALL) {
            "bank $area"
        } else {
            when (type) {
                BankType.MANDIRI -> "Bank Mandiri $area"
                BankType.BCA -> "Bank BCA $area"
                BankType.BRI -> "Bank BRI $area"
                BankType.BNI -> "Bank BNI $area"
                BankType.CIMB -> "CIMB Niaga $area"
                BankType.MAYBANK -> "Maybank $area"
                BankType.JAGO -> "Bank Jago $area"
                BankType.SEABANK -> "Seabank $area"
                BankType.ALL -> "bank $area"
            }
        }
    }

    // Search banks by query across Indonesia (area-based). Apply selected type
    fun onSearchQueryChanged(query: String) {
        _searchQuery.value = query
        if (query.isBlank()) {
            filterBanks()
            return
        }
        performAreaSearch(query)
    }

    // Backward-compatible alias for older UI code
    fun onSearchQueryChange(query: String) = onSearchQueryChanged(query)

    private fun performAreaSearch(area: String) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            val typed = buildTypedQuery(area)
            val result = bankLocationRepository.searchPlacesFlexible(typed)
            result.onSuccess { list ->
                _bankLocations.value = list
                filterBanks()
            }.onFailure { e ->
                _errorMessage.value = e.message ?: "Search failed"
            }
            _isLoading.value = false
        }
    }

    fun onBankTypeSelected(type: BankType) {
        _selectedBankType.value = type
        if (_searchQuery.value.isNotBlank()) {
            performAreaSearch(_searchQuery.value)
        } else {
            filterBanks()
        }
    }

    fun onBankSelected(bank: BankLocation?) {
        _selectedBank.value = bank
    }

    fun updateUserLocation(location: LatLng) {
        _userLocation.value = location
    }

    private fun filterBanks() {
        val type = _selectedBankType.value
        val base = _bankLocations.value
        _filteredBankLocations.value = if (type == BankType.ALL) base else base.filter { it.bankType == type }
    }

    fun getNearbyBanks(userLocation: LatLng, radiusKm: Double = 5.0): List<BankLocation> {
        return _filteredBankLocations.value.filter { bank ->
            val distance = calculateDistance(userLocation, bank.position)
            distance <= radiusKm
        }.sortedBy {
            calculateDistance(userLocation, it.position)
        }
    }

    private fun calculateDistance(start: LatLng, end: LatLng): Double {
        val earthRadius = 6371.0 // km
        val dLat = Math.toRadians(end.latitude - start.latitude)
        val dLon = Math.toRadians(end.longitude - start.longitude)
        val a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(start.latitude)) * Math.cos(Math.toRadians(end.latitude)) *
                Math.sin(dLon / 2) * Math.sin(dLon / 2)
        val c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
        return earthRadius * c
    }

    fun getDirectionsUrl(destination: LatLng, origin: LatLng? = null): String {
        return if (origin != null) {
            "https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving"
        } else {
            "https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}&travelmode=driving"
        }
    }

    fun clearError() {
        _errorMessage.value = null
    }
}
