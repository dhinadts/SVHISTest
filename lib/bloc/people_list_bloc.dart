import '../model/non_member_search_request_model.dart';
import '../model/people.dart';
import '../model/people_response.dart';
import '../model/user_search_request_model.dart';
import '../repo/common_repository.dart';
import '../repo/search_repository.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class PeopleListBloc extends Bloc {
  PeopleResponse response;

  final _repository = CommonRepository();
  final _searchRepository = SearchRepository();

  final peopleListFetcher = PublishSubject<PeopleResponse>();

  PeopleListBloc(BuildContext context) : super(context);

  Stream<PeopleResponse> get list => peopleListFetcher.stream;

  @override
  void init() {}
  List<People> peopleList = [];
  bool isAllPagesLoaded;

  Future<PeopleResponse> fetchPeopleList(
      {String searchUsernameString,
      bool onlyPrimary: false,
      bool isFromDiabetesRiskScore: false,
      String departmentName: '',
      String membershipType: "",
      String tempMembershipStatus = '',
      String membershipEntitlements = ''}) async {
    peopleListFetcher.sink.add(null);
    if (searchUsernameString == null) {
      peopleListFetcher.sink.add(null);
    }
    UserSearchRequestModel model = UserSearchRequestModel();
    model.filterData = [];
    model.entity = "User";
    if (searchUsernameString != null &&
        searchUsernameString.trim().isNotEmpty) {
      model.filterData.add(FilterData(
          columnName: "userFullName",
          columnType: "STRING",
          columnValue: ['%$searchUsernameString%'],
          filterType: Constants.LIKE_OPERATOR));
    }

    if (onlyPrimary)
      model.filterData.add(FilterData(
          columnName: "userRelation",
          columnType: "STRING",
          columnValue: ["PRIMARY"],
          filterType: Constants.EQUAL_OPERATOR));

    if (membershipType.isNotEmpty) {
      model.filterData.add(FilterData(
          columnName: "membershipType",
          columnType: "STRING",
          columnValue: [membershipType],
          filterType: Constants.EQUAL_OPERATOR));
    }
    /* model.filterData.add(FilterData(
        columnName: "departmentName",
        columnType: "STRING",
        columnValue: ['$departmentName'],
        filterType: Constants.EQUAL_OPERATOR)); */

    if (isFromDiabetesRiskScore) {
      model.filterData.add(FilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: ['$departmentName'],
          filterType: Constants.EQUAL_OPERATOR));
      model.filterData.add(
        FilterData(
            columnName: "hasMembership",
            columnType: "BOOLEAN",
            columnValue: ["true"],
            filterType: "EQUAL"),
      );
      model.filterData.add(FilterData(
          columnName: "roleName",
          columnType: "STRING",
          columnValue: ['User'],
          filterType: "EQUAL"));
      if (membershipEntitlements != null ||
          membershipEntitlements != "" ||
          membershipEntitlements.isNotEmpty) {
        model.filterData.add(FilterData(
            columnName: "membershipStatus",
            columnType: "STRING",
            columnValue: ['$membershipEntitlements'],
            filterType: Constants.EQUAL_OPERATOR));
      }
      if (tempMembershipStatus != null ||
          tempMembershipStatus != "" ||
          tempMembershipStatus.isNotEmpty) {
        model.filterData.add(FilterData(
            columnName: "tempMembershipStatus",
            columnType: "STRING",
            columnValue: ['$tempMembershipStatus'],
            filterType: Constants.EQUAL_OPERATOR));
      }
    }

    response = await _searchRepository.dynamicSearch(
        model,
        isFromDiabetesRiskScore,
        departmentName,
        membershipEntitlements,
        tempMembershipStatus);
    await removeSupervisorAndSameUser();

    peopleListFetcher.sink.add(response);
    return response;
  }

  Future<void> fetchNonMembershipList({String searchUsernameString}) async {
    if (searchUsernameString == null) {
      peopleListFetcher.sink.add(null);
    }
    NonMemberSearchRequestModel model = NonMemberSearchRequestModel();
    model.filterData = [];
    model.entity = "UserMembership";
    if (searchUsernameString != null &&
        searchUsernameString.trim().isNotEmpty) {
      model.filterData.add(NonMemberFilterData(
          columnName: "userFullName",
          columnType: "STRING",
          columnValue: ['%$searchUsernameString%'],
          filterType: Constants.LIKE_OPERATOR));
    }

    model.filterData.add(NonMemberFilterData(
        columnName: "roleName",
        columnType: "STRING",
        columnValue: ['User'],
        filterType: Constants.EQUAL_OPERATOR));

    model.filterData.add(
      NonMemberFilterData(
          columnName: "hasMembership",
          columnType: "BOOLEAN",
          columnValue: ["false"],
          filterType: "EQUAL"),
    );

    response = await _searchRepository.dynamicMembershipSearch(model, true);
    await removeSupervisorAndSameUser();
    peopleListFetcher.sink.add(response);
  }

  removeSupervisorAndSameUser() async {
    if (peopleList.length > 0) {
      peopleList = List?.from(response?.peopleResponse);
      response?.peopleResponse = List();

      for (int i = 0; i < peopleList?.length; i++) {
        if (peopleList[i]?.userName == AppPreferences().username ||
            peopleList[i]?.roleName == Constants.supervisorRole) {
          // print("People List : $i ${peopleList[i].toJson()}");
          peopleList.removeAt(i);
        } else {
          response?.peopleResponse?.add(peopleList[i]);
        }
      }
      //print("peopleList length ${response?.peopleResponse?.length}\n ");
    }
  }

  Future<void> fetchSecondaryUserList(
      {String parentUserName,
      String departmentName,
      bool isFromAddUserFamily: false}) async {
    peopleListFetcher.sink.add(null);
    response = await _repository.fetchSecondaryUserList(
        parentUserName, departmentName, isFromAddUserFamily);
    peopleListFetcher.sink.add(response);
  }

  @override
  void dispose() {
    peopleListFetcher.close();
  }

  /// Global search api
  Future<PeopleResponse> fetchPeopleListGlobal({
    String searchUsernameString,
    bool onlyPrimary: false,
    bool isFromDiabetesRiskScore: false,
    String departmentName: '',
    String membershipType: "",
    String tempMembershipStatus = '',
    String membershipEntitlements = '',
  }) async {
    peopleListFetcher.sink.add(null);
    if (searchUsernameString == null) {
      peopleListFetcher.sink.add(null);
    }
    UserSearchRequestModel model = UserSearchRequestModel();
    model.filterData = [];
    model.entity = "User";
    if (searchUsernameString != null &&
        searchUsernameString.trim().isNotEmpty) {
      model.filterData.add(FilterData(
          columnName: "userFullName",
          columnType: "STRING",
          columnValue: ['%$searchUsernameString%'],
          filterType: Constants.LIKE_OPERATOR));
    }

    if (onlyPrimary)
      model.filterData.add(FilterData(
          columnName: "userRelation",
          columnType: "STRING",
          columnValue: ["PRIMARY"],
          filterType: Constants.EQUAL_OPERATOR));

    if (membershipType.isNotEmpty) {
      model.filterData.add(FilterData(
          columnName: "membershipType",
          columnType: "STRING",
          columnValue: [membershipType],
          filterType: Constants.EQUAL_OPERATOR));
    }

    if (isFromDiabetesRiskScore) {
      model.filterData.add(FilterData(
          columnName: "departmentName",
          columnType: "STRING",
          columnValue: ['$departmentName'],
          filterType: Constants.EQUAL_OPERATOR));
      model.filterData.add(
        FilterData(
            columnName: "hasMembership",
            columnType: "BOOLEAN",
            columnValue: ["true"],
            filterType: "EQUAL"),
      );
      model.filterData.add(FilterData(
          columnName: "roleName",
          columnType: "STRING",
          columnValue: ['User'],
          filterType: "EQUAL"));
      if (membershipEntitlements != null ||
          membershipEntitlements != "" ||
          membershipEntitlements.isNotEmpty) {
        model.filterData.add(FilterData(
            columnName: "membershipStatus",
            columnType: "STRING",
            columnValue: ['$membershipEntitlements'],
            filterType: Constants.EQUAL_OPERATOR));
      }
      if (tempMembershipStatus != null ||
          tempMembershipStatus != "" ||
          tempMembershipStatus.isNotEmpty) {
        model.filterData.add(FilterData(
            columnName: "tempMembershipStatus",
            columnType: "STRING",
            columnValue: ['$tempMembershipStatus'],
            filterType: Constants.EQUAL_OPERATOR));
      }
    }

    response = await _searchRepository.dynamicGlobalSearch(
      model,
      isFromDiabetesRiskScore,
      departmentName,
      membershipEntitlements,
      tempMembershipStatus,
    );
    await removeSupervisorAndSameUser();

    peopleListFetcher.sink.add(response);
    return response;
  }
}
