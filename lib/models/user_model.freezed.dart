// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError; // 'male', 'female'
  double get weight => throw _privateConstructorUsedError; // in kg
  double get height => throw _privateConstructorUsedError; // in cm
  String get activityLevel =>
      throw _privateConstructorUsedError; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  String get goal =>
      throw _privateConstructorUsedError; // 'lose', 'maintain', 'gain'
  double get tdee =>
      throw _privateConstructorUsedError; // Calculated Total Daily Energy Expenditure
  double get proteinTarget => throw _privateConstructorUsedError;
  double get carbTarget => throw _privateConstructorUsedError;
  double get fatTarget => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      int age,
      String gender,
      double weight,
      double height,
      String activityLevel,
      String goal,
      double tdee,
      double proteinTarget,
      double carbTarget,
      double fatTarget});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? age = null,
    Object? gender = null,
    Object? weight = null,
    Object? height = null,
    Object? activityLevel = null,
    Object? goal = null,
    Object? tdee = null,
    Object? proteinTarget = null,
    Object? carbTarget = null,
    Object? fatTarget = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      tdee: null == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as double,
      proteinTarget: null == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double,
      carbTarget: null == carbTarget
          ? _value.carbTarget
          : carbTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fatTarget: null == fatTarget
          ? _value.fatTarget
          : fatTarget // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      int age,
      String gender,
      double weight,
      double height,
      String activityLevel,
      String goal,
      double tdee,
      double proteinTarget,
      double carbTarget,
      double fatTarget});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? age = null,
    Object? gender = null,
    Object? weight = null,
    Object? height = null,
    Object? activityLevel = null,
    Object? goal = null,
    Object? tdee = null,
    Object? proteinTarget = null,
    Object? carbTarget = null,
    Object? fatTarget = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      tdee: null == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as double,
      proteinTarget: null == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double,
      carbTarget: null == carbTarget
          ? _value.carbTarget
          : carbTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fatTarget: null == fatTarget
          ? _value.fatTarget
          : fatTarget // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.email,
      required this.name,
      required this.age,
      required this.gender,
      required this.weight,
      required this.height,
      required this.activityLevel,
      required this.goal,
      required this.tdee,
      required this.proteinTarget,
      required this.carbTarget,
      required this.fatTarget});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? name;
  @override
  final int age;
  @override
  final String gender;
// 'male', 'female'
  @override
  final double weight;
// in kg
  @override
  final double height;
// in cm
  @override
  final String activityLevel;
// 'sedentary', 'light', 'moderate', 'active', 'very_active'
  @override
  final String goal;
// 'lose', 'maintain', 'gain'
  @override
  final double tdee;
// Calculated Total Daily Energy Expenditure
  @override
  final double proteinTarget;
  @override
  final double carbTarget;
  @override
  final double fatTarget;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, age: $age, gender: $gender, weight: $weight, height: $height, activityLevel: $activityLevel, goal: $goal, tdee: $tdee, proteinTarget: $proteinTarget, carbTarget: $carbTarget, fatTarget: $fatTarget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.tdee, tdee) || other.tdee == tdee) &&
            (identical(other.proteinTarget, proteinTarget) ||
                other.proteinTarget == proteinTarget) &&
            (identical(other.carbTarget, carbTarget) ||
                other.carbTarget == carbTarget) &&
            (identical(other.fatTarget, fatTarget) ||
                other.fatTarget == fatTarget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      age,
      gender,
      weight,
      height,
      activityLevel,
      goal,
      tdee,
      proteinTarget,
      carbTarget,
      fatTarget);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      required final String email,
      required final String? name,
      required final int age,
      required final String gender,
      required final double weight,
      required final double height,
      required final String activityLevel,
      required final String goal,
      required final double tdee,
      required final double proteinTarget,
      required final double carbTarget,
      required final double fatTarget}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get name;
  @override
  int get age;
  @override
  String get gender; // 'male', 'female'
  @override
  double get weight; // in kg
  @override
  double get height; // in cm
  @override
  String
      get activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  @override
  String get goal; // 'lose', 'maintain', 'gain'
  @override
  double get tdee; // Calculated Total Daily Energy Expenditure
  @override
  double get proteinTarget;
  @override
  double get carbTarget;
  @override
  double get fatTarget;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
