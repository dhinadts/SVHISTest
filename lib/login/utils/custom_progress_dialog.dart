import '../../login/colors/color_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressLoader {
  static showLoader(context, {String title}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Material(
            color: Colors.transparent,
            child: Center(
                // Aligns the container to center
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Color(ColorInfo.APP_BLUE)
                            : Color(ColorInfo.APP_GREEN),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title ?? "",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                )
              ],
            ))));
  }

  static cancelLoader(context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  static void showDialogBackDialog(context1) {
    // flutter defined function
    showDialog(
      context: context1,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are you sure you want to exit?",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
                  style: new TextStyle()),
              onPressed: () {
                Navigator.of(context).pop(true);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: new TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showDialogBackDialogWithPush(context1) {
    // flutter defined function
    showDialog(
      context: context1,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are you sure you want to exit?",
            style: TextStyle(fontSize: 15.0,),
          ),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
                  style: new TextStyle()),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.pop(context, "push");
              },
            ),
            new FlatButton(
              child: new Text("No",
                  style: new TextStyle()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showDialogBackDialogWithPop(context1) {
    // flutter defined function
    showDialog(
      context: context1,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are you sure you want to exit?",
            style: TextStyle(fontSize: 15.0,),
          ),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
                  style: new TextStyle()),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("No",
                  style: new TextStyle()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
