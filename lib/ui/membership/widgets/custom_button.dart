import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final double width;
  final double height;
  final double fontSize;
  final double borderRadius;
  final Icon icon;
  final Color buttonColor;

  CustomButton({
    @required this.onPressed,
    this.buttonText,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius,
    this.icon,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50.0,
      width: width,
      child: RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              buttonText ?? "Next",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize ?? 16.0,
              ),
            ),
            if (icon != null) icon,
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 7.0),
        ),
        color: buttonColor ?? Color(0xff2ab0a1),
        onPressed: onPressed,
      ),
    );
  }
}
