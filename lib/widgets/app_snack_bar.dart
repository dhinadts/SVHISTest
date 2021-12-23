import 'package:flutter/material.dart';

class AppSnackBar {
  final String message;
  final String actionText;
  final VoidCallback onPressed;

  const AppSnackBar({@required this.message, this.actionText, this.onPressed});

  void showAppSnackBar(BuildContext context, {ScaffoldState scaffoldState}) {
    SnackBarAction snackBarAction;
    if (actionText != null && actionText.isNotEmpty && onPressed != null) {
      snackBarAction = SnackBarAction(label: actionText, onPressed: onPressed);
    }

    SnackBar snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      content: Text(message,
          textAlign: TextAlign.left,
          softWrap: true,
          style: TextStyle(color: Colors.white)),
      action: snackBarAction,
    );
    if (scaffoldState == null) {
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      scaffoldState.showSnackBar(snackBar);
    }
  }
}
