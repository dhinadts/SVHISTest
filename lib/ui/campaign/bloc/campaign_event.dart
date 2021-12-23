import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object> get props => [];
}

class GetCampaignList extends CampaignEvent {
  final String departmentName;
  final String userName;

  const GetCampaignList({this.departmentName, this.userName});

  @override
  List<Object> get props => [departmentName, userName];

  @override
  String toString() => "GetCampaignList";
}

class GetCampaignListSearch extends CampaignEvent {
  final String query;

  const GetCampaignListSearch({@required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => "GetCampaignListSearch";
}
