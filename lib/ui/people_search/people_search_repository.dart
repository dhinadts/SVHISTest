import 'dart:async';

import '../../ui/people_search/people_search_api_client.dart';
import 'package:meta/meta.dart';

class DiagnosisRepository {
  final PeopleSearchApiClient peopleSearchApiClient;

  DiagnosisRepository({@required this.peopleSearchApiClient})
      : assert(peopleSearchApiClient != null);

  Future<dynamic> fetchPeopleList() async {
    return await peopleSearchApiClient.fetchPeopleListImp();
  }
}
