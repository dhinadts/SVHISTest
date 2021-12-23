import '../model/base_response.dart';
import '../model/dynamic_fields_reponse.dart';
import '../repo/dynamic_fields_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class DynamicFieldsBloc extends Bloc {
  List<DynamicFieldsResponse> response;

  final _repository = DynamicFieldsRepository();

  final dynamicFieldsCheckInFetcher =
      PublishSubject<List<DynamicFieldsResponse>>();
  final dynamicFieldsHistoryFetcher =
      PublishSubject<List<DynamicFieldsResponse>>();

  final dynamicFieldPostFetcher = PublishSubject<BaseResponse>();

  DynamicFieldsBloc(BuildContext context) : super(context);

  Stream<List<DynamicFieldsResponse>> get dynamicFieldsStreamCheckIn =>
      dynamicFieldsCheckInFetcher.stream;

  Stream<List<DynamicFieldsResponse>> get dynamicFieldsStreamHistory =>
      dynamicFieldsHistoryFetcher.stream;

  @override
  void init() {}

  Future<void> fetchDynamicFieldsCheckIn(
      {String departmentName, String username}) async {
    response = await _repository.getDynamicFieldWithFieldCategory("CHECK_IN",
        departmentName: departmentName, username: username);
    dynamicFieldsCheckInFetcher.sink.add(response);
  }

  Future<void> postDynamicFieldCheckInData(Map map,
      {bool isUpdate: false}) async {
    BaseResponse response =
        await _repository.postDynamicFieldCheckInData(map, isUpdate);
    dynamicFieldPostFetcher.sink.add(response);
  }

  Future<void> postDynamicFieldCheckInHistoryData(Map map,
      {bool isUpdate: false}) async {
    BaseResponse response =
        await _repository.postDynamicFieldHistoryData(map, isUpdate);
    dynamicFieldPostFetcher.sink.add(response);
  }

  Future<void> fetchDynamicFieldHistoryData(String id) async {
    List<DynamicFieldsResponse> response =
        await _repository.fetchDynamicFieldCheckInData(id);
    dynamicFieldsHistoryFetcher.sink.add(response);
  }

  Future<void> fetchDynamicFieldsHistory() async {
    response = await _repository.getDynamicFieldWithFieldCategory("HISTORY");
    dynamicFieldsHistoryFetcher.sink.add(response);
  }

  @override
  void dispose() {
    dynamicFieldsCheckInFetcher.close();
    dynamicFieldsHistoryFetcher.close();
    dynamicFieldPostFetcher.close();
  }
}
