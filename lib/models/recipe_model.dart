import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_model.freezed.dart';
part 'recipe_model.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String name,
    required List<RecipeIngredient> ingredients,
    required int servings,
    required double totalCalories,
    required double totalProtein,
    required double totalCarbs,
    required double totalFat,
    String? instructions,
    DateTime? createdAt,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}

@freezed
class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    required String foodName,
    required double amount,
    required String unit,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);
}
