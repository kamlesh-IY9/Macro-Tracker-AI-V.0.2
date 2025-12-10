import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';

final recipeServiceProvider = StateNotifierProvider<RecipeService, List<Recipe>>((ref) {
  return RecipeService();
});

class RecipeService extends StateNotifier<List<Recipe>> {
  RecipeService() : super([]) {
    _loadRecipes();
  }

  static const _storageKey = 'recipes';

  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      state = jsonList.map((e) => Recipe.fromJson(e)).toList();
    }
  }

  Future<void> _saveRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  Future<void> addRecipe(Recipe recipe) async {
    state = [...state, recipe];
    await _saveRecipes();
  }

  Future<void> deleteRecipe(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _saveRecipes();
  }

  Recipe? getRecipe(String id) {
    try {
      return state.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
