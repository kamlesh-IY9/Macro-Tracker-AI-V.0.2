import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_log_model.freezed.dart';
part 'food_log_model.g.dart';

@freezed
class FoodLog with _$FoodLog {
  const factory FoodLog({
    required String id,
    required String userId,
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required DateTime timestamp,
    String? imageUrl,
    @Default(false) bool isAiGenerated,
    @Default('Breakfast') String mealType, // NEW: Track which meal this belongs to
  }) = _FoodLog;

  factory FoodLog.fromJson(Map<String, dynamic> json) => _$FoodLogFromJson(json);
}
