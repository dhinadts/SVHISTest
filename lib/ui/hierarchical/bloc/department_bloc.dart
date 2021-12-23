import '../../../bloc/bloc.dart';
import '../../../ui/hierarchical/model/department_model.dart';
import '../../../ui/hierarchical/repo/hierarchical_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DepartmentBloc extends Bloc {
  DepartmentModel response;
  DepartmentModel memberResponse;

  final _repository = HierarchicalRepository();

  final departmentFetcher = PublishSubject<DepartmentModel>();
  final departmentMemberFetcher = PublishSubject<DepartmentModel>();

  DepartmentBloc(BuildContext context) : super(context);

  Stream<DepartmentModel> get list => departmentFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> getDepartment() async {
    departmentFetcher.sink.add(null);
    response = await _repository.getDepartment();
    departmentFetcher.sink.add(response);
  }

  Future<void> getMemberDepartment(String departmentName) async {
    // debugPrint("getMemberDepartment called...");
    departmentMemberFetcher.sink.add(null);
    response = await _repository.getMembersBaseOnDepartment(
        department: departmentName);
    print(response);
    departmentMemberFetcher.sink.add(response);
  }

  @override
  void dispose() {
    departmentFetcher.close();
    departmentMemberFetcher.close();
  }
}
