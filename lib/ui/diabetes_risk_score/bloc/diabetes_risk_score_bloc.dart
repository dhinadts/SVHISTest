import '../../../ui/diabetes_risk_score/bloc/diabetes_risk_score_event.dart';
import '../../../ui/diabetes_risk_score/bloc/diabetes_risk_score_state.dart';
import '../../../ui/diabetes_risk_score/repository/diabetes_risk_score_api_client.dart';
import '../../../ui/diabetes_risk_score/repository/diabetes_risk_score_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class DiabetesRiskScoreBloc
    extends Bloc<DiabetesRiskScoreEvent, DiabetesRiskScoreState> {
  final DiabetesRiskScoreRepository repository = DiabetesRiskScoreRepository(
    diabetesRiskScoreApiClient: DiabetesRiskScoreApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  DiabetesRiskScoreState get initialState => DiabetesRiskScoreState.initial();

  @override
  Stream<DiabetesRiskScoreState> mapEventToState(
      DiabetesRiskScoreEvent event) async* {
    if (event is GetHealthScoreHistoryList) {
      yield DiabetesRiskScoreState.loading();
      try {
        dynamic response = await repository.getHealthScoreHistoryList(
            userName: event.userName);
        yield DiabetesRiskScoreState.success(response);
      } catch (e) {
        yield DiabetesRiskScoreState.error();
      }
    } else if (event is GetHealthScoreHistoryListForProspects) {
      yield DiabetesRiskScoreState.loading();
      try {
        dynamic response = await repository
            .getHealthScoreHistoryListForProspects(event.searchUser);
        yield DiabetesRiskScoreState.success(response);
      } catch (e) {
        yield DiabetesRiskScoreState.error();
      }
    }
  }
}
