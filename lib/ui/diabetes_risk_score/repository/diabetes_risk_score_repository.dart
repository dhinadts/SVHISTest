import 'dart:async';

import '../../../ui/diabetes_risk_score/repository/diabetes_risk_score_api_client.dart';
import 'package:meta/meta.dart';

class DiabetesRiskScoreRepository {
  final DiabetesRiskScoreApiClient diabetesRiskScoreApiClient;

  DiabetesRiskScoreRepository({@required this.diabetesRiskScoreApiClient})
      : assert(diabetesRiskScoreApiClient != null);

  Future<dynamic> getHealthScoreHistoryList({String userName}) async {
    return await diabetesRiskScoreApiClient.getHealthScoreHistoryList(
        userName: userName);
  }

  Future<dynamic> getHealthScoreHistoryListForProspects(
      String searchStr) async {
    return await diabetesRiskScoreApiClient
        .getHealthScoreHistoryListForProspects(searchStr);
  }

  Future<dynamic> createHealthScore({@required Map healthScoreDetails}) async {
    return await diabetesRiskScoreApiClient
        .createHealthScore(healthScoreDetails);
  }
}
