import '../login/utils/utils.dart';
import '../model/notice_board_response.dart';
import '../ui/global_configuration_page.dart';
import '../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Status { Open, InProgress, Completed, Error }

class NotificationListItemNew extends StatelessWidget {
  final NewNotification notification;
  List<Color> _colors = [Colors.deepOrange, Colors.yellow];
  List<double> _stops = [0.0, 0.7];

  NotificationListItemNew(this.notification);

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 2, color: Colors.blue),
      borderRadius: BorderRadius.all(
          Radius.circular(.0) //         <--- border radius here
          ),
    );
  }

  Widget message() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 3, 10, 10),
        height: 85,
        child: ListTile(
          title: Text(
              notification.subject != null
                  ? "${notification.subject.length > 60 ? notification.subject.substring(0, 60) : notification.subject}..."
                  : "",
              style: TextStyle(
                  fontSize: 14,
                  color: HexColor("#909090"),
                  //fontFamily: "Verdana",
                  fontWeight: FontWeight.normal)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: RichText(
                overflow: TextOverflow.clip,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '...Read More',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            height: 1.8,
                            //fontFamily: "Poppins",
                            fontWeight: FontWeight.w500)),
                  ],
                  text: ConversionUtils.parseHtmlString(
                      notification.message.length > 10
                          ? notification.message.substring(0, 10).trim()
                          : notification.message.trim()),
                  style: TextStyle(
                      color: HexColor("#909090"),
                      //fontFamily: "Verdana",
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                )),
          ),
        )

        // Container(
        //     child: RichText(
        //   maxLines: 6,
        //   overflow: TextOverflow.clip,
        //   strutStyle: StrutStyle(fontSize: 12.0),
        //   text: TextSpan(
        //     // text: notification.subject,
        //     // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //     children: <TextSpan>[
        //       TextSpan(
        //         text:
        //             notification.subject != null ? "${notification.subject}" : "",
        //         style: TextStyle(
        //             color: HexColor("#909090"),
        //             fontFamily: "Verdana",
        //             fontWeight: FontWeight.normal),
        //       ),
        //       TextSpan(
        //         text: ConversionUtils.parseHtmlString(
        //             notification.message.length > 90
        //                 ? notification.message.substring(0, 90)
        //                 : notification.message),
        //         children: [
        //           TextSpan(
        //               text: '...Read More',
        //               style: TextStyle(
        //                   color: Colors.blue, fontWeight: FontWeight.bold)),
        //         ],
        //         /*   text: ConversionUtils.parseHtmlString(
        //                 notification.message.length > 60
        //                     ? notification.message.substring(0, 50)
        //                     : notification.message),*/
        //         style: TextStyle(
        //             color: HexColor("#909090"),
        //             fontFamily: "Verdana",
        //             fontWeight: FontWeight.normal),
        //       ),
        //       /*TextSpan(
        //               text: '...Read More',
        //               style:
        //               TextStyle(color: Colors.blue, fontSize: 12, height:1.8, fontFamily: "Poppins", fontWeight: FontWeight.w500)),*/
        //     ],
        //   ),
        // )),
        );
  }

  Widget statusWidget() {
    return new ConstrainedBox(
      constraints: new BoxConstraints(minHeight: 5.0, maxHeight: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
            height: 20,
            decoration: new BoxDecoration(
                color: getStatusColorForMessageStatus(
                    notification.messageStatus.toString()),
                borderRadius: new BorderRadius.all(Radius.circular(9.0))),
            child: Center(
                child: Text(
              "  ${notification.messageStatus.toString()}  ",
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
          )
          // Text("Status : ${notification.messageStatus.toString()}")
        ],
      ),
    );
  }

  BoxDecoration leftBoxDecoration() {
    return BoxDecoration(
        border: Border.all(width: 0, color: Colors.transparent),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //         <--- border radius here
            ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment
              .bottomLeft, // 10% of the width, so there are ten blinds.
          colors: [
            getStatusColorForMessageStatus(
                    notification.messageStatus.toString())
                .withOpacity(1),
            getStatusColorForMessageStatus(
                    notification.messageStatus.toString())
                .withOpacity(0.4)
          ], // whitish to gray
        ));
  }

  BoxDecoration topBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        // border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.all(
            Radius.circular(3.0) //         <--- border radius here
            ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          // 10% of the width, so there are ten blinds.
          colors: [
            Colors.white.withAlpha(10),
            getStatusColorForMessageStatus(
                    notification.messageStatus.toString())
                .withAlpha(10)
          ], // whitish to gray
//
        ));
  }

  @override
  Widget build(BuildContext context) {
    //print("MESSAGE "+notification.message);
    return Container(
        height: 105,
        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
        // padding: EdgeInsets.all(20),
        decoration: leftBoxDecoration(),
        child: Container(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          // width: 320,
          // padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: HexColor("#CCCCCC")),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  )),
          child: Stack(
            overflow: Overflow.clip,
            children: <Widget>[
              new Positioned(
                left: 5,
                bottom: (notification.type == "Push_Notification" ? 3 : -1),
                child: Stack(
                  children: <Widget>[
                    //Center(child: FaIcon(FontAwesomeIcons.envelope, size: 45, color: HexColor("#4f68b5"))),
                    Center(child: buildFaBgIconByType(notification)),
                    /* Center(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/10x10.png',
                        image:
                        'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                      ),
                    ),*/
                  ],
                ),
              ),
              topContainer(context),
              new Positioned(
                top: 20,
                left: 5,
                width: MediaQuery.of(context).size.width - 35,
                child: message(),
              ),
              new Positioned(
                right: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width - 35,
                child: statusWidget(),
              ),
            ],
          )
          /*child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              topContainer(context),
              message(),
              statusWidget()
            ],
          )*/
          ,
        ));
  }

  Color getStatusColorForMessageStatus(String messageStatus) {
    if (messageStatus == "Completed") {
      return Colors.green;
    } else if (messageStatus == "Open") {
      return Colors.blue;
    } else if (messageStatus.toLowerCase().contains("progress")) {
      return Colors.orange;
    } else if (messageStatus.contains("OffDuty")) {
      return Colors.yellow[700];
    } else if (messageStatus.contains("Queued")) {
      return Colors.blue;
    } else if (messageStatus.contains("Error")) {
      return Colors.red;
    }
    // print(" Message Status $messageStatus");
    return Colors.red;
  }

  Widget notifMessage() {
    return Expanded(
        child: RichText(
      text: TextSpan(
        text: '',
        style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: ConversionUtils.parseHtmlString(
                notification.message.length > 10
                    ? notification.message.substring(0, 10)
                    : notification.message),
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: '...Read More',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal)),
        ],
      ),
    ));
  }

  Widget emailWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        /*notification.groupName == null
            ? Image.asset("assets/images/user_ic.png")
            : Image.asset("assets/images/group_ic.png"),*/
        notification.groupName == null
            ? FaIcon(FontAwesomeIcons.solidUser,
                size: 12.0,
                color: getStatusColorForMessageStatus(
                    notification.messageStatus.toString()))
            : FaIcon(
                FontAwesomeIcons.userFriends,
                size: 12.0,
              ),

        SizedBox(width: 5),
        // Flexible(
        // child:
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          // color: Colors.pink,
          child: Text(
            notification.groupName ??
                notification.contactName ??
                '${notification.userName}',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  Widget topContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 3, 10, 5),
      decoration: topBoxDecoration(),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  emailWidget(context),
                  Text(
                    // DateUtils.convertUTCToLocalTimeRecent(
                    //     notification.formattedCreatedDate.toString()),
                    DateUtils.convertUTCToLocalTime(
                        notification.createdOn.toString()),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      color: HexColor("#666666"),
                      fontSize: 14,
                      letterSpacing: 0.75,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /*Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            emailWidget(context),
            Text(
              DateUtils.convertUTCToLocalTimeRecent(
                  notification.formattedCreatedDate.toString()),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(color: Colors.black),
            ),
          ],
        )*/
    );
  }

  buildFaBgIconByType(NewNotification notification) {
    var clr = HexColor("#4f68b5").withAlpha(15);
    double fntSize = 35;
    if (notification.type == "Email")
      return FaIcon(FontAwesomeIcons.envelope, size: fntSize, color: clr);
    if (notification.type == "SMS")
      return FaIcon(FontAwesomeIcons.sms, size: fntSize, color: clr);
    if (notification.type == "Mobile_Application")
      return FaIcon(FontAwesomeIcons.tablet, size: fntSize, color: clr);
    if (notification.type == "Push_Notification")
      return FaIcon(FontAwesomeIcons.mobileAlt, size: fntSize, color: clr);
    if (notification.type == "WhatsApp")
      return FaIcon(FontAwesomeIcons.whatsapp, size: fntSize, color: clr);

    return FaIcon(FontAwesomeIcons.bell, size: fntSize, color: clr);
  }
}
