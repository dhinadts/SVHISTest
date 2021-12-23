import 'package:equatable/equatable.dart';

abstract class PeopleSearchEvent extends Equatable {
  const PeopleSearchEvent();
  @override
  List<Object> get props => [];
}

class GetPeople extends PeopleSearchEvent {
  const GetPeople();

  @override
  List<Object> get props => [];
}