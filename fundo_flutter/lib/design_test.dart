import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';

class DesignTestApp extends StatelessWidget {
  const DesignTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MockDashboard(),
    );
  }
}

class MockDashboard extends StatelessWidget {
  const MockDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fundo Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary, // Emerald Green
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Balance",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Rp 3.500.000",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _IncomeExpenseBadge(
                        icon: Icons.arrow_downward,
                        label: "Income",
                        amount: "Rp 5jt",
                        isIncome: true,
                      ),
                      _IncomeExpenseBadge(
                        icon: Icons.arrow_upward,
                        label: "Expense",
                        amount: "Rp 1.5jt",
                        isIncome: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Section Title
            Text(
              "Recent Transactions",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // 3. List Items
            _TransactionItem(
              icon: Icons.fastfood,
              color: AppColors.catFood,
              title: "Starbucks Coffee",
              date: "Today, 10:00 AM",
              amount: "-Rp 55.000",
              isExpense: true,
            ),
            _TransactionItem(
              icon: Icons.directions_car,
              color: AppColors.catTransport,
              title: "Grab Ride",
              date: "Yesterday",
              amount: "-Rp 24.000",
              isExpense: true,
            ),
            _TransactionItem(
              icon: Icons.work,
              color: AppColors.catEducation,
              title: "Freelance Payment",
              date: "Mon, 12 Oct",
              amount: "+Rp 1.500.000",
              isExpense: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Stats"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _IncomeExpenseBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final bool isIncome;

  const _IncomeExpenseBadge({
    required this.icon,
    required this.label,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String date;
  final String amount;
  final bool isExpense;

  const _TransactionItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isExpense ? AppColors.error : AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
