import '../../../ui/b2c/model/countrywiseHealthcareProviders_model.dart';
import '../../../ui/b2c/model/providersAndSuppliersActiveStatus_model.dart';
import '../../../ui/b2c/model/requestCompleteVsIncomplete_model.dart';
import '../../../ui/b2c/repository/reports_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class ReportsBloc extends Bloc {
  final _repositorys = ReportsRepository();

  final countrywiseHealthcareProvidersListFetcher =
      PublishSubject<List<CountrywiseHealthcareProvidersModel>>();
  //final countrywiseHealthcareProvidersListFetcher = PublishSubject<dynamic>();
  final healthcareProvidersAndSuppliersActiveStatusListFetcher =
      PublishSubject<ProvidersAndSuppliersActiveStatusModel>();
  final requestCompleteVsIncompleteListFetcher =
      PublishSubject<RequestCompleteVsIncompleteModel>();
//  final requestedForPurchaseVsDonationsListFetcher = PublishSubject<RequestedForPurchaseVsDonationsModel>();

  ReportsBloc(BuildContext context) : super(context);

  Stream<List<CountrywiseHealthcareProvidersModel>> get list =>
      countrywiseHealthcareProvidersListFetcher.stream;
  // Stream<CountrywiseHealthcareProvidersModel> get list => countrywiseHealthcareProvidersListFetcher.stream;
  Stream<ProvidersAndSuppliersActiveStatusModel> get list1 =>
      healthcareProvidersAndSuppliersActiveStatusListFetcher.stream;
  Stream<RequestCompleteVsIncompleteModel> get list2 =>
      requestCompleteVsIncompleteListFetcher.stream;
//  Stream<RequestedForPurchaseVsDonationsModel> get list => requestedForPurchaseVsDonationsListFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchCountrywiseHealthcareProvidersList(
      {String reportType, String dateFilter, String userGroup}) async {
    print("Hello Pranay in fetchCountrywiseHealthcareProvidersList");
    List<CountrywiseHealthcareProvidersModel> response =
        await _repositorys.fetchCountrywiseHealthcareProvidersList(
            reportType: reportType,
            dateFilter: dateFilter,
            userGroup: userGroup);

    countrywiseHealthcareProvidersListFetcher.sink.add(response);
  }

  Future<void> fetchProvidersAndSuppliersActiveStatusList(
      {String reportType, String dateFilter, String userGroup}) async {
    print("Hello Pranay in fetchProvidersAndSuppliersActiveStatusList");
    ProvidersAndSuppliersActiveStatusModel response =
        await _repositorys.fetchProvidersAndSuppliersActiveStatusList(
            reportType: reportType,
            dateFilter: dateFilter,
            userGroup: userGroup);

    healthcareProvidersAndSuppliersActiveStatusListFetcher.sink.add(response);
  }

  Future<void> fetchRequestCompleteVsIncompleteList(
      {String reportType, String dateFilter, String userGroup}) async {
    print("Hello Pranay in fetchrequestCompleteVsIncompleteList");
    RequestCompleteVsIncompleteModel response =
        await _repositorys.fetchRequestCompleteVsIncompleteList(
            reportType: reportType,
            dateFilter: dateFilter,
            userGroup: userGroup);

    requestCompleteVsIncompleteListFetcher.sink.add(response);
  }

//  Future<void> fetchSymptomsDynamicById(String userName, String id) async {
//    List<DynamicFieldsResponse> response =
//    await _repository.fetchSymptomsDynamicById(userName, id);
//    //await AppPreferences().init();
//    //symptomListFetcher.sink.add(response);
//  }

  @override
  void dispose() {
    countrywiseHealthcareProvidersListFetcher.close();
    healthcareProvidersAndSuppliersActiveStatusListFetcher.close();
    requestCompleteVsIncompleteListFetcher.close();
    //symptomCreateFetcher.close();
    // dynamicFieldsSymptomsFetcherWithData.close();
  }
}
