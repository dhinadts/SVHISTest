import 'dart:convert';
import 'dart:io';

import '../../model/user_info.dart';
import '../../repo/common_repository.dart';
import '../../ui/attendance/models/entry_log_model.dart';
import '../../ui/attendance/services/location_service.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  Barcode qrCodeResult;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var location = Location();
  UserLocation currentLocation;

  List<EntryLogModel> entryLogModel = [];

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  checkQRCode() async {
    String departmentName = await AppPreferences.getDeptName();
    try {
      print(departmentName);
      String code = qrCodeResult.code;
      print(code);
      String departmentNameFromQR;
      String deviceLocationFromQR;
      String sort;
      departmentNameFromQR = json.decode(code)['Organization'];
      deviceLocationFromQR = json.decode(code)['Location'];
      sort = json.decode(code)['Time'];

      if (departmentName == departmentNameFromQR) {
        getLocation(deviceLocationFromQR, sort);
      } else {
        Fluttertoast.showToast(
            msg: "Invalid QR code",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: "Invalid QR code",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  getLocation(String deviceLocationFromQR, String sort) {
    // Request permission to use location
    location.requestPermission().then((granted) async {
      print("location request res is " + granted.index.toString());
      if (granted == PermissionStatus.granted) {
        showProgress();
        currentLocation = await LocationService().getLocation();
        String latLog = currentLocation.latitude.toString() +
            "," +
            currentLocation.longitude.toString();
        sendData(
            sendLocation: true,
            deviceLocationFromQR: deviceLocationFromQR,
            latLog: latLog,
            sort: sort);
      } else {
        showProgress();
        sendData(deviceLocationFromQR: deviceLocationFromQR, sort: sort);
      }
    });
  }

  showProgress() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<bool> checkLog() async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    String url = '${WebserviceConstants.baseAdminURL}/DailyEntrylog/users';
    try {
      final http.Response response = await http.get(url, headers: header);
      debugPrint(response.body);
      debugPrint(response.statusCode.toString());
      entryLogModel = (json.decode(response.body) as List)
          .map((data) => EntryLogModel.fromJson(data))
          .toList();
      return true;
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
      return false;
    }
  }

  sendData(
      {bool sendLocation = false,
      String deviceLocationFromQR,
      String latLog,
      String sort}) async {
    debugPrint("====================> Lat Long ======>"+latLog);
    String username = await AppPreferences.getUsername();
    bool isData = await checkLog();
    if (isData) {
      if (entryLogModel.isEmpty) {
        if (sort == "OUT") {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "No records found",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        } else {
          insertLog(sendLocation, deviceLocationFromQR, latLog);
        }
      } else {
        int index =
            entryLogModel.indexWhere((element) => element.userId == username) ??
                -1;
        if (index != -1) {
          if (sort == "IN") {
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: "Log record already exists",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP);
          } else {
            updateLog(entryLogModel[index].entryLogId);
          }
        } else {
          if (sort == "OUT") {
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: "No records found",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP);
          } else {
            insertLog(sendLocation, deviceLocationFromQR, latLog);
          }
        }
      }
    }
  }

  insertLog(sendLocation, String deviceLocationFromQR, String latLong) async {
    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);

    String url = '${WebserviceConstants.baseAdminURL}/DailyentryLog';

    UserInfo userInfo = await AppPreferences.getUserInfo();

    String firstName = userInfo.firstName;
    String userName = userInfo.userName;
    String lastName = userInfo.lastName;
    String email = userInfo.emailId;
    String phone = userInfo.mobileNo;
    String inTime = DateTime.now().toString();

    var body = {
      "userId": userName,
      "emailId": email,
      'firstName': firstName,
      'inTime': inTime,
      'phoneNo': phone,
      "outTime": null,
      "latlong": !sendLocation ? null : '${latLong}',
      "lastName": lastName,
      "timeStamp": Timestamp.now().seconds.toString()
    };
    
    debugPrint("URL - $url");
    debugPrint("Headers - $header");
    debugPrint("body - " + body.toString());
    try {
      final http.Response response =
          await http.post(url, body: json.encode(body), headers: header);
      debugPrint(response.body);
      debugPrint(response.statusCode.toString());
      if (response.statusCode > 199 && response.statusCode < 299) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
            ModalRoute.withName(Routes.dashBoard));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  updateLog(String entryLogId) async {
    String url =
        '${WebserviceConstants.baseAdminURL}/Update/user/$entryLogId/outTime/${DateTime.now().toString()}';

    /*  var body = {
      "entryLogId": entryLogId,
      "outTime": DateTime.now().toString()
    };*/

    debugPrint("URL - $url");
    // debugPrint("body - " + body.toString());
    try {
      final http.Response response = await http.put(url);
      debugPrint(response.body);
      debugPrint(response.statusCode.toString());
      if (response.statusCode > 199 && response.statusCode < 299) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
            ModalRoute.withName(Routes.dashBoard));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (qrCodeResult != null)
                  Text(
                    qrCodeResult.code,
                    textAlign: TextAlign.center,
                  ),
                RaisedButton(
                  onPressed: qrCodeResult == null
                      ? null
                      : () {
                          checkQRCode();
                        },
                  child: Text("SUBMIT"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
