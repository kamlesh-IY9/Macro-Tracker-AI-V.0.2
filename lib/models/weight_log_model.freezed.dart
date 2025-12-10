// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeightLog _$WeightLogFromJson(Map<String, dynamic> json) {
  return _WeightLog.fromJson(json);
}

/// @nodoc
mixin _$WeightLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this WeightLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightLogCopyWith<WeightLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightLogCopyWith<$Res> {
  factory $WeightLogCopyWith(WeightLog value, $Res Function(WeightLog) then) =
      _$WeightLogCopyWithImpl<$Res, WeightLog>;
  @useResult
  $Res call({String id, String userId, double weight, DateTime timestamp});
}

/// @nodoc
class _$WeightLogCopyWithImpl<$Res, $Val extends WeightLog>
    implements $WeightLogCopyWith<$Res> {
  _$WeightLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weight = null,
    Object? timestamp = null,
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
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeightLogImplCopyWith<$Res>
    implements $WeightLogCopyWith<$Res> {
  factory _$$WeightLogImplCopyWith(
          _$WeightLogImpl value, $Res Function(_$WeightLogImpl) then) =
      __$$WeightLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String userId, double weight, DateTime timestamp});
}

/// @nodoc
class __$$WeightLogImplCopyWithImpl<$Res>
    extends _$WeightLogCopyWithImpl<$Res, _$WeightLogImpl>
    implements _$$WeightLogImplCopyWith<$Res> {
  __$$WeightLogImplCopyWithImpl(
      _$WeightLogImpl _value, $Res Function(_$WeightLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeightLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weight = null,
    Object? timestamp = null,
  }) {
    return _then(_$WeightLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightLogImpl implements _WeightLog {
  const _$WeightLogImpl(
      {required this.id,
      required this.userId,
      required this.weight,
      required this.timestamp});

  factory _$WeightLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final double weight;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'WeightLog(id: $id, userId: $userId, weight: $weight, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, weight, timestamp);

  /// Create a copy of WeightLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightLogImplCopyWith<_$WeightLogImpl> get copyWith =>
      __$$WeightLogImplCopyWithImpl<_$WeightLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightLogImplToJson(
      this,
    );
  }
}

abstract class _WeightLog implements WeightLog {
  const factory _WeightLog(
      {required final String id,
      required final String userId,
      required final double weight,
      required final DateTime timestamp}) = _$WeightLogImpl;

  factory _WeightLog.fromJson(Map<String, dynamic> json) =
      _$WeightLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  double get weight;
  @override
  DateTime get timestamp;

  /// Create a copy of WeightLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightLogImplCopyWith<_$WeightLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
