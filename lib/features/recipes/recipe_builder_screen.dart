import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../services/recipe_service.dart';
import '../../models/recipe_model.dart';

class RecipeBuilderScreen extends ConsumerStatefulWidget {
  const RecipeBuilderScreen({super.key});

  @override
  ConsumerState<RecipeBuilderScreen> createState() => _RecipeBuilderScreenState();
}

class _RecipeBuilderScreenState extends ConsumerState<RecipeBuilderScreen> {
  final _nameController = TextEditingController();
  final _servingsController = TextEditingController(text: '1');
  final _instructionsController = TextEditingController();
  final List<RecipeIngredient> _ingredients = [];

  @override
  void dispose() {
    _nameController.dispose();
    _servingsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    showDialog(
      context: context,
      builder: (context) => _IngredientDialog(
        onAdd: (ingredient) {
          setState(() => _ingredients.add(ingredient));
        },
      ),
    );
  }

  void _saveRecipe() {
    if (_nameController.text.isEmpty || _ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a name and at least one ingredient')),
      );
      return;
    }

    final totalCal = _ingredients.fold<double>(0, (sum, i) => sum + i.calories);
    final totalProtein = _ingredients.fold<double>(0, (sum, i) => sum + i.protein);
    final totalCarbs = _ingredients.fold<double>(0, (sum, i) => sum + i.carbs);
    final totalFat = _ingredients.fold<double>(0, (sum, i) => sum + i.fat);

    final recipe = Recipe(
      id: const Uuid().v4(),
      name: _nameController.text,
      ingredients: _ingredients,
      servings: int.tryParse(_servingsController.text) ?? 1,
      totalCalories: totalCal,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      instructions: _instructionsController.text.isEmpty ? null : _instructionsController.text,
      createdAt: DateTime.now(),
    );

    ref.read(recipeServiceProvider.notifier).addRecipe(recipe);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final totalCal = _ingredients.fold<double>(0, (sum, i) => sum + i.calories);
    final servings = int.tryParse(_servingsController.text) ?? 1;
    final caloriesPerServing = servings > 0 ? totalCal / servings : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Create Recipe'),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF14B8A6), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Recipe Name
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Recipe Name',
                labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Servings
            TextField(
              controller: _servingsController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Servings',
                labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Total Macros Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Per Serving',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${caloriesPerServing.toInt()} kcal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'P: ${(totalCal > 0 ? _ingredients.fold<double>(0, (s, i) => s + i.protein) / servings : 0).toInt()}g • '
                    'C: ${(totalCal > 0 ? _ingredients.fold<double>(0, (s, i) => s + i.carbs) / servings : 0).toInt()}g • '
                    'F: ${(totalCal > 0 ? _ingredients.fold<double>(0, (s, i) => s + i.fat) / servings : 0).toInt()}g',
                    style: const TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ingredients Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add, color: Color(0xFF14B8A6)),
                  label: const Text(
                    'Add',
                    style: TextStyle(color: Color(0xFF14B8A6)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ingredients List
            if (_ingredients.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No ingredients added yet',
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ),
              )
            else
              ..._ingredients.map((ingredient) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ingredient.foodName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${ingredient.amount} ${ingredient.unit}',
                                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${ingredient.calories.toInt()} kcal',
                          style: const TextStyle(color: Color(0xFF14B8A6)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => _ingredients.remove(ingredient));
                          },
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 24),

            // Instructions
            TextField(
              controller: _instructionsController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Instructions (Optional)',
                labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientDialog extends StatefulWidget {
  final Function(RecipeIngredient) onAdd;

  const _IngredientDialog({required this.onAdd});

  @override
  State<_IngredientDialog> createState() => _IngredientDialogState();
}

class _IngredientDialogState extends State<_IngredientDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _unitController = TextEditingController(text: 'g');
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      title: const Text('Add Ingredient', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Food Name',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _unitController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _caloriesController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Calories',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _proteinController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Protein (g)',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _carbsController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Carbs (g)',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fatController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Fat (g)',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
        ),
        ElevatedButton(
          onPressed: () {
            final ingredient = RecipeIngredient(
              foodName: _nameController.text,
              amount: double.tryParse(_amountController.text) ?? 0,
              unit: _unitController.text,
              calories: double.tryParse(_caloriesController.text) ?? 0,
              protein: double.tryParse(_proteinController.text) ?? 0,
              carbs: double.tryParse(_carbsController.text) ?? 0,
              fat: double.tryParse(_fatController.text) ?? 0,
            );
            widget.onAdd(ingredient);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14B8A6)),
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
