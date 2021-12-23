import '../model/base_response.dart';
import '../model/requested_item_inprocess_model.dart';
import '../model/requested_item_model.dart';
import '../repository/requestedItemsList_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class RequestedItemsListBloc extends Bloc {
  final _repositorys = RequestedItemsListRepository();

  final requestedItemsListFetcher = PublishSubject<List<RequestedItemModel>>();
  final requestedItemsInProcessListFetcher =
      PublishSubject<List<RequestedItemInProcessDataModel>>();
  final requestCreateFetcher = PublishSubject<BaseResponse>();
  final deleteRequestFetcher = PublishSubject<BaseResponse>();
  final completeOrderStatusFetcher = PublishSubject<BaseResponse>();

  RequestedItemsListBloc(BuildContext context) : super(context);

  Stream<List<RequestedItemModel>> get list => requestedItemsListFetcher.stream;
  Stream<List<RequestedItemInProcessDataModel>>
      get requestedItemsInProcessList =>
          requestedItemsInProcessListFetcher.stream;
  Stream<BaseResponse> get createStream => requestCreateFetcher.stream;
  Stream<BaseResponse> get deleteStream => deleteRequestFetcher.stream;
  Stream<BaseResponse> get completeOrderStatusStream =>
      completeOrderStatusFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchRequestedItemsList() async {
    // print("Hello Pranay in fetchRequestedItemsList");
    List<RequestedItemModel> response =
        await _repositorys.fetchRequestedItemsList();

    requestedItemsListFetcher.sink.add(response);
  }

  Future<void> fetchRequestedItemsInProcessList() async {
    //  print("Hello Pranay in fetchRequestedItemsList");
    List<RequestedItemInProcessDataModel> response =
        await _repositorys.fetchRequestedItemsInProcessList();

    requestedItemsInProcessListFetcher.sink.add(response);
  }

  Future<void> createOrUpdateRequest(RequestedItemModel newRequestData,
      {bool isUpdate = false}) async {
    BaseResponse response = await _repositorys
        .createOrUpdateRequest(newRequestData, isUpdate: isUpdate);
    requestCreateFetcher.sink.add(response);
  }

  Future<void> deleteRequest(num itemId) async {
    BaseResponse response = await _repositorys.deleteRequest(itemId);
    deleteRequestFetcher.sink.add(response);
  }

  Future<void> completeOrderStatus(String orderConfirm, num orderId) async {
    BaseResponse response =
        await _repositorys.completeOrderStatus(orderConfirm, orderId);
    completeOrderStatusFetcher.sink.add(response);
  }

  @override
  void dispose() {
    requestedItemsListFetcher.close();
    requestedItemsInProcessListFetcher.close();
    requestCreateFetcher.close();
    deleteRequestFetcher.close();
    completeOrderStatusFetcher.close();
  }
}
