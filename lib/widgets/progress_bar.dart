import '../ui_utils/ui_dimens.dart';
import 'package:flutter/material.dart';

class ProgressCircle {
  final BuildContext context;
  bool isShowing = false;

  ProgressCircle(this.context);

  void showProgressBar(String resourceKey, {String text}) {
    if (isShowing) {
      hideProgressBar();
    }
    isShowing = true;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8.0),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Padding(
                    padding: EdgeInsets.all(AppUIDimens.paddingSmall),
                    child: Text(
                      text ?? "Please wait",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )),
              ],
            ))));
  }

  void hideProgressBar() {
    if (isShowing) {
      Navigator.pop(context);
      isShowing = false;
    }
  }
}
