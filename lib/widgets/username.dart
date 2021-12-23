import 'dart:ui';

import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';

class Username extends StatefulWidget {
  @override
  UsernameState createState() => UsernameState();
}

class UsernameState extends State<Username> {
  String name = "Super Admin";
  String email = "email";
  String phone = "";

  @override
  void initState() {
    super.initState();
    AppPreferences.getFullName().then((value) => {getUserName(value)});
    AppPreferences.getEmail().then((value) => {getemail(value)});
    AppPreferences.getPhone().then((value) => {getphone(value)});
    setState(() {
      if (AppPreferences().loginStatus) {
        this.name = AppPreferences().username;
        this.email = AppPreferences().email;
        this.phone = AppPreferences().fullName;
        //   this.phone = AppPreferences().phone;
      }
    });
  }

  getemail(String name) {
    setState(() {
      this.name = name;
    });
  }

  getUserName(String email) {
    setState(() {
      this.email = email;
    });
  }

  getphone(String phone) {
    setState(() {
      this.phone = phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
            Text(email ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
            Text(phone ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
          ],
        ),

        /*  ClipRect(
            child: Image.asset(
              "assets/images/userInfo.png",
              height: 60,
              width: 60,
            )),*/
        SizedBox(
          width: 20,
        ),
        /* InkWell(
            onTap: () async {
              String name = await AppPreferences.getFullName();
              AlertUtils.logoutAlert(context, name);
            },
        */ /*    child: ClipRect(
                child: Image.asset(
                  "assets/images/logout.png",
                  height: 30,
                  width: 30,
                ))*/ /*),*/
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
