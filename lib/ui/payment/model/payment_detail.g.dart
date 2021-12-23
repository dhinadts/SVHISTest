// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDetail _$PaymentDetailFromJson(Map<String, dynamic> json) {
  return PaymentDetail(
    active: json['active'] as bool,
    comments: json['comments'] as String,
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    currency: json['currency'] as String,
    developerId: json['developerId'] as String,
    departmentName: json['departmentName'] as String,
    fxRate: json['fxRate'] as int,
    merchantId: json['merchantId'] as String,
    modifiedBy: json['modifiedBy'] as String,
    modifiedOn: json['modifiedOn'] as String,
    orderId: json['orderId'] as String,
    payeeEmail: json['payeeEmail'] as String,
    payeeName: json['payeeName'] as String,
    payeePhoneNumber: json['payeePhoneNumber'] as String,
    paymentId: json['paymentId'] as String,
    reasonCode: json['reasonCode'] as String,
    reasonDescription: json['reasonDescription'] as String,
    requestId: json['requestId'] as String,
    returnURL: json['returnURL'] as String,
    totalAmount: (json['totalAmount'] as dynamic),
    transactionDate: json['transactionDate'] as String,
    transactionGateway: json['transactionGateway'] as String,
    transactionId: json['transactionId'] as String,
    transactionSource: json['transactionSource'] as String,
    paymentDescription: json['paymentDescription'] as String,
    paymentMode: json['paymentMode'] as String,
    transactionStatus: json['transactionStatus'] as String,
  );
}

Map<String, dynamic> _$PaymentDetailToJson(PaymentDetail instance) =>
    <String, dynamic>{
      'active': instance.active,
      'comments': instance.comments,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'currency': instance.currency,
      'developerId': instance.developerId,
      'departmentName': instance.departmentName,
      'fxRate': instance.fxRate,
      'merchantId': instance.merchantId,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'orderId': instance.orderId,
      'payeeEmail': instance.payeeEmail,
      'payeeName': instance.payeeName,
      'payeePhoneNumber': instance.payeePhoneNumber,
      'paymentId': instance.paymentId,
      'reasonCode': instance.reasonCode,
      'reasonDescription': instance.reasonDescription,
      'paymentDescription': instance.paymentDescription,
      'paymentMode': instance.paymentMode,
      'requestId': instance.requestId,
      'returnURL': instance.returnURL,
      'totalAmount': instance.totalAmount,
      'transactionDate': instance.transactionDate,
      'transactionGateway': instance.transactionGateway,
      'transactionId': instance.transactionId,
      'transactionSource': instance.transactionSource,
      'transactionStatus': instance.transactionStatus,
    };
