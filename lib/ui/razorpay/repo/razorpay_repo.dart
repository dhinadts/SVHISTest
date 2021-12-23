import '../../../ui/razorpay/repo/razorpay_api_client.dart';
import 'package:flutter/material.dart';

class RazorpayRepository {
  final RazorpayApiClient razorpayApiClient;

  RazorpayRepository({
    @required this.razorpayApiClient,
  }) : assert(razorpayApiClient != null);

  Future<dynamic> createRazorpayOrder(
      {@required double amount,
      @required String currency,
      @required String customerName,
      @required String email,
      @required String phone,
      @required String departmentName,
      @required String requestId,
      @required String userName}) async {
    return await razorpayApiClient.createRazorpayOrder(
        amount: amount,
        currency: currency,
        customerName: customerName,
        email: email,
        phone: phone,
        departmentName: departmentName,
        requestId: requestId,
        userName: userName);
  }

  Future<dynamic> updateRazorpayOrder(
      Map<String, dynamic> orderInfo, String paymentId) async {
    return await razorpayApiClient.updateRazorpayOrder(
        orderInfo: orderInfo, oldPaymentId: paymentId);
  }

  Future<dynamic> getRazorpayDetailsByRequestId(String requestId) async {
    return await razorpayApiClient.getRazorpayDetailsByRequestId(requestId);
  }
}
