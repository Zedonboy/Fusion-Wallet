// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canister.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CanisterMetricImpl _$$CanisterMetricImplFromJson(Map<String, dynamic> json) =>
    _$CanisterMetricImpl(
      memorySize: BigInt.parse(json['memorySize'] as String),
      cyclesBalance: BigInt.parse(json['cyclesBalance'] as String),
      status: json['status'] as String,
      canisterId: json['canisterId'] as String,
      totalCalls: BigInt.parse(json['totalCalls'] as String),
      totalOutboundBytes: BigInt.parse(json['totalOutboundBytes'] as String),
      totalInboundBytes: BigInt.parse(json['totalInboundBytes'] as String),
    );

Map<String, dynamic> _$$CanisterMetricImplToJson(
        _$CanisterMetricImpl instance) =>
    <String, dynamic>{
      'memorySize': instance.memorySize.toString(),
      'cyclesBalance': instance.cyclesBalance.toString(),
      'status': instance.status,
      'canisterId': instance.canisterId,
      'totalCalls': instance.totalCalls.toString(),
      'totalOutboundBytes': instance.totalOutboundBytes.toString(),
      'totalInboundBytes': instance.totalInboundBytes.toString(),
    };
