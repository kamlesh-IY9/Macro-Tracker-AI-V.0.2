import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_log_model.freezed.dart';
part 'weight_log_model.g.dart';

@freezed
class WeightLog with _$WeightLog {
  const factory WeightLog({
    required String id,
    required String userId,
    required double weight,
    required DateTime timestamp,
  }) = _WeightLog;

  factory WeightLog.fromJson(Map<String, dynamic> json) => _$WeightLogFromJson(json);
}
