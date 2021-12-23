import 'package:json_annotation/json_annotation.dart';

part 'payment_detail.g.dart';

@JsonSerializable()
class PaymentDetail {
  bool active;
  String comments;
  String createdBy;
  String createdOn;
  String currency;
  String developerId;
  String departmentName;
  int fxRate;
  String merchantId;
  String modifiedBy;
  String modifiedOn;
  String orderId;
  String payeeEmail;
  String payeeName;
  String payeePhoneNumber;
  String paymentId;
  String reasonCode;
  String reasonDescription;
  String paymentDescription;
  String paymentMode;
  String requestId;
  String returnURL;
  dynamic totalAmount;
  String transactionDate;
  String transactionGateway;
  String transactionId;
  String transactionSource;
  String transactionStatus;

  PaymentDetail(
      {this.active,
      this.comments,
      this.createdBy,
      this.createdOn,
      this.currency,
      this.developerId,
      this.departmentName,
      this.fxRate,
      this.merchantId,
      this.modifiedBy,
      this.modifiedOn,
      this.orderId,
      this.payeeEmail,
      this.payeeName,
      this.payeePhoneNumber,
      this.paymentId,
      this.reasonCode,
      this.reasonDescription,
      this.requestId,
      this.returnURL,
      this.totalAmount,
      this.transactionDate,
      this.transactionGateway,
      this.transactionId,
      this.transactionSource,
      this.paymentDescription,
      this.paymentMode,
      this.transactionStatus});

  factory PaymentDetail.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailToJson(this);
}
