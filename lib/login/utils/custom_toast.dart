import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void getToastLong(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.TOP);
  }

  static void getToasShort(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.TOP);
  }
}
