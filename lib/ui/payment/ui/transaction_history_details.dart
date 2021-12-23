import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../../ui/advertise/adWidget.dart';
import '../../../utils/app_preferences.dart';
import '../../../login/colors/color_info.dart';
import '../../../ui/custom_drawer/navigation_home_screen.dart';
import '../../../ui/payment/model/payment_detail.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/icon_utils.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import '../../../widgets/item_text_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../login/stateLessWidget/upper_logo_widget.dart';

class TransactionHistoryDetails extends StatefulWidget {
  final PaymentDetail paymentDetail;

  TransactionHistoryDetails(this.paymentDetail);

  @override
  TransactionHistoryDetailsState createState() =>
      TransactionHistoryDetailsState();
}

class TransactionHistoryDetailsState extends State<TransactionHistoryDetails> {
  String defaultCurrency = "";
  var buttonView;
  bool showAppBar = true;
  bool showButton = true;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
    _askPermissions();

    /// Initialize Admob
    initializeAd();
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  getShared() async {
    defaultCurrency = await AppPreferences.getDefaultCurrency();
  }

  var _globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    buttonView = new Container(
        child: new InkWell(
      child: new Container(
          height: 50.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(ColorInfo.APP_BLUE),
          ),
          child: new Center(
            child: Text(
              "Download",
              style: TextStyle(
                  color: Color(ColorInfo.WHITE),
                  fontSize: 18.0,
                  fontFamily: Constants.LatoRegular),
            ),
          )),
      onTap: () {
        //takeScreenShot();
        _saveScreen();
      },
    ));
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: showAppBar
            ? AppBar(
                backgroundColor: AppColors.primaryColor,
                centerTitle: true,
                title: Text("Transaction Details"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigationHomeScreen()),
                            ModalRoute.withName(Routes.navigatorHomeScreen));
                      }),
                ],
              )
            : null,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    RepaintBoundary(
                      key: _globalKey,
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: UpperLogoWidget(
                                        showPoweredBy: false,
                                        showTitle: AppPreferences().clientId ==
                                            Constants.GNAT_KEY,
                                        showVersion: false,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      widget.paymentDetail
                                                  ?.paymentDescription !=
                                              null
                                          ? widget
                                              .paymentDetail?.paymentDescription
                                          : "Payment Description",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: AppColors.borderLine,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 3,
                                    color: AppColors.borderShadow,
                                  ),
                                  if (widget.paymentDetail?.paymentMode ==
                                      "CASH")
                                    TextItemOption(
                                      "Order ID",
                                      defValue:
                                          widget.paymentDetail?.orderId ?? "",
                                    ),
                                  if (widget.paymentDetail?.transactionId !=
                                          null &&
                                      widget.paymentDetail?.paymentMode !=
                                          "CASH")
                                    TextItemOption(
                                      "Transaction ID",
                                      defValue: widget.paymentDetail
                                                      .transactionId !=
                                                  null &&
                                              widget.paymentDetail.transactionId
                                                  .isNotEmpty
                                          ? widget.paymentDetail.transactionId
                                          : "NIL",
                                    ),
                                  if (widget.paymentDetail?.createdOn != null)
                                    TextItemOption(
                                      "Transaction Date",
                                      defValue: DateUtils.convertUTCToLocalTime(
                                          widget.paymentDetail
                                                  ?.createdOn ??
                                              widget.paymentDetail?.transactionDate),
                                    ),
                                  TextItemOption(
                                    "Transaction Amount",
                                    defValue: (widget.paymentDetail
                                                    ?.totalAmount ==
                                                null
                                            ? ""
                                            : (/* widget.paymentDetail.currency ==
                                                            defaultCurrency && */
                                                    AppPreferences()
                                                        .defaultCurrencySymbol) +
                                                " " +
                                                (widget
                                                    .paymentDetail?.totalAmount
                                                    .toString()) +
                                                " " +
                                                AppPreferences()
                                                    .defaultCurrencySuffix)
                                        .toString(),
                                  ),
                                  TextItemOption(
                                    "Transaction Mode",
                                    defValue: widget
                                            .paymentDetail?.paymentMode ??
                                        (widget.paymentDetail?.transactionId !=
                                                null
                                            ? "CARD"
                                            : "CASH"),
                                  ),
                                  TextItemOption(
                                    "Transaction Status",
                                    defValue: widget
                                            .paymentDetail?.transactionStatus ??
                                        "",
                                  ),
                                ],
                              ))),
                    ),
                    showButton
                        ? SizedBox(
                            height: 30,
                          )
                        : Container(),
                    showButton ? buttonView : Container(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),

            /// Show Banner Ad
            getSivisoftAdWidget(),
          ],
        ));
  }

  _saveScreen() async {
    setState(() {
      showAppBar = false;
      showButton = false;
    });
    Map<String, dynamic> result1 = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File(dir + 'transaction_invoice.pdf');
    var doc = pw.Document();
    doc.addPage(pw.Page(build: (pw.Context context) {
      return getPDFPage(byteData);
    }));
    await file.writeAsBytes(doc.save());
    final result = await ImageGallerySaver.saveFile(file.path);
    // print("result $result");
    result1['filePath'] = dir + 'transaction_invoice.pdf';
    _toastInfo("\t\tDownloaded successfully \n${result.toString()}");
    result1['isSuccess'] = true;
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showAppBar = true;
        showButton = true;
      });
    });
    await _showNotification(result1);
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(
        msg: info, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.restricted) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      return permissionStatus[PermissionGroup.storage] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  getPDFPage(ByteData byteData) {
    final image = pw.MemoryImage(byteData.buffer.asUint8List());
    return pw.Center(child: pw.Image.provider(image));
  }
}
