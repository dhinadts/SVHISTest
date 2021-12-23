import 'dart:convert';

import '../model/env_props.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../utils/app_preferences.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';

class StoredLocalData extends StatefulWidget {
  StoredLocalData({Key key}) : super(key: key);

  @override
  _StoredLocalDataState createState() => _StoredLocalDataState();
}

class _StoredLocalDataState extends State<StoredLocalData> {
  var showList = new List();
  EnvProps envproperties; //  = await AppPreferences.getEnvProps();
  var menuItemsData; //  = await AppPreferences.getMenuItemsData();

  @override
  void initState() {
    super.initState();
    callingAppPref();
  }

  callingAppPref() async {
    // print(defaultDateFormat);
    envproperties = await AppPreferences.getEnvProps();
    // print(envproperties.toJson().keys);
    // menuItemsData = await AppPreferences.getMenuItemsData();
    // var userInfo = await AppPreferences.getUserInfo();
    // print(menuItemsData);
    showList.add({
      "sdx.environment.default.date.format":
          await AppPreferences.getDefaultDateFormat(),
      "version": await AppPreferences.getVersion(),
      "gcPageIsShowing": await AppPreferences.isGCPageIsShowing(),
      "language": await AppPreferences.getLanguage(),
      "loginStatus": await AppPreferences.getLoginStatus(),
      "username": await AppPreferences.getUsername(),
      "userCategory": await AppPreferences.getUserCategory(),
      "userDepartment": await AppPreferences.getDeptName(),
      "role": await AppPreferences.getRole(),
      "fullName": await AppPreferences.getFullName(),
      "fullName2": await AppPreferences.getSecondFullName(),
      "email": await AppPreferences.getEmail(),
      "terms": await AppPreferences.getTermsAcceptance(),
      "historySaved": await AppPreferences.isHistorySaved(),
      "checkInSaved": await AppPreferences.isCheckInSaved(),
      "physicianSaved": await AppPreferences.isPhysicianSaved(),
      "latAndLang": await AppPreferences.getLatLang(),
      "signUp": await AppPreferences.getSignUpStatus(),
      "setterCountry": await AppPreferences.getCountry(),
      "phoneNo": await AppPreferences.getPhone(),
      "apiUrl": await AppPreferences.getApiUrl(),
      "tenant": await AppPreferences.getTenant(),
      "profileUpdate": await AppPreferences.getProfileUpdate(),
      "environmentCode": await AppPreferences.getEnvironment(),
      "passwordChanged": await AppPreferences.isPasswordChanged(),
      "height": await AppPreferences.getHeight(),
      "weight": await AppPreferences.getWeight(),
      "clientId": await AppPreferences.getClientId(),
      "appName": await AppPreferences.getAppName(),
      "consideredDomain": await AppPreferences.getConsideredDomain(),
      "currency": await AppPreferences.getDefaultCurrency(),
      "isDailyCheckInEnabled":
          await AppPreferences.getDailyCheckinReportEnabled(),
      "isAdditionalInformationAvl":
          await AppPreferences.getProfileHistoryEnabled(),
      "isCheckInAvl": await AppPreferences.getUserDailyCheckinEnabled(),
      "com.sdx.environment.memberly.host.url":
          await AppPreferences.getHostUrl(),
      "com.sdx.environment.memberly.host.site.navigator":
          await AppPreferences.getSiteNavigator(),
      "sdx.environment.payment.gateway":
          await AppPreferences.getDefaultPaymentGateway(),
      "primaryColor": await AppPreferences.getAppColor(),
      "isUserEligibleForBluetooth":
          await AppPreferences.getUserEligibleForBluetooth(),
      "sdx.environment.payments.enable":
          await AppPreferences.getEnablePayments(),
    });
    setState(() {});
    // print("${showList[0].keys.toList()[0]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(showList.length == 0
            ? "Locally Stored Data 1"
            : "Locally Stored Data - ${showList[0].keys.length + 1}"),
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
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Text("1"),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text("EnvProps"),
              onTap: () {
                showDialog(
                    context: context,
                    child: envproperties == null
                        ? AlertDialog(
                            title: Text("No Data Available"),
                          )
                        : AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            title: Center(child: Text("EnvProps")),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      ListTile(
                                        leading: Text("1"),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("clientID",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                            Text(
                                              envproperties.clientId,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      ListTile(
                                        leading: Text("2"),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("clientName",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                            Text(
                                              envproperties.clientName,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      ListTile(
                                        leading: Text("3"),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("userDepartment",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                            Text(
                                              AppPreferences().deptmentName,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      ListTile(
                                        leading: Text("4"),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("apiUrl",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                            Text(
                                              AppPreferences().apiURL,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
              },
            ),
            Divider(
              color: Colors.black,
            ),
            /*       ListTile(
              leading: Text("2"),
              title: Text("MenuItems"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      content: Container(
                        child: Column(
                          children: [
                            Center(child: Text("Menu Items")),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("clientID:    ${envproperties.clientId}"),
                                Text("clientName: ${envproperties.clientName}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
       */
            ListView.separated(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: showList.length == 0 ? 1 : showList[0].keys.length,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  var i = index + 2;
                  //  showList.toList()[index].keys.length;
                  return showList.length == 0
                      ? Center(child: Text("No data from AppPreferences"))
                      : Column(
                          children: [
                            ListTile(
                              leading: Text("$i"),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${showList[0].keys.toList()[index]}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text("${showList[0].values.toList()[index]}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        );
                }),
          ],
        ),
      ),
    );
  }
}
/* 
fn() {
  showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        title: Center(child: Text("EnvProps")),
        content: Container(
          height: MediaQuery.of(context).size.height -
              100, // Change as per your requirement
          width: MediaQuery.of(context).size.width - 100,
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                var ii = i + 1;
                return ListTile(
                  leading: Text("$ii"),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${envproperties.toJson().keys.toList()[i]}"),
                      Text("${envproperties.toJson().values.toList()[i]}"),
                    ],
                  ),
                );
                // envproperties.toJson().keys
              },
              separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                  ),
              itemCount: envproperties.toJson().keys.length),
        ),
      ));
}
 */
