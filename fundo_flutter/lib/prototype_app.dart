import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/text_styles.dart';

// --- MAIN APP WRAPPER ---
class PrototypeApp extends StatelessWidget {
  const PrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

// --- BOTTOM NAVIGATION CONTROLLER ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of the main tab pages
  final List<Widget> _pages = [
    const MockDashboard(), // Tab 0
    const PlaceholderScreen(
      title: "Activity / Stats",
      icon: Icons.pie_chart,
    ), // Tab 1
    const PlaceholderScreen(
      title: "AI Chat",
      icon: Icons.chat,
    ), // Tab 2 (Index 3 in bar)
    const PlaceholderScreen(
      title: "Profile",
      icon: Icons.person,
    ), // Tab 3 (Index 4 in bar)
  ];

  void _onTabTapped(int index) {
    // If the user taps the middle button (Add), we don't switch pages.
    // We show a modal instead.
    if (index == 2) {
      _showAddTransactionModal();
    } else {
      setState(() {
        // We have to adjust the index because the "Add" button is at index 2
        // but our _pages list only has 4 items.
        // Tabs: [0:Home, 1:Stats, 2:ADD, 3:Chat, 4:Profile]
        // Pages: [0:Home, 1:Stats,        2:Chat, 3:Profile]
        _currentIndex = index > 2 ? index - 1 : index;
      });
    }
  }

  void _showAddTransactionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddTransactionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We show the page based on the adjusted index
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex >= 2 ? _currentIndex + 1 : _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, // Needed for 4+ items
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add, color: Colors.white),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// --- PLACEHOLDER SCREEN (Generic) ---
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({required this.title, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text("This is the $title Screen", style: AppTextStyles.h3),
            const SizedBox(height: 8),
            const Text("Design implementation coming soon."),
          ],
        ),
      ),
    );
  }
}

// --- ADD TRANSACTION MODAL (Mockup) ---
class AddTransactionModal extends StatelessWidget {
  const AddTransactionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Handle keyboard
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content height
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add Transaction", style: AppTextStyles.h2),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Amount Input Placeholder
          const TextField(
            decoration: InputDecoration(
              labelText: "Amount (Rp)",
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          // Category Placeholder
          const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(label: "Food", isSelected: true),
                _CategoryChip(label: "Transport"),
                _CategoryChip(label: "Shopping"),
                _CategoryChip(label: "Bills"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Media Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Add Receipt"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map),
                  label: const Text("Add Location"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Save Transaction"),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? AppColors.primary.withOpacity(0.2) : null,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: isSelected ? const BorderSide(color: AppColors.primary) : null,
      ),
    );
  }
}

// --- DASHBOARD (Reuse your existing one) ---
// (Paste your MockDashboard code here from the previous step,
//  but remove the `bottomNavigationBar` property from its Scaffold
//  because the MainScreen handles that now.)
class MockDashboard extends StatelessWidget {
  const MockDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fundo Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            ),            Container(
              height: 200,
              color: AppColors.primary,
              child: const Center(child: Text("Your Balance Card Here")),
            ),
          ],
        ),
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
