import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String? name,
    required int age,
    required String gender, // 'male', 'female'
    required double weight, // in kg
    required double height, // in cm
    required String activityLevel, // 'sedentary', 'light', 'moderate', 'active', 'very_active'
    required String goal, // 'lose', 'maintain', 'gain'
    required double tdee, // Calculated Total Daily Energy Expenditure
    required double proteinTarget,
    required double carbTarget,
    required double fatTarget,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
