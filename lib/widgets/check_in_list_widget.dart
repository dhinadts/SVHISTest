import '../model/check_in_dynamic.dart';
import '../model/passing_arg.dart';
import '../model/people.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/app_preferences.dart';
import '../utils/routes.dart';
import '../widgets/check_in_list_item.dart';
import 'package:flutter/material.dart';

class CheckInListWidget extends StatefulWidget {
  final List<CheckInDynamic> checkIn;
  final People people;
  final String userName;
  final void Function(bool) _successCallback;

  CheckInListWidget(
      this.checkIn, this.people, this._successCallback, this.userName);

  @override
  CheckInListWidgetState createState() => CheckInListWidgetState();
}

class CheckInListWidgetState extends State<CheckInListWidget> {
  bool isContentAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: WidgetStyles.cardBoxShadow),
        child: Column(
          children: <Widget>[
            _userTitleText(),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: widget.checkIn.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckInListItem(
                    widget.checkIn[index],
                    onPress: () async {
                      // if (AppPreferences().role == Constants.supervisorRole) {
                      //   updateViewedStatus(index);
                      // }
                      String fullName = "";
                      if (widget.people != null) {
                        fullName = widget.people.firstName.length > 0
                            ? widget.people.firstName +
                                " " +
                                widget.people.lastName
                            : widget.people?.userName;
                      } else {
                        fullName = AppPreferences().fullName2.length > 0
                            ? AppPreferences().fullName2
                            : AppPreferences().username;
                      }
                      final refresh = await Navigator.pushNamed(
                        context,
                        Routes.checkInScreen,
                        arguments: Args(
                          arg: "",
                          checkInDynamic: widget.checkIn[index],
                          username: widget.people != null
                              ? widget.people.userName
                              : AppPreferences().username,
                          // userFullName: widget.people != null
                          //     ? widget.people.userFullName
                          //     : widget.userName,
                          userFullName: widget.people != null &&
                                  widget.people.userFullName != null &&
                                  widget.people.userFullName.isNotEmpty
                              ? widget.people.userFullName
                              : fullName,
                          departmentName: widget.people != null
                              ? widget.people.departmentName
                              : AppPreferences().deptmentName,
                          // "${widget.people.firstName}, ${widget.people.lastName}"
                        ),
                      );
                      widget._successCallback(refresh);
                    },
                  );
                  if (widget.people.userName ==
                      widget.checkIn[index].userName) {
                    isContentAvailable = true;
                  } else {
                    return Container();
                  }
                }),
          ],
        ));
  }

  Widget _userTitleText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.arrivedColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 45,
          ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 25),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Date",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
          SizedBox(
            width: 100,
          ),
          /*  Container(
              margin: EdgeInsets.only(right: 25),
              padding: EdgeInsets.all(15),
              child: Text(
                "View",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),*/
        ],
      ),
    );
  }
}
