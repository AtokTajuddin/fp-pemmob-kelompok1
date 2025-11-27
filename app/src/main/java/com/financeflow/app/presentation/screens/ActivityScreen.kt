package com.financeflow.app.presentation.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.financeflow.app.presentation.components.BottomNavigationBar
import com.financeflow.app.ui.theme.*
import com.financeflow.app.utils.CurrencyUtils
import androidx.hilt.navigation.compose.hiltViewModel
import com.financeflow.app.presentation.viewmodel.TransactionViewModel
import androidx.compose.foundation.layout.RowScope

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ActivityScreen(
    navController: NavController,
    viewModel: TransactionViewModel = hiltViewModel(),
    isDark: Boolean
) {
    val allTransactions by viewModel.transactions.collectAsState()
    var selectedFilter by remember { mutableStateOf("All") }
    val filtered = remember(selectedFilter, allTransactions) { viewModel.getFilteredTransactions(selectedFilter) }

    val totalIncome = viewModel.getTotalIncome()
    val totalExpenses = viewModel.getTotalExpenses()
    val netBalance = viewModel.getNetBalance()

    Scaffold(
        bottomBar = { BottomNavigationBar(navController) },
        topBar = {
            TopAppBar(
                title = { Text("Activity") },
                actions = {
                    IconButton(onClick = { /* Export functionality */ }) { Icon(Icons.Default.Download, contentDescription = "Export") }
                    IconButton(onClick = { /* Search functionality */ }) { Icon(Icons.Default.Search, contentDescription = "Search") }
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
                            listOf(BackgroundGradientStart, BackgroundGradientMiddle, BackgroundGradientEnd)
                    )
                )
        ) {
            // Summary Cards
            Row(
                modifier = Modifier.fillMaxWidth().padding(16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                SummaryCard(title = "Total Income", value = CurrencyUtils.formatIDR(totalIncome), color = SuccessGreen)
                SummaryCard(title = "Total Expenses", value = CurrencyUtils.formatIDR(totalExpenses), color = ErrorRed)
                SummaryCard(title = "Net Balance", value = CurrencyUtils.formatIDR(netBalance), color = InfoBlue)
            }
            
            // Filter Chips
            Row(
                modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                listOf("All", "Today", "Week", "Month", "Year").forEach { filter ->
                    FilterChip(
                        selected = selectedFilter == filter,
                        onClick = { selectedFilter = filter },
                        label = { Text(filter) },
                        modifier = Modifier.height(36.dp)
                    )
                }
            }
            
            Spacer(Modifier.height(16.dp))

            // Transactions List
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(filtered) { txn ->
                    ActivityTransactionCard(
                        icon = txn.icon.ifBlank { if (txn.type == "income") "💰" else "💸" },
                        description = txn.description,
                        dateLabel = viewModel.relativeLabel(txn.date),
                        amount = txn.amount,
                        type = txn.type,
                        category = txn.category
                    ) {}
                }
            }
        }
    }
}

@Composable
private fun RowScope.SummaryCard(title: String, value: String, color: Color) {
    Card(modifier = Modifier.weight(1f), colors = CardDefaults.cardColors(containerColor = color)) {
        Column(modifier = Modifier.fillMaxWidth().padding(12.dp), horizontalAlignment = Alignment.CenterHorizontally) {
            Text(text = title, color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp)
            Text(text = value, color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.Bold)
        }
    }
}

@Composable
fun ActivityTransactionCard(
    icon: String,
    description: String,
    dateLabel: String,
    amount: Double,
    type: String,
    category: String,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = MaterialTheme.shapes.medium,
        colors = CardDefaults.cardColors(containerColor = Color.White),
        onClick = onClick
    ) {
        Row(
            modifier = Modifier.fillMaxWidth().padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                Box(
                    modifier = Modifier.size(40.dp).clip(CircleShape).background(Color(0xFFF5F5F5)),
                    contentAlignment = Alignment.Center
                ) { Text(text = icon, fontSize = 18.sp) }
                Column {
                    Text(text = description, fontWeight = FontWeight.Medium, color = TextPrimary, fontSize = 14.sp)
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalAlignment = Alignment.CenterVertically) {
                        Text(text = dateLabel, color = TextSecondary, fontSize = 12.sp)
                        Text(text = "•", color = TextSecondary, fontSize = 12.sp)
                        Text(text = category.replaceFirstChar { it.uppercase() }, color = TextSecondary, fontSize = 12.sp)
                    }
                }
            }
            Column(horizontalAlignment = Alignment.End) {
                val signed = if (type == "income") "+${CurrencyUtils.formatIDR(amount)}" else "-${CurrencyUtils.formatIDR(amount)}"
                Text(
                    text = signed,
                    fontWeight = FontWeight.Bold,
                    color = if (type == "income") SuccessGreen else ErrorRed,
                    fontSize = 14.sp
                )
            }
        }
    }
}
