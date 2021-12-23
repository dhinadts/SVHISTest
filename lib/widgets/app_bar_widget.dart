import 'dart:io';

import '../ui_utils/ui_dimens.dart';
import '../ui_utils/widget_styles.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget titleText;
  final GestureTapCallback onPressed;

  const AppBarWidget({Key key, this.onPressed, this.titleText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        padding: EdgeInsets.only(
            left: AppUIDimens.paddingMedium,
            top: AppUIDimens.paddingMedium,
            bottom: AppUIDimens.paddingMedium),
        icon: Icon(WidgetStyles.backIcon),
        alignment: Alignment.centerLeft,
        onPressed: onPressed,
        color: Theme.of(context).accentColor,
      ),
      backgroundColor: Colors.white,
      brightness: Platform.isIOS ? Brightness.light : null,
      title: titleText,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
