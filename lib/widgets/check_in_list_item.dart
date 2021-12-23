import '../model/check_in_dynamic.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';

class CheckInListItem extends StatelessWidget {
  final CheckInDynamic checkIn;
  final GestureTapCallback onPress;

  CheckInListItem(this.checkIn, {this.onPress});

  @override
  Widget build(BuildContext context) {
//    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: onPress,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, right: 15, left: 15),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 7,
                      ),
                      Image.asset(
                        "assets/images/search_icon.png",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                          DateUtils.convertUTCToLocalTime(checkIn.checkInDate)),
                    ],
                  )),
                  /* SizedBox(
                    width: 65,
                  ),
                  Icon(Icons.offline_pin,
                      color: (checkIn.viewed == null)
                          ? Colors.grey
                          : (checkIn.viewed ? Colors.green : Colors.grey)),
                  SizedBox(
                    width: 40,
                  )*/
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 7),
                height: 1,
                color: AppColors.borderLine,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 7),
                height: 5,
                color: AppColors.borderShadow,
              ),
            ],
          ),
        ));
  }
}
