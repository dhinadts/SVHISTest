import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';

class CouponCodeDialog extends StatefulWidget {
  final String couponCode;
  const CouponCodeDialog({Key key, @required this.couponCode})
      : super(key: key);
  @override
  _CouponCodeDialogState createState() => new _CouponCodeDialogState();
}

class _CouponCodeDialogState extends State<CouponCodeDialog> {
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _textFieldController.text = widget.couponCode;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Enter your coupon code'),
      content: TextField(
        maxLength: 8,
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Enter code"),
      ),
      actions: <Widget>[
        FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text('Submit'),
            onPressed: () {
              apiCall();
            })
      ],
    );
  }

  apiCall() async {
    if (_textFieldController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter coupon code",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    } else {
      http.Response response = await http.get(WebserviceConstants
              .baseAppointmentURL +
          "/v2/coupon_availability/${_textFieldController.text}/department/${AppPreferences().deptmentName}/patient/${AppPreferences().username}");
      if (response.statusCode == 200) {
        if (response.body.toString().trim() == "Invalid Coupon Code") {
          Fluttertoast.showToast(
              msg: response.body.toString().trim(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        } else if (response.body.toString().trim() ==
            "Appointment Not yet Booked") {
          Fluttertoast.showToast(
              msg: "Coupon code applied successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
          Navigator.pop(context, _textFieldController.text.trim());
        } else {
          Fluttertoast.showToast(
              msg: "Please enter invalid coupon code",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
      }
    }
  }
}
