import 'package:flutter/material.dart';
import 'dart:math' as math;

class ActivityPage extends StatefulWidget {
  final bool scrollToBottom; 
  const ActivityPage({super.key, this.scrollToBottom = false});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class CategoryData {
  final String title;
  final String amount;
  final double percent;
  final Color color;
  final IconData icon;

  CategoryData(this.title, this.amount, this.percent, this.color, this.icon);
}

class TransactionData {
  final String title;
  final String date;
  final String amount;
  final bool isExpense;
  final String category;

  TransactionData(this.title, this.date, this.amount, this.isExpense, this.category);
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedFilterIndex = 2;
  final List<String> _filters = ["Day", "Week", "Month", "Year"];
  int? _touchedBarIndex;
  final ScrollController _scrollController = ScrollController();

  final List<String> _totalSpending = [
    "Rp 150.000", "Rp 850.000", "Rp 2.450.000", "Rp 18.500.000"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.scrollToBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Map<String, dynamic> _getCategoryStyle(String categoryName) {
    switch (categoryName) {
      case "Food & Drinks": return {"icon": Icons.fastfood_rounded, "color": Colors.orange};
      case "Transportation": return {"icon": Icons.directions_car_rounded, "color": Colors.purple};
      case "Shopping": return {"icon": Icons.shopping_bag_rounded, "color": Colors.blue};
      case "Salary": return {"icon": Icons.work_rounded, "color": const Color(0xFF10B981)};
      case "Others": default: return {"icon": Icons.grid_view_rounded, "color": Colors.grey};
    }
  }

  final List<List<TransactionData>> _historyData = [
    [
      TransactionData("Starbucks", "10:00 AM", "- Rp 55.000", true, "Food & Drinks"),
      TransactionData("GoRide", "08:30 AM", "- Rp 20.000", true, "Transportation"),
      TransactionData("Indomaret", "01:00 PM", "- Rp 15.000", true, "Shopping"),
    ],
    [
      TransactionData("Weekly Groceries", "Mon", "- Rp 400.000", true, "Shopping"),
      TransactionData("Shell Bensin", "Tue", "- Rp 150.000", true, "Transportation"),
      TransactionData("KFC Dinner", "Wed", "- Rp 300.000", true, "Food & Drinks"),
    ],
    [
      TransactionData("Gaji Bulanan", "01 Nov", "+ Rp 5.000.000", false, "Salary"),
      TransactionData("Uniqlo", "15 Nov", "- Rp 400.000", true, "Shopping"),
      TransactionData("GoCar", "20 Nov", "- Rp 45.000", true, "Transportation"),
      TransactionData("Token Listrik", "25 Nov", "- Rp 100.000", true, "Others"),
    ],
    [
      TransactionData("Servis Mobil", "August", "- Rp 4.500.000", true, "Transportation"),
      TransactionData("Beli Laptop", "January", "- Rp 12.000.000", true, "Shopping"),
      TransactionData("Bonus Tahunan", "December", "+ Rp 10.000.000", false, "Salary"),
      TransactionData("Renovasi Rumah", "March", "- Rp 5.000.000", true, "Others"),
    ],
  ];

  final List<List<CategoryData>> _categoriesData = [
    [
      CategoryData("Food & Drinks", "- Rp 35.000", 0.6, Colors.orange, Icons.fastfood_rounded),
      CategoryData("Transportation", "- Rp 20.000", 0.3, Colors.purple, Icons.directions_car_rounded),
      CategoryData("Others", "- Rp 15.000", 0.1, Colors.grey, Icons.grid_view_rounded),
    ],
    [
      CategoryData("Shopping", "- Rp 400.000", 0.5, Colors.blue, Icons.shopping_bag_rounded),
      CategoryData("Food & Drinks", "- Rp 300.000", 0.3, Colors.orange, Icons.fastfood_rounded),
      CategoryData("Transportation", "- Rp 150.000", 0.2, Colors.purple, Icons.directions_car_rounded),
    ],
    [
      CategoryData("Food & Drinks", "- Rp 1.200.000", 0.5, Colors.orange, Icons.fastfood_rounded),
      CategoryData("Transportation", "- Rp 650.000", 0.25, Colors.purple, Icons.directions_car_rounded),
      CategoryData("Shopping", "- Rp 400.000", 0.15, Colors.blue, Icons.shopping_bag_rounded),
      CategoryData("Others", "- Rp 200.000", 0.1, Colors.grey, Icons.grid_view_rounded),
    ],
    [
      CategoryData("Shopping", "- Rp 14.000.000", 0.6, Colors.blue, Icons.shopping_bag_rounded),
      CategoryData("Transportation", "- Rp 4.500.000", 0.25, Colors.purple, Icons.directions_car_rounded),
      CategoryData("Others", "- Rp 5.000.000", 0.15, Colors.grey, Icons.grid_view_rounded),
    ],
  ];

  final List<List<String>> _barLabels = [
    ["6AM", "9AM", "12PM", "3PM", "6PM", "9PM"],
    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
    ["W1", "W2", "W3", "W4"],
    ["Jan", "Mar", "May", "Jul", "Sep", "Nov"],
  ];

  final List<List<double>> _barValues = [
    [0.1, 0.4, 0.8, 0.3, 0.6, 0.2],
    [0.4, 0.6, 0.3, 0.8, 0.5, 0.7, 0.4],
    [0.5, 0.8, 0.4, 0.6],
    [0.6, 0.4, 0.7, 0.9, 0.5, 0.8],
  ];

  @override
  Widget build(BuildContext context) {
    final currentCategories = _categoriesData[_selectedFilterIndex];
    final currentHistory = _historyData[_selectedFilterIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      
      body: Column(
        children: [
          // 1. HEADER GRADIENT
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF10B981)],
              ),
            ),
            child: const SafeArea(
              bottom: false,
              child: Center(
                child: Text(
                  "Activity",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // 2. FIXED FILTER
          Transform.translate(
            offset: const Offset(0, -25),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_filters.length, (index) {
                  return Expanded(
                    child: _buildFilterButton(
                      label: _filters[index],
                      isSelected: _selectedFilterIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                          _touchedBarIndex = null; 
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // 3. SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // B. TOTAL SPENDING
                  Center(
                    child: Column(
                      children: [
                        const Text("Total Spending", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        const SizedBox(height: 5),
                        Text(
                          _totalSpending[_selectedFilterIndex],
                          style: const TextStyle(color: Colors.black87, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.arrow_upward_rounded, color: Color(0xFFFF5252), size: 16),
                              SizedBox(width: 4),
                              Text("+12% vs last period", style: TextStyle(color: Color(0xFFFF5252), fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // C. PIE CHART
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(220, 220),
                            painter: DonutChartPainter(
                              data: currentCategories.map((e) => e.percent * 100).toList(),
                              colors: currentCategories.map((e) => e.color).toList(),
                              width: 30,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Top Spending", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(currentCategories[0].title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // D. TOP CATEGORIES LIST
                  const Text("Top Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  ...List.generate(currentCategories.length, (index) {
                    final cat = currentCategories[index];
                    return _buildCategoryItem(
                      title: cat.title,
                      amount: cat.amount,
                      percent: cat.percent,
                      color: cat.color,
                      icon: cat.icon,
                    );
                  }),

                  const SizedBox(height: 40),

                  // E. SPENDING TREND
                  const Text("Spending Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 250,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(_barLabels[_selectedFilterIndex].length, (index) {
                        return _buildBarColumn(
                          label: _barLabels[_selectedFilterIndex][index],
                          heightPct: _barValues[_selectedFilterIndex][index],
                          index: index,
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // F. TRANSACTION HISTORY
                  const Text("Transaction History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  ...currentHistory.map((data) {
                    return _buildTransactionItem(
                      title: data.title,
                      date: data.date,
                      amount: data.amount,
                      isExpense: data.isExpense,
                      category: data.category,
                    );
                  }),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({required String title, required String amount, required double percent, required Color color, required IconData icon}) {
    return Padding(padding: const EdgeInsets.only(bottom: 20.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]), const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: percent, backgroundColor: Colors.grey.shade200, color: color, minHeight: 6))]))]));
  }

  Widget _buildBarColumn({required String label, required double heightPct, required int index}) {
    bool isTouched = _touchedBarIndex == index;
    return GestureDetector(onTap: () { setState(() { _touchedBarIndex = isTouched ? null : index; }); }, child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [if (isTouched) Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)), child: Text("Rp ${(heightPct * 1000).toInt()}k", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))), AnimatedContainer(duration: const Duration(milliseconds: 300), curve: Curves.easeOut, width: 16, height: isTouched ? 140 * heightPct : 120 * heightPct, decoration: BoxDecoration(color: isTouched ? const Color(0xFF059669) : const Color(0xFF10B981).withOpacity(0.5), borderRadius: BorderRadius.circular(10))), const SizedBox(height: 10), Text(label, style: TextStyle(color: isTouched ? const Color(0xFF10B981) : Colors.grey.shade600, fontWeight: isTouched ? FontWeight.bold : FontWeight.normal, fontSize: 12))]));
  }

  Widget _buildTransactionItem({required String title, required String date, required String amount, required bool isExpense, required String category}) {
    final style = _getCategoryStyle(category);
    final IconData icon = style['icon'];
    final Color color = style['color'];

    return Container(margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))]), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)), const SizedBox(height: 4), Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[500]))])), Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981)))]));
  }
}

class DonutChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;
  final double width;
  DonutChartPainter({required this.data, required this.colors, required this.width});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - width) / 2;
    double startAngle = -math.pi / 2;
    final total = data.reduce((a, b) => a + b);
    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 2 * math.pi;
      final paint = Paint()..color = colors[i]..style = PaintingStyle.stroke..strokeWidth = width..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle - 0.1, false, paint);
      startAngle += sweepAngle;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}