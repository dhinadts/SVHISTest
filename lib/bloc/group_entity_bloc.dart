import '../model/base_response.dart';
import '../repo/dynamic_fields_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class GroupEntityBloc extends Bloc {
  BaseResponse response;

  final _repository = DynamicFieldsRepository();

  final groupEntityFetcher = PublishSubject<BaseResponse>();

  GroupEntityBloc(BuildContext context) : super(context);

  @override
  void init() {}

  createGroupEntity(Map postData) async {
    response = await _repository.postGroupEntity(postData);
    groupEntityFetcher.sink.add(response);
  }

  @override
  void dispose() {
    groupEntityFetcher.close();
  }
}
