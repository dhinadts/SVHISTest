import '../../../ui/campaign/api/campaign_api_client.dart';
import 'package:flutter/material.dart';

class CampaignRepository {
  final CampaignApiClient campaignApiClient;

  CampaignRepository({
    @required this.campaignApiClient,
  }) : assert(campaignApiClient != null);

  Future<dynamic> getCampaignList(
      {String departmentName, String userName}) async {
    return await campaignApiClient.getCampaignList(
        department: departmentName, userName: userName);
  }
}
