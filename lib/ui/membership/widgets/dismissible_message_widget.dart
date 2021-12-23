import 'package:flutter/material.dart';

class DismissibleMessageWidget extends StatefulWidget {
  final String msg;
  final IconData icon;
  final Color color;
  final Color textColor;

  const DismissibleMessageWidget({
    this.msg,
    this.icon = Icons.info_outline,
    this.color = Colors.blueGrey,
    this.textColor = Colors.white,
  });

  @override
  DismissibleMessageWidgetState createState() {
    return new DismissibleMessageWidgetState();
  }
}

class DismissibleMessageWidgetState extends State<DismissibleMessageWidget> {
  var _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) {
      return Container();
    }
    return Container(
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(widget.icon, color: widget.textColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  widget.msg,
                  style: TextStyle(color: widget.textColor),
                ),
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.close),
            //   color: widget.textColor,
            //   onPressed: () {
            //     setState(() {
            //       _isDismissed = true;
            //     });
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
