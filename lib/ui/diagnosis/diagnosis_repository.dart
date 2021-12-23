import 'dart:async';
import '../../ui/diagnosis/diagnosis_api_client.dart';
import 'package:meta/meta.dart';

class DiagnosisRepository {
  final DiagnosisApiClient diagnosisApiClient;

  DiagnosisRepository({@required this.diagnosisApiClient})
      : assert(diagnosisApiClient != null);

  Future<dynamic> fetchPeopleList() async {
    return await diagnosisApiClient.fetchPeopleListImp();
  }

  Future<dynamic> addDiagnosisReport({@required Map diagnosisData}) async {
    return await diagnosisApiClient.addDiagnosisReportImp(diagnosisData);
  }

  Future<dynamic> getVitalSignList({String userName}) async {
    return await diagnosisApiClient.getVitalSignsListImp(userName: userName);
  }

  Future<dynamic> getDiagnosisReportList() async {
    return await diagnosisApiClient.getDiagnosisReportList();
  }

  Future<dynamic> fetchDependantsData({String userName}) async {
    return await diagnosisApiClient.fetchDependantsData(userName: userName);
  }
}
