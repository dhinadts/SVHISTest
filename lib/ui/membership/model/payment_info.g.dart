// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInfo _$PaymentInfoFromJson(Map<String, dynamic> json) {
  return PaymentInfo(
    totalAmount: (json['totalAmount'] as num)?.toDouble(),
    payeePhoneNumber: json['payeePhoneNumber'] as String,
    payeeName: json['payeeName'] as String,
    payeeEmail: json['payeeEmail'] as String,
    paymentSource: json['paymentSource'] as String,
    requestId: json['requestId'] as String,
    currency: json['currency'] as String,
    paymentId: json['paymentId'] as String,
    transactionStatus: json['transactionStatus'] as String,
    transactionId: json['transactionId'] as String,
    paymentDescription: json['paymentDescription'] as String,
    transactionType: json['transactionType'] as String,
    departmentName: json['departmentName'] as String,
  );
}

Map<String, dynamic> _$PaymentInfoToJson(PaymentInfo instance) =>
    <String, dynamic>{
      'totalAmount': instance.totalAmount,
      'payeePhoneNumber': instance.payeePhoneNumber,
      'payeeName': instance.payeeName,
      'payeeEmail': instance.payeeEmail,
      'paymentSource': instance.paymentSource,
      'requestId': instance.requestId,
      'currency': instance.currency,
      'paymentId': instance.paymentId,
      'transactionStatus': instance.transactionStatus,
      'transactionId': instance.transactionId,
      'paymentDescription': instance.paymentDescription,
      'transactionType': instance.transactionType,
      'departmentName': instance.departmentName,
    };
