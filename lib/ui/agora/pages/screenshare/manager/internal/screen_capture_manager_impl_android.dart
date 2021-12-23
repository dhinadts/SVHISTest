import 'package:flutter/services.dart';

import '../screen_capture_manager.dart';

/// Private implementation
class ScreenCaptureManagerImplAndroid extends ScreenCaptureManager {
  static const platform =
      const MethodChannel('flutter.native/screen_share_helper');

  String appId;
  String appToken;
  String channelName;
  String userFullName;
  int screenShareUid;

  @override
  Future<void> setParamsForAgoraEngine(String appID, String appToken,
      String channelName, String userFullName, int screenShareUid) async {
    this.appId = appID;
    this.appToken = appToken;
    this.channelName = channelName;
    this.userFullName = userFullName;
    this.screenShareUid = screenShareUid;
    return null;
  }

  @override
  Future<bool> startScreenCapture() async {
    await platform.invokeMethod('createMediaProjection', {
      'appId': this.appId,
      'appToken': this.appToken,
      'channelName': this.channelName,
      'userFullName': this.userFullName,
      'screenShareUid': this.screenShareUid,
    });
    return true;
  }

  @override
  Future<bool> stopScreenCapture() async {
    await platform.invokeMethod('destroyMediaProjection', {});
    return true;
  }
}
