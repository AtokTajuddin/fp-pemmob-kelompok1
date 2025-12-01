package com.financeflow.app.presentation.screens

import android.Manifest
import android.content.Intent
import android.net.Uri
import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.financeflow.app.data.model.BankType
import com.financeflow.app.presentation.components.BottomNavigationBar
import com.financeflow.app.presentation.viewmodel.MapsViewModel
import com.financeflow.app.ui.theme.*
import com.financeflow.app.ui.theme.NavyBlue as PrimaryBlue
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.rememberMultiplePermissionsState
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.maps.android.compose.*
import kotlinx.coroutines.delay

@OptIn(ExperimentalMaterial3Api::class, ExperimentalPermissionsApi::class)
@Composable
fun MapsScreen(
    navController: NavController,
    viewModel: MapsViewModel = hiltViewModel(),
    isDark: Boolean
) {
    val context = LocalContext.current
    val selectedBankType by viewModel.selectedBankType.collectAsState()
    val searchQuery by viewModel.searchQuery.collectAsState()
    val filteredBanks by viewModel.filteredBankLocations.collectAsState()
    val selectedBank by viewModel.selectedBank.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()
    val userLocation by viewModel.userLocation.collectAsState()

    // Indonesia default location (Jakarta)
    val defaultLocation = LatLng(-6.2088, 106.8456)
    val cameraPositionState = rememberCameraPositionState {
        position = CameraPosition.fromLatLngZoom(userLocation ?: defaultLocation, 12f)
    }

    // Update camera when user location changes
    LaunchedEffect(userLocation) {
        userLocation?.let {
            cameraPositionState.position = CameraPosition.fromLatLngZoom(it, 14f)
        }
    }

    // Request location permissions
    val locationPermissions = rememberMultiplePermissionsState(
        permissions = listOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
        )
    )
    
    // Get user location when permissions are granted
    LaunchedEffect(locationPermissions.allPermissionsGranted) {
        if (locationPermissions.allPermissionsGranted) {
            try {
                val fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
                fusedLocationClient.lastLocation.addOnSuccessListener { location ->
                    location?.let {
                        val latLng = LatLng(it.latitude, it.longitude)
                        viewModel.onUserLocationChanged(latLng)
                    } ?: run {
                        // No location available, load banks around Jakarta
                        viewModel.onUserLocationChanged(defaultLocation)
                    }
                }
            } catch (e: SecurityException) {
                viewModel.onUserLocationChanged(defaultLocation)
            }
        } else {
            locationPermissions.launchMultiplePermissionRequest()
        }
    }
    
    Scaffold(
        bottomBar = { BottomNavigationBar(navController) },
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        "Bank Locations - All Indonesia",
                        fontWeight = FontWeight.Bold
                    )
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = com.financeflow.app.ui.theme.NavyBlue,
                    titleContentColor = Color.White
                )
            )
        }
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // Google Map
            GoogleMap(
                modifier = Modifier.fillMaxSize(),
                cameraPositionState = cameraPositionState,
                properties = MapProperties(
                    isMyLocationEnabled = locationPermissions.allPermissionsGranted
                ),
                uiSettings = MapUiSettings(
                    zoomControlsEnabled = false,
                    myLocationButtonEnabled = true,
                    compassEnabled = true
                )
            ) {
                filteredBanks.forEach { bank ->
                    Marker(
                        state = MarkerState(position = bank.position),
                        title = bank.name,
                        snippet = bank.address,
                        icon = BitmapDescriptorFactory.defaultMarker(
                            when (bank.bankType) {
                                BankType.MANDIRI -> BitmapDescriptorFactory.HUE_BLUE
                                BankType.BCA -> BitmapDescriptorFactory.HUE_AZURE
                                BankType.BRI -> BitmapDescriptorFactory.HUE_CYAN
                                BankType.BNI -> BitmapDescriptorFactory.HUE_ORANGE
                                BankType.CIMB -> BitmapDescriptorFactory.HUE_RED
                                BankType.MAYBANK -> BitmapDescriptorFactory.HUE_YELLOW
                                BankType.JAGO -> BitmapDescriptorFactory.HUE_GREEN
                                BankType.SEABANK -> BitmapDescriptorFactory.HUE_VIOLET
                                else -> BitmapDescriptorFactory.HUE_RED
                            }
                        ),
                        onClick = {
                            viewModel.onBankSelected(bank)
                            true
                        }
                    )
                }
            }

            // Search Bar
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
                    .align(Alignment.TopCenter),
                shape = RoundedCornerShape(28.dp),
                elevation = CardDefaults.cardElevation(8.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                TextField(
                    value = searchQuery,
                    onValueChange = { viewModel.onSearchQueryChange(it) },
                    modifier = Modifier.fillMaxWidth(),
                    placeholder = {
                        Text(
                            "Search banks across Indonesia...",
                            color = Color.Gray
                        )
                    },
                    leadingIcon = {
                        if (isLoading) {
                            CircularProgressIndicator(
                                modifier = Modifier.size(20.dp),
                                strokeWidth = 2.dp,
                                color = com.financeflow.app.ui.theme.NavyBlue
                            )
                        } else {
                            Icon(
                                Icons.Default.Search,
                                contentDescription = "Search",
                                tint = com.financeflow.app.ui.theme.NavyBlue
                            )
                        }
                    },
                    trailingIcon = {
                        if (searchQuery.isNotEmpty()) {
                            IconButton(onClick = { viewModel.onSearchQueryChange("") }) {
                                Icon(
                                    Icons.Default.Close,
                                    contentDescription = "Clear",
                                    tint = Color.Gray
                                )
                            }
                        }
                    },
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = Color.Transparent,
                        unfocusedContainerColor = Color.Transparent,
                        focusedIndicatorColor = Color.Transparent,
                        unfocusedIndicatorColor = Color.Transparent
                    ),
                    singleLine = true
                )
            }
            
            // Bank Type Filter Chips
            LazyRow(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 88.dp, start = 16.dp, end = 16.dp)
                    .align(Alignment.TopCenter),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(BankType.values().toList()) { bankType ->
                    FilterChip(
                        selected = selectedBankType == bankType,
                        onClick = { viewModel.onBankTypeSelected(bankType) },
                        label = {
                            Text(
                                bankType.displayName,
                                fontSize = 13.sp
                            )
                        },
                        leadingIcon = {
                            Text(bankType.icon, fontSize = 16.sp)
                        },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = Color(bankType.color),
                            selectedLabelColor = Color.White,
                            containerColor = Color.White
                        )
                    )
                }
            }
            
            // Error Message
            errorMessage?.let { error ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                        .align(Alignment.TopCenter)
                        .padding(top = 150.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = Color(0xFFFFEBEE)
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            error,
                            color = Color(0xFFC62828),
                            modifier = Modifier.weight(1f)
                        )
                        IconButton(onClick = { viewModel.clearError() }) {
                            Icon(
                                Icons.Default.Close,
                                contentDescription = "Close",
                                tint = Color(0xFFC62828)
                            )
                        }
                    }
                }
            }

            // Selected Bank Details Bottom Sheet
            selectedBank?.let { bank ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .align(Alignment.BottomCenter)
                        .padding(16.dp),
                    shape = RoundedCornerShape(20.dp),
                    elevation = CardDefaults.cardElevation(12.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(20.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.Top
                        ) {
                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    bank.name,
                                    fontSize = 20.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = Color(bank.bankType.color)
                                )
                                Spacer(modifier = Modifier.height(4.dp))
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Text(
                                        bank.bankType.displayName,
                                        fontSize = 14.sp,
                                        color = Color.Gray
                                    )
                                    if (bank.isOpen) {
                                        Spacer(modifier = Modifier.width(8.dp))
                                        Text(
                                            "• Open",
                                            fontSize = 12.sp,
                                            color = Color(0xFF4CAF50),
                                            fontWeight = FontWeight.Medium
                                        )
                                    }
                                }
                            }
                            IconButton(onClick = { viewModel.onBankSelected(null) }) {
                                Icon(
                                    Icons.Default.Close,
                                    contentDescription = "Close",
                                    tint = Color.Gray
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(12.dp))

                        // Address
                        Row(
                            verticalAlignment = Alignment.Top,
                            modifier = Modifier.padding(vertical = 4.dp)
                        ) {
                            Icon(
                                Icons.Default.LocationOn,
                                contentDescription = null,
                                tint = com.financeflow.app.ui.theme.NavyBlue,
                                modifier = Modifier.size(20.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                bank.address,
                                fontSize = 14.sp,
                                color = Color.DarkGray
                            )
                        }

                        // Rating
                        if (bank.rating > 0) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.padding(vertical = 4.dp)
                            ) {
                                Icon(
                                    Icons.Default.Star,
                                    contentDescription = null,
                                    tint = Color(0xFFFFC107),
                                    modifier = Modifier.size(20.dp)
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(
                                    "${bank.rating} / 5.0",
                                    fontSize = 14.sp,
                                    color = Color.DarkGray,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        // Action Buttons
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(12.dp)
                        ) {
                            // Get Directions Button with animation
                            AnimatedButton(
                                onClick = {
                                    val directionsUrl = viewModel.getDirectionsUrl(
                                        destination = bank.position,
                                        origin = userLocation
                                    )
                                    // Create intent for Google Maps
                                    val gmmIntentUri = Uri.parse("google.navigation:q=${bank.position.latitude},${bank.position.longitude}")
                                    val mapIntent = Intent(Intent.ACTION_VIEW, gmmIntentUri).apply {
                                        setPackage("com.google.android.apps.maps")
                                    }

                                    // Try to open Google Maps app, fallback to browser
                                    if (mapIntent.resolveActivity(context.packageManager) != null) {
                                        context.startActivity(mapIntent)
                                    } else {
                                        // Fallback to web browser with directions
                                        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(directionsUrl))
                                        context.startActivity(browserIntent)
                                    }
                                },
                                modifier = Modifier.weight(1f),
                                containerColor = com.financeflow.app.ui.theme.NavyBlue,
                                contentColor = Color.White,
                                icon = Icons.Default.Directions,
                                text = "Directions"
                            )

                            // Share Button with animation
                            AnimatedOutlinedButton(
                                onClick = {
                                    val shareText = buildString {
                                        append("📍 ${bank.name}\n")
                                        append("📌 ${bank.address}\n")
                                        append("⭐ Rating: ${bank.rating}/5\n")
                                        append("🔗 https://maps.google.com/?q=${bank.position.latitude},${bank.position.longitude}")
                                    }
                                    val sendIntent = Intent().apply {
                                        action = Intent.ACTION_SEND
                                        putExtra(Intent.EXTRA_TEXT, shareText)
                                        putExtra(Intent.EXTRA_SUBJECT, "Bank Location: ${bank.name}")
                                        type = "text/plain"
                                    }
                                    val shareIntent = Intent.createChooser(sendIntent, "Share Bank Location")
                                    context.startActivity(shareIntent)
                                },
                                modifier = Modifier.weight(1f),
                                contentColor = com.financeflow.app.ui.theme.NavyBlue,
                                icon = Icons.Default.Share,
                                text = "Share"
                            )
                        }
                    }
                }
            }

            // Bank Count Indicator
            if (filteredBanks.isNotEmpty() && selectedBank == null) {
                Card(
                    modifier = Modifier
                        .align(Alignment.BottomCenter)
                        .padding(bottom = 24.dp),
                    shape = RoundedCornerShape(20.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = com.financeflow.app.ui.theme.NavyBlue
                    ),
                    elevation = CardDefaults.cardElevation(8.dp)
                ) {
                    Text(
                        "${filteredBanks.size} banks found",
                        modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp),
                        color = Color.White,
                        fontWeight = FontWeight.Medium,
                        fontSize = 14.sp
                    )
                }
            }

            // Loading Indicator
            if (isLoading && filteredBanks.isEmpty()) {
                Card(
                    modifier = Modifier
                        .align(Alignment.Center),
                    colors = CardDefaults.cardColors(
                        containerColor = Color.White
                    ),
                    elevation = CardDefaults.cardElevation(8.dp)
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        CircularProgressIndicator(color = com.financeflow.app.ui.theme.NavyBlue)
                        Spacer(modifier = Modifier.height(16.dp))
                        Text(
                            "Loading banks across Indonesia...",
                            fontWeight = FontWeight.Medium
                        )
                    }
                }
            }
        }
    }
}

// Animated Button with scale effect for better UX
@Composable
fun AnimatedButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    containerColor: Color = PrimaryBlue,
    contentColor: Color = Color.White,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    text: String
) {
    var isPressed by remember { mutableStateOf(false) }

    val scale by animateFloatAsState(
        targetValue = if (isPressed) 0.95f else 1f,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessLow
        ),
        label = "button_scale"
    )

    Button(
        onClick = {
            isPressed = true
            onClick()
        },
        modifier = modifier.graphicsLayer {
            scaleX = scale
            scaleY = scale
        },
        colors = ButtonDefaults.buttonColors(
            containerColor = containerColor,
            contentColor = contentColor
        ),
        shape = RoundedCornerShape(12.dp),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 4.dp,
            pressedElevation = 8.dp
        )
    ) {
        Icon(
            icon,
            contentDescription = null,
            modifier = Modifier.size(20.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
        Text(text, fontWeight = FontWeight.Medium)
    }

    LaunchedEffect(isPressed) {
        if (isPressed) {
            delay(150)
            isPressed = false
        }
    }
}

@Composable
fun AnimatedOutlinedButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    contentColor: Color = com.financeflow.app.ui.theme.NavyBlue,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    text: String
) {
    var isPressed by remember { mutableStateOf(false) }

    val scale by animateFloatAsState(
        targetValue = if (isPressed) 0.95f else 1f,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessLow
        ),
        label = "outlined_button_scale"
    )

    OutlinedButton(
        onClick = {
            isPressed = true
            onClick()
        },
        modifier = modifier.graphicsLayer {
            scaleX = scale
            scaleY = scale
        },
        shape = RoundedCornerShape(12.dp),
        colors = ButtonDefaults.outlinedButtonColors(
            contentColor = contentColor
        ),
        border = ButtonDefaults.outlinedButtonBorder.copy(width = 2.dp)
    ) {
        Icon(
            icon,
            contentDescription = null,
            modifier = Modifier.size(20.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
        Text(text, fontWeight = FontWeight.Medium)
    }

    LaunchedEffect(isPressed) {
        if (isPressed) {
            delay(150)
            isPressed = false
        }
    }
}
