import '../bloc/bloc.dart';
import '../../../model/base_response.dart';
import '../../../ui/b2c/model/matched_request_data_model.dart';
import '../../../ui/b2c/repository/matchedList_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../model/matched_supply_data_model.dart';

class MatchedListBloc extends Bloc {
  final _repositorys = MatchedListRepository();

  final matchedRequestListFetcher =
      PublishSubject<List<MatchedRequestDataModel>>();
  final matchedSupplyListFetcher =
      PublishSubject<List<MatchedSupplyDataModel>>();

  final connectSupplierFetcher = PublishSubject<BaseResponse>();

  MatchedListBloc(BuildContext context) : super(context);

  Stream<List<MatchedRequestDataModel>> get list =>
      matchedRequestListFetcher.stream;
  Stream<List<MatchedSupplyDataModel>> get supplyList =>
      matchedSupplyListFetcher.stream;

  Stream<BaseResponse> get connectSupplierStream =>
      connectSupplierFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchMatchedRequestList() async {
    //  print("Hello Pranay in fetchMatchedRequestList");
    List<MatchedRequestDataModel> response =
        await _repositorys.fetchMatchedRequestList();

    matchedRequestListFetcher.sink.add(response);
  }

  Future<void> fetchMatchedSupplyList() async {
    // print("Hello Pranay in fetchMatchedSupplyList");
    List<MatchedSupplyDataModel> response =
        await _repositorys.fetchMatchedSupplyList();

    matchedSupplyListFetcher.sink.add(response);
  }

  Future<void> connectSupplier(
      num supplierId, num quantity, String critical) async {
    BaseResponse response =
        await _repositorys.connectSupplier(supplierId, quantity, critical);
    connectSupplierFetcher.sink.add(response);
  }

  @override
  void dispose() {
    matchedRequestListFetcher.close();
    connectSupplierFetcher.close();
    matchedSupplyListFetcher.close();
  }
}
