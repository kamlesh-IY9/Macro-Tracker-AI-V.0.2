// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodLogImpl _$$FoodLogImplFromJson(Map<String, dynamic> json) =>
    _$FoodLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      imageUrl: json['imageUrl'] as String?,
      isAiGenerated: json['isAiGenerated'] as bool? ?? false,
      mealType: json['mealType'] as String? ?? 'Breakfast',
    );

Map<String, dynamic> _$$FoodLogImplToJson(_$FoodLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'timestamp': instance.timestamp.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'isAiGenerated': instance.isAiGenerated,
      'mealType': instance.mealType,
    };
