import 'package:flutter/material.dart';

class ModeTag extends StatelessWidget {
  final String mode;
  final bool leading;
  final bool capsLockOff;

  ModeTag(this.mode, {this.leading: false, this.capsLockOff: false});

  @override
  Widget build(BuildContext context) {
    String status = this.mode == null || this.mode.isEmpty ? "CASH" : this.mode;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        margin: EdgeInsets.fromLTRB(10, 12, 5, 10),
        decoration: new BoxDecoration(
            border: Border.all(color: Colors.grey[leading ? 700 : 500]),
            borderRadius: new BorderRadius.all(Radius.circular(3.0))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Center(
            child: Text(
              capsLockOff ? "$status" : "$status".toUpperCase(),
              style: TextStyle(color: Colors.grey[leading ? 700 : 500]),
            ),
          ),
          if (leading)
            SizedBox(
              width: 10,
            ),
          if (leading)
            Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.grey[700],
            )
        ]));
  }
}
