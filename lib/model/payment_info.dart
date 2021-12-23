import 'package:json_annotation/json_annotation.dart';

part 'payment_info.g.dart';

@JsonSerializable()
class PaymentInfo {
  double totalAmount;
  String payeePhoneNumber;
  String payeeName;
  String payeeEmail;
  String paymentSource;
  String requestId;
  String currency;
  String paymentId;
  String transactionStatus;
  String transactionId;
  String paymentDescription;
  String transactionType;

  PaymentInfo({
    this.totalAmount,
    this.payeePhoneNumber,
    this.payeeName,
    this.payeeEmail,
    this.paymentSource,
    this.requestId,
    this.currency,
    this.paymentId,
    this.transactionStatus,
    this.transactionId,
    this.paymentDescription,
    this.transactionType,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> data) =>
      _$PaymentInfoFromJson(data);

  Map<String, dynamic> toJson() => _$PaymentInfoToJson(this);
}
