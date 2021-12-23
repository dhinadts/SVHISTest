import '../model/work_force_task_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class WorkForceTaskBloc extends Bloc {
  final workForceTaskFetcher = PublishSubject<List<WorkForceTaskModel>>();

  WorkForceTaskBloc(BuildContext context) : super(context);

  @override
  void init() {}

  getWorkForceTask(List<WorkForceTaskModel> model) async {
    workForceTaskFetcher.sink.add(model);
  }

  @override
  void dispose() {
    workForceTaskFetcher.close();
  }
}
