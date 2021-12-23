import '../login/stateLessWidget/upper_logo_widget.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/ui_dimens.dart';
import 'package:flutter/material.dart';

class RootedDeviceMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          UpperLogoWidget(),
          Container(
            margin: EdgeInsets.all(AppUIDimens.marginXXLarge),
            child: Text(
              "Rooted Device",
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppUIDimens.marginXXLarge),
            child: Text(
              "Sorry!, we are unable to support in your device. Because, your device is rooted. Please try some other device to use our app.",
              textAlign: TextAlign.center,
              /*style: TextStyle(color: AppColors.arrivedColor)*/
            ),
          )
        ]);
  }

}
