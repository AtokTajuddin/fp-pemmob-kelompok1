import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'activity_page.dart'; 
import 'add_transaction_page.dart';
import 'ai_chat_page.dart';

class DashboardPage extends StatefulWidget {
  final String username;
  const DashboardPage({super.key, this.username = "Raynard"});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool _shouldScrollToHistory = false; 

  List<Widget> get _pages {
    return [
      DashboardView(
        username: widget.username,
        onViewAllPressed: () {
          setState(() {
            _shouldScrollToHistory = true; 
            _selectedIndex = 1; 
          });
        },
      ),
      ActivityPage(scrollToBottom: _shouldScrollToHistory), 
      const AiChatPage(),
      const Center(child: Text("Profile Feature Coming Soon")), 
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _shouldScrollToHistory = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // FAB DIAMOND
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 40),
        width: 65,
        height: 65,
        child: Transform.rotate(
          angle: math.pi / 4,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTransactionPage()),
              );
            }, 
            backgroundColor: const Color(0xFF10B981),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: const Icon(Icons.add, size: 32, color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAV
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        color: Colors.white,
        elevation: 15,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(icon: Icons.home_rounded, label: "Home", index: 0),
              _buildNavItem(icon: Icons.list_alt_rounded, label: "Activity", index: 1),
              const SizedBox(width: 40), 
              _buildNavItem(icon: Icons.chat_rounded, label: "AI Chat", index: 2),
              _buildNavItem(icon: Icons.person_rounded, label: "Profile", index: 3),
            ],
          ),
        ),
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF10B981) : Colors.grey[400], size: 26),
          if (isSelected)
            Text(label, style: const TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// DASHBOARD VIEW
class DashboardView extends StatefulWidget {
  final String username;
  final VoidCallback onViewAllPressed; 

  const DashboardView({super.key, required this.username, required this.onViewAllPressed});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isBalanceVisible = false; 
  
  bool _hasNotification = true;

  Map<String, dynamic> _getCategoryStyle(String categoryName) {
    switch (categoryName) {
      case "Food & Drinks": return {"icon": Icons.fastfood_rounded, "color": Colors.orange};
      case "Transportation": return {"icon": Icons.directions_car_rounded, "color": Colors.purple};
      case "Shopping": return {"icon": Icons.shopping_bag_rounded, "color": Colors.blue};
      case "Salary": return {"icon": Icons.work_rounded, "color": const Color(0xFF10B981)};
      case "Others": default: return {"icon": Icons.grid_view_rounded, "color": Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // HEADER GRADIENT
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 24, right: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF10B981)],
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Welcome back,", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Text(widget.username, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    
                    // 2. MENU DROPDOWN PROFILE
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        print("Selected Menu: $value");
                      },
                      offset: const Offset(0, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, color: Colors.black87),
                              SizedBox(width: 10),
                              Text('Profile'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings_outlined, color: Colors.black87),
                              SizedBox(width: 10),
                              Text('Settings'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'darkmode',
                          child: Row(
                            children: [
                              Icon(Icons.dark_mode_outlined, color: Colors.black87),
                              SizedBox(width: 10),
                              Text('Dark Mode'),
                            ],
                          ),
                        ),
                      ],
                      // Profile Top Right Avatar
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Balance
                Row(
                  children: [
                    Text("Total Balance", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                      child: Icon(_isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white70, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Balance Amount Logic
                Text(
                  _isBalanceVisible ? "Rp 3.500.000" : "Rp ••••••••", 
                  style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: _buildHeaderSummary(title: "Income", amount: "Rp 5.000.000", icon: Icons.arrow_downward_rounded, color: const Color(0xFF10B981))),
                    const SizedBox(width: 15),
                    Expanded(child: _buildHeaderSummary(title: "Expense", amount: "Rp 1.500.000", icon: Icons.arrow_upward_rounded, color: const Color(0xFFFF5252))),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Insight
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFE0F7EF), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2))),
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Image.asset('assets/images/fundoLogo.png', width: 24, height: 24)),
                      const SizedBox(width: 12),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text("Fundo Insight", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981))), SizedBox(width: 5), Icon(Icons.auto_awesome, size: 12, color: Color(0xFF10B981))]), SizedBox(height: 4), Text("You spent 20% less on food this week! Ask Fundo for details?", style: TextStyle(fontSize: 13, color: Colors.black87))])),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))]),
                  child: Row(
                    children: [
                      Expanded(child: _buildQuickAction(label: "Add Income", icon: Icons.add_circle_outline_rounded, color: const Color(0xFF10B981), bgColor: const Color(0xFFE0F7EF), onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionPage(isIncomeDefault: true))); })),
                      const SizedBox(width: 15),
                      Expanded(child: _buildQuickAction(label: "Add Expense", icon: Icons.remove_circle_outline_rounded, color: const Color(0xFFFF5252), bgColor: const Color(0xFFFFEBEE), onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionPage(isIncomeDefault: false))); })),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    TextButton(
                      onPressed: widget.onViewAllPressed, 
                      child: const Text("View All", style: TextStyle(color: Color(0xFF10B981))),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTransactionItem("Starbucks Coffee", "Today, 10:00 AM", "- Rp 55.000", true, "Food & Drinks"),
                _buildTransactionItem("Salary", "Yesterday", "+ Rp 5.000.000", false, "Salary"),
                _buildTransactionItem("GoCar to Office", "24 Nov 2025", "- Rp 45.000", true, "Transportation"),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSummary({required String title, required String amount, required IconData icon, required Color color}) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))]), child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis), FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)))]))]));
  }

  Widget _buildQuickAction({required String label, required IconData icon, required Color color, required Color bgColor, required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)), child: Column(children: [Icon(icon, color: color, size: 32), const SizedBox(height: 8), Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14))])));
  }

  Widget _buildTransactionItem(String title, String date, String amount, bool isExpense, String category) {
    final style = _getCategoryStyle(category);
    return Container(margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))]), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: style['color'].withOpacity(0.1), shape: BoxShape.circle), child: Icon(style['icon'], color: style['color'], size: 20)), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)), const SizedBox(height: 4), Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[500]))])), Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981)))]));
  }
}