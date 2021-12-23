import 'dart:ui';

import '../ui/reset_password_screen.dart';
import '../ui/tabs/AppLanguage.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UsernameAndTimeWidget extends StatefulWidget {
  final AppLanguage appLanguage;

  const UsernameAndTimeWidget({Key key, this.appLanguage}) : super(key: key);

  @override
  UsernameAndTimeWidgetState createState() => UsernameAndTimeWidgetState();
}

class UsernameAndTimeWidgetState extends State<UsernameAndTimeWidget> {
  String name = "Super Admin";

  @override
  void initState() {
    super.initState();
    AppPreferences.getFullName().then((value) => {getUserName(value)});
  }

  getUserName(String name) {
    setState(() {
      this.name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var appLanguage = Provider.of<AppLanguage>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(name ?? "SuperAdmin",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.primaryColor)),
            Text(DateFormat(DateUtils.dateAndTimeFormat).format(DateTime.now()),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.primaryColor)),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        ClipRect(
            child: Image.asset(
          "assets/images/userInfo.png",
          height: 60,
          width: 60,
        )),
        SizedBox(
          width: 20,
        ),
        InkWell(
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResetPassword()));
            },
            child: ClipRect(
                child: Image.asset(
              "assets/images/updatePassword.png",
              height: 30,
              width: 30,
            ))),
        SizedBox(
          width: 10,
        ),
        PopupMenuButton(
          itemBuilder: (context) {
            var list = List<PopupMenuEntry<Object>>();
            list.add(
              PopupMenuItem(
                child: Text("English"),
                value: 1,
              ),
            );
            list.add(
              PopupMenuDivider(
                height: 10,
              ),
            );
            list.add(
              PopupMenuItem(
                child: Text("Tamil"),
                value: 2,
              ),
            );
            return list;
          },
          icon: Image.asset(
            "assets/images/lang_trans.png",
            height: 35,
            width: 35,
          ),
          onSelected: (value) {
            if (value == 1) {
              // print("English selected");
              widget.appLanguage.changeLanguage(Locale("en"));
            } else if (value == 2) {
              // print("Tamil selected");
              widget.appLanguage.changeLanguage(Locale("ta"));
            }
          },
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () async {
              String name = await AppPreferences.getFullName();
              AlertUtils.logoutAlert(context, name);
            },
            child: ClipRect(
                child: Image.asset(
              "assets/images/logout.png",
              height: 30,
              width: 30,
            ))),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
