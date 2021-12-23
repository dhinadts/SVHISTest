import '../../../bloc/bloc.dart';
import '../../../ui/payment/model/payment_detail.dart';
import '../../../ui/payment/model/payment_detail_response.dart';
import '../../../ui/payment/repo/payment_repository.dart';
import '../../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PaymentBloc extends Bloc {
  PaymentDetailResponse response;

  final _repository = PaymentRepository();

  final paymentFetcher = PublishSubject<PaymentDetailResponse>();
  final countFetcher = PublishSubject<int>();

  PaymentBloc(BuildContext context) : super(context);

  Stream<PaymentDetailResponse> get list => paymentFetcher.stream;

  Stream<int> get count => countFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> getPaymentHistory() async {
    response = await _repository.getPayment();
    // print("Response Length Before >>> ${response.paymentDetailList.length}");
    if (response != null) {
      await removeSupervisorAndSameUser();
    }
    // print("Response Length After >>> ${response.paymentDetailList.length}");
    paymentFetcher.sink.add(response);
    countFetcher.sink.add(response.paymentDetailList.length);
  }

  Future<PaymentDetailResponse> removeSupervisorAndSameUser() async {
    List<PaymentDetail> paymentList = [];
    paymentList = List?.from(response?.paymentDetailList);
    response?.paymentDetailList = List();

    for (int i = 0; i < paymentList?.length; i++) {
      if (ValidationUtils.validStringOrNot(paymentList[i].transactionStatus)) {
      } else {
        response?.paymentDetailList?.add(paymentList[i]);
      }
    }
    return response;
  }

  removeUndefinedTransactionStatusRecords() {
    List<PaymentDetail> paymentList = [];
    paymentList = List?.from(response?.paymentDetailList);
    response?.paymentDetailList = List();
    for (int i = 0; i < paymentList.length; i++) {
      if (paymentList[i].transactionStatus != null &&
          paymentList[i].transactionStatus.isNotEmpty) {}
    }
  }

  @override
  void dispose() {
    paymentFetcher.close();
    countFetcher.close();
  }
}
