import '../model/base_response.dart';
import '../model/dynamic_fields_reponse.dart';
import '../repo/common_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class HistoryBloc extends Bloc {
  final _repository = CommonRepository();

  final createFetcher = PublishSubject<BaseResponse>();

  final dynamicFieldsHistoryFetcherWithData =
      PublishSubject<List<DynamicFieldsResponse>>();

  HistoryBloc(BuildContext context) : super(context);

  Stream<BaseResponse> get resp => createFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchHistoryDynamicList(
      {@required String username, @required String dept}) async {
    List<DynamicFieldsResponse> response =
        await _repository.fetchHistoryDynamicList(username, dept);
    dynamicFieldsHistoryFetcherWithData.sink.add(response);
  }

  @override
  void dispose() {
    dynamicFieldsHistoryFetcherWithData.close();
    createFetcher.close();
  }
}
