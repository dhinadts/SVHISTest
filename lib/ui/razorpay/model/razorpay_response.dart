import 'package:json_annotation/json_annotation.dart';

part 'razorpay_response.g.dart';

@JsonSerializable()
class RazorpayResponse {
  String accountId;
  bool active;
  String amountRefunded;
  String attempts;
  String comments;
  String createdBy;
  String createdOn;
  String currency;
  String imageURL;
  String merchantName;
  String modifiedBy;
  String modifiedOn;
  String notes;
  String offerId;
  String orderId;
  String payeeEmail;
  String payeeName;
  String payeePhoneNumber;
  String paymentDescription;
  String paymentId;
  String paymentMode;
  String reasonCode;
  String reasonDescription;
  String refundStatus;
  String requestId;
  String secretKey;
  String signature;
  String theme;
  double totalAmount;
  String transactionDate;
  String transactionGateway;
  String transactionId;
  String transactionSource;
  String transactionStatus;
  String transactionType;
  String userName;

  RazorpayResponse(
      {this.accountId,
      this.active,
      this.amountRefunded,
      this.attempts,
      this.comments,
      this.createdBy,
      this.createdOn,
      this.currency,
      this.imageURL,
      this.merchantName,
      this.modifiedBy,
      this.modifiedOn,
      this.notes,
      this.offerId,
      this.orderId,
      this.payeeEmail,
      this.payeeName,
      this.payeePhoneNumber,
      this.paymentDescription,
      this.paymentId,
      this.paymentMode,
      this.reasonCode,
      this.reasonDescription,
      this.refundStatus,
      this.requestId,
      this.secretKey,
      this.signature,
      this.theme,
      this.totalAmount,
      this.transactionDate,
      this.transactionGateway,
      this.transactionId,
      this.transactionSource,
      this.transactionStatus,
      this.transactionType,
      this.userName});

  factory RazorpayResponse.fromJson(Map<String, dynamic> data) =>
      _$RazorpayResponseFromJson(data);

  Map<String, dynamic> toJson() => _$RazorpayResponseToJson(this);
}
