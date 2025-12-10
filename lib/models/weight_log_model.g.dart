// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeightLogImpl _$$WeightLogImplFromJson(Map<String, dynamic> json) =>
    _$WeightLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weight: (json['weight'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$WeightLogImplToJson(_$WeightLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'weight': instance.weight,
      'timestamp': instance.timestamp.toIso8601String(),
    };
