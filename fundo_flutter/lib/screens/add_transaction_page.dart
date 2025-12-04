import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  final bool isIncomeDefault;
  const AddTransactionPage({super.key, this.isIncomeDefault = false});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  late bool _isIncome;
  String? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // 5 CATEGORIES
  final List<Map<String, dynamic>> _allCategories = [
    {"name": "Salary", "icon": Icons.work_rounded, "color": const Color(0xFF10B981), "type": "Income"},
    {"name": "Food & Drinks", "icon": Icons.fastfood_rounded, "color": Colors.orange, "type": "Expense"},
    {"name": "Shopping", "icon": Icons.shopping_bag_rounded, "color": Colors.blue, "type": "Expense"},
    {"name": "Transportation", "icon": Icons.directions_car_rounded, "color": Colors.purple, "type": "Expense"},
    {"name": "Others", "icon": Icons.grid_view_rounded, "color": Colors.grey, "type": "Both"},
  ];

  @override
  void initState() {
    super.initState();
    _isIncome = widget.isIncomeDefault;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _isIncome ? const Color(0xFF10B981) : const Color(0xFFFF5252),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _allCategories.where((cat) {
      if (cat['type'] == "Both") return true;
      return _isIncome ? cat['type'] == "Income" : cat['type'] == "Expense";
    }).toList();

    final primaryColor = _isIncome ? const Color(0xFF10B981) : const Color(0xFFFF5252);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isIncome ? "Add Income" : "Add Expense",
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOGGLE SWITCH
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildTypeButton("Income", true),
                    _buildTypeButton("Expense", false),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 2. AMOUNT INPUT
              const Text("Amount", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  prefixStyle: TextStyle(color: primaryColor, fontSize: 40, fontWeight: FontWeight.bold),
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                  border: InputBorder.none,
                ),
              ),

              const SizedBox(height: 30),

              // 3. CATEGORY SELECTION
              const Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: filteredCategories.map((cat) {
                  final isSelected = _selectedCategory == cat['name'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat['name']),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isSelected ? cat['color'] : Colors.grey.shade100,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade300),
                            boxShadow: isSelected ? [
                              BoxShadow(color: (cat['color'] as Color).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
                            ] : [],
                          ),
                          child: Icon(
                            cat['icon'],
                            color: isSelected ? Colors.white : Colors.grey.shade600,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.black87 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // 4. DATE & NOTE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Picker
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 18, color: primaryColor),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Note Input
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Note", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            hintText: "Add note...",
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 5. MEDIA PLACEHOLDERS
              const Text("Attachments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildMediaPlaceholder(
                      icon: Icons.camera_alt_rounded,
                      label: "Add Receipt",
                      color: Colors.blue,
                      onTap: () {
                        print("Open Camera Logic");
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildMediaPlaceholder(
                      icon: Icons.location_on_rounded,
                      label: "Add Location",
                      color: Colors.orange,
                      onTap: () {
                         print("Open Maps Logic");
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 6. SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: primaryColor.withOpacity(0.4),
                  ),
                  child: const Text(
                    "Save Transaction",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, bool isIncomeBtn) {
    final isActive = _isIncome == isIncomeBtn;
    final activeColor = isIncomeBtn ? const Color(0xFF10B981) : const Color(0xFFFF5252);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isIncome = isIncomeBtn;
            _selectedCategory = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isActive ? [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
            ] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPlaceholder({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}