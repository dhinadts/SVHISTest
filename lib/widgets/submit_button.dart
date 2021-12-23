import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  final TextStyle textStyle;
  final Color color;
  final String roundedSide;
  SubmitButton(
      {this.onPress,
      this.text,
      this.textStyle: const TextStyle(color: Colors.white),
      this.roundedSide,
      this.color});

  Widget build(BuildContext context) {
    double left = 0;
    double right = 0;
    if (roundedSide == "left") {
      left = 20;
      right = 0;
    } else {
      right = 20;
      left = 0;
    }
    return Stack(children: <Widget>[
      RaisedButton(
        padding: EdgeInsets.fromLTRB(13, 13, 23, 13),
        color: color != null ? color : AppColors.arrivedColor,
        child: Text(
          text ?? AppLocalizations.of(context).translate("key_finish"),
          style: textStyle,
        ),
        onPressed: onPress,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(right), topLeft: Radius.circular(left)),
        ),
      ),
//          Icon(Icons.navigate_next,color: Colors.white,)
    ]);
  }
}
