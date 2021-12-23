// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDetailResponse _$PaymentDetailResponseFromJson(
    Map<String, dynamic> json) {
  return PaymentDetailResponse()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..paymentDetailList = (json['paymentDetailList'] as List)
        ?.map((e) => e == null
            ? null
            : PaymentDetail.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PaymentDetailResponseToJson(
        PaymentDetailResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'paymentDetailList': instance.paymentDetailList,
    };
