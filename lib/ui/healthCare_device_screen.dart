import '../ui_utils/app_colors.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';
import '../ui/custom_drawer/custom_app_bar.dart';
import '../utils/constants.dart';
import '../ui/tabs/app_localizations.dart';

class HealthCareDeviceScreen extends StatefulWidget {
  @override
  _HealthCareDeviceScreenState createState() => _HealthCareDeviceScreenState();
}

class _HealthCareDeviceScreenState extends State<HealthCareDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: AppLocalizations.of(context).translate("key_healthcare"),
          pageId: Constants.PAGE_ID_ADD_NEW_DEVICE),
      // appBar: AppBar(
      //   backgroundColor: AppColors.primaryColor,
      //   centerTitle: true,
      //   title: Text("Healthcare Devices"),
    //   ),
// floatingActionButton: FloatingActionButton(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => AddNewDevice()),
// );
// },
// child: Icon(Icons.add),
// ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            Container(
              height: 50.0,
              color: Colors.indigo[700],
              width: MediaQuery.of(context).size.width * .90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("Device Name",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      "Status",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.addNewDeviceScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, bottom: 10.0),
                      child: Text("C19 Pro",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0, bottom: 10.0),
                      child: Text(
                        "Active",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 5,
              color: AppColors.borderShadow,
            ),
          ],
        ),
      ),
    );
  }
}
