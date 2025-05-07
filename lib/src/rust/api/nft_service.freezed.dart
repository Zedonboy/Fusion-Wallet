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
  Object get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data) text,
    required TResult Function(BigInt data) metadataInt,
    required TResult Function(BigInt data) nat,
    required TResult Function(Uint8List data) blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? text,
    TResult? Function(BigInt data)? metadataInt,
    TResult? Function(BigInt data)? nat,
    TResult? Function(Uint8List data)? blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? text,
    TResult Function(BigInt data)? metadataInt,
    TResult Function(BigInt data)? nat,
    TResult Function(Uint8List data)? blob,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_MetadataInt value) metadataInt,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_MetadataInt value)? metadataInt,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_MetadataInt value)? metadataInt,
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
  $Res call({String data});
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
    Object? data = null,
  }) {
    return _then(_$CollectMetaValue_TextImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_TextImpl extends CollectMetaValue_Text {
  const _$CollectMetaValue_TextImpl({required this.data}) : super._();

  @override
  final String data;

  @override
  String toString() {
    return 'CollectMetaValue.text(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_TextImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

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
    required TResult Function(String data) text,
    required TResult Function(BigInt data) metadataInt,
    required TResult Function(BigInt data) nat,
    required TResult Function(Uint8List data) blob,
  }) {
    return text(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? text,
    TResult? Function(BigInt data)? metadataInt,
    TResult? Function(BigInt data)? nat,
    TResult? Function(Uint8List data)? blob,
  }) {
    return text?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? text,
    TResult Function(BigInt data)? metadataInt,
    TResult Function(BigInt data)? nat,
    TResult Function(Uint8List data)? blob,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_MetadataInt value) metadataInt,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_MetadataInt value)? metadataInt,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_MetadataInt value)? metadataInt,
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
  const factory CollectMetaValue_Text({required final String data}) =
      _$CollectMetaValue_TextImpl;
  const CollectMetaValue_Text._() : super._();

  @override
  String get data;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectMetaValue_TextImplCopyWith<_$CollectMetaValue_TextImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CollectMetaValue_MetadataIntImplCopyWith<$Res> {
  factory _$$CollectMetaValue_MetadataIntImplCopyWith(
          _$CollectMetaValue_MetadataIntImpl value,
          $Res Function(_$CollectMetaValue_MetadataIntImpl) then) =
      __$$CollectMetaValue_MetadataIntImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BigInt data});
}

/// @nodoc
class __$$CollectMetaValue_MetadataIntImplCopyWithImpl<$Res>
    extends _$CollectMetaValueCopyWithImpl<$Res,
        _$CollectMetaValue_MetadataIntImpl>
    implements _$$CollectMetaValue_MetadataIntImplCopyWith<$Res> {
  __$$CollectMetaValue_MetadataIntImplCopyWithImpl(
      _$CollectMetaValue_MetadataIntImpl _value,
      $Res Function(_$CollectMetaValue_MetadataIntImpl) _then)
      : super(_value, _then);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$CollectMetaValue_MetadataIntImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_MetadataIntImpl extends CollectMetaValue_MetadataInt {
  const _$CollectMetaValue_MetadataIntImpl({required this.data}) : super._();

  @override
  final BigInt data;

  @override
  String toString() {
    return 'CollectMetaValue.metadataInt(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_MetadataIntImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectMetaValue_MetadataIntImplCopyWith<
          _$CollectMetaValue_MetadataIntImpl>
      get copyWith => __$$CollectMetaValue_MetadataIntImplCopyWithImpl<
          _$CollectMetaValue_MetadataIntImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data) text,
    required TResult Function(BigInt data) metadataInt,
    required TResult Function(BigInt data) nat,
    required TResult Function(Uint8List data) blob,
  }) {
    return metadataInt(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? text,
    TResult? Function(BigInt data)? metadataInt,
    TResult? Function(BigInt data)? nat,
    TResult? Function(Uint8List data)? blob,
  }) {
    return metadataInt?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? text,
    TResult Function(BigInt data)? metadataInt,
    TResult Function(BigInt data)? nat,
    TResult Function(Uint8List data)? blob,
    required TResult orElse(),
  }) {
    if (metadataInt != null) {
      return metadataInt(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_MetadataInt value) metadataInt,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return metadataInt(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_MetadataInt value)? metadataInt,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return metadataInt?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_MetadataInt value)? metadataInt,
    TResult Function(CollectMetaValue_Nat value)? nat,
    TResult Function(CollectMetaValue_Blob value)? blob,
    required TResult orElse(),
  }) {
    if (metadataInt != null) {
      return metadataInt(this);
    }
    return orElse();
  }
}

abstract class CollectMetaValue_MetadataInt extends CollectMetaValue {
  const factory CollectMetaValue_MetadataInt({required final BigInt data}) =
      _$CollectMetaValue_MetadataIntImpl;
  const CollectMetaValue_MetadataInt._() : super._();

  @override
  BigInt get data;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectMetaValue_MetadataIntImplCopyWith<
          _$CollectMetaValue_MetadataIntImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CollectMetaValue_NatImplCopyWith<$Res> {
  factory _$$CollectMetaValue_NatImplCopyWith(_$CollectMetaValue_NatImpl value,
          $Res Function(_$CollectMetaValue_NatImpl) then) =
      __$$CollectMetaValue_NatImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BigInt data});
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
    Object? data = null,
  }) {
    return _then(_$CollectMetaValue_NatImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_NatImpl extends CollectMetaValue_Nat {
  const _$CollectMetaValue_NatImpl({required this.data}) : super._();

  @override
  final BigInt data;

  @override
  String toString() {
    return 'CollectMetaValue.nat(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_NatImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

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
    required TResult Function(String data) text,
    required TResult Function(BigInt data) metadataInt,
    required TResult Function(BigInt data) nat,
    required TResult Function(Uint8List data) blob,
  }) {
    return nat(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? text,
    TResult? Function(BigInt data)? metadataInt,
    TResult? Function(BigInt data)? nat,
    TResult? Function(Uint8List data)? blob,
  }) {
    return nat?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? text,
    TResult Function(BigInt data)? metadataInt,
    TResult Function(BigInt data)? nat,
    TResult Function(Uint8List data)? blob,
    required TResult orElse(),
  }) {
    if (nat != null) {
      return nat(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_MetadataInt value) metadataInt,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return nat(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_MetadataInt value)? metadataInt,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return nat?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_MetadataInt value)? metadataInt,
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
  const factory CollectMetaValue_Nat({required final BigInt data}) =
      _$CollectMetaValue_NatImpl;
  const CollectMetaValue_Nat._() : super._();

  @override
  BigInt get data;

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
  $Res call({Uint8List data});
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
    Object? data = null,
  }) {
    return _then(_$CollectMetaValue_BlobImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$CollectMetaValue_BlobImpl extends CollectMetaValue_Blob {
  const _$CollectMetaValue_BlobImpl({required this.data}) : super._();

  @override
  final Uint8List data;

  @override
  String toString() {
    return 'CollectMetaValue.blob(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectMetaValue_BlobImpl &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

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
    required TResult Function(String data) text,
    required TResult Function(BigInt data) metadataInt,
    required TResult Function(BigInt data) nat,
    required TResult Function(Uint8List data) blob,
  }) {
    return blob(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? text,
    TResult? Function(BigInt data)? metadataInt,
    TResult? Function(BigInt data)? nat,
    TResult? Function(Uint8List data)? blob,
  }) {
    return blob?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? text,
    TResult Function(BigInt data)? metadataInt,
    TResult Function(BigInt data)? nat,
    TResult Function(Uint8List data)? blob,
    required TResult orElse(),
  }) {
    if (blob != null) {
      return blob(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CollectMetaValue_Text value) text,
    required TResult Function(CollectMetaValue_MetadataInt value) metadataInt,
    required TResult Function(CollectMetaValue_Nat value) nat,
    required TResult Function(CollectMetaValue_Blob value) blob,
  }) {
    return blob(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CollectMetaValue_Text value)? text,
    TResult? Function(CollectMetaValue_MetadataInt value)? metadataInt,
    TResult? Function(CollectMetaValue_Nat value)? nat,
    TResult? Function(CollectMetaValue_Blob value)? blob,
  }) {
    return blob?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CollectMetaValue_Text value)? text,
    TResult Function(CollectMetaValue_MetadataInt value)? metadataInt,
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
  const factory CollectMetaValue_Blob({required final Uint8List data}) =
      _$CollectMetaValue_BlobImpl;
  const CollectMetaValue_Blob._() : super._();

  @override
  Uint8List get data;

  /// Create a copy of CollectMetaValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectMetaValue_BlobImplCopyWith<_$CollectMetaValue_BlobImpl>
      get copyWith => throw _privateConstructorUsedError;
}
