import '../../../model/non_member_search_request_model.dart';
import '../../../model/people.dart';
import '../../../model/people_response.dart';
import '../../../ui/membership/repo/membership_repo.dart';
import '../../../ui/people_search/bloc/people_search_event.dart';
import '../../../ui/people_search/bloc/people_search_state.dart';
import '../../../ui/people_search/people_search_repository.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FromRepo { Diagnosis, Membership }

class PeopleBloc extends Bloc<PeopleSearchEvent, PeopleSearchState> {
  final DiagnosisRepository diagnosisRepository;
  final MembershipRepository membershipRepository;
  final FromRepo fromRepo;

  PeopleBloc(
      {@required this.diagnosisRepository,
      @required this.membershipRepository,
      @required this.fromRepo});

  @override
  PeopleSearchState get initialState => PeopleSearchState.initial();

  @override
  void onTransition(
      Transition<PeopleSearchEvent, PeopleSearchState> transition) {
    //print(transition.toString());
  }

  @override
  Stream<PeopleSearchState> mapEventToState(PeopleSearchEvent event) async* {
    if (event is GetPeople) {
      yield PeopleSearchState.loading();
      try {
        PeopleResponse response;

        if (fromRepo == FromRepo.Diagnosis) {
          response = await diagnosisRepository.fetchPeopleList();
          yield PeopleSearchState.success(response.peopleResponse);
        } else if (fromRepo == FromRepo.Membership) {
          NonMemberSearchRequestModel model = NonMemberSearchRequestModel();
          model.filterData = [];
          model.entity = "UserMembership";

          response = await membershipRepository.fetchNonMembersList(model);
          if (response != null) removeSupervisorAndSameUser(response);
          yield PeopleSearchState.success(response.peopleResponse);
        }
      } catch (_) {
        debugPrint("error non member list --> $_");
        yield PeopleSearchState.error();
      }
    }
  }

  Future<PeopleResponse> removeSupervisorAndSameUser(
      PeopleResponse response) async {
    List<People> peopleList = [];
    peopleList = List?.from(response?.peopleResponse);
    response?.peopleResponse = List();

    for (int i = 0; i < peopleList?.length; i++) {
      debugPrint("${peopleList[i]}");
      if (peopleList[i]?.userName == AppPreferences().username ||
          peopleList[i]?.roleName == Constants.supervisorRole) {
        peopleList.removeAt(i);
      } else {
        response?.peopleResponse?.add(peopleList[i]);
      }
    }
    return response;
  }
}
