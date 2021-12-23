import 'dart:io';

import '../../../model/non_member_search_request_model.dart';
import '../../../ui/membership/api/membership_api_client.dart';
import '../../../ui/membership/bloc/membership_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembershipRepository {
  final MembershipApiClient membershipApiClient;

  MembershipRepository({
    @required this.membershipApiClient,
  }) : assert(membershipApiClient != null);

  Future<dynamic> getMembershipPageReferenceData({String clientId}) async {
    return await membershipApiClient.getMembershipPageReferenceData(
        clientId: clientId);
  }

  Future<dynamic> getMembershipFormFields({String clientId}) async {
    return await membershipApiClient.getMembershipFormFields(
        clientId: clientId);
  }

  Future<dynamic> getMembershipList({String departmentName}) async {
    return await membershipApiClient.getMembershipList(
        department: departmentName);
  }

  Future<dynamic> getMembershipHierarchyList({String departmentName}) async {
    return await membershipApiClient.getMembersBaseOnDepartment(
        department: departmentName);
  }

  Future<dynamic> searchMembershipList(
      SEARCH_MEMERSHIP searchBy, String searchStr, bool isApprovedStatus,
      {String departmentName}) async {
    return await membershipApiClient.searchMembershipList(
        searchBy, searchStr, isApprovedStatus,
        departmentName: departmentName);
  }

  Future<dynamic> filterMembershipList(String filterBy,
      {String departmentName}) async {
    return await membershipApiClient.filterMembershipList(filterBy);
  }

  Future<dynamic> getMembershipFormBranches() async {
    return await membershipApiClient.getMembershipFormBranches();
  }

  Future<dynamic> fetchNonMembersList(
      NonMemberSearchRequestModel request) async {
    return await membershipApiClient.fetchNonMembersListImp(request);
  }

  Future<dynamic> getMembershipInfoById(String membershipId) async {
    return await membershipApiClient.getMembershipInfoById(membershipId);
  }

  Future<dynamic> getMembershipInfoByUserName(String userName) async {
    return await membershipApiClient.getMembershipInfoByUserName(userName);
  }

  Future<dynamic> createMembership({
    @required Map membershipData,
    @required File frontImageFile,
    @required File backImageFile,
    @required File addressProofImageFile,
    @required File rnRmImageFile,
    @required File recentImageFile,
  }) async {
    return await membershipApiClient.createMembership(
        membershipData,
        frontImageFile,
        backImageFile,
        addressProofImageFile,
        rnRmImageFile,
        recentImageFile);
  }

  Future<dynamic> updateMembership({
    @required Map membershipData,
    @required String membershipId,
    @required File frontImageFile,
    @required File backImageFile,
    @required File addressProofImageFile,
    @required File rnRmImageFile,
    @required File recentImageFile,
  }) async {
    return await membershipApiClient.updateMembership(
        membershipData,
        membershipId,
        frontImageFile,
        backImageFile,
        addressProofImageFile,
        rnRmImageFile,
        recentImageFile);
  }

  Future<dynamic> getMembershipTransactionDetails(
      {String requestId, String transactionType}) async {
    return await membershipApiClient.getMembershipTransactionDetails(
        requestId: requestId, transactionType: transactionType);
  }

  Future<dynamic> getMembershipTransactionDetailsByRequestId(
      {String requestId, String transactionType}) async {
    return await membershipApiClient.getMembershipTransactionDetailsByRequestId(
        requestId: requestId, transactionType: transactionType);
  }

  Future<http.Response> cashInitiate({
    @required String email,
    @required String phone,
    @required String name,
    @required String total,
    @required String departmentName,
    @required String paymentDescription,
    @required String receiptNo,
  }) async {
    return await membershipApiClient.cashPaymentInitiate(
        email: email,
        name: name,
        phone: phone,
        total: total,
        departmentName: departmentName,
        paymentDescription: paymentDescription,
        receiptNo: receiptNo,
        );
  }
}
