import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/meal_planner_service.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  final List<String> _items = [];
  final Set<String> _checkedItems = {};
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _importFromMealPlan();
  }

  void _importFromMealPlan() {
    final plannerService = ref.read(mealPlannerServiceProvider.notifier);
    final currentPlan = plannerService.getCurrentPlan();
    
    if (currentPlan != null) {
      final newItems = <String>[];
      currentPlan.days.forEach((day, meals) {
        for (var meal in meals) {
          // Simple heuristic: Add meal name as a placeholder for ingredients
          // In a real app, we'd parse ingredients or have them in the data model
          final item = "Ingredients for ${meal.name}";
          if (!_items.contains(item)) {
            newItems.add(item);
          }
        }
      });
      
      if (newItems.isNotEmpty) {
        setState(() {
          _items.addAll(newItems);
        });
      }
    }
  }

  void _addItem(String item) {
    if (item.isNotEmpty) {
      setState(() {
        _items.add(item);
        _controller.clear();
      });
    }
  }

  void _toggleItem(String item) {
    setState(() {
      if (_checkedItems.contains(item)) {
        _checkedItems.remove(item);
      } else {
        _checkedItems.add(item);
      }
    });
  }

  void _deleteItem(String item) {
    setState(() {
      _items.remove(item);
      _checkedItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Add Item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _addItem,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32, color: Colors.orange),
                  onPressed: () => _addItem(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text(
                      'List is empty',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final isChecked = _checkedItems.contains(item);
                      return ListTile(
                        leading: Checkbox(
                          value: isChecked,
                          onChanged: (_) => _toggleItem(item),
                          activeColor: theme.primaryColor,
                        ),
                        title: Text(
                          item,
                          style: TextStyle(
                            decoration: isChecked ? TextDecoration.lineThrough : null,
                            color: isChecked ? Colors.grey : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteItem(item),
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
