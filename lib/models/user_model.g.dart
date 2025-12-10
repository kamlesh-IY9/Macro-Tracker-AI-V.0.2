// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      activityLevel: json['activityLevel'] as String,
      goal: json['goal'] as String,
      tdee: (json['tdee'] as num).toDouble(),
      proteinTarget: (json['proteinTarget'] as num).toDouble(),
      carbTarget: (json['carbTarget'] as num).toDouble(),
      fatTarget: (json['fatTarget'] as num).toDouble(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'age': instance.age,
      'gender': instance.gender,
      'weight': instance.weight,
      'height': instance.height,
      'activityLevel': instance.activityLevel,
      'goal': instance.goal,
      'tdee': instance.tdee,
      'proteinTarget': instance.proteinTarget,
      'carbTarget': instance.carbTarget,
      'fatTarget': instance.fatTarget,
    };
