// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'razorpay_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RazorpayInfo _$RazorpayInfoFromJson(Map<String, dynamic> json) {
  return RazorpayInfo(
    paymentId: json['paymentId'] as String,
    requestId: json['requestId'] as String,
    orderId: json['orderId'] as String,
    totalAmount: (json['totalAmount'] as num)?.toDouble(),
    currency: json['currency'] as String,
    payeeName: json['payeeName'] as String,
    payeeEmail: json['payeeEmail'] as String,
    payeePhoneNumber: json['payeePhoneNumber'] as String,
    merchantName: json['merchantName'] as String,
    notes: json['notes'] as String,
    paymentDescription: json['paymentDescription'] as String,
    secretKey: json['secretKey'] as String,
    theme: json['theme'] as String,
    userName: json['userName'] as String,
    active: json['active'] as bool,
    transactionGateway: json['transactionGateway'] as String,
  );
}

Map<String, dynamic> _$RazorpayInfoToJson(RazorpayInfo instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'requestId': instance.requestId,
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'payeeName': instance.payeeName,
      'payeeEmail': instance.payeeEmail,
      'payeePhoneNumber': instance.payeePhoneNumber,
      'merchantName': instance.merchantName,
      'notes': instance.notes,
      'paymentDescription': instance.paymentDescription,
      'secretKey': instance.secretKey,
      'theme': instance.theme,
      'active': instance.active,
      'userName': instance.userName,
      'transactionGateway': instance.transactionGateway,
    };
