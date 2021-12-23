import 'dart:async';

import '../../../ui/campaign/model/campaign_model.dart';
import '../../../ui/campaign/repository/campaign_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'campaign_event.dart';

part 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignRepository repository;

  CampaignBloc({@required this.repository}) : assert(repository != null);

  @override
  CampaignState get initialState => CampaignState.initial();

  @override
  Stream<CampaignState> mapEventToState(
    CampaignEvent event,
  ) async* {
    if (event is GetCampaignList) {
      yield* _mapGetCampaignListToState(
          departmentName: event.departmentName, userName: event.userName);
    } else if (event is GetCampaignListSearch) {
      yield* _mapGetCampaignListSearchToState(searchQuery: event.query);
    }
  }

  List<CampaignModel> response;

  Stream<CampaignState> _mapGetCampaignListToState(
      {String departmentName, String userName}) async* {
    yield CampaignState.loading();
    try {
      response = await repository.getCampaignList(
          departmentName: departmentName, userName: userName);
      yield CampaignState.success(response);
    } catch (_) {
      yield CampaignState.error();
    }
  }

  Stream<CampaignState> _mapGetCampaignListSearchToState(
      {String searchQuery}) async* {
    yield CampaignState.loading();
    try {
      if (searchQuery.length == 0) {
        yield CampaignState.success(response);
      } else {
        List<CampaignModel> filteredList = new List();
        for (final campaign in response) {
          //TODO: Need to clarify search option by username or first and last name?
          if (campaign.formName
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
            filteredList.add(campaign);
          }
        }
        yield CampaignState.success(filteredList);
      }
    } catch (_) {
      debugPrint("Exception while searching:  $_");
      yield CampaignState.error();
    }
  }
}
