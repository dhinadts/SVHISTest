import '../../login/colors/color_info.dart';
import '../../ui/booking_appointment/appointment_grid_dashboard.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import '../../ui_utils/app_colors.dart';

class BookAppointmentHomeScreen extends StatefulWidget {
  final String title;
  const BookAppointmentHomeScreen({Key key, this.title}) : super(key: key);
  @override
  _BookAppointmentHomeScreenState createState() =>
      _BookAppointmentHomeScreenState();
}

class _BookAppointmentHomeScreenState extends State<BookAppointmentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 16, right: 16),
          //   child: Column(
          //     children: <Widget>[
          //       SizedBox(
          //         height: 24,
          //       ),
          //       Align(
          //         alignment: Alignment.center,
          //         child: Text('Dashboard',
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(ColorInfo.APP_BLUE),
          //                 fontSize: 40.0)),
          //       ),
          //       SizedBox(
          //         height: 4,
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 15,
          ),
          AppointmentGridDashboard(
            from: Constants.bookAppointmentDashboard,
          )
        ],
      ),
    );
  }
}
