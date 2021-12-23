//part of 'membership_bloc.dart';
import 'package:equatable/equatable.dart';

enum SEARCH_MEMERSHIP { MembershipId, Name }
enum FILTER_MEMBERSHIP {
  Approved,
  PendingApproval,
  PendingPayment,
  UnderReview,
  Rejected
}

abstract class MembershipEvent extends Equatable {
  const MembershipEvent();

  @override
  List<Object> get props => [];
}

class GetMembershipList extends MembershipEvent {
  final String departmentName;

  const GetMembershipList({this.departmentName});

  @override
  List<Object> get props => [departmentName];

  @override
  String toString() => "GetMembershipList";
}

class GetMembershipHierarchyList extends MembershipEvent {
  final String departmentName;

  const GetMembershipHierarchyList({this.departmentName});

  @override
  List<Object> get props => [departmentName];

  @override
  String toString() => "GetMembershipList";
}

class GetMembershipListBySearch extends MembershipEvent {
  final String searchStr;
  final String departmentName;
  final SEARCH_MEMERSHIP searchBy;
  final bool isApprovedStatus;

  GetMembershipListBySearch(
      this.searchStr, this.searchBy, this.isApprovedStatus,
      {this.departmentName});

  @override
  List<Object> get props =>
      [searchStr, searchBy, isApprovedStatus, departmentName];

  @override
  String toString() =>
      "GetMembershipListBySearch, searchStr: $searchStr, searchBy: $searchBy, isApprovedStatus: $isApprovedStatus , departmentName: $departmentName ";
}

class GetMembershipListByFilter extends MembershipEvent {
  final String filterBy;
  final String departmentName;

  GetMembershipListByFilter(this.filterBy, {this.departmentName});

  @override
  List<Object> get props => [filterBy, departmentName];

  @override
  String toString() =>
      "GetMembershipListByFilter, filterBy: $filterBy , departmentName: $departmentName ";
}
