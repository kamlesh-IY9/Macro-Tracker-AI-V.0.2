import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:uuid/uuid.dart';
import '../../services/food_search_service.dart';
import '../../services/food_log_service.dart';
import '../../services/user_service.dart';
import '../../models/food_log_model.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  final String? mealType;
  final DateTime? selectedDate;

  const FoodSearchScreen({
    super.key,
    this.mealType,
    this.selectedDate,
  });

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();
  final _foodSearchService = FoodSearchService();
  
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _search(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _foodSearchService.searchProducts(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Search failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _scanBarcode() async {
    // Check platform support for scanning
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barcode scanning is only available on mobile devices.')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (result is String) {
      _fetchProductByBarcode(result);
    }
  }

  Future<void> _fetchProductByBarcode(String barcode) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final product = await _foodSearchService.getProductByBarcode(barcode);
      if (product != null) {
        _addFoodLog(product);
      } else {
        setState(() => _error = 'Product not found');
      }
    } catch (e) {
      setState(() => _error = 'Scan failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addFoodLog(Product product) {
    final user = ref.read(userServiceProvider);
    if (user == null) return;

    // Extract macros (default to 0 if missing)
    final nutriments = product.nutriments;
    final calories = nutriments?.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams) ?? 0;
    final protein = nutriments?.getValue(Nutrient.proteins, PerSize.oneHundredGrams) ?? 0;
    final carbs = nutriments?.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams) ?? 0;
    final fat = nutriments?.getValue(Nutrient.fat, PerSize.oneHundredGrams) ?? 0;
    final name = product.productName ?? 'Unknown Food';

    // Show dialog to confirm portion
    showDialog(
      context: context,
      builder: (context) => _AddFoodDialog(
        name: name,
        caloriesPer100g: calories,
        proteinPer100g: protein,
        carbsPer100g: carbs,
        fatPer100g: fat,
        onAdd: (factor) async {
           final log = FoodLog(
            id: const Uuid().v4(),
            userId: user.id,
            name: name,
            calories: calories * factor,
            protein: protein * factor,
            carbs: carbs * factor,
            fat: fat * factor,
            timestamp: widget.selectedDate ?? DateTime.now(),
            isAiGenerated: false,
            mealType: widget.mealType ?? 'Breakfast',
          );

          await ref.read(foodLogServiceProvider.notifier).addLog(log);
          if (mounted) {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Close search screen
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Search Food'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for food (e.g., "Avocado")',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Color(0xFF14B8A6)),
                  onPressed: () => _search(_searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: _search,
            ),
          ),
          
          if (_isLoading)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1.2),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14B8A6).withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF14B8A6).withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.psychology,
                              size: 40,
                              color: Color(0xFF14B8A6),
                            ),
                          ),
                        );
                      },
                      onEnd: () {}, // Loop handled by parent state if needed, but simple tween is okay for now
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'AI Finding Product...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_error != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: _searchResults.isEmpty && _searchController.text.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 48, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 16),
                          const Text(
                            'No products found',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final product = _searchResults[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF334155),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: product.imageFrontSmallUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.imageFrontSmallUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c,e,s) => const Icon(Icons.fastfood, color: Colors.grey),
                                      ),
                                    )
                                  : const Icon(Icons.fastfood, color: Colors.grey),
                            ),
                            title: Text(
                              product.productName ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              product.brands ?? 'Unknown Brand',
                              style: const TextStyle(color: Color(0xFF94A3B8)),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF14B8A6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add, color: Color(0xFF14B8A6)),
                            ),
                            onTap: () => _addFoodLog(product),
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              Navigator.pop(context, barcode.rawValue);
              break; // Return first code found
            }
          }
        },
      ),
    );
  }
}

class _AddFoodDialog extends StatefulWidget {
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final Function(double) onAdd;

  const _AddFoodDialog({
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.onAdd,
  });

  @override
  State<_AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<_AddFoodDialog> {
  late TextEditingController _controller;
  double _grams = 100;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '100');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final factor = _grams / 100;
    return AlertDialog(
      title: Text(widget.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Calories: ${(widget.caloriesPer100g * factor).toInt()}'),
          Text('P: ${(widget.proteinPer100g * factor).toInt()}g  C: ${(widget.carbsPer100g * factor).toInt()}g  F: ${(widget.fatPer100g * factor).toInt()}g'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount (g)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _grams = double.tryParse(value) ?? 100;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => widget.onAdd(factor),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
