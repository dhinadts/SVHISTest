import '../../../ui/hierarchical/model/department_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../bloc/bloc.dart';
import '../../../model/base_response.dart';
import '../../../model/user_info.dart';
import '../model/committee_data.dart';
import '../repository/committees_repository.dart';

class CommitteesBloc extends Bloc {
  List<dynamic> committeesList;
  List<String> departmentList;
  List<String> committeeMembersList;
  List<UserInfo> departmentUserList;
  DepartmentModel departmentModel = DepartmentModel();
  CommitteeData committeeData;
  final _repository = CommitteesRepository();
  final committeeMembersListFetcher = PublishSubject<List<String>>();
  final committeesListFetcher = PublishSubject<List<dynamic>>();
  final departmentListFetcher = PublishSubject<List<String>>();
  final departmentUserListFetcher = PublishSubject<List<UserInfo>>();
  final committeeCreateFetcher = PublishSubject<BaseResponse>();
  final addCommitteeTitleFetcher = PublishSubject<BaseResponse>();
  final committeeDataFetcher = PublishSubject<CommitteeData>();

  Stream<BaseResponse> get createStream => committeeCreateFetcher.stream;

  CommitteesBloc(BuildContext context) : super(context);

  @override
  void init() {}

  getCommitteeRoleDefinitionList() async {
    committeeMembersList = await _repository.getCommitteeRoleDefinitionList();
    committeeMembersListFetcher.sink.add(committeeMembersList);
  }

  getCommittee(String committeeName, String departmentName) async {
    committeeData =
        await _repository.getCommitteeData(committeeName, departmentName);
    committeeDataFetcher.sink.add(committeeData);
  }

  getCommitteesList() async {
    committeesList = await _repository.getCommitteesList();
    committeesListFetcher.sink.add(committeesList);
  }

  getDepartmentList() async {
    departmentList = await _repository.getDepartmentList();
    departmentListFetcher.sink.add(departmentList);
  }
  /* getDepartmentbyHierarchy() async {
    departmentList = await _repository.getDepartmentbyHierarchy();
    departmentListFetcher.sink.add(departmentList);
  } */

  getDepartmentUserList(List<String> departmentName) async {
    departmentUserList =
        await _repository.getDepartmentUserList(departmentName);
    departmentUserListFetcher.sink.add(departmentUserList);
  }

  Future<void> createOrUpdateCommittee(
      CommitteeData committeeData, FilePickerResult companyPoliciesFile,
      {bool isUpdate = false}) async {
    BaseResponse response = await _repository.createOrUpdateCommittee(
        committeeData, companyPoliciesFile,
        isUpdate: isUpdate);
    committeeCreateFetcher.sink.add(response);
  }

  Future<void> addCommitteeTitle(Map committeeData) async {
    BaseResponse response = await _repository.addCommitteeTitle(committeeData);
    addCommitteeTitleFetcher.sink.add(response);
  }

  Future<void> deleteCommittee(String committeeName) async {
    BaseResponse response = await _repository.deleteCommittee(committeeName);
  }

  @override
  void dispose() {
    committeesListFetcher.close();
    departmentListFetcher.close();
    departmentUserListFetcher.close();
    committeeCreateFetcher.close();
    committeeMembersListFetcher.close();
    addCommitteeTitleFetcher.close();
    committeeDataFetcher.close();
  }
}
