// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canister.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CanisterMetric _$CanisterMetricFromJson(Map<String, dynamic> json) {
  return _CanisterMetric.fromJson(json);
}

/// @nodoc
mixin _$CanisterMetric {
  String? get canisterName => throw _privateConstructorUsedError;
  BigInt get memorySize => throw _privateConstructorUsedError;
  BigInt get cyclesBalance => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get canisterId => throw _privateConstructorUsedError;
  BigInt get totalCalls => throw _privateConstructorUsedError;
  BigInt get totalOutboundBytes => throw _privateConstructorUsedError;
  BigInt get totalInboundBytes => throw _privateConstructorUsedError;

  /// Serializes this CanisterMetric to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CanisterMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanisterMetricCopyWith<CanisterMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanisterMetricCopyWith<$Res> {
  factory $CanisterMetricCopyWith(
          CanisterMetric value, $Res Function(CanisterMetric) then) =
      _$CanisterMetricCopyWithImpl<$Res, CanisterMetric>;
  @useResult
  $Res call(
      {String? canisterName,
      BigInt memorySize,
      BigInt cyclesBalance,
      String status,
      String canisterId,
      BigInt totalCalls,
      BigInt totalOutboundBytes,
      BigInt totalInboundBytes});
}

/// @nodoc
class _$CanisterMetricCopyWithImpl<$Res, $Val extends CanisterMetric>
    implements $CanisterMetricCopyWith<$Res> {
  _$CanisterMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanisterMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canisterName = freezed,
    Object? memorySize = null,
    Object? cyclesBalance = null,
    Object? status = null,
    Object? canisterId = null,
    Object? totalCalls = null,
    Object? totalOutboundBytes = null,
    Object? totalInboundBytes = null,
  }) {
    return _then(_value.copyWith(
      canisterName: freezed == canisterName
          ? _value.canisterName
          : canisterName // ignore: cast_nullable_to_non_nullable
              as String?,
      memorySize: null == memorySize
          ? _value.memorySize
          : memorySize // ignore: cast_nullable_to_non_nullable
              as BigInt,
      cyclesBalance: null == cyclesBalance
          ? _value.cyclesBalance
          : cyclesBalance // ignore: cast_nullable_to_non_nullable
              as BigInt,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      canisterId: null == canisterId
          ? _value.canisterId
          : canisterId // ignore: cast_nullable_to_non_nullable
              as String,
      totalCalls: null == totalCalls
          ? _value.totalCalls
          : totalCalls // ignore: cast_nullable_to_non_nullable
              as BigInt,
      totalOutboundBytes: null == totalOutboundBytes
          ? _value.totalOutboundBytes
          : totalOutboundBytes // ignore: cast_nullable_to_non_nullable
              as BigInt,
      totalInboundBytes: null == totalInboundBytes
          ? _value.totalInboundBytes
          : totalInboundBytes // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CanisterMetricImplCopyWith<$Res>
    implements $CanisterMetricCopyWith<$Res> {
  factory _$$CanisterMetricImplCopyWith(_$CanisterMetricImpl value,
          $Res Function(_$CanisterMetricImpl) then) =
      __$$CanisterMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? canisterName,
      BigInt memorySize,
      BigInt cyclesBalance,
      String status,
      String canisterId,
      BigInt totalCalls,
      BigInt totalOutboundBytes,
      BigInt totalInboundBytes});
}

/// @nodoc
class __$$CanisterMetricImplCopyWithImpl<$Res>
    extends _$CanisterMetricCopyWithImpl<$Res, _$CanisterMetricImpl>
    implements _$$CanisterMetricImplCopyWith<$Res> {
  __$$CanisterMetricImplCopyWithImpl(
      _$CanisterMetricImpl _value, $Res Function(_$CanisterMetricImpl) _then)
      : super(_value, _then);

  /// Create a copy of CanisterMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canisterName = freezed,
    Object? memorySize = null,
    Object? cyclesBalance = null,
    Object? status = null,
    Object? canisterId = null,
    Object? totalCalls = null,
    Object? totalOutboundBytes = null,
    Object? totalInboundBytes = null,
  }) {
    return _then(_$CanisterMetricImpl(
      canisterName: freezed == canisterName
          ? _value.canisterName
          : canisterName // ignore: cast_nullable_to_non_nullable
              as String?,
      memorySize: null == memorySize
          ? _value.memorySize
          : memorySize // ignore: cast_nullable_to_non_nullable
              as BigInt,
      cyclesBalance: null == cyclesBalance
          ? _value.cyclesBalance
          : cyclesBalance // ignore: cast_nullable_to_non_nullable
              as BigInt,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      canisterId: null == canisterId
          ? _value.canisterId
          : canisterId // ignore: cast_nullable_to_non_nullable
              as String,
      totalCalls: null == totalCalls
          ? _value.totalCalls
          : totalCalls // ignore: cast_nullable_to_non_nullable
              as BigInt,
      totalOutboundBytes: null == totalOutboundBytes
          ? _value.totalOutboundBytes
          : totalOutboundBytes // ignore: cast_nullable_to_non_nullable
              as BigInt,
      totalInboundBytes: null == totalInboundBytes
          ? _value.totalInboundBytes
          : totalInboundBytes // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CanisterMetricImpl implements _CanisterMetric {
  const _$CanisterMetricImpl(
      {this.canisterName,
      required this.memorySize,
      required this.cyclesBalance,
      required this.status,
      required this.canisterId,
      required this.totalCalls,
      required this.totalOutboundBytes,
      required this.totalInboundBytes});

  factory _$CanisterMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$CanisterMetricImplFromJson(json);

  @override
  final String? canisterName;
  @override
  final BigInt memorySize;
  @override
  final BigInt cyclesBalance;
  @override
  final String status;
  @override
  final String canisterId;
  @override
  final BigInt totalCalls;
  @override
  final BigInt totalOutboundBytes;
  @override
  final BigInt totalInboundBytes;

  @override
  String toString() {
    return 'CanisterMetric(canisterName: $canisterName, memorySize: $memorySize, cyclesBalance: $cyclesBalance, status: $status, canisterId: $canisterId, totalCalls: $totalCalls, totalOutboundBytes: $totalOutboundBytes, totalInboundBytes: $totalInboundBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanisterMetricImpl &&
            (identical(other.canisterName, canisterName) ||
                other.canisterName == canisterName) &&
            (identical(other.memorySize, memorySize) ||
                other.memorySize == memorySize) &&
            (identical(other.cyclesBalance, cyclesBalance) ||
                other.cyclesBalance == cyclesBalance) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.canisterId, canisterId) ||
                other.canisterId == canisterId) &&
            (identical(other.totalCalls, totalCalls) ||
                other.totalCalls == totalCalls) &&
            (identical(other.totalOutboundBytes, totalOutboundBytes) ||
                other.totalOutboundBytes == totalOutboundBytes) &&
            (identical(other.totalInboundBytes, totalInboundBytes) ||
                other.totalInboundBytes == totalInboundBytes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      canisterName,
      memorySize,
      cyclesBalance,
      status,
      canisterId,
      totalCalls,
      totalOutboundBytes,
      totalInboundBytes);

  /// Create a copy of CanisterMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanisterMetricImplCopyWith<_$CanisterMetricImpl> get copyWith =>
      __$$CanisterMetricImplCopyWithImpl<_$CanisterMetricImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CanisterMetricImplToJson(
      this,
    );
  }
}

abstract class _CanisterMetric implements CanisterMetric {
  const factory _CanisterMetric(
      {final String? canisterName,
      required final BigInt memorySize,
      required final BigInt cyclesBalance,
      required final String status,
      required final String canisterId,
      required final BigInt totalCalls,
      required final BigInt totalOutboundBytes,
      required final BigInt totalInboundBytes}) = _$CanisterMetricImpl;

  factory _CanisterMetric.fromJson(Map<String, dynamic> json) =
      _$CanisterMetricImpl.fromJson;

  @override
  String? get canisterName;
  @override
  BigInt get memorySize;
  @override
  BigInt get cyclesBalance;
  @override
  String get status;
  @override
  String get canisterId;
  @override
  BigInt get totalCalls;
  @override
  BigInt get totalOutboundBytes;
  @override
  BigInt get totalInboundBytes;

  /// Create a copy of CanisterMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanisterMetricImplCopyWith<_$CanisterMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
