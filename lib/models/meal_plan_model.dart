import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'meal_plan_model.freezed.dart';
part 'meal_plan_model.g.dart';

@freezed
class MealItem with _$MealItem {
  const factory MealItem({
    required String id,
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required String type, // Breakfast, Lunch, Dinner, Snack
  }) = _MealItem;

  factory MealItem.fromJson(Map<String, dynamic> json) => _$MealItemFromJson(json);
}

@freezed
class MealPlan with _$MealPlan {
  const factory MealPlan({
    required String id,
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, List<MealItem>> days, // Key: "Monday", Value: List of meals
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);
}
