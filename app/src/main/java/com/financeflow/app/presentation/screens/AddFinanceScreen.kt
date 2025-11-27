package com.financeflow.app.presentation.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
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
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.financeflow.app.data.model.Transaction
import com.financeflow.app.presentation.components.BottomNavigationBar
import com.financeflow.app.ui.theme.*
import com.financeflow.app.presentation.viewmodel.TransactionViewModel
import java.util.Date
import kotlinx.coroutines.launch
import androidx.hilt.navigation.compose.hiltViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddFinanceScreen(
    navController: NavController,
    viewModel: TransactionViewModel = hiltViewModel(),
    isDark: Boolean
) {
    var selectedType by remember { mutableStateOf("income") }
    var amount by remember { mutableStateOf("") }
    var description by remember { mutableStateOf("") }
    var selectedCategory by remember { mutableStateOf<String?>(null) }
    var showSuccessDialog by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()
    
    Scaffold(
        bottomBar = { BottomNavigationBar(navController) },
        topBar = {
            TopAppBar(
                title = { Text("Add Transaction") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
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
            // Transaction Type Selection
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = "Transaction Type",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        // Income Button
                        Card(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(
                                containerColor = if (selectedType == "income") SuccessGreen else Color(0xFFE8F5E8)
                            ),
                            onClick = { selectedType = "income" }
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
                                        .background(if (selectedType == "income") Color.White else SuccessGreen),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.TrendingUp,
                                        contentDescription = "Income",
                                        tint = if (selectedType == "income") SuccessGreen else Color.White
                                    )
                                }
                                Spacer(modifier = Modifier.height(8.dp))
                                Text(
                                    text = "Income",
                                    color = if (selectedType == "income") Color.White else SuccessGreen,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }
                        
                        // Expense Button
                        Card(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(
                                containerColor = if (selectedType == "expense") ErrorRed else Color(0xFFFFEBEE)
                            ),
                            onClick = { selectedType = "expense" }
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
                                        .background(if (selectedType == "expense") Color.White else ErrorRed),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.TrendingDown,
                                        contentDescription = "Expense",
                                        tint = if (selectedType == "expense") ErrorRed else Color.White
                                    )
                                }
                                Spacer(modifier = Modifier.height(8.dp))
                                Text(
                                    text = "Expense",
                                    color = if (selectedType == "expense") Color.White else ErrorRed,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }
                    }
                }
            }
            
            // Quick Amount Buttons
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
                        text = "Quick Amount",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Medium,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        QuickAmountButton("50K") { amount = "50000" }
                        QuickAmountButton("100K") { amount = "100000" }
                        QuickAmountButton("250K") { amount = "250000" }
                        QuickAmountButton("500K") { amount = "500000" }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Amount Input
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
                    OutlinedTextField(
                        value = amount,
                        onValueChange = { amount = it.filter { char -> char.isDigit() } },
                        label = { Text("Amount (IDR)") },
                        modifier = Modifier.fillMaxWidth(),
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        leadingIcon = {
                            Text(
                                text = "Rp",
                                color = TextSecondary,
                                fontWeight = FontWeight.Medium
                            )
                        }
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Category Selection
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
                        text = "Category",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Medium,
                        color = TextPrimary
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    
                    val categories = if (selectedType == "income") {
                        listOf(
                            Category("salary", "Salary", "💰"),
                            Category("freelance", "Freelance", "💻"),
                            Category("investment", "Investment", "📈"),
                            Category("business", "Business", "🏢"),
                            Category("other-income", "Other", "💵")
                        )
                    } else {
                        listOf(
                            Category("food", "Food", "🍽️"),
                            Category("transport", "Transport", "🚌"),
                            Category("shopping", "Shopping", "🛍️"),
                            Category("entertainment", "Fun", "🎬"),
                            Category("education", "Education", "📚"),
                            Category("healthcare", "Health", "🏥"),
                            Category("utilities", "Bills", "⚡"),
                            Category("other-expense", "Other", "📝")
                        )
                    }
                    
                    Column(
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        categories.chunked(3).forEach { rowCategories ->
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                rowCategories.forEach { category ->
                                    CategoryChip(
                                        category = category,
                                        isSelected = selectedCategory == category.id,
                                        onClick = { selectedCategory = category.id }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            // Description Input
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
                    OutlinedTextField(
                        value = description,
                        onValueChange = { description = it },
                        label = { Text("Description (Optional)") },
                        modifier = Modifier.fillMaxWidth(),
                        maxLines = 3
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(24.dp))
            
            // Action Buttons
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                OutlinedButton(
                    onClick = {
                        amount = ""
                        description = ""
                        selectedCategory = null
                    },
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text("Clear")
                }
                
                Button(
                    onClick = {
                        val numericAmount = amount.toDoubleOrNull()
                        if (numericAmount != null && description.isNotBlank() && selectedCategory != null) {
                            viewModel.addTransaction(
                                Transaction(
                                    type = selectedType,
                                    amount = numericAmount,
                                    category = selectedCategory!!,
                                    description = description,
                                    date = Date(),
                                    icon = if (selectedType == "income") "💰" else "💸"
                                )
                            )
                            amount = ""
                            description = ""
                            selectedCategory = null
                            showSuccessDialog = true
                        }
                    },
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = NavyBlue)
                ) {
                    Text("Save Transaction")
                }
            }
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
    
    if (showSuccessDialog) {
        AlertDialog(
            onDismissRequest = { showSuccessDialog = false },
            confirmButton = {
                TextButton(onClick = { showSuccessDialog = false; navController.popBackStack() }) {
                    Text("Done")
                }
            },
            title = { Text("Saved") },
            text = { Text("Transaction added successfully.") }
        )
    }
}

@Composable
fun RowScope.QuickAmountButton(
    label: String,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .weight(1f)
            .clickable { onClick() },
        shape = RoundedCornerShape(8.dp),
        colors = CardDefaults.cardColors(containerColor = Color(0xFFF5F5F5))
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = label,
                fontWeight = FontWeight.Medium,
                color = TextPrimary,
                fontSize = 12.sp
            )
        }
    }
}

@Composable
fun RowScope.CategoryChip(
    category: Category,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .weight(1f)
            .clickable { onClick() },
        shape = RoundedCornerShape(8.dp),
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) NavyBlue else Color(0xFFF5F5F5)
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Box(
                modifier = Modifier
                    .size(32.dp)
                    .clip(CircleShape)
                    .background(if (isSelected) Color.White else Color(0xFFE0E0E0)),
                contentAlignment = Alignment.Center
            ) {
                Text(text = category.icon, fontSize = 16.sp)
            }
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = category.name,
                fontSize = 10.sp,
                fontWeight = FontWeight.Medium,
                color = if (isSelected) Color.White else TextPrimary,
                maxLines = 1
            )
        }
    }
}

data class Category(
    val id: String,
    val name: String,
    val icon: String
)