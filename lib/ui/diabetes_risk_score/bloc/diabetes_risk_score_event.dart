import 'package:equatable/equatable.dart';

abstract class DiabetesRiskScoreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetHealthScoreHistoryList extends DiabetesRiskScoreEvent {
  final String userName;

  GetHealthScoreHistoryList(this.userName);

  @override
  List<Object> get props => [userName];
}

class GetHealthScoreHistoryListForProspects extends DiabetesRiskScoreEvent {
  final String searchUser;

  GetHealthScoreHistoryListForProspects(this.searchUser);

  @override
  List<Object> get props => [searchUser];
}
