import '../../../model/people.dart';

class PeopleSearchState {
  final bool isLoading;
  final List<People> people;
  final bool hasError;

  const PeopleSearchState({this.isLoading, this.people, this.hasError});

  factory PeopleSearchState.initial() {
    return PeopleSearchState(
      people: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory PeopleSearchState.loading() {
    return PeopleSearchState(
      people: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory PeopleSearchState.success(List<People> people) {
    return PeopleSearchState(
      people: people,
      isLoading: false,
      hasError: false,
    );
  }

  factory PeopleSearchState.error() {
    return PeopleSearchState(
      people: [],
      isLoading: false,
      hasError: true,
    );
  }

  @override
  String toString() =>
      'PeopleSearchState {people: ${people.toString()}, isLoading: $isLoading, hasError: $hasError }';
}
