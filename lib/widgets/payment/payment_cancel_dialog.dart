import 'package:flutter/material.dart';

class PaymentCancellationDialog extends StatelessWidget {
  final Function() onTap;

  const PaymentCancellationDialog({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Do you want to cancel the Payment?"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "No",
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            "Yes",
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onTap();
          },
        )
      ],
    );
  }
}
