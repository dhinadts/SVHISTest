import 'dart:typed_data';
import 'dart:math';
import 'dart:convert';

import '../model/notice_board_response.dart';
import '../model/people.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AvatarBottomSheet extends StatefulWidget {
  final Widget child;
  final Animation<double> animation;
  final NewNotification notification;
  final bool isRecentActivity;
  final People peopleInfo;
  final String profileImage;

  const AvatarBottomSheet(
      {Key key,
      this.child,
      this.animation,
      this.notification,
      this.isRecentActivity,
      this.peopleInfo,
      this.profileImage})
      : super(key: key);

  @override
  _AvatarBottomSheetState createState() => _AvatarBottomSheetState();
}

class _AvatarBottomSheetState extends State<AvatarBottomSheet> {
  Uint8List imageBytes;
  @override
  void initState() {
    loadProfileImage();
    super.initState();
  }

  loadProfileImage() async {
    if (widget.profileImage != null) {
      imageBytes = base64Decode(widget.profileImage);
    } else {
      if (imageBytes == null) {
        // imageBytes.clear();
      } else {
        imageBytes = base64Decode(widget.peopleInfo.profileImage);
      }
    }
    setState(() {
      imageBytes = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("@NAvatar_bottom_sheet --> OTIFICATION DETAILS  --> $notification");
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: widget.isRecentActivity == true
                    ? 20.0
                    : MediaQuery.of(context).size.height / 6),
            SafeArea(
                bottom: false,
                child: AnimatedBuilder(
                  animation: widget.animation,
                  builder: (context, child) => Transform.translate(
                      offset: Offset(0, (1 - widget.animation.value) * 100),
                      child: Opacity(
                          child: child,
                          opacity: max(0, widget.animation.value * 2 - 1))),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 20),
                      CircleAvatar(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.0),
                            child: imageBytes == null
                                ? Image.asset("assets/images/userInfo.png")
                                : (imageBytes != null && imageBytes.length > 0)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                        child: Image.memory(
                                          imageBytes,
                                          fit: BoxFit.fitWidth,
                                          width: double.maxFinite,
                                          height: double.maxFinite,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            return Image.asset(
                                                "assets/images/userInfo.png");
                                          },
                                        ),
                                      )
                                    : widget.peopleInfo != null &&
                                            widget.peopleInfo.profileImage !=
                                                null &&
                                            widget.peopleInfo.profileImage
                                                    .length >
                                                0
                                        ? Container(
                                            height: 55,
                                            width: 55,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                                child: Image.network(
                                                  widget.peopleInfo
                                                      .downloadProfileURL,
                                                  fit: BoxFit.fitWidth,
                                                  width: double.maxFinite,
                                                  height: double.maxFinite,
                                                )))
                                        : buildFAIconByType(
                                            widget.notification)),
                        radius: 32,
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 12),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.black12,
                              spreadRadius: 5)
                        ]),
                    width: double.infinity,
                    child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: widget.child)),
              ),
            ),
          ]),
    );
  }

  buildFAIconByType(NewNotification notification) {
    if (notification.type == "Email")
      return FaIcon(FontAwesomeIcons.envelope, color: Colors.blue, size: 35);
    if (notification.type == "SMS")
      return FaIcon(FontAwesomeIcons.sms, color: Colors.blue, size: 35);
    if (notification.type == "Mobile_Application")
      return FaIcon(FontAwesomeIcons.mobile, color: Colors.blue, size: 35);
    if (notification.type == "Push_Notification")
      return FaIcon(FontAwesomeIcons.mobileAlt, color: Colors.blue, size: 35);
    if (notification.type == "Whatsapp")
      return FaIcon(FontAwesomeIcons.whatsapp, color: Colors.blue, size: 35);
    if (notification.type == "Profile")
      return FaIcon(FontAwesomeIcons.user, color: Colors.blue, size: 35);
    return FaIcon(FontAwesomeIcons.bell, color: Colors.blue, size: 35);
  }
}

Future<T> showAvatarModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  Color backgroundColor,
  bool isRecentActivity,
  double elevation,
  ShapeBorder shape,
  Clip clipBehavior,
  Color barrierColor = Colors.black87,
  bool bounce = true,
  bool expand = false,
  AnimationController secondAnimation,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  Duration duration,
  People people,
  String profileImage,
  @required NewNotification notification,
}) async {
  assert(context != null);
  assert(builder != null);
  assert(expand != null);
  assert(useRootNavigator != null);
  assert(isDismissible != null);
  assert(enableDrag != null);
  // assert(isRecentActivity != null);
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  final result = await Navigator.of(context, rootNavigator: useRootNavigator)
      .push(ModalBottomSheetRoute<T>(
    builder: builder,
    containerBuilder: (_, animation, child) => AvatarBottomSheet(
      child: child,
      animation: animation,
      peopleInfo: people,
      notification: notification,
      isRecentActivity: isRecentActivity,
      profileImage: profileImage,
    ),
    bounce: bounce,
    secondAnimationController: secondAnimation,
    expanded: expand,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: isDismissible,
    modalBarrierColor: barrierColor,
    enableDrag: enableDrag,
    duration: duration,
  ));
  return result;
}
