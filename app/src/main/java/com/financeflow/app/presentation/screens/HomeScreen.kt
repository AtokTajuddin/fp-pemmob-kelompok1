package com.financeflow.app.presentation.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
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
import com.financeflow.app.presentation.navigation.Screen
import com.financeflow.app.presentation.navigation.Screen.*
import com.financeflow.app.ui.theme.*
import com.financeflow.app.data.model.Transaction as DomainTransaction
import com.financeflow.app.presentation.viewmodel.TransactionViewModel
import com.financeflow.app.utils.CurrencyUtils
import java.util.Calendar
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.foundation.layout.RowScope
import androidx.compose.runtime.getValue

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    navController: NavController,
    viewModel: TransactionViewModel = hiltViewModel(),
    isDark: Boolean,
    onToggleTheme: () -> Unit
) {
    val transactions by viewModel.transactions.collectAsState()
    val recent = transactions.take(5)

    // Compute real financial stats (no animation)
    val netBalance = viewModel.getNetBalance()
    val calendar = Calendar.getInstance()
    val currentMonth = calendar.get(Calendar.MONTH)
    val currentYear = calendar.get(Calendar.YEAR)

    val monthlyIncome = transactions.filter { txn ->
        txn.type == "income" && Calendar.getInstance().apply { time = txn.date }.let { it.get(Calendar.MONTH) == currentMonth && it.get(Calendar.YEAR) == currentYear }
    }.sumOf { it.amount }

    val monthlyExpenses = transactions.filter { txn ->
        txn.type == "expense" && Calendar.getInstance().apply { time = txn.date }.let { it.get(Calendar.MONTH) == currentMonth && it.get(Calendar.YEAR) == currentYear }
    }.sumOf { it.amount }

    val savingsScore = if (monthlyIncome <= 0.0) 0.0 else (monthlyIncome - monthlyExpenses).coerceAtLeast(0.0) / monthlyIncome

    var showContent by remember { mutableStateOf(false) }
    LaunchedEffect(Unit) { showContent = true }

    // Adjust gradients based on dark/light toggle
    val headerGradient = if (isDark) listOf(Color(0xFF121212), NavyBlue) else listOf(NavyBlue, Color(0xFF3949AB))
    val backgroundGradient = if (isDark) listOf(Color(0xFF0E0E0E), Color(0xFF1E1E1E), Color(0xFF2A2A2A)) else listOf(
        BackgroundGradientStart, BackgroundGradientMiddle, BackgroundGradientEnd
    )

    Scaffold(
        bottomBar = { BottomNavigationBar(navController) }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .background(
                    Brush.verticalGradient(
                        colors = backgroundGradient
                    )
                )
        ) {
            // Header Section
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .background(
                        Brush.linearGradient(
                            colors = headerGradient
                        )
                    )
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "FinanceFlow",
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                    Text(
                        text = "Smart Money Management",
                        fontSize = 16.sp,
                        color = Color.White.copy(alpha = 0.9f)
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Box(
                        modifier = Modifier
                            .size(64.dp)
                            .clip(CircleShape)
                            .background(Color.White.copy(alpha = 0.2f)),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Person,
                            contentDescription = "User",
                            tint = Color.White,
                            modifier = Modifier.size(32.dp)
                        )
                    }
                    // Dark mode toggle
                    Spacer(modifier = Modifier.height(16.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        Text(if (isDark) "Dark" else "Light", color = Color.White.copy(alpha = 0.8f), fontSize = 14.sp)
                        Spacer(modifier = Modifier.width(8.dp))
                        Switch(
                            checked = isDark,
                            onCheckedChange = { onToggleTheme() },
                            colors = SwitchDefaults.colors(
                                checkedThumbColor = Color.White,
                                uncheckedThumbColor = Color(0xFFB0BEC5),
                                checkedTrackColor = NavyBlue,
                                uncheckedTrackColor = Color(0xFFB0BEC5).copy(alpha = 0.5f)
                            )
                        )
                    }
                }
            }
            
            // Balance Card
            AnimatedVisibility(
                visible = showContent,
                enter = fadeIn() + scaleIn(initialScale = .9f),
                exit = fadeOut() + scaleOut()
            ) {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                        .offset(y = (-32).dp),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = NavyBlue)
                ) {
                    Column(modifier = Modifier.fillMaxWidth().padding(20.dp)) {
                        Text("Current Balance", color = Color.White.copy(alpha = 0.8f), fontSize = 14.sp)
                        Text(CurrencyUtils.formatIDR(netBalance), color = Color.White, fontSize = 28.sp, fontWeight = FontWeight.Bold)
                        Spacer(Modifier.height(8.dp))
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Box(
                                modifier = Modifier.size(8.dp).clip(CircleShape).background(
                                    if (netBalance >= 0) SuccessGreen else ErrorRed
                            )
                            )
                            Spacer(Modifier.width(8.dp))
                            Text(
                                text = if (monthlyIncome > 0) {
                                    val pct = ((monthlyIncome - monthlyExpenses) / monthlyIncome * 100).toInt()
                                    "$pct% net this month"
                            } else "No income this month",
                                color = Color.White.copy(alpha = 0.8f),
                                fontSize = 12.sp
                            )
                        }
                    }
                }
            }
            
            // Quick Stats (real values)
            AnimatedVisibility(
                visible = showContent,
                enter = fadeIn() + scaleIn(initialScale = .9f),
                exit = fadeOut() + scaleOut()
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    StatCard(title = "Monthly Income", value = CurrencyUtils.formatIDR(monthlyIncome), icon = Icons.Default.TrendingUp, bg = SuccessGreen)
                    StatCard(title = "Monthly Expenses", value = CurrencyUtils.formatIDR(monthlyExpenses), icon = Icons.Default.TrendingDown, bg = Coral)
                }
            }
            
            Spacer(Modifier.height(24.dp))

            // Quick Actions
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
                        text = "Quick Actions",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        // Add Income Button
                        Card(
                            modifier = Modifier
                                .weight(1f)
                                .clickable { navController.navigate(AddFinance.route) },
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = Color(0xFFE8F5E8))
                        ) {
                            Column(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(16.dp),
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Box(
                                    modifier = Modifier
                                        .size(40.dp)
                                        .clip(CircleShape)
                                        .background(SuccessGreen),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.Add,
                                        contentDescription = "Add Income",
                                        tint = Color.White
                                    )
                                }
                                Spacer(modifier = Modifier.height(8.dp))
                                Text(
                                    text = "Add Income",
                                    color = SuccessGreen,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }
                        
                        // Add Expense Button
                        Card(
                            modifier = Modifier
                                .weight(1f)
                                .clickable { navController.navigate(AddFinance.route) },
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = Color(0xFFFFEBEE))
                        ) {
                            Column(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(16.dp),
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Box(
                                    modifier = Modifier
                                        .size(40.dp)
                                        .clip(CircleShape)
                                        .background(ErrorRed),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.Remove,
                                        contentDescription = "Add Expense",
                                        tint = Color.White
                                    )
                                }
                                Spacer(modifier = Modifier.height(8.dp))
                                Text(
                                    text = "Add Expense",
                                    color = ErrorRed,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Recent Transactions (real data)
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Recent Transactions", fontSize = 18.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                        TextButton(onClick = { navController.navigate(Activity.route) }) { Text("View All", color = InfoBlue) }
                    }
                    Spacer(Modifier.height(12.dp))
                    if (recent.isEmpty()) {
                        Text("No transactions yet. Add one to get started.", color = TextSecondary, fontSize = 14.sp)
                    } else {
                        recent.forEach { txn ->
                            TransactionItem(txn, viewModel)
                            if (txn != recent.last()) Divider(Modifier.padding(vertical = 8.dp))
                        }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Financial Health Score (real computed)
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(Modifier.padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Financial Health", fontSize = 18.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                    Spacer(Modifier.height(16.dp))
                    CircularProgressIndicator(
                        progress = savingsScore.toFloat().coerceIn(0f, 1f),
                        modifier = Modifier.size(120.dp),
                        color = SuccessGreen,
                        strokeWidth = 8.dp
                    )
                    Text(
                        text = "Net: ${CurrencyUtils.formatIDR(netBalance)}",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Medium,
                        color = TextPrimary,
                        modifier = Modifier.padding(top = 8.dp)
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(80.dp))
        }
    }
}

@Composable
private fun RowScope.StatCard(title: String, value: String, icon: ImageVector, bg: Color) {
    Card(
        modifier = Modifier.weight(1f),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = bg)
    ) {
        Column(Modifier.fillMaxWidth().padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(title, color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp)
                    Text(value, color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.Bold)
                }
                Icon(icon, contentDescription = title, tint = Color.White.copy(alpha = 0.7f), modifier = Modifier.size(24.dp))
            }
        }
    }
}

@Composable
fun TransactionItem(transaction: DomainTransaction, viewModel: TransactionViewModel) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            Box(
                modifier = Modifier.size(40.dp).clip(CircleShape).background(Color(0xFFF5F5F5)),
                contentAlignment = Alignment.Center
            ) { Text(text = transaction.icon.ifBlank { if (transaction.type == "income") "💰" else "💸" }, fontSize = 18.sp) }
            Column {
                Text(transaction.description, fontWeight = FontWeight.Medium, color = TextPrimary, fontSize = 14.sp)
                Text(viewModel.relativeLabel(transaction.date), color = TextSecondary, fontSize = 12.sp)
            }
        }
        val signed = (if (transaction.type == "income") "+" else "-") + CurrencyUtils.formatIDR(transaction.amount)
        Text(signed, fontWeight = FontWeight.Bold, color = if (transaction.type == "income") SuccessGreen else ErrorRed, fontSize = 14.sp)
    }
}
