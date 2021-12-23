import '../api/membership_api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembershipRepository {
  final MembershipApiClient membershipApiClient;

  MembershipRepository({
    @required this.membershipApiClient,
  }) : assert(membershipApiClient != null);

  Future<dynamic> getMembershipTransactionDetails(
      {String requestId, String transactionType}) async {
    return await membershipApiClient.getMembershipTransactionDetails(
        requestId: requestId, transactionType: transactionType);
  }

  Future<http.Response> cashInitiate({
    @required String email,
    @required String phone,
    @required String name,
    @required String total,
    @required String paymentDescription,
  }) async {
    return await membershipApiClient.cashPaymentInitiate(
        email: email,
        name: name,
        phone: phone,
        total: total,
        paymentDescription: paymentDescription);
  }
}
