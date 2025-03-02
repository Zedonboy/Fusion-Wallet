/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nft_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CollectMetaValue {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) int,
    required TResult Function(BigInt field0) nat,
    required TResult Function(Uint8List field0) blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? int,
    TResult? Function(BigInt field0)? nat,
    TResult? Function(Uint8List field0)? blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? int,
    TResult Function(BigInt field0)? nat,
    TResult Function(Uint8List field0)? blob,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_Int value) int,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_Int value)? int,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_Int value)? int,
    TResult Function(CollectMetaValue_Nat value)? nat,
    TResult Function(CollectMetaValue_Blob value)? blob,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectMetaValueCopyWith<$Res> {
  factory $CollectMetaValueCopyWith(
          CollectMetaValue value, $Res Function(CollectMetaValue) then) =
      _$CollectMetaValueCopyWithImpl<$Res, CollectMetaValue>;
}

/// @nodoc
class _$CollectMetaValueCopyWithImpl<$Res, $Val extends CollectMetaValue>
    implements $CollectMetaValueCopyWith<$Res> {
  _$CollectMetaValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CollectMetaValue_TextImplCopyWith<$Res> {
  factory _$$CollectMetaValue_TextImplCopyWith(
          _$CollectMetaValue_TextImpl value,
          $Res Function(_$CollectMetaValue_TextImpl) then) =
      __$$CollectMetaValue_TextImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$CollectMetaValue_TextImplCopyWithImpl<$Res>
    extends _$CollectMetaValueCopyWithImpl<$Res, _$CollectMetaValue_TextImpl>
    implements _$$CollectMetaValue_TextImplCopyWith<$Res> {
  __$$CollectMetaValue_TextImplCopyWithImpl(_$CollectMetaValue_TextImpl _value,
      $Res Function(_$CollectMetaValue_TextImpl) _then)
      : super(_value, _then);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$CollectMetaValue_TextImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_TextImpl extends CollectMetaValue_Text {
  const _$CollectMetaValue_TextImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'CollectMetaValue.text(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_TextImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectMetaValue_TextImplCopyWith<_$CollectMetaValue_TextImpl>
      get copyWith => __$$CollectMetaValue_TextImplCopyWithImpl<
          _$CollectMetaValue_TextImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) int,
    required TResult Function(BigInt field0) nat,
    required TResult Function(Uint8List field0) blob,
  }) {
    return text(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? int,
    TResult? Function(BigInt field0)? nat,
    TResult? Function(Uint8List field0)? blob,
  }) {
    return text?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? int,
    TResult Function(BigInt field0)? nat,
    TResult Function(Uint8List field0)? blob,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_Int value) int,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_Int value)? int,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_Int value)? int,
    TResult Function(CollectMetaValue_Nat value)? nat,
    TResult Function(CollectMetaValue_Blob value)? blob,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class CollectMetaValue_Text extends CollectMetaValue {
  const factory CollectMetaValue_Text(final String field0) =
      _$CollectMetaValue_TextImpl;
  const CollectMetaValue_Text._() : super._();

  @override
  String get field0;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectMetaValue_TextImplCopyWith<_$CollectMetaValue_TextImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CollectMetaValue_IntImplCopyWith<$Res> {
  factory _$$CollectMetaValue_IntImplCopyWith(_$CollectMetaValue_IntImpl value,
          $Res Function(_$CollectMetaValue_IntImpl) then) =
      __$$CollectMetaValue_IntImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$CollectMetaValue_IntImplCopyWithImpl<$Res>
    extends _$CollectMetaValueCopyWithImpl<$Res, _$CollectMetaValue_IntImpl>
    implements _$$CollectMetaValue_IntImplCopyWith<$Res> {
  __$$CollectMetaValue_IntImplCopyWithImpl(_$CollectMetaValue_IntImpl _value,
      $Res Function(_$CollectMetaValue_IntImpl) _then)
      : super(_value, _then);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$CollectMetaValue_IntImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_IntImpl extends CollectMetaValue_Int {
  const _$CollectMetaValue_IntImpl(this.field0) : super._();

  @override
  final int field0;

  @override
  String toString() {
    return 'CollectMetaValue.int(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_IntImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectMetaValue_IntImplCopyWith<_$CollectMetaValue_IntImpl>
      get copyWith =>
          __$$CollectMetaValue_IntImplCopyWithImpl<_$CollectMetaValue_IntImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) int,
    required TResult Function(BigInt field0) nat,
    required TResult Function(Uint8List field0) blob,
  }) {
    return int(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? int,
    TResult? Function(BigInt field0)? nat,
    TResult? Function(Uint8List field0)? blob,
  }) {
    return int?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? int,
    TResult Function(BigInt field0)? nat,
    TResult Function(Uint8List field0)? blob,
    required TResult orElse(),
  }) {
    if (int != null) {
      return int(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_Int value) int,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return int(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_Int value)? int,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return int?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_Int value)? int,
    TResult Function(CollectMetaValue_Nat value)? nat,
    TResult Function(CollectMetaValue_Blob value)? blob,
    required TResult orElse(),
  }) {
    if (int != null) {
      return int(this);
    }
    return orElse();
  }
}

abstract class CollectMetaValue_Int extends CollectMetaValue {
  const factory CollectMetaValue_Int(final int field0) =
      _$CollectMetaValue_IntImpl;
  const CollectMetaValue_Int._() : super._();

  @override
  int get field0;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectMetaValue_IntImplCopyWith<_$CollectMetaValue_IntImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CollectMetaValue_NatImplCopyWith<$Res> {
  factory _$$CollectMetaValue_NatImplCopyWith(_$CollectMetaValue_NatImpl value,
          $Res Function(_$CollectMetaValue_NatImpl) then) =
      __$$CollectMetaValue_NatImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BigInt field0});
}

/// @nodoc
class __$$CollectMetaValue_NatImplCopyWithImpl<$Res>
    extends _$CollectMetaValueCopyWithImpl<$Res, _$CollectMetaValue_NatImpl>
    implements _$$CollectMetaValue_NatImplCopyWith<$Res> {
  __$$CollectMetaValue_NatImplCopyWithImpl(_$CollectMetaValue_NatImpl _value,
      $Res Function(_$CollectMetaValue_NatImpl) _then)
      : super(_value, _then);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$CollectMetaValue_NatImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_NatImpl extends CollectMetaValue_Nat {
  const _$CollectMetaValue_NatImpl(this.field0) : super._();

  @override
  final BigInt field0;

  @override
  String toString() {
    return 'CollectMetaValue.nat(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_NatImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectMetaValue_NatImplCopyWith<_$CollectMetaValue_NatImpl>
      get copyWith =>
          __$$CollectMetaValue_NatImplCopyWithImpl<_$CollectMetaValue_NatImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) int,
    required TResult Function(BigInt field0) nat,
    required TResult Function(Uint8List field0) blob,
  }) {
    return nat(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? int,
    TResult? Function(BigInt field0)? nat,
    TResult? Function(Uint8List field0)? blob,
  }) {
    return nat?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? int,
    TResult Function(BigInt field0)? nat,
    TResult Function(Uint8List field0)? blob,
    required TResult orElse(),
  }) {
    if (nat != null) {
      return nat(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_Int value) int,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return nat(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_Int value)? int,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return nat?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_Int value)? int,
    TResult Function(CollectMetaValue_Nat value)? nat,
    TResult Function(CollectMetaValue_Blob value)? blob,
    required TResult orElse(),
  }) {
    if (nat != null) {
      return nat(this);
    }
    return orElse();
  }
}

abstract class CollectMetaValue_Nat extends CollectMetaValue {
  const factory CollectMetaValue_Nat(final BigInt field0) =
      _$CollectMetaValue_NatImpl;
  const CollectMetaValue_Nat._() : super._();

  @override
  BigInt get field0;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectMetaValue_NatImplCopyWith<_$CollectMetaValue_NatImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CollectMetaValue_BlobImplCopyWith<$Res> {
  factory _$$CollectMetaValue_BlobImplCopyWith(
          _$CollectMetaValue_BlobImpl value,
          $Res Function(_$CollectMetaValue_BlobImpl) then) =
      __$$CollectMetaValue_BlobImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Uint8List field0});
}

/// @nodoc
class __$$CollectMetaValue_BlobImplCopyWithImpl<$Res>
    extends _$CollectMetaValueCopyWithImpl<$Res, _$CollectMetaValue_BlobImpl>
    implements _$$CollectMetaValue_BlobImplCopyWith<$Res> {
  __$$CollectMetaValue_BlobImplCopyWithImpl(_$CollectMetaValue_BlobImpl _value,
      $Res Function(_$CollectMetaValue_BlobImpl) _then)
      : super(_value, _then);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$CollectMetaValue_BlobImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_BlobImpl extends CollectMetaValue_Blob {
  const _$CollectMetaValue_BlobImpl(this.field0) : super._();

  @override
  final Uint8List field0;

  @override
  String toString() {
    return 'CollectMetaValue.blob(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_BlobImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectMetaValue_BlobImplCopyWith<_$CollectMetaValue_BlobImpl>
      get copyWith => __$$CollectMetaValue_BlobImplCopyWithImpl<
          _$CollectMetaValue_BlobImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) int,
    required TResult Function(BigInt field0) nat,
    required TResult Function(Uint8List field0) blob,
  }) {
    return blob(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? int,
    TResult? Function(BigInt field0)? nat,
    TResult? Function(Uint8List field0)? blob,
  }) {
    return blob?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? int,
    TResult Function(BigInt field0)? nat,
    TResult Function(Uint8List field0)? blob,
    required TResult orElse(),
  }) {
    if (blob != null) {
      return blob(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_Int value) int,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return blob(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_Int value)? int,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return blob?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_Int value)? int,
    TResult Function(CollectMetaValue_Nat value)? nat,
    TResult Function(CollectMetaValue_Blob value)? blob,
    required TResult orElse(),
  }) {
    if (blob != null) {
      return blob(this);
    }
    return orElse();
  }
}

abstract class CollectMetaValue_Blob extends CollectMetaValue {
  const factory CollectMetaValue_Blob(final Uint8List field0) =
      _$CollectMetaValue_BlobImpl;
  const CollectMetaValue_Blob._() : super._();

  @override
  Uint8List get field0;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectMetaValue_BlobImplCopyWith<_$CollectMetaValue_BlobImpl>
      get copyWith => throw _privateConstructorUsedError;
}
