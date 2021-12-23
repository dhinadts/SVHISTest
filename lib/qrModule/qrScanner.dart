import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Memberly/qrModule/qrCodeResult.dart';
import 'package:Memberly/ui/custom_drawer/custom_app_bar.dart';
import 'package:Memberly/ui/splash_screen.dart';
import 'package:Memberly/utils/constants.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_info.dart';
import '../repo/common_repository.dart';

import '../ui/custom_drawer/navigation_home_screen.dart';
import '../utils/app_preferences.dart';
import '../utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  final String title;
  QRScanPage({Key key, this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  Barcode qrCodeResult;
  QRViewController controller;
  bool pause = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var location = Location();

  var firstName = '';
  var lastName = '';
  var dateOfBirth = '';
  var dose1Date = '';
  var dose2Date = '';
  var vaccineName = '';
  var identificationType = '';
  var identificationNumber = "";
  var certificationNumber = "";
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  var timeToday = DateTime.now();
  String today = "";
  var logOut; // = "";
  int count1 = 0;
  Timer a;
  String totalCounts = "0";
  String pause1 = "PAUSE";
  String urlpppp = "";
  bool qrresult = false;
  @override
  void initState() {
    // count1 = 0;

    super.initState();
    // controller.pauseCamera();
    totalCountsCall();
    // today = timeToday.toUtc().toString().split(" ")[0];
    // print("date today ---> ${timeToday.day}      ${timeToday.toUtc()}");
    // print("${timeToday.toUtc().toString().split(" ")[0]}");
    // print(today);

    print("${WebserviceConstants.baseFilingURL}" + "/vaccinationform/Details?");
    // "first_name=${res['First Name']}&identification_type=${res['Identification Type']}&last_name=${res['Last Name']}&login_user=${AppPreferences().username}");

    // autologout();
  }

  @override
  void reassemble() {
    // autologout();
    super.reassemble();
    if (AppPreferences().loginStatus) {
      if (Platform.isAndroid) {
        controller.pauseCamera();
      }
      // controller.resumeCamera();
    }
  }

  totalCountsCall() async {
    // String url = "${WebserviceConstants.baseFilingURL}" +
    //     "/GetVaccinationQrScanCount?login_user=${AppPreferences().username}&role=${AppPreferences().role}";

    String url =
        "https: //qa.servicedx.com/filing/GetVaccinationQrScanCount?login_user=${AppPreferences().username}&role=${AppPreferences().role}";
    var response = await http.get(url);
    print(response.body);
    print(response.statusCode);
    if (mounted)
      setState(() {
        totalCounts = response.body.toString().contains("error")
            ? "Error"
            : response.body.toString();
      });
  }

  autologout() async {
    print("123");

    // try {
    //   DateTime endDate = new DateTime.now();
    //   DateTime startDate = endDate.subtract(Duration(hours: 1));
    //   List<AppUsageInfo> infoList =
    //       await AppUsage.getAppUsage(startDate, endDate);
    //   setState(() {
    //     _infos = infoList;
    //   });

    //   for (var info in infoList) {
    //     print("11123");
    //     print(info.toString());
    //   }
    // } on AppUsageException catch (exception) {
    //   print("exception  --$exception");
    // }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.getInt("QRLogin") != 1) {
      await prefs.setInt("QRLogin", 1);
      logOut = DateTime.now().add(Duration(seconds: 15));
      // await AppPreferences.logoutClearPreferences();
    } else if (logOut == DateTime.now()) {
      print("count != 15");
      controller.stopCamera();
      controller.dispose();
      await AppPreferences.logoutClearPreferences();
      getVersion();
      await prefs.setInt("QRLogin", 0);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
          ModalRoute.withName(Routes.splashScreen));
    } else if (count1 == 15) {
      controller.stopCamera();
      print("count == 15");
      controller.dispose();
      await AppPreferences.logoutClearPreferences();
      getVersion();
      // a.cancel();
      await prefs.setInt("QRLogin", 0);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
          ModalRoute.withName(Routes.splashScreen));
    }
    Timer.periodic(Duration(seconds: 1), (t) {
      count1 = count1 + 1;
      autologout();
    });

    // return logOut;
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    // print("version = $version");
    await AppPreferences.setVersion(version);
  }

  checkQRCode() async {
    try {
      String code = qrCodeResult.code;
      print("QR Code result ------>");
      print(code);

      if (code.contains('Date of vaccination')) {
        var res = json.decode(code);

        print("success");
        print(res);
        // https://qa.servicedx.com/filing/vaccinationform/Details?first_name=Testananyakayu098&identification_type=ID%20Card&last_name=V
        print("https://qa.servicedx.com/filing/vaccinationform/Details?" +
            "first_name=$firstName&identification_type=$identificationType&last_name=$lastName");
        String url = res['Identification Type'] == "none"
            ? "${WebserviceConstants.baseFilingURL}" +
                "/vaccinationform/Details?" +
                "first_name=${res['First Name']}&identification_type=${res['Identification Type']}&last_name=${res['Last Name']}&login_user=${AppPreferences().username}"
            : "${WebserviceConstants.baseFilingURL}" +
                "/vaccinationform/Details?" +
                "first_name=${res['First Name']}&identification_type=${res['Identification Type']}&identification_number=${res['Identification Number']}&last_name=${res['Last Name']}&login_user=${AppPreferences().username}";
        // https://qa.servicedx.com/filing/vaccinationform/Details?first_name=Test&identification_number=SVG222&identification_type=birthCertificate&last_name=Vijaya&login_user=Admin

        // "https://qa.servicedx.com/filing/vaccinationform/Details?" +
        //     "first_name=${res['First Name']}&identification_type=${res['Identification Type']}&last_name=${res['Last Name']}";
        print("testing url");
        print(url);
        bool result = await getVaccinationInfo(url);
        print("RESULT ===" + "$result");
        if (!result) {
          firstName = res['First Name'];
          lastName = res['Last Name'];
          dateOfBirth = res['Birth Date'];
          dose1Date = res['V-1 Dose1-Date of vaccination'];
          dose2Date = res['V-1 Dose2-Date of vaccination'];
          vaccineName = res['V-1 Dose1-Vaccine'];
          identificationType = res['Identification Type'];
          certificationNumber = res['Certificate Number'];
          identificationNumber = res['Identification Number'];
          /* {Identification Type: none, 
          First Name: Testbabu0989, 
          Last Name: V, 
          Birth Date: 12/03/1997, 
          V-1 Dose1: dose-1, 
          V-1 Dose1-Date of vaccination: 12/08/2021, 
          V-1 Dose1-Vaccine: Janssen, 
          V-1 Dose1-Batch #: 1000, 
          V-1 Dose2: dose-2, 
          V-1 Dose2-Date of vaccination: 12/08/2021, 
          V-1 Dose2-Vaccine: Janssen, 
          V-1 Dose2-Batch #: 67, 
          Certificate Issued By: This information is verified by the Government of St. Vincent and the Grenadines., 
          Certificate Number: 565979}; */

          // Firebase work
          // List dummy = [];
          // QuerySnapshot querySnapshot1 = await Firestore.instance
          //     .collection('VaccinationDetails')
          //     .getDocuments();
          // final allData1 =
          //     querySnapshot1.documents.map((doc) => doc.data).toList();

          // if (allData1.length > 0) {
          //   for (var i = 0; i < allData1.length; i++) {
          //     dummy.add(allData1[i]['date']); // ["Certificate Number"]);;
          //   }
          // }

          // if (allData1.isEmpty || !dummy.contains(today)) {
          //   Firestore.instance.collection("VaccinationDetails").add({
          //     "date":
          //         today //your data which will be added to the collection and collection will be created after this
          //   }).then((_) {
          //     // print("Certificate Number ${res['Certificate Number']} created");
          //     print(today + " is created");
          //   }).catchError((_) {
          //     print("an error occured");
          //   });
          // } else {
          //   print("Already available");
          // }
        } else {
          Fluttertoast.showToast(
              msg: "Record not available for now",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Invalid QR code",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
      // await totalCountsCall();
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: "Invalid QR code",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
    totalCountsCall();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("QR Code"),
      //   centerTitle: true,

      // ),
      appBar: CustomAppBar(
          title: widget.title == null ? "QR Code" : widget.title,
          pageId: Constants.PAGE_ID_QRCODE),
      body: Column(
        // shrinkWrap: true,

        children: <Widget>[
          !qrresult
              ? Expanded(flex: 2, child: _buildQrView(context))
              // : QRResultScreen(),
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Image.asset(
                              "assets/images/qrcodeLogo_logo.png",
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Name : ',
                              //textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$firstName $lastName',
                              //textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Vaccination Name : ',
                              //textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$vaccineName',
                              //textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Identification Type : ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('$identificationType'),
                          ],
                        ),
                        identificationType == "none"
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Identification No : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '$identificationNumber',
                                    maxLines: 2,
                                  ),
                                ],
                              ),

                        // Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Certification No',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 12,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '$certificationNumber',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        // fontSize: 12,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            /*           Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),  */
                            Column(
                              children: [
                                Text(
                                  'Dose 1 Date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '$dose1Date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      // fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                            /*  Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: Colors.blueGrey,
                          ),
                        ],
                      ), */
                            Column(
                              children: [
                                Text(
                                  'Dose 2 Date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '$dose2Date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      // fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                              /* AppPreferences().role != "User"
                        ? MainAxisAlignment.spaceBetween
                        : */
                              MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Today's Scanned Count : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "$totalCounts",
                                    // style: TextStyle(
                                    //   fontWeight: FontWeight.bold,
                                    //   // fontSize: 14,
                                    // ),
                                  )
                                ],
                              ),
                            ),
                            /* if (AppPreferences().role != "User")
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Row(
                            children: [
                              Text(
                                "Today's total Count: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontSize: 12,
                                ),
                              ),
                              Text(
                                "$totalCounts",
                                // style: TextStyle(
                                //   fontWeight: FontWeight.bold,
                                //   // fontSize: 12,
                                // ),
                              )
                            ],
                          ),
                        ), */
                          ],
                        ),

                        //   onPressed: qrCodeResult == null
                        //       ? null
                        //       : () {
                        //           checkQRCode();
                        //         },
                        //   child: Text("SUBMIT"),
                        // )
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                qrresult = false;
                                controller.resumeCamera();
                                pause = false;
                                pause1 = "PAUSE";
                              });
                            },
                            child: Text("Scan More"),
                          ),
                        )
                      ],
                    ),
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
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
        ),
        Positioned(
            bottom: 10.0,
            left: 20,
            right: 20.0,
            child: Center(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      pause = !pause;
                    });
                    print("pause");
                    print(pause);
                    if (!pause) {
                      pause1 = "RESUME";
                      controller.pauseCamera();
                    } else {
                      pause1 = "PAUSE";
                      controller.resumeCamera();
                    }
                  },
                  child: Text(
                      // controller?.pauseCamera() ?
                      pause1)),
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     TextButton(
            //         onPressed: () {
            //           setState(() {
            //             pause = true;
            //             controller.pauseCamera();
            //           });
            //         },
            //         child: Text(
            //           "PAUSE",
            //           // style: TextStyle(color: pause ? Colors.blue : Colors.white),
            //         )),
            //     TextButton(
            //         onPressed: () {
            //           setState(() {
            //             pause = false;
            //             controller.resumeCamera();
            //           });
            //         },
            //         child: Text(
            //           "RESUME",
            //           // style: TextStyle(color: pause ? Colors.white : Colors.blue),
            //         ))
            //   ],
            // ),
            )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    print("bool ---> $pause");
    print(controller.getCameraInfo());

    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData;
        if (scanData.code.toString().contains('Date of vaccination')) {
          this.controller.pauseCamera();

          setState(() {
            checkQRCode();
            pause = false;
            pause1 = "RESUME";
            qrresult = true;
          });
        } else {
          setState(() {
            pause = true;
            pause1 = "PAUSE";
            qrresult = true;
          });

          this.controller.resumeCamera();
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    a?.cancel();
    super.dispose();
  }

  TextStyle columnWise() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
  }

  TextStyle columnWise1() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }
}

Future<bool> getVaccinationInfo(String url) async {
  var response = await http.get(url);
  print(response.body);
  print(response.statusCode);
  return response.body == null || response.body == "false" ? false : true;
}
