import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title1;
  final String title2;

  TitleWidget({this.title1, this.title2});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.arrivedColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 25),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    title1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
          SizedBox(
            width: 100,
          ),
          Container(
              margin: EdgeInsets.only(right: 25),
              padding: EdgeInsets.all(15),
              child: Text(
                title2,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
        ],
      ),
    );
  }
}
