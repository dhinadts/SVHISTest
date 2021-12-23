import 'package:replay_kit_launcher/replay_kit_launcher.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';

import '../screen_capture_manager.dart';

/// Private implementation
class ScreenCaptureManagerImplIOS extends ScreenCaptureManager {
  String extensionName;
  String appGroupID;

  @override
  Future<bool> startScreenCapture() async {
    if (this.extensionName == null || this.appGroupID == null) {
      print(
          'On iOS, please `setAppGroup` and `setReplayKitExtensionName` first');
      return false;
    }
    return ReplayKitLauncher.launchReplayKitBroadcast(this.extensionName);
  }

  @override
  Future<bool> stopScreenCapture() async {
    return await ReplayKitLauncher.finishReplayKitBroadcast(
        'ZGFinishBroadcastUploadExtensionProcessNotification');
  }

  @override
  Future<void> setAppGroup(String appGroupID) async {
    this.appGroupID = appGroupID;
    await SharedPreferenceAppGroup.setAppGroup(appGroupID);
  }

  @override
  Future<void> setReplayKitExtensionName(String extensionName) {
    this.extensionName = extensionName;
    return null;
  }

  @override
  Future<void> setParamsForAgoraEngine(String appID, String appToken,
      String channelName, String userFullName, int screenShareUid) async {
    await SharedPreferenceAppGroup.setString('AGORA_APP_ID', appID);
    await SharedPreferenceAppGroup.setString('AGORA_APP_TOKEN', appToken);
    await SharedPreferenceAppGroup.setString('AGORA_CHANNEL_NAME', channelName);
    await SharedPreferenceAppGroup.setString(
        'AGORA_USER_FULLNAME', userFullName);
    await SharedPreferenceAppGroup.setInt(
        'AGORA_SCREENSHARE_UID', screenShareUid);
  }
}
