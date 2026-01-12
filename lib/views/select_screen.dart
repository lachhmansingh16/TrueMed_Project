import 'package:flutter/material.dart';
import 'package:true_med_fyp/main.dart';
import 'package:true_med_fyp/views/scan_screen.dart';
import '../constants.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  List<Medicine> _allMedicines = [];
  List<Medicine> _filteredMedicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  // --- NEW: Function to load data from your JSON file ---
  Future<void> _loadMedicines() async {
    try {
      // Load the JSON string from the asset file
      final jsonString = await rootBundle.loadString('assets/medicines.json');
      // Decode the JSON string into a List of dynamic objects
      final List<dynamic> jsonList = json.decode(jsonString);
      // Map the list of strings to a list of Medicine objects
      final medicines = jsonList
          .map((name) => Medicine(name: name as String))
          .toList();

      setState(() {
        _allMedicines = medicines;
        _filteredMedicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      // Handle potential errors, e.g., file not found
      setState(() {
        _isLoading = false;
      });
      print("Error loading medicines: $e");
    }
  }

  void _onQueryChanged(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      _filteredMedicines = _allMedicines.where((m) {
        return m.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Medicine',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppColors.navyBlue,
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          SearchBar(onChanged: _onQueryChanged),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MedicineListCard(
                      items: _filteredMedicines,
                      onTap: (m) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ScanScreen(medicine: m,),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------- UI Pieces ----------------

class MedicineListCard extends StatelessWidget {
  final List<Medicine> items;
  final ValueChanged<Medicine> onTap;
  const MedicineListCard({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.withAlpha(100),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 1,
          color: AppColors.gray.withAlpha(60),
        ),
        itemBuilder: (context, i) {
          final m = items[i];
          return InkWell(
            borderRadius: i == 0
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : i == items.length - 1
                ? const BorderRadius.vertical(bottom: Radius.circular(12))
                : BorderRadius.zero,
            onTap: () => onTap(m),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: m.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.gray.withAlpha(160),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const SearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.withAlpha(100),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search medicine...',
          hintStyle: TextStyle(
            color: AppColors.gray.withAlpha(150),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 25,
            color: AppColors.gray.withAlpha(150),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
