import '../../ui/advertise/adWidget.dart';
import '../../ui/attendance/scan_qrcode_screen.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  final String title;

  AttendanceScreen({this.title});

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()),
                    ModalRoute.withName(Routes.dashBoard));
              },
            ),
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 90,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRScannerScreen(),
                            ),
                          );
                        },
                        child: Text("Scan QR Code"),
                      )
                    ],
                  ),
                ),
              ),
            ),

            /// Show Banner Ad
            // getSivisoftAdWidget(),
          ],
        ));
  }
}
