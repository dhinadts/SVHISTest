import '../model/base_response.dart';
import '../model/check_in_dynamic.dart';
import '../model/check_in_dynamic_response.dart';
import '../model/dynamic_fields_reponse.dart';
import '../model/people.dart';
import '../model/request_model_group_entity.dart';
import '../repo/check_in_dynamic_repo.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class CheckInBloc extends Bloc {
  dynamic response;

  final _repository = CommonRepository();
  final _repositorys = CheckInDynamicRepository();

  final dynamicFieldsCheckInFetcherWithData =
      PublishSubject<List<DynamicFieldsResponse>>();
  final checkInListFetcher = PublishSubject<dynamic>();
  final expandableControllerFetcher = PublishSubject<dynamic>();
  final checkInCreateFetcher = PublishSubject<BaseResponse>();

  CheckInBloc(BuildContext context) : super(context);

  Stream<CheckInDynamicResponse> get list => checkInListFetcher.stream;

  Stream<BaseResponse> get createStream => checkInCreateFetcher.stream;

  Stream<List<DynamicFieldsResponse>> get dynamicFieldsStream =>
      dynamicFieldsCheckInFetcherWithData.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchCheckInDynamicList(People people) async {
    response = await _repository.fetchCheckInDynamicList(people);
    await AppPreferences().init();
    checkInListFetcher.sink.add(response);
  }

  Future<void> fetchCheckInGroupDynamicList(People people) async {
    RequestModelGroupEntity response =
        await _repository.fetchCheckInGroupEntityDynamicList(people);
    await AppPreferences().init();
    checkInListFetcher.sink.add(response);
  }

  Future<void> fetchCheckInDynamicById(
      String departmentName, String userName, String id) async {
    List<DynamicFieldsResponse> response =
        await _repository.fetchCheckInDynamicById(departmentName, userName, id);
    dynamicFieldsCheckInFetcherWithData.sink.add(response);
  }

  Future<void> setExpandable(dynamic exp) async {
    expandableControllerFetcher.sink.add(exp);
  }

  Future<void> createOrUpdateCheckInDynamic(CheckInDynamic checkIn,
      {bool isUpdate = false}) async {
    BaseResponse response = await _repositorys
        .createOrUpdateCheckInDynamic(checkIn, isUpdate: isUpdate);
    checkInCreateFetcher.sink.add(response);
  }

  @override
  void dispose() {
    checkInListFetcher.close();
    checkInCreateFetcher.close();
    expandableControllerFetcher.close();
    dynamicFieldsCheckInFetcherWithData.close();
  }
}
