part of 'campaign_bloc.dart';

class CampaignState {
  final bool isLoading;
  final List<CampaignModel> campaignList;
  final bool hasError;

  const CampaignState({this.isLoading, this.campaignList, this.hasError});

  factory CampaignState.initial() {
    return CampaignState(
      isLoading: false,
      campaignList: [],
      hasError: false,
    );
  }

  factory CampaignState.loading() {
    return CampaignState(
      isLoading: true,
      campaignList: [],
      hasError: false,
    );
  }

  factory CampaignState.success(List<CampaignModel> campaignList) {
    return CampaignState(
      isLoading: false,
      campaignList: campaignList,
      hasError: false,
    );
  }

  factory CampaignState.error() {
    return CampaignState(
      isLoading: false,
      campaignList: [],
      hasError: true,
    );
  }

  @override
  String toString() =>
      'CampaignState { isLoading: $isLoading }, { campaignList: $campaignList }, { hasError: $hasError }';
}
