package com.financeflow.app.presentation.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.financeflow.app.presentation.components.BottomNavigationBar
import com.financeflow.app.ui.theme.*
import com.financeflow.app.utils.CurrencyUtils
import androidx.hilt.navigation.compose.hiltViewModel
import com.financeflow.app.presentation.viewmodel.TransactionViewModel
import java.util.Calendar

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SummaryScreen(
    navController: NavController,
    viewModel: TransactionViewModel = hiltViewModel(),
    isDark: Boolean
) {
    val transactions by viewModel.transactions.collectAsState()

    // Compute real stats from transactions
    val calendar = Calendar.getInstance()
    val currentMonth = calendar.get(Calendar.MONTH)
    val currentYear = calendar.get(Calendar.YEAR)

    val totalIncome = transactions.filter { it.type == "income" }.sumOf { it.amount }
    val totalExpenses = transactions.filter { it.type == "expense" }.sumOf { it.amount }
    val netSavings = totalIncome - totalExpenses

    val monthlyIncome = transactions.filter { txn ->
        txn.type == "income" && Calendar.getInstance().apply { time = txn.date }.let {
            it.get(Calendar.MONTH) == currentMonth && it.get(Calendar.YEAR) == currentYear
        }
    }.sumOf { it.amount }

    val monthlyExpenses = transactions.filter { txn ->
        txn.type == "expense" && Calendar.getInstance().apply { time = txn.date }.let {
            it.get(Calendar.MONTH) == currentMonth && it.get(Calendar.YEAR) == currentYear
        }
    }.sumOf { it.amount }

    val avgDaily = if (monthlyExpenses > 0) (monthlyExpenses / 30).toInt() else 0

    // Currency converter state
    var convertAmount by remember { mutableStateOf("") }
    var selectedCurrency by remember { mutableStateOf("USD") }
    var convertedAmount by remember { mutableStateOf("Rp 0") }
    
    // Update converted amount when input changes
    LaunchedEffect(convertAmount, selectedCurrency) {
        convertedAmount = convertCurrency(convertAmount, selectedCurrency)
    }
    
    Scaffold(
        bottomBar = { BottomNavigationBar(navController) },
        topBar = {
            TopAppBar(
                title = { Text("Financial Summary") },
                actions = {
                    IconButton(onClick = { /* Export functionality */ }) {
                        Icon(Icons.Default.Download, contentDescription = "Export")
                    }
                    IconButton(onClick = { /* Period toggle */ }) {
                        Icon(Icons.Default.CalendarToday, contentDescription = "Period")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .background(
                    Brush.verticalGradient(
                        colors = if (isDark)
                            listOf(Color(0xFF0E0E0E), Color(0xFF1E1E1E), Color(0xFF2A2A2A))
                        else
                            listOf(
                                BackgroundGradientStart,
                                BackgroundGradientMiddle,
                                BackgroundGradientEnd
                            )
                    )
                )
                .verticalScroll(rememberScrollState())
        ) {
            // Period Filter
            var selectedPeriod by remember { mutableStateOf("Month") }
            val periods = listOf("Month", "Quarter", "Year", "All Time")
            
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                periods.forEach { period ->
                    FilterChip(
                        selected = selectedPeriod == period,
                        onClick = { selectedPeriod = period },
                        label = { Text(period) },
                        modifier = Modifier.height(36.dp)
                    )
                }
            }
            
            // Key Metrics
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // Total Income
                Card(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = SuccessGreen)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Default.TrendingUp,
                            contentDescription = "Income",
                            tint = Color.White.copy(alpha = 0.7f),
                            modifier = Modifier.size(24.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Total Income",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 12.sp
                        )
                        Text(
                            text = CurrencyUtils.formatIDR(totalIncome),
                            color = Color.White,
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = "+12.5% vs last month",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 10.sp
                        )
                    }
                }
                
                // Total Expenses
                Card(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = ErrorRed)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Default.TrendingDown,
                            contentDescription = "Expenses",
                            tint = Color.White.copy(alpha = 0.7f),
                            modifier = Modifier.size(24.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Total Expenses",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 12.sp
                        )
                        Text(
                            text = CurrencyUtils.formatIDR(totalExpenses),
                            color = Color.White,
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = "+8.3% vs last month",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 10.sp
                        )
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // Net Savings
                Card(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = InfoBlue)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Default.Savings,
                            contentDescription = "Savings",
                            tint = Color.White.copy(alpha = 0.7f),
                            modifier = Modifier.size(24.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Net Savings",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 12.sp
                        )
                        Text(
                            text = CurrencyUtils.formatIDR(netSavings),
                            color = Color.White,
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = "15.2% of income",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 10.sp
                        )
                    }
                }
                
                // Average Daily
                Card(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = WarningOrange)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Default.Calculate,
                            contentDescription = "Average",
                            tint = Color.White.copy(alpha = 0.7f),
                            modifier = Modifier.size(24.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Avg Daily",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 12.sp
                        )
                        Text(
                            text = CurrencyUtils.formatIDR(avgDaily.toDouble()),
                            color = Color.White,
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = "Last 30 days",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 10.sp
                        )
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Currency Converter
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = "Currency Converter",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        // Amount Input
                        OutlinedTextField(
                            value = convertAmount,
                            onValueChange = { convertAmount = it.filter { char -> char.isDigit() } },
                            label = { Text("From (IDR)") },
                            modifier = Modifier.weight(1f),
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                            leadingIcon = {
                                Text(
                                    text = "Rp",
                                    color = TextSecondary,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        )
                        
                        // Currency Selection
                        var expanded by remember { mutableStateOf(false) }
                        val currencies = listOf("USD", "EUR", "SAR", "MYR", "JPY")
                        val currencyNames = mapOf(
                            "USD" to "USD ($)",
                            "EUR" to "EUR (€)",
                            "SAR" to "SAR (﷼)",
                            "MYR" to "MYR (RM)",
                            "JPY" to "JPY (¥)"
                        )
                        
                        ExposedDropdownMenuBox(
                            expanded = expanded,
                            onExpandedChange = { expanded = !expanded },
                            modifier = Modifier.weight(1f)
                        ) {
                            OutlinedTextField(
                                value = currencyNames[selectedCurrency] ?: "",
                                onValueChange = {},
                                readOnly = true,
                                label = { Text("To Currency") },
                                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                                modifier = Modifier.menuAnchor()
                            )
                            
                            ExposedDropdownMenu(
                                expanded = expanded,
                                onDismissRequest = { expanded = false }
                            ) {
                                currencies.forEach { currency ->
                                    DropdownMenuItem(
                                        text = { Text(currencyNames[currency] ?: currency) },
                                        onClick = {
                                            selectedCurrency = currency
                                            expanded = false
                                        }
                                    )
                                }
                            }
                        }
                    }
                    
                    Spacer(modifier = Modifier.height(16.dp))
                    
                    // Converted Amount Display
                    Card(
                        colors = CardDefaults.cardColors(containerColor = Color(0xFFE3F2FD)),
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
                                text = "Converted Amount:",
                                color = TextPrimary,
                                fontWeight = FontWeight.Medium
                            )
                            Text(
                                text = convertedAmount,
                                color = NavyBlue,
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }
                    
                    Spacer(modifier = Modifier.height(12.dp))
                    
                    Text(
                        text = "Exchange rates are for reference only. Actual rates may vary.",
                        color = TextSecondary,
                        fontSize = 12.sp
                    )
                    
                    Spacer(modifier = Modifier.height(16.dp))
                    
                    // Exchange Rates
                    Text(
                        text = "Current Exchange Rates:",
                        fontWeight = FontWeight.Medium,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    
                    val rates = listOf(
                        "USD" to "1 IDR = $0.000067",
                        "EUR" to "1 IDR = €0.000062",
                        "SAR" to "1 IDR = ﷼0.00025",
                        "MYR" to "1 IDR = RM0.00031",
                        "JPY" to "1 IDR = ¥0.0098"
                    )
                    
                    rates.forEach { (currency, rate) ->
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                text = currency,
                                fontWeight = FontWeight.Medium,
                                color = TextPrimary,
                                modifier = Modifier.weight(1f)
                            )
                            Text(
                                text = rate,
                                color = TextSecondary,
                                modifier = Modifier.weight(2f)
                            )
                        }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Financial Health Score
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(
                    modifier = Modifier.padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = "Financial Health Score",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = TextPrimary
                    )
                    
                    Spacer(modifier = Modifier.height(16.dp))
                    
                    // Circular Progress
                    Box {
                        CircularProgressIndicator(
                            progress = 0.75f,
                            modifier = Modifier.size(120.dp),
                            color = SuccessGreen,
                            strokeWidth = 8.dp
                        )
                        Column(
                            modifier = Modifier
                                .size(120.dp)
                                .padding(16.dp),
                            horizontalAlignment = Alignment.CenterHorizontally,
                            verticalArrangement = Arrangement.Center
                        ) {
                            Text(
                                text = "75",
                                fontSize = 32.sp,
                                fontWeight = FontWeight.Bold,
                                color = TextPrimary
                            )
                            Text(
                                text = "Good",
                                fontSize = 12.sp,
                                color = TextSecondary
                            )
                        }
                    }
                    
                    Spacer(modifier = Modifier.height(16.dp))
                    
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceEvenly
                    ) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Text(text = "Savings Rate", color = TextSecondary, fontSize = 12.sp)
                            Text(text = "22%", color = SuccessGreen, fontWeight = FontWeight.Bold)
                        }
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Text(text = "Debt-to-Income", color = TextSecondary, fontSize = 12.sp)
                            Text(text = "15%", color = InfoBlue, fontWeight = FontWeight.Bold)
                        }
                    }
                    
                    Spacer(modifier = Modifier.height(16.dp))
                    
                    Card(
                        colors = CardDefaults.cardColors(containerColor = Color(0xFFE8F5E8)),
                        shape = RoundedCornerShape(12.dp)
                    ) {
                        Row(
                            modifier = Modifier.padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.CheckCircle,
                                contentDescription = "Success",
                                tint = SuccessGreen
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = "Great job! You're maintaining a healthy financial profile.",
                                color = SuccessGreen,
                                fontSize = 12.sp
                            )
                        }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(80.dp))
        }
    }
}

fun convertCurrency(amount: String, targetCurrency: String): String {
    val amountValue = amount.toIntOrNull() ?: 0
    
    // Mock conversion rates
    val rates = mapOf(
        "USD" to 0.000067,
        "EUR" to 0.000062,
        "SAR" to 0.00025,
        "MYR" to 0.00031,
        "JPY" to 0.0098
    )
    
    val rate = rates[targetCurrency] ?: 1.0
    val converted = amountValue * rate
    
    return when (targetCurrency) {
        "USD" -> "$$converted"
        "EUR" -> "€$converted"
        "SAR" -> "﷼$converted"
        "MYR" -> "RM$converted"
        "JPY" -> "¥${converted.toInt()}"
        else -> "Rp $amountValue"
    }
}