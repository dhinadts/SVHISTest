import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  final String status;

  StatusTag(this.status);

  @override
  Widget build(BuildContext context) {
    String status =
        this.status == null || this.status.isEmpty ? "pending" : this.status;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      margin: EdgeInsets.fromLTRB(10, 12, 5, 10),
      //height: 24,
      decoration: new BoxDecoration(
          color: getStatusColorForMessageStatus(status),
          borderRadius: new BorderRadius.all(Radius.circular(12.0))),
      child: Center(
          child: Text(
        "$status".toUpperCase(),
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  Color getStatusColorForMessageStatus(String messageStatus) {
    if (messageStatus == "success" ||
        messageStatus == "success".toUpperCase()) {
      return Colors.green;
    } else if (messageStatus != null &&
        messageStatus.toLowerCase().contains("pending")) {
      return Colors.orange;
    }
    // print(" Message Status $messageStatus");
    return Colors.red;
  }
}
