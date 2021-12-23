import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final IconData iconData;
  final Color buttonColor;
  final Color textColor;

  const RoundedButton({
    Key key,
    this.text,
    this.iconData,
    @required this.onTap,
    @required this.buttonColor,
    @required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EaseInWidget(
      onTap: onTap,
      child: Material(
        child: Container(
          padding: text != null
              ? EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)
              : EdgeInsets.symmetric(vertical: 19.0, horizontal: 22.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    blurRadius: 12.0,
                    spreadRadius: 0.1)
              ]),
          child: text != null
              ? Text(
                  "$text",
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: textColor,
                        fontSize: 16,
                      ),
                )
              : Icon(
                  iconData,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
