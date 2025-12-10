// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodLog _$FoodLogFromJson(Map<String, dynamic> json) {
  return _FoodLog.fromJson(json);
}

/// @nodoc
mixin _$FoodLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get calories => throw _privateConstructorUsedError;
  double get protein => throw _privateConstructorUsedError;
  double get carbs => throw _privateConstructorUsedError;
  double get fat => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isAiGenerated => throw _privateConstructorUsedError;
  String get mealType => throw _privateConstructorUsedError;

  /// Serializes this FoodLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodLogCopyWith<FoodLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodLogCopyWith<$Res> {
  factory $FoodLogCopyWith(FoodLog value, $Res Function(FoodLog) then) =
      _$FoodLogCopyWithImpl<$Res, FoodLog>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      double calories,
      double protein,
      double carbs,
      double fat,
      DateTime timestamp,
      String? imageUrl,
      bool isAiGenerated,
      String mealType});
}

/// @nodoc
class _$FoodLogCopyWithImpl<$Res, $Val extends FoodLog>
    implements $FoodLogCopyWith<$Res> {
  _$FoodLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fat = null,
    Object? timestamp = null,
    Object? imageUrl = freezed,
    Object? isAiGenerated = null,
    Object? mealType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodLogImplCopyWith<$Res> implements $FoodLogCopyWith<$Res> {
  factory _$$FoodLogImplCopyWith(
          _$FoodLogImpl value, $Res Function(_$FoodLogImpl) then) =
      __$$FoodLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      double calories,
      double protein,
      double carbs,
      double fat,
      DateTime timestamp,
      String? imageUrl,
      bool isAiGenerated,
      String mealType});
}

/// @nodoc
class __$$FoodLogImplCopyWithImpl<$Res>
    extends _$FoodLogCopyWithImpl<$Res, _$FoodLogImpl>
    implements _$$FoodLogImplCopyWith<$Res> {
  __$$FoodLogImplCopyWithImpl(
      _$FoodLogImpl _value, $Res Function(_$FoodLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fat = null,
    Object? timestamp = null,
    Object? imageUrl = freezed,
    Object? isAiGenerated = null,
    Object? mealType = null,
  }) {
    return _then(_$FoodLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodLogImpl implements _FoodLog {
  const _$FoodLogImpl(
      {required this.id,
      required this.userId,
      required this.name,
      required this.calories,
      required this.protein,
      required this.carbs,
      required this.fat,
      required this.timestamp,
      this.imageUrl,
      this.isAiGenerated = false,
      this.mealType = 'Breakfast'});

  factory _$FoodLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final double calories;
  @override
  final double protein;
  @override
  final double carbs;
  @override
  final double fat;
  @override
  final DateTime timestamp;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isAiGenerated;
  @override
  @JsonKey()
  final String mealType;

  @override
  String toString() {
    return 'FoodLog(id: $id, userId: $userId, name: $name, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, timestamp: $timestamp, imageUrl: $imageUrl, isAiGenerated: $isAiGenerated, mealType: $mealType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAiGenerated, isAiGenerated) ||
                other.isAiGenerated == isAiGenerated) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, calories,
      protein, carbs, fat, timestamp, imageUrl, isAiGenerated, mealType);

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodLogImplCopyWith<_$FoodLogImpl> get copyWith =>
      __$$FoodLogImplCopyWithImpl<_$FoodLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodLogImplToJson(
      this,
    );
  }
}

abstract class _FoodLog implements FoodLog {
  const factory _FoodLog(
      {required final String id,
      required final String userId,
      required final String name,
      required final double calories,
      required final double protein,
      required final double carbs,
      required final double fat,
      required final DateTime timestamp,
      final String? imageUrl,
      final bool isAiGenerated,
      final String mealType}) = _$FoodLogImpl;

  factory _FoodLog.fromJson(Map<String, dynamic> json) = _$FoodLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  double get calories;
  @override
  double get protein;
  @override
  double get carbs;
  @override
  double get fat;
  @override
  DateTime get timestamp;
  @override
  String? get imageUrl;
  @override
  bool get isAiGenerated;
  @override
  String get mealType;

  /// Create a copy of FoodLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodLogImplCopyWith<_$FoodLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
