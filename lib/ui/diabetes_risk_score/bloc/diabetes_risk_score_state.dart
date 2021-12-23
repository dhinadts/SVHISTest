import '../../../ui/diabetes_risk_score/model/health_score.dart';

class DiabetesRiskScoreState {
  final bool isLoading;
  final List<HealthScore> healthScoreList;
  final bool hasError;

  const DiabetesRiskScoreState({
    this.isLoading,
    this.healthScoreList,
    this.hasError,
  });

  factory DiabetesRiskScoreState.initial() {
    return DiabetesRiskScoreState(
      isLoading: false,
      healthScoreList: [],
      hasError: false,
    );
  }

  factory DiabetesRiskScoreState.loading() {
    return DiabetesRiskScoreState(
      isLoading: true,
      healthScoreList: [],
      hasError: false,
    );
  }

  factory DiabetesRiskScoreState.success(List<HealthScore> healthScoreList) {
    return DiabetesRiskScoreState(
      isLoading: false,
      healthScoreList: healthScoreList,
      hasError: false,
    );
  }

  factory DiabetesRiskScoreState.error() {
    return DiabetesRiskScoreState(
      isLoading: false,
      healthScoreList: [],
      hasError: true,
    );
  }
}
