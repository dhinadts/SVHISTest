import 'dart:async';

import '../../../ui/membership/model/membership_info.dart';
import '../../../ui/membership/repo/membership_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'membership_event.dart';

//part 'membership_event.dart';
part 'membership_state.dart';

class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  final MembershipRepository repository;

  MembershipBloc({@required this.repository}) : assert(repository != null);

  @override
  MembershipState get initialState => MembershipState.initial();

  @override
  void onTransition(Transition<MembershipEvent, MembershipState> transition) {
    //print(transition.toString());
  }

  @override
  Stream<MembershipState> mapEventToState(
    MembershipEvent event,
  ) async* {
    if (event is GetMembershipList) {
      yield* _mapGetMembershipListToState(departmentName: event.departmentName);
    } else if (event is GetMembershipListBySearch) {
      yield* _mapGetMembershipListBySearchToState(
          searchStr: event.searchStr,
          searchBy: event.searchBy,
          isApprovedStatus: event.isApprovedStatus,
          departmentName: event.departmentName);
    } else if (event is GetMembershipListByFilter) {
      yield* _mapGetMembershipListByFilterToState(filterBy: event.filterBy);
    } else if (event is GetMembershipHierarchyList) {
      yield* _mapGetMembershipHierarchyListToState(
          departmentName: event.departmentName);
    }
  }

  Stream<MembershipState> _mapGetMembershipListToState(
      {String departmentName}) async* {
    yield MembershipState.loading();
    try {
      dynamic response =
          await repository.getMembershipList(departmentName: departmentName);
      yield MembershipState.success(response);
    } catch (_) {
      yield MembershipState.error();
    }
  }

  Stream<MembershipState> _mapGetMembershipHierarchyListToState(
      {String departmentName}) async* {
    yield MembershipState.loading();
    try {
      dynamic response = await repository.getMembershipHierarchyList(
          departmentName: departmentName);
      yield MembershipState.success(response);
    } catch (_) {
      yield MembershipState.error();
    }
  }

  Stream<MembershipState> _mapGetMembershipListBySearchToState(
      {@required SEARCH_MEMERSHIP searchBy,
      @required String searchStr,
      @required bool isApprovedStatus,
      String departmentName}) async* {
    yield MembershipState.loading();
    try {
      dynamic response = await repository.searchMembershipList(
          searchBy, searchStr, isApprovedStatus,
          departmentName: departmentName);
      yield MembershipState.success(response);
    } catch (_) {
      yield MembershipState.error();
    }
  }

  Stream<MembershipState> _mapGetMembershipListByFilterToState(
      {@required String filterBy, String departmentName}) async* {
    yield MembershipState.loading();
    try {
      dynamic response = await repository.filterMembershipList(filterBy);
      yield MembershipState.success(response);
    } catch (_) {
      yield MembershipState.error();
    }
  }
}
