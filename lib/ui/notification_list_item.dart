import '../model/notice_board_response.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';

class NotificationListItem extends StatelessWidget {
  final NewNotification notification;

  NotificationListItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: notification.message.length > 90
                            ? notification.message.substring(0, 90)
                            : notification.message,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: '...Read More',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
                Column(
                  children: <Widget>[
                    Text(
                      DateUtils.convertUTCToLocalTimeRecent(
                          notification.formattedCreatedDate.toString()),
                      style: TextStyle(color: Colors.grey),
                    ),
                    /*SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: EdgeInsets.all(7),
                        child: Icon(Icons.info_outline)),*/
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    notification.groupName == null
                        ? Image.asset("assets/images/user_ic.png")
                        : Image.asset("assets/images/group_ic.png"),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(notification.groupName ??
                          notification.contactName ??
                          '${notification.userName}'),
                    ),
                  ],
                )),
                Text("Status : ${notification.messageStatus.toString()}")
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.borderLine,
            ),
            Container(
              width: double.infinity,
              height: 5,
              color: AppColors.borderShadow,
            ),
          ],
        ));
  }
}
