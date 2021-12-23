part of 'membership_bloc.dart';

class MembershipState {
  final bool isLoading;
  final List<MembershipInfo> membershipList;
  final bool hasError;

  const MembershipState({this.isLoading, this.membershipList, this.hasError});

  factory MembershipState.initial() {
    return MembershipState(
      isLoading: false,
      membershipList: [],
      hasError: false,
    );
  }

  factory MembershipState.loading() {
    return MembershipState(
      isLoading: true,
      membershipList: [],
      hasError: false,
    );
  }

  factory MembershipState.success(List<MembershipInfo> membershipList) {
    return MembershipState(
      isLoading: false,
      membershipList: membershipList,
      hasError: false,
    );
  }

  factory MembershipState.error() {
    return MembershipState(
      isLoading: false,
      membershipList: [],
      hasError: true,
    );
  }

  @override
  String toString() =>
      'MembershipState { isLoading: $isLoading }, { membershipList: $membershipList }, { hasError: $hasError }';
}
