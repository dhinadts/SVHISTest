import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import '../../login/colors/color_info.dart';
import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';
import '../../utils/app_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const debug = true;

class UserInfoMembershipCardScreen extends StatefulWidget {
  final UserInfoMemberShipObject membershipInfo;

  const UserInfoMembershipCardScreen({Key key, @required this.membershipInfo})
      : super(key: key);

  @override
  _UserInfoMembershipCardScreenState createState() =>
      _UserInfoMembershipCardScreenState();
}

class _UserInfoMembershipCardScreenState
    extends State<UserInfoMembershipCardScreen> {
  String logoPath = "sdxcontact";
  String clientName = "";
  String personalTitle = "";

  var _documents = [];

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;

  bool _permissionReady;
  String _localPath;
  bool _isAppDownloaded = false;

  ReceivePort _port;

  final globalKey = GlobalKey<ScaffoldState>();

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  String membershipId;
  String gender;
  String firstName;
  String lastName;
  String approvedDate;
  String expiryDate;

  @override
  void initState() {
    super.initState();

    initializeLogoPath();
    final url = WebserviceConstants.baseURL +
        "/filing/membership/qrcode/${widget.membershipInfo.membershipId}";
    _documents = [
      {'name': 'APK', 'link': '$url'}
    ];

    _port = ReceivePort();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    _prepare();

    // Flip the card animation
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        cardKey.currentState.toggleCard();
      });
    });

    /// Initialize Admob
    initializeAd();
  }

  String logoUrl;

  initializeLogoPath() async {
    String path = await AppPreferences.getClientId();
    clientName = await AppPreferences.getClientName();
    logoPath = (path != null) ? path : logoPath;
    String appLogo = await AppPreferences.getAppLogo();
    if (appLogo != null) {
      setState(() {
        logoUrl = appLogo;
      });
    }

    String gender = widget.membershipInfo?.gender ?? "";
    if (gender.isNotEmpty && gender == "Male") {
      personalTitle = "Mr.";
    } else if (gender.isNotEmpty && gender == "Female") {
      personalTitle = "Ms.";
    }
    setState(() {});
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        // print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
          if (task.status == DownloadTaskStatus.complete) {
            _isAppDownloaded = true;
          }
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      // print(
      // 'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<Null> _prepare() async {
    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    debugPrint("_localPath --> $_localPath");
    debugPrint("_localPath --> ${_tasks[0]}");
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    _requestDownload(_tasks[0]);
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: false,
        openFileFromNotification: false);
  }

  Future<String> _findLocalPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      return directory.path;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  Future<bool> _checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Membership Card'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 2,
                  child: FlipCard(
                    key: cardKey,
                    direction: FlipDirection.HORIZONTAL,
                    speed: 1000,
                    front: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                    back: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 5,
                          ),
                          child: Container(
                            color: Colors.white,
                            child: logoUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: logoUrl,
                                    height: 120,
                                    width: 250,
                                  )
                                : Image.asset(
                                    "assets/images/${logoPath.toLowerCase()}_logo.png",
                                    width: 100,
                                    height: 100,
                                  ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(clientName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(ColorInfo.APP_BLUE))),
                        ),
                        if (_isAppDownloaded)
                          Image.file(
                            File('$_localPath' +
                                "/" +
                                '${widget.membershipInfo.membershipId}_QR.PNG'),
                            width: 120,
                            height: 120,
                          ),
                        Container(
                          height: 1,
                          color: Color(0xFFc29417),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            '$personalTitle ${widget.membershipInfo.firstName} ${widget.membershipInfo.lastName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Text(
                                'Membership Number',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${widget.membershipInfo.membershipId}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Text(
                                'Card Valid From',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              if (widget.membershipInfo.approvedDate != null &&
                                  widget.membershipInfo.approvedDate.isNotEmpty)
                                Text(
                                  '${DateUtils.convertUTCToLocalMembershipFormatDate(widget.membershipInfo.approvedDate) ?? ""}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Text(
                                'Expires',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              if (widget.membershipInfo.expiryDate != null &&
                                  widget.membershipInfo.expiryDate.isNotEmpty)
                                Text(
                                  '${DateUtils.convertUTCToLocalMembershipFormatDate(widget.membershipInfo.expiryDate) ?? ""}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Show Banner Ad
            getSivisoftAdWidget(),
          ],
        ),
      ),
    );
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}

class UserInfoMemberShipObject {
  String membershipId;
  String gender;
  String firstName;
  String lastName;
  String approvedDate;
  String expiryDate;
  String membershipStatus;
  UserInfoMemberShipObject(
      {this.membershipId,
      this.gender,
      this.firstName,
      this.lastName,
      this.approvedDate,
      this.expiryDate,
      this.membershipStatus});
}
