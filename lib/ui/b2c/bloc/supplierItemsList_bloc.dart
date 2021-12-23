import '../model/base_response.dart';
import '../model/supplier_item_inprocess_model.dart';
import '../model/supplier_item_model.dart';
import '../repository/supplierItemsList_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class SupplierItemsListBloc extends Bloc {
  final _repositorys = SupplierItemsListRepository();

  final supplierItemsListFetcher = PublishSubject<List<SupplierItemModel>>();
  final supplierItemsInProcessListFetcher =
      PublishSubject<List<SupplierItemInProcessDataModel>>();
  final supplyCreateFetcher = PublishSubject<BaseResponse>();
  final deleteSupplyFetcher = PublishSubject<BaseResponse>();
  final acceptRejectOrderFetcher = PublishSubject<BaseResponse>();

  SupplierItemsListBloc(BuildContext context) : super(context);

  Stream<List<SupplierItemModel>> get list => supplierItemsListFetcher.stream;
  Stream<List<SupplierItemInProcessDataModel>> get supplierItemsInProcessList =>
      supplierItemsInProcessListFetcher.stream;
  Stream<BaseResponse> get createStream => supplyCreateFetcher.stream;
  Stream<BaseResponse> get deleteStream => deleteSupplyFetcher.stream;
  Stream<BaseResponse> get acceptRejectStream =>
      acceptRejectOrderFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchSupplierItemsList() async {
    print("Hello Pranay in fetchSupplierItemsList");
    List<SupplierItemModel> response =
        await _repositorys.fetchSupplierItemsList();

    supplierItemsListFetcher.sink.add(response);
  }

  Future<void> fetchSupplierItemsInProcessList() async {
    print("Hello Pranay in fetchSupplierItemsInProcessList");
    List<SupplierItemInProcessDataModel> response =
        await _repositorys.fetchSupplierItemsInProcessList();

    supplierItemsInProcessListFetcher.sink.add(response);
  }

  Future<void> createOrUpdateSupply(SupplierItemModel newSupplyData,
      {bool isUpdate = false}) async {
    BaseResponse response = await _repositorys
        .createOrUpdateSupply(newSupplyData, isUpdate: isUpdate);
    supplyCreateFetcher.sink.add(response);
  }

  Future<void> deleteSupply(num itemId) async {
    BaseResponse response = await _repositorys.deleteSupply(itemId);
    deleteSupplyFetcher.sink.add(response);
  }

  Future<void> acceptRejectOrder(
      String orderConfirm, num itemId, String comment) async {
    BaseResponse response =
        await _repositorys.acceptRejectOrder(orderConfirm, itemId, comment);
    acceptRejectOrderFetcher.sink.add(response);
  }

  @override
  void dispose() {
    supplierItemsListFetcher.close();
    supplierItemsInProcessListFetcher.close();
    supplyCreateFetcher.close();
    deleteSupplyFetcher.close();
    acceptRejectOrderFetcher.close();
  }
}
