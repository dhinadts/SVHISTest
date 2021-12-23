import 'package:json_annotation/json_annotation.dart';

part 'razorpay_info.g.dart';

@JsonSerializable()
class RazorpayInfo {
  String paymentId;
  String requestId;
  String orderId;
  double totalAmount;
  String currency;
  String payeeName;
  String payeeEmail;
  String payeePhoneNumber;
  String merchantName;
  String notes;
  String paymentDescription;
  String secretKey;
  String theme;
  bool active;
  String transactionGateway;
  String userName;

  RazorpayInfo({
    this.paymentId,
    this.requestId,
    this.orderId,
    this.totalAmount,
    this.currency,
    this.payeeName,
    this.payeeEmail,
    this.payeePhoneNumber,
    this.merchantName,
    this.notes,
    this.paymentDescription,
    this.secretKey,
    this.theme,
    this.active,
    this.transactionGateway,
    this.userName
  });

  factory RazorpayInfo.fromJson(Map<String, dynamic> data) =>
      _$RazorpayInfoFromJson(data);

  Map<String, dynamic> toJson() => _$RazorpayInfoToJson(this);
}
