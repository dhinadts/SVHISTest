import '../../../model/base_response.dart';
import '../../../ui/payment/model/payment_detail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_detail_response.g.dart';

@JsonSerializable()
class PaymentDetailResponse extends BaseResponse {
  @JsonKey(name: "paymentDetailList")
  List<PaymentDetail> paymentDetailList;

  PaymentDetailResponse();

  factory PaymentDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailResponseToJson(this);
}
