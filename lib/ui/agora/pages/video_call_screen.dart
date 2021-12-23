import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import '../../../ui/agora/repository/modelAppointment.dart';
import '../../../ui/campaign/campaign_inappwebview_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../ui/agora/repository/modelAppointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../ui/agora/pages/annotate/annotate_model.dart';
import '../../../ui/agora/pages/chat_screen.dart';
import '../../../ui/agora/pages/participants_screen.dart';
import '../../../ui/agora/pages/screenshare/manager/screen_capture_manager.dart';
import '../../../ui/agora/pages/screenshare/screen_share_receiver_screen.dart';
import '../../../ui/agora/pages/screenshare/screenshare_message_widget.dart';
import '../../../ui/agora/pages/snapshot_preview_screen.dart';
import '../../../ui/agora/repository/recordingRepository.dart';
import '../../../ui/agora/utils/utils.dart';
import '../../../ui/booking_appointment/models/appointment.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/text_styles.dart';
import '../../../utils/app_preferences.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../../../model/user_info.dart' as MemberlyUserInfo;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:native_screenshot/native_screenshot.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:wakelock/wakelock.dart';

import 'annotate/draw_screen.dart';

const int SCREEN_SHARE_UID_MIN = 501;
const int SCREEN_SHARE_UID_MAX = 1000;

enum SessionRole { doctor, patient }

enum SessionEvent { join, update, leave }

class VideoCallScreen extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role;
  final String token;

  final SessionRole sessionRole;
  final Appointment appointment;
  final bool isLaunch;
  final String referenceId;
  const VideoCallScreen(
      {Key key,
      this.channelName,
      this.role,
      this.token,
      this.sessionRole,
      this.appointment,
      @required this.isLaunch,
      this.referenceId})
      : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  RtcEngine _engine;
  bool _joined = false;
  int selfUid, largeViewUid;

  bool audioMuted = false;
  bool videoMuted = false;
  bool cameraFront = true;
  bool showToolBar = true;
  bool showBottomVideoView = true;

  List<int> userUidList = List<int>();
  List<String> userAccountList = List<String>();
  List<int> userAudioMutedList = List<int>();
  List<int> userVideoMutedList = List<int>();

  Widget largePreView;
  String userFullName;

  List<MessageBubble> messageBubbles = [];
  List<Map<String, String>> annotations = [];

  final messageStream = StreamController<List<MessageBubble>>.broadcast();
  final annotateStream =
      StreamController<List<Map<String, String>>>.broadcast();

// To send chat message
  int rtcDataStreamId;
  bool isChatScreenOpened = false;
  int newMessageCount = 0;

  // To enable snapshot icon
  bool isAdminRole = false;
  bool enableSnapshot = false;

  // To enable invitee icon
  bool enableInviteeIcon = true;

  ScreenCaptureManager manager = ScreenCaptureManagerFactory.createManager();
  // To check screenshare
  bool isYourScreenShared = false;
  bool isRemoteScreenShared = false;
  bool isScreenSharePageOpened = false;
  int screenShareUid;

  String agoraAppId;

  // Screen shared user info
  int remoteScreenShareUid;
  String remoteScreenShareUserName;

  // To show ongoing call
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool otherShared = false;

  /// Recording
  bool isRecording = false;
  RecordingRepository _repository;
  String _timeString;
  static const duration = const Duration(seconds: 1);
  int secondsPassed = 0;
  bool isActive = false;
  Timer timer;
  int seconds = 00, minutes = 00, hours = 00;

  ModelAppointment selectedAppointment;
  var _inviteLink = "";
  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    showCustomLoader(
        msg: 'connecting . . .',
        easyLoadingIndicatorType: EasyLoadingIndicatorType.wave);
    initPlatformState();

    // Need to set app group ID and broadcast upload extension name first
    manager.setAppGroup('group.com.servicedx.datt');
    manager.setReplayKitExtensionName('DATT');

    /// Recording Code
    _repository = RecordingRepository();
    // _timeString = _formatDateTime(DateTime.now());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _repository
        .getInviteLink(
      widget.appointment.departmentName,
      widget.appointment.patientName,
      widget.appointment.bookingId,
    )
        .then((value) {
      setCollectionDataForCallStatus();
      setState(() {
        _inviteLink = value;
      });
    });

    checkPermission();
  }

  Future checkPermission() async {
    PermissionHandler permissionHandler = PermissionHandler();
    PermissionStatus permissionStatus =
        await permissionHandler.checkPermissionStatus(PermissionGroup.storage);
    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus = (await permissionHandler.requestPermissions(
          [PermissionGroup.storage]))[PermissionGroup.storage];
      if (permissionStatus == PermissionStatus.denied ||
          (Platform.isAndroid
              ? permissionStatus == PermissionStatus.neverAskAgain
              : permissionStatus == PermissionStatus.restricted)) {
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Allow storage access',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              content: Text(
                'Storage access is required to use files download',
                style: TextStyle(color: Colors.black54),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    return Future.value(true);
                  },
                  child: Text('Cancel'),
                ),
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await permissionHandler.openAppSettings();
                    return Future.value(true);
                  },
                  child: Text('Go to settings'),
                ),
              ],
            );
          },
        );
//                              Navigator.pop(context);
        return Future.value(true);
      } else {
        // scanQrCode();
        return Future.value(false);
      }
    } else {
      // scanQrCode();
      return Future.value(false);
    }
  }

  @override
  void dispose() {
    // clear users
    userUidList.clear();
    userAccountList.clear();
    userAudioMutedList.clear();
    userVideoMutedList.clear();

    // To disable the screen awake
    Wakelock.disable();
    if (Platform.isAndroid) _clearOnGoingCallNotification();

    messageStream.close();
    annotateStream.close();

    _engine.leaveChannel();
    _engine.destroy();
    timer.cancel();
    timer = null;
    super.dispose();
  }

  // Initialize the app
  Future<void> initPlatformState() async {
    userFullName = await getUserFullNameWithRole();
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );

    await _initAgoraRtcEngine();
    // Define event handling
    _agoraEventHandler();
    _agoraJoinChannelWithUserAccount();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    agoraAppId = await AppPreferences.getAgoraAppId();
    debugPrint("appId --> $agoraAppId");
    debugPrint("token --> ${widget.token}");
    debugPrint("channelName --> ${widget.channelName}");
    // Create RTC client instance
    _engine = await RtcEngine.create(agoraAppId);

    //VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    //configuration.dimensions = VideoDimensions(1920, 1080);
    //configuration.orientationMode = VideoOutputOrientationMode.FixedPortrait;
    //await _engine.setVideoEncoderConfiguration(configuration);

    // Enable video
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    //await _engine.joinChannel(widget.token, widget.channelName, null, 0);
    // await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // WatermarkOptions watermarkOptions = WatermarkOptions(
    //     Rectangle(200, 100, 250, 80), Rectangle(200, 100, 250, 80),
    //     visibleInPreview: true);
    // await _engine.addVideoWatermark(
    //     'assets/images/memberly_logo.png', watermarkOptions);
    //await _engine.setClientRole(widget.role);

    rtcDataStreamId = await _engine.createDataStream(true, true);
  }

  Future<String> getUserFullNameWithRole() async {
    MemberlyUserInfo.UserInfo userInfo = await AppPreferences.getUserInfo();
    String firstName = userInfo.firstName ?? "";
    String lastName = userInfo.lastName ?? "";

    String role = userInfo.userCategory ?? "";
    if (role.toLowerCase() == "doctor" || role.toLowerCase() == "consultant") {
      isAdminRole = true;
    }

    if (role.isEmpty) {
      role = "Consultant";
    } else {
      role = role.toLowerCase().inCaps;
    }
    return '$firstName $lastName'.capitalizeFirstofEach + ', $role';
  }

  _agoraJoinChannelWithUserAccount() async {
    debugPrint("userFullName --> $userFullName");
    // String token =
    //     "0062a068eda257e410db89d78e649544cd0IAC8f/DoAV4PlPThLdvc55BlT5Lgv4YybaiFy3e+DVfsAAZq8ykAAAAAIgCruxlFF1dbYAQAAQAXV1tgAgAXV1tgAwAXV1tgBAAXV1tg";
    await _engine.joinChannelWithUserAccount(
        widget.token, widget.channelName, userFullName);
  }

  _isScreenShareUid(int uid) {
    return uid >= SCREEN_SHARE_UID_MIN && uid <= SCREEN_SHARE_UID_MAX;
  }

  int notificationId;
  _showOnGoingCallNotification() async {
    notificationId = 10 + Random().nextInt(10000 - 10);

    String title = widget.appointment.bookingId;
    String body = "Ongoing video call";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId',
      'ChannelNameMemberly',
      'Memberly Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      tag: "on-going-call",
      usesChronometer: true,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        notificationId, title, body, platformChannelSpecifics);
  }

  _clearOnGoingCallNotification() async {
    await flutterLocalNotificationsPlugin.cancel(notificationId,
        tag: "on-going-call");
  }

  _agoraEventHandler() {
    _engine.setEventHandler(
      RtcEngineEventHandler(error: (ErrorCode errorCode) {
        debugPrint('errorCode --> $errorCode');
      }, joinChannelSuccess: (String channel, int uid, int elapsed) {
        debugPrint('joinChannelSuccess --> $channel, $uid');
        setState(() {
          _joined = true;
          if (Platform.isAndroid) _showOnGoingCallNotification();
          // To keep the screen awake
          Wakelock.enable();

          selfUid = uid;
          largePreView = _renderLargePreview(uid);
          dismissCustomLoader();
        });
      }, leaveChannel: (stats) {
        debugPrint("leaveChannel stats --> ${stats.toJson()}");
        setState(() {
          // To disable the screen awake
          Wakelock.disable();

          if (Platform.isAndroid) _clearOnGoingCallNotification();

          userUidList.clear();
          userAccountList.clear();
          userAudioMutedList.clear();
          userVideoMutedList.clear();
        });
      }, userJoined: (int uid, int elapsed) {
        debugPrint('userJoined --> $uid');

        // Check the screenshare source, if it is not you then navigate to ScreenShareReceiverScreen
        if (_isScreenShareUid(uid)) {
          debugPrint("_isScreenShareUid --> $uid");
          if (screenShareUid != null && screenShareUid == uid) {
            debugPrint("Your screen is shared");
            setState(() {
              isYourScreenShared = !isYourScreenShared;
            });
          }
          // else {21
          //   showBarModalBottomSheet(
          //     context: context,
          //     builder: (BuildContext context) => ScreenShareReceiverScreen(
          //       uid: uid,
          //       remoteUserName: 'Test',
          //     ),
          //   );
          // }
        } else {
          setState(() {
            // Switch selfview from large to small
            if (userUidList.length == 0) {
              userUidList.add(selfUid);
              largePreView = _renderLargePreview(uid);
              largeViewUid = uid;
            } else {
              userUidList.add(uid);
            }
          });

          userAccountList.forEach((element) {
            if (element.contains(uid.toString())) {
              String userAccountStr = element.split('~')[1];
              displaySnackBar(context, SessionEvent.join, uid, userAccountStr);
            }
          });
        }
      }, userInfoUpdated: (int uid, UserInfo userInfo) {
        debugPrint("userInfoUpdated --> $uid, ${userInfo.userAccount}");
        String userAccountStr = "${uid.toString()}~${userInfo.userAccount}";
        setState(() {
          userAccountList.add(userAccountStr);
        });
        displaySnackBar(
            context, SessionEvent.update, uid, userInfo.userAccount);
      }, userOffline: (int uid, UserOfflineReason reason) {
        debugPrint('userOffline --> $uid, $reason');

        // Check the screenshare source, if it is not you then navigate to ScreenShareReceiverScreen
        if (_isScreenShareUid(uid)) {
          if (screenShareUid != null && screenShareUid == uid) {
            debugPrint("Your screen is stoped");
            screenShareUid = null;
            setState(() {
              isYourScreenShared = !isYourScreenShared;
            });
          } else {
            setState(() {
              isRemoteScreenShared = false;
              otherShared = false;
            });
            remoteScreenShareUid = null;
            remoteScreenShareUserName = null;

            if (isScreenSharePageOpened) {
              Navigator.pop(context);
            }
          }
        } else {
          setState(() {
            if (reason == UserOfflineReason.Quit) {
              final indexUid = userUidList.indexOf(uid);
              debugPrint("indexUid --> $indexUid");
              // if the userid found from the list
              if (indexUid != -1) {
                userUidList.removeAt(indexUid);
                if (userUidList.isEmpty) {
                  largePreView = _renderLargePreview(selfUid);
                  largeViewUid = selfUid;
                }
              } else {
                if (userUidList.isNotEmpty) {
                  // If only selfview presents in the userUidList
                  if (userUidList.length == 1 && userUidList[0] == selfUid) {
                    largePreView = _renderLargePreview(userUidList[0]);
                    largeViewUid = userUidList[0];
                    userUidList.clear();
                  } else {
                    // If useruidlist[0] is not selfuid
                    if (userUidList[0] != selfUid) {
                      largePreView = _renderLargePreview(userUidList[0]);
                      largeViewUid = userUidList[0];
                      userUidList.removeAt(0);
                    } else if (userUidList.length > 1) {
                      largePreView = _renderLargePreview(userUidList[1]);
                      largeViewUid = userUidList[1];
                      userUidList.removeAt(1);
                    }
                  }
                }
              }

              //Remove audio and video mute
              if (userAudioMutedList.contains(uid)) {
                userAudioMutedList.remove(uid);
              }
              if (userVideoMutedList.contains(uid)) {
                userVideoMutedList.remove(uid);
              }

              userAccountList.forEach((element) {
                if (element.contains(uid.toString())) {
                  String userAccountStr = element.split('~')[1];
                  displaySnackBar(
                      context, SessionEvent.leave, uid, userAccountStr);
                }
              });
            }
          });
          // To show the snapshot button
          snapshotBtn(largeViewUid);
        }
      }, userMuteAudio: (int uid, bool mute) {
        debugPrint('userMuteAudio --> $uid, $mute');
        setState(() {
          if (mute) {
            if (!userAudioMutedList.contains(uid)) {
              userAudioMutedList.add(uid);
            }
          } else {
            if (userAudioMutedList.contains(uid)) {
              userAudioMutedList.remove(uid);
            }
          }

          if (largeViewUid == uid) {
            largePreView = _renderLargePreview(uid);
          }
        });
      }, userMuteVideo: (int uid, bool mute) {
        debugPrint('userMuteVideo --> $uid, $mute');
        setState(() {
          if (mute) {
            if (!userVideoMutedList.contains(uid)) {
              userVideoMutedList.add(uid);
            }
          } else {
            if (userVideoMutedList.contains(uid)) {
              userVideoMutedList.remove(uid);
            }
          }
          if (largeViewUid == uid) {
            largePreView = _renderLargePreview(uid);
          }
        });
      }, remoteVideoStateChanged: (int uid, VideoRemoteState state,
          VideoRemoteStateReason reason, int ellapsed) {
        debugPrint('remoteVideoStateChanged --> $uid, $state, $reason');
      }, remoteAudioStateChanged: (int uid, AudioRemoteState state,
          AudioRemoteStateReason reason, int ellapsed) {
        debugPrint('remoteAudioStateChanged --> $uid, $state, $reason');
      }, streamMessage: (int uid, int streamId, String message) {
        //debugPrint('streamMessage --> $uid, $streamId');
        final messageData = json.decode(message);
        final eventName = messageData["event"];

        debugPrint('streamMessage --> $uid, $streamId, $eventName');
        final data = messageData["data"];
        if (uid != screenShareUid) {
          switch (eventName) {
            case "screen_share":
              debugPrint("userFullName --> ${data['userFullName']}");
              debugPrint("uid --> ${data['uid']}");
              debugPrint("status --> ${data['status']}");
              setState(() {
                otherShared = true;
              });
              if (screenShareUid != null && screenShareUid == uid) {
                debugPrint("${data['userFullName']}'s screen is shared");
              } else {
                debugPrint("${data['userFullName']}'s screen is shared");
                _navigateToScreenShareReceiverScreen(
                    uid: data['uid'], userFullName: data['userFullName']);
              }

              break;
            case "chat":
              if (!isChatScreenOpened) {
                setState(() {
                  newMessageCount++;
                });
              }

              String userAccountStr = "";
              userAccountList.forEach((element) {
                if (element.contains(uid.toString())) {
                  userAccountStr = element.split('~')[1];
                  userAccountStr = userAccountStr.split(',')[0];
                }
              });

              final messageBubble = MessageBubble(
                sender: userAccountStr,
                text: data['message'],
                isMe: false,
              );
              messageBubbles.add(messageBubble);
              messageStream.sink.add(messageBubbles);
              break;
            case "annotate":
              if (uid != selfUid) {
                if (data['action'] == "open") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Draw(
                        annotateMode: AnnotateMode.receive,
                        engine: _engine,
                        annotateCallback:
                            (List<Map<String, String>> annotations) {},
                        annotates: [],
                        rtcDataStreamId: rtcDataStreamId,
                        annotateStream: annotateStream,
                      ),
                    ),
                  );
                } else if (data['action'] == "close") {
                  Navigator.pop(context);
                } else if (data['action'] == "draw") {
                  // List<dynamic> sample = data['offset'];
                  // List<Map<String, double>> sampleData = [];
                  // sample.forEach((element) {
                  //   Map<String, double> newvar = element;
                  //   sampleData.add({"dx": newvar["dx"], "dy": newvar["dy"]});
                  //   debugPrint("element --> $element");
                  // });
                  // debugPrint("sampleData --> $sampleData");
                  //
                  //
                  debugPrint("annotateModel before -->");
                  AnnotateModel annotateModel =
                      AnnotateModel.fromJson(messageData);
                  debugPrint("annotateModel data --> ${annotateModel.data}");
                  debugPrint(
                      "offset.length --> ${annotateModel.data.offset.length}");

                  List<Map<String, String>> sampleData = [];
                  annotateModel.data.offset.forEach((element) {
                    debugPrint("element receive --> ${element.toJson()}");
                    sampleData.add({
                      "dx": element.dx.toString(),
                      "dy": element.dy.toString()
                    });
                  });
                  debugPrint("sampleData.length --> ${sampleData.length}");
                  annotations.addAll(sampleData);
                  annotateStream.sink.add(sampleData);
                }
              } else {
                debugPrint("annotate uid --> $uid, selfUid --> $selfUid");
              }

              break;
            default:
              break;
          }
        }
      }, streamMessageError:
          (int uid, int streamId, ErrorCode errorCode, int missed, int cached) {
        debugPrint(
            'streamMessageError --> $uid, $streamId, $errorCode, $missed, $cached');
      }),
    );
  }

  _navigateToScreenShareReceiverScreen(
      {@required int uid, @required String userFullName}) async {
    remoteScreenShareUid = uid;
    remoteScreenShareUserName = userFullName;

    showCustomLoader(
        msg: "$userFullName\n has started screen sharing",
        easyLoadingIndicatorType: EasyLoadingIndicatorType.fadingCircle);

    Future.delayed(const Duration(milliseconds: 2000), () async {
      dismissCustomLoader();
      setState(() {
        isRemoteScreenShared = true;
      });
      _navigateToScreenShareReceiverScreenWithoutLoader(
          uid: uid, userFullName: userFullName);
    });
  }

  _navigateToScreenShareReceiverScreenWithoutLoader(
      {@required int uid, @required String userFullName}) async {
    isScreenSharePageOpened = true;
    final screenSharePageResult = await showBarModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ScreenShareReceiverScreen(
        uid: uid,
        remoteUserName: userFullName,
      ),
    );
    debugPrint("screenSharePageResult --> $screenSharePageResult");
    if (screenSharePageResult == null) {
      setState(() {
        isScreenSharePageOpened = false;
      });
    }
  }

  _onToggleAudioMute() {
    setState(() {
      audioMuted = !audioMuted;
    });
    _engine.muteLocalAudioStream(audioMuted);
  }

  _onToggleVideoMute() {
    setState(() {
      videoMuted = !videoMuted;
      _engine.muteLocalVideoStream(videoMuted);
      // For a video call, the default audio route is the speaker. If the user disables the video using RtcEngine.disableVideo, or RtcEngine.muteLocalVideoStream and RtcEngine.muteAllRemoteVideoStreams, the default audio route automatically switches back to the earpiece
      _engine.setDefaultAudioRoutetoSpeakerphone(true);
      if (selfUid == largeViewUid || largeViewUid == null) {
        largePreView = _renderLargePreview(selfUid);
      }
    });
  }

  _onSwitchCamera() {
    setState(() {
      cameraFront = !cameraFront;
    });
    _engine.switchCamera();
  }

  _onTakeSnapShot() {
    // Hide all the toolbar and bottom video view
    setState(() {
      showToolBar = false;
      showBottomVideoView = false;
      Future.delayed(const Duration(milliseconds: 100), () async {
        String path = await NativeScreenshot.takeScreenshot();
        if (path != null) {
          File file = File(path);
          debugPrint("path --> $path");
          setState(() {
            showToolBar = true;
            showBottomVideoView = true;
          });

          final result = await showCupertinoModalBottomSheet(
            expand: true,
            enableDrag: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => SnapshotPreviewScreen(
              imageFile: file,
            ),
          );
          if (result == null) {
            final isFileExist = await file.exists();
            if (isFileExist) {
              file.deleteSync();
            }
          }
        } else {
          Fluttertoast.showToast(
              msg: "Snapshot is not supported",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              gravity: ToastGravity.TOP);
        }
      });
    });
  }

  _onInviteeParticipants() {
    // Share.share("Sample Invite URL");
    Share.share(_inviteLink);
  }

  snapshotBtn(int uid) {
    // To enable the snapshot button comment the below code
    // int patientUid;
    // userAccountList.forEach((element) {
    //   if (element.toLowerCase().contains('patient')) {
    //     patientUid = int.parse(element.split('~')[0]);
    //   }
    // });

    // debugPrint("--> patientUid - $patientUid,  uid - $uid");
    // setState(() {
    //   if (patientUid != null &&
    //       patientUid == uid &&
    //       !userVideoMutedList.contains(patientUid)) {
    //     enableSnapshot = true;
    //   } else {
    //     enableSnapshot = false;
    //   }
    // });
  }

  displaySnackBar(
      BuildContext context, SessionEvent event, int uid, String userAccount) {
    // To show the snapshot button
    snapshotBtn(uid);
    String message = "";
    if (event == SessionEvent.join || event == SessionEvent.update) {
      message = "$userAccount joined the session";
    } else {
      message = "$userAccount left the session";
    }

    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> startScreenCapture() async {
    // final CollectionReference userCollection =
    //     Firestore.instance.collection('Agoracall');
    // var snapshot =
    //     await userCollection.document(widget.appointment.bookingId).get();
    // print("COLLECTION: ${snapshot.exists}  Data: ${snapshot.data}");
    // if (snapshot.exists) {
    //   if (snapshot.data['isSharing']) {
    //     Fluttertoast.showToast(
    //         msg: "ScreenSharing is already activated by other person");
    //     return;
    //   }
    // }

    // screenShareUid = SCREEN_SHARE_UID_MIN +
    //     Random().nextInt(SCREEN_SHARE_UID_MAX - SCREEN_SHARE_UID_MIN);

    // await manager.setParamsForAgoraEngine(agoraAppId, widget.token,
    //     widget.channelName, userFullName, screenShareUid);

    // // Start screen capture
    // await manager.startScreenCapture();

    // if (snapshot.exists) {
    //   updateCollectionData(widget.appointment, 'isSharing', true);
    // } else {
    //   setCollectionData(widget.appointment, true, false);
    // }

    // return;

    /// webservice call for checking Screen Share availability
    selectedAppointment = await _repository.getAppointment(
      widget.appointment.departmentName,
      widget.appointment.patientName,
      widget.appointment.bookingId,
    );

    if (selectedAppointment != null &&
        (selectedAppointment.isScreensharing == null ||
            !selectedAppointment.isScreensharing)) {
      screenShareUid = SCREEN_SHARE_UID_MIN +
          Random().nextInt(SCREEN_SHARE_UID_MAX - SCREEN_SHARE_UID_MIN);

      await manager.setParamsForAgoraEngine(agoraAppId, widget.token,
          widget.channelName, userFullName, screenShareUid);

      // Start screen capture
      await manager.startScreenCapture();

      selectedAppointment.isScreensharing = true;
      await _repository.updateAppointment(
        widget.appointment.bookingId,
        widget.appointment.departmentName,
        widget.appointment.patientName,
        selectedAppointment,
      );

      final CollectionReference userCollection =
          Firestore.instance.collection('Agoracall');
      print("COLLECTION: ${userCollection.id}");

      /*userCollection.document(selectedAppointment.bookingId).add({
        'email': userInfo.emailId,
        'token': userCredential.user.uid,
        'user_type': userType,
        'username': userInfo.userName
      });*/
    } else {
      Fluttertoast.showToast(msg: "Screen Share is in progress");
    }

    ///
  }

  void stopScreenCapture() async {
    if (Platform.isIOS) {
      await manager.startScreenCapture();
    } else {
      await manager.stopScreenCapture();
    }

    selectedAppointment.isScreensharing = false;
    await _repository.updateAppointment(
      widget.appointment.bookingId,
      widget.appointment.departmentName,
      widget.appointment.patientName,
      selectedAppointment,
    );

    // setCollectionData(widget.appointment, false, false);
    updateCollectionData(widget.appointment, 'isSharing', false);
  }

  void shareNotAllowed() {
    Fluttertoast.showToast(
        msg: "Share screen already in progress", gravity: ToastGravity.TOP);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sessionEndAlert(context, onPositivePress: () {
          //update disconnect call in firestore
          updateCollectionDataForCallStatus();
          //check if recording was going on and user leave the session , update the API

          if (selectedAppointment != null) {
            if (selectedAppointment.isRecording == true) {
              stopRecording();
              Future.delayed(const Duration(milliseconds: 500), () async {
                stopScreenCapture();

                Navigator.pop(context);
                Navigator.pop(context);
                return Future.value(true);
              });
            }
            stopScreenCapture();
            Navigator.pop(context);
            Navigator.pop(context);
            return Future.value(true);
          } else {
            stopScreenCapture();
            Navigator.pop(context);
            Navigator.pop(context);
            return Future.value(true);
          }
        }, onNegativePress: () {
          Navigator.pop(context);
          return Future.value(false);
        });
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          onTap: () {
            setState(() {
              showToolBar = !showToolBar;
            });
          },
          child: Stack(
            children: [
              Center(
                child: largePreView,
              ),
              if (showBottomVideoView)
                Positioned(
                  bottom: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: List.of(userUidList.map((e) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                largePreView = _renderLargePreview(e);
                                final indexUid = userUidList.indexOf(e);
                                if (indexUid != -1) {
                                  userUidList.removeAt(indexUid);
                                }
                                userUidList.add(
                                  largeViewUid,
                                );
                                largeViewUid = e;
                              });
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 100,
                                      height: 120,
                                      child: e == selfUid
                                          ? videoMuted
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Container(
                                                    width: 100,
                                                    height: 120,
                                                    color: Colors.grey[500],
                                                    child: Center(
                                                      child:
                                                          _renderSmallVideoAvatarText(
                                                              e),
                                                    ),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: RtcLocalView
                                                      .SurfaceView())
                                          : userVideoMutedList.contains(e)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Container(
                                                    width: 100,
                                                    height: 120,
                                                    color: Colors.grey[500],
                                                    child: Center(
                                                      child:
                                                          _renderSmallVideoAvatarText(
                                                              e),
                                                    ),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child:
                                                      RtcRemoteView.SurfaceView(
                                                    uid: e,
                                                  ),
                                                ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0.0,
                                    right: 0.0,
                                    left: 0.0,
                                    child: _smallVideoToolbar(e)),
                              ],
                            ),
                          );
                        })),
                      ),
                    ),
                  ),
                ),
              if (showToolBar)
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).padding.top,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_joined)
                          Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () async {
                              //     isChatScreenOpened = true;
                              //     setState(() {
                              //       newMessageCount = 0;
                              //     });
                              //     if (rtcDataStreamId == null) {
                              //       rtcDataStreamId = await _engine
                              //           .createDataStream(true, true);
                              //     }
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (BuildContext context) => Draw(
                              //           annotateMode: AnnotateMode.send,
                              //           engine: _engine,
                              //           annotateCallback:
                              //               (List<Map<String, String>>
                              //                   annotations) {
                              //             annotations.addAll(annotations);
                              //             //annotateStream.sink.add(annotations);
                              //           },
                              //           annotates: annotations,
                              //           rtcDataStreamId: rtcDataStreamId,
                              //           annotateStream: annotateStream,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   child: Container(
                              //     height: 30,
                              //     padding: EdgeInsets.symmetric(horizontal: 15),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(5),
                              //       ),
                              //       color: Colors.white,
                              //     ),
                              //     child: Center(
                              //       child: Icon(
                              //         Icons.open_in_browser,
                              //         color: Colors.blueAccent,
                              //         size: 22,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(width: 10),
                              widget.referenceId.isNotEmpty
                                  ? GestureDetector(
                                      child: Container(
                                        height: 30,
                                        // padding:
                                        //     EdgeInsets.symmetric(horizontal: 15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Image.asset(
                                            "assets/images/feedback.png",
                                            height: 25),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CampaignInAppWebViewScreen(
                                                      userName: widget
                                                          .appointment
                                                          .patientName,
                                                      departmentName: widget
                                                          .appointment
                                                          .departmentName,
                                                      referenceID: widget
                                                          .referenceId,
                                                      enableFeedback: true,
                                                    )));
                                      })
                                  : Container(),
                              SizedBox(width: 10),
                              //  widget.isLaunch ?
                              GestureDetector(
                                onTap: () {
                                  if (isRecording) {
                                    stopRecording();
                                  } else {
                                    startRecording();
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                      child: isRecording
                                          ? Icon(
                                              Icons.adjust,
                                              color: Colors.red,
                                              size: 22,
                                            )
                                          : Icon(
                                              Icons.adjust,
                                              color: Colors.blueAccent,
                                              size: 22,
                                            )),
                                ),
                              ),
                              //    : Container(),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  if (otherShared) {
                                    shareNotAllowed();
                                  } else {
                                    if (isYourScreenShared) {
                                      stopScreenCapture();
                                    } else {
                                      startScreenCapture();
                                    }
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                      child: otherShared
                                          ? Icon(
                                              Icons.stop_screen_share,
                                              color: Colors.grey,
                                              size: 22,
                                            )
                                          : isYourScreenShared
                                              ? Icon(
                                                  Icons.stop_screen_share,
                                                  color: Colors.red,
                                                  size: 22,
                                                )
                                              : Icon(
                                                  Icons.screen_share,
                                                  color: Colors.blueAccent,
                                                  size: 22,
                                                )),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  isChatScreenOpened = true;
                                  setState(() {
                                    newMessageCount = 0;
                                  });
                                  if (rtcDataStreamId == null) {
                                    rtcDataStreamId = await _engine
                                        .createDataStream(true, true);
                                  }
                                  final result =
                                      await showCupertinoModalBottomSheet(
                                    expand: true,
                                    enableDrag: false,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => ChatScreen(
                                      engine: _engine,
                                      messageBubbleCallback:
                                          (MessageBubble messageBubble) {
                                        messageBubbles.add(messageBubble);
                                        messageStream.sink.add(messageBubbles);
                                      },
                                      userFullName: userFullName.split(',')[0],
                                      messageBubbles: messageBubbles,
                                      messageStream: messageStream,
                                      rtcDataStreamId: rtcDataStreamId,
                                    ),
                                  );
                                  debugPrint("result --> $result");
                                  if (result == null) {
                                    isChatScreenOpened = false;
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: newMessageCount > 0
                                        ? Badge(
                                            position: BadgePosition.topEnd(
                                                top: -12, end: -12),
                                            animationType:
                                                BadgeAnimationType.fade,
                                            badgeContent: Text(
                                              newMessageCount.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            child: Icon(
                                              Icons.chat,
                                              color: Colors.blueAccent,
                                              size: 22,
                                            ),
                                          )
                                        : Icon(
                                            Icons.chat,
                                            color: Colors.blueAccent,
                                            size: 22,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  List<int> participants = List<int>();
                                  participants.add(selfUid);

                                  // To add largeViewId
                                  if (selfUid != largeViewUid &&
                                      userUidList.isNotEmpty) {
                                    participants.add(largeViewUid);
                                  }

                                  for (var userId in userUidList) {
                                    if (userId != selfUid &&
                                        userId != largeViewUid) {
                                      participants.add(userId);
                                    }
                                  }

                                  List<String> participantsUserNames =
                                      List<String>();
                                  String userFullNameStr =
                                      userFullName.split(',')[0];
                                  participantsUserNames.add(userFullNameStr);
                                  if (selfUid != largeViewUid &&
                                      userUidList.isNotEmpty) {
                                    String userName =
                                        getUserAccountName(largeViewUid);
                                    participantsUserNames.add((userName));
                                  }

                                  for (var userId in userUidList) {
                                    userAccountList.forEach((element) {
                                      if (element.contains(userId.toString())) {
                                        String userAccountStr =
                                            element.split('~')[1];
                                        participantsUserNames
                                            .add(userAccountStr);
                                      }
                                    });
                                  }

                                  List<int> participantsAudioMutedList =
                                      List<int>();
                                  if (audioMuted) {
                                    participantsAudioMutedList.add(selfUid);
                                  }
                                  participantsAudioMutedList
                                      .addAll(userAudioMutedList);

                                  List<int> participantsVideoMutedList =
                                      List<int>();
                                  if (videoMuted) {
                                    participantsVideoMutedList.add(selfUid);
                                  }
                                  participantsVideoMutedList
                                      .addAll(userVideoMutedList);

                                  showCupertinoModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => ParticipantsScreen(
                                      participantsList: participants,
                                      participantsUserNameList:
                                          participantsUserNames,
                                      participantsAudioMutedList:
                                          participantsAudioMutedList,
                                      participantsVideoMutedList:
                                          participantsVideoMutedList,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.people,
                                        color: Colors.blueAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            sessionEndAlert(context, onPositivePress: () {
                              //update disconnect call in firestore
                              updateCollectionDataForCallStatus();
                              //check if recording was going on and user leave the session , update the API
                              if (selectedAppointment != null) {
                                if (selectedAppointment.isRecording == true) {
                                  stopRecording();
                                  Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () async {
                                    if (isYourScreenShared) {
                                      stopScreenCapture();
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  if (isYourScreenShared) {
                                    stopScreenCapture();
                                  }
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              } else {
                                if (isYourScreenShared) {
                                  stopScreenCapture();
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            }, onNegativePress: () {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                'Leave',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (showToolBar)
                Positioned(
                  top: AppBar().preferredSize.height + 30.0,
                  left: 0,
                  right: 0,
                  child: largeVideoUserName(),
                ),
              Positioned(
                right: 0,
                bottom: 140,
                child: Column(
                  children: [
                    if (isAdminRole && enableSnapshot && showToolBar)
                      RawMaterialButton(
                        onPressed: _onTakeSnapShot,
                        child: Icon(
                          Icons.center_focus_weak,
                          color: Colors.blueAccent,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    // if (_joined && showToolBar && enableInviteeIcon)
                    //   RawMaterialButton(
                    //     onPressed: _onInviteeParticipants,
                    //     child: Icon(
                    //       Icons.person_add_alt,
                    //       color: Colors.blueAccent,
                    //     ),
                    //     shape: CircleBorder(),
                    //     elevation: 2.0,
                    //     fillColor: Colors.white,
                    //     padding: const EdgeInsets.all(8.0),
                    //   ),
                  ],
                ),
              ),
              if (isRemoteScreenShared && !isScreenSharePageOpened)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ScreenShareMessageWidget(
                    icon: Icons.screen_share,
                    color: Colors.redAccent,
                    uid: remoteScreenShareUid,
                    name: remoteScreenShareUserName,
                    iconTapped: () {
                      _navigateToScreenShareReceiverScreenWithoutLoader(
                          uid: remoteScreenShareUid,
                          userFullName: remoteScreenShareUserName);
                    },
                  ),
                ),
              isRecording
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: AppColors.transparentBg,
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: Text(
                          "REC  ${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.red),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  // Generate large preview
  Widget _renderLargePreview(int uid) {
    // To show the snapshot button
    snapshotBtn(uid);

    if (uid == selfUid) {
      return videoMuted
          ? _renderLargeVideoMute(uid)
          : RtcLocalView.SurfaceView();
    } else {
      return userVideoMutedList.contains(uid)
          ? _renderLargeVideoMute(uid)
          : RtcRemoteView.SurfaceView(
              uid: uid,
            );
    }
  }

  Widget _renderLargeVideoMute(int uid) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: _renderLargeVideoAvatarText(uid),
          ),
        ],
      ),
    );
  }

  Widget _renderLargeVideoAvatarText(int uid) {
    String userAccountName = (uid == selfUid)
        ? userFullName.split(',')[0]
        : getUserAccountName(uid).split(',')[0];

    return Stack(
      children: [
        Container(
          child: AvatarLetter(
            size: 120,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 28,
            upperCase: true,
            numberLetters: 2,
            letterType: LetterType.Circular,
            text: userAccountName,
            backgroundColorHex: null,
            textColorHex: null,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
              width: 3.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(60.0)),
          ),
        ),
        if (uid != selfUid)
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: _smallVideoToolbar(uid),
          ),
      ],
    );
  }

  Widget _renderSmallVideoAvatarText(int uid) {
    String userAccountName = uid == selfUid
        ? userFullName.split(',')[0]
        : getUserAccountName(uid).split(',')[0];
    ;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: AvatarLetter(
        size: 40,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 20,
        upperCase: true,
        numberLetters: 2,
        letterType: LetterType.Circular,
        text: userAccountName,
        backgroundColorHex: null,
        textColorHex: null,
      ),
    );
  }

  getUserAccountName(int uid) {
    String userAccountStr = "";
    userAccountList.forEach((element) {
      if (element.contains(uid.toString())) {
        userAccountStr = element.split('~')[1];
      }
    });
    return userAccountStr;
  }

  Widget largeVideoUserName() {
    String userName = getUserAccountName(largeViewUid);
    return Column(
      children: [
        userName != null && userName.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black38,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userName != null &&
                              userName.isNotEmpty &&
                              userName != userFullName
                          ? userName
                          : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (userAudioMutedList.contains(largeViewUid) &&
                        !userVideoMutedList.contains(largeViewUid))
                      SizedBox(width: 2),
                    if (userAudioMutedList.contains(largeViewUid) &&
                        !userVideoMutedList.contains(largeViewUid))
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: 20,
                          height: 20,
                          child: RawMaterialButton(
                            child: Icon(
                              Icons.mic_off,
                              color: Colors.red,
                              size: 15.0,
                            ),
                            shape: CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(3.0),
                            onPressed: () {},
                          ),
                        ),
                      )
                  ],
                ),
              )
            : Container(),
        if (showToolBar) _largeTopToolbar(),
      ],
    );
  }

  /// Toolbar layout
  Widget _largeTopToolbar() {
    return _joined
        ? Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleAudioMute,
                  child: Icon(
                    audioMuted ? Icons.mic_off : Icons.mic,
                    color: audioMuted ? Colors.red : Colors.blueAccent,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                ),
                RawMaterialButton(
                  onPressed: _onToggleVideoMute,
                  child: Icon(
                    videoMuted ? Icons.videocam_off : Icons.videocam,
                    color: videoMuted ? Colors.red : Colors.blueAccent,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                ),
                if (!videoMuted)
                  RawMaterialButton(
                    onPressed: _onSwitchCamera,
                    child: Icon(
                      cameraFront ? Icons.camera_rear : Icons.camera_front,
                      color: Colors.blueAccent,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                  ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _smallVideoToolbar(int uid) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          userAudioMutedList.contains(uid)
              ? Container(
                  width: 20,
                  height: 20,
                  child: RawMaterialButton(
                    child: Icon(
                      Icons.mic_off,
                      color: Colors.red,
                      size: 15.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(3.0),
                    onPressed: () {},
                  ),
                )
              : const SizedBox.shrink(),
          if (userAudioMutedList.contains(uid) &&
              userVideoMutedList.contains(uid))
            SizedBox(width: 10),
          userVideoMutedList.contains(uid)
              ? Container(
                  width: 20,
                  height: 20,
                  child: RawMaterialButton(
                    child: Icon(
                      Icons.videocam_off,
                      color: Colors.red,
                      size: 15.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(3.0),
                    onPressed: () {},
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  sessionEndAlert(BuildContext context,
      {VoidCallback onPositivePress, VoidCallback onNegativePress}) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text(
          "Yes",
          style: AppPreferences().isLanguageTamil()
              ? TextStyles.tamilStyle
              : TextStyle(fontSize: 15),
        ),
        onPressed: onPositivePress);
    Widget cancelButton = FlatButton(
      child: Text(
        "No",
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: onNegativePress,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Do you want to leave the session?",
        maxLines: 2,
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyleBold
            : TextStyle(fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Recording code
  void stopRecording() async {
    setState(() {
      isRecording = false;
      timer.cancel();
      timer = null;
      seconds = 00;
      hours = 00;
      minutes = 00;
    });

    Fluttertoast.showToast(
        msg: "Download option will be available once file generated");

    selectedAppointment.isRecording = false;
    await _repository.updateAppointment(
      widget.appointment.bookingId,
      widget.appointment.departmentName,
      widget.appointment.patientName,
      selectedAppointment,
    );

    //  Future.delayed(const Duration(milliseconds: 5),
    //                           () async {

    //                       });

    // _repository
    //     .stopRecording(widget.appointment.bookingId,
    //         widget.appointment.departmentName, widget.appointment.patientName)
    //     .then((value) {
    //   updateCollectionData(widget.appointment, 'isRecording', false);
    // });
  }

  void startRecording() async {
    /// webservice call for checking Screen Share availability
    selectedAppointment = await _repository.getAppointment(
      widget.appointment.departmentName,
      widget.appointment.patientName,
      widget.appointment.bookingId,
    );

    if (selectedAppointment != null &&
        (selectedAppointment.isRecording == null ||
            !selectedAppointment.isRecording)) {
      setState(() {
        isRecording = true;
      });
      if (timer == null)
        timer = Timer.periodic(duration, (Timer t) {
          handleTick();
        });
      selectedAppointment.isRecording = true;
      await _repository.updateAppointment(
        widget.appointment.bookingId,
        widget.appointment.departmentName,
        widget.appointment.patientName,
        selectedAppointment,
      );

      final CollectionReference userCollection =
          Firestore.instance.collection('Agoracall');
      print("COLLECTION: ${userCollection.id}");

      /*userCollection.document(selectedAppointment.bookingId).add({
        'email': userInfo.emailId,
        'token': userCredential.user.uid,
        'user_type': userType,
        'username': userInfo.userName
      });*/
    } else {
      Fluttertoast.showToast(
          msg: "Screen recording is already activated by other person");
    }

    return;

    final CollectionReference userCollection =
        Firestore.instance.collection('Agoracall');
    var snapshot =
        await userCollection.document(widget.appointment.bookingId).get();
    print("COLLECTION: ${snapshot.exists}  Data: ${snapshot.data}");
    if (snapshot.exists) {
      if (snapshot.data['isRecording']) {
        Fluttertoast.showToast(
            msg: "ScreenSharing is already activated by other person");
        return;
      }
    }

    setState(() {
      isRecording = true;
    });
    if (timer == null)
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });

    _repository
        .startRecording(widget.appointment.bookingId,
            widget.appointment.departmentName, widget.appointment.patientName)
        .then((value) {
      if (snapshot.exists) {
        updateCollectionData(widget.appointment, 'isRecording', true);
      } else {
        setCollectionData(widget.appointment, false, true);
      }
    });
  }

  void handleTick() {
    if (isRecording) {
      setState(() {
        secondsPassed = secondsPassed + 1;
        seconds = secondsPassed % 60;
        minutes = secondsPassed ~/ 60 % 60;
        hours = secondsPassed ~/ (60 * 60) % 24;
      });
    }
  }

  Future setCollectionData(
      Appointment appointment, bool isShare, bool isRecord) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('Agoracall');
    await userCollection.document(appointment.bookingId).setData({
      'bookingId': appointment.bookingId,
      'isSharing': isShare,
      'isRecording': isRecord,
    }).whenComplete(() {
      print("Variable Updated");
    });
  }

  Future updateCollectionData(
      Appointment appointment, String type, bool typeVal) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('Agoracall');
    await userCollection.document(appointment.bookingId).updateData({
      type: typeVal,
    }).whenComplete(() {
      print("Variable Update success");
    });
  }

  Future setCollectionDataForCallStatus() async {
    final CollectionReference userCollection =
        Firestore.instance.collection('AgoraCallStatus');
    await userCollection.document(widget.appointment.bookingId).setData({
      'BookingID': widget.appointment.bookingId,
      'CallStatus': "Connected",
    }).whenComplete(() {
      print("Variable Updated");
    });
  }

  Future updateCollectionDataForCallStatus() async {
    final CollectionReference userCollection =
        Firestore.instance.collection('AgoraCallStatus');
    await userCollection.document(widget.appointment.bookingId).updateData({
      "CallStatus": "DisConnected",
    }).whenComplete(() {
      print("Variable Update success");
    });
  }

  /// End here
}
