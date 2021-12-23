import '../../../ui/diabetes_risk_score/model/health_score.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';

class ProspectsRiskScoreListItem extends StatelessWidget {
  final HealthScore healthScoreData;
  final GestureTapCallback onPress;

  ProspectsRiskScoreListItem({
    this.healthScoreData,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    //DateTime dateTime = DateTime.parse(healthScoreData.modifiedOn.toString());
    //dateTime = DateTime.utc(dateTime.year, dateTime.month, dateTime.day,
    //dateTime.hour, dateTime.minute, dateTime.second);

    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 7,
                          ),
                          Image.asset(
                            "assets/images/search_icon.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            child: Flexible(
                              child: Text(
                                "${healthScoreData.firstName} ${healthScoreData.lastName}",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: 90,
                      child: Text(
                        DateUtils.convertUTCToLocalTime(
                            healthScoreData.createdOn),
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 75,
                      child: Text(
                        '${healthScoreData.scorePoints.toInt()}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  //margin: EdgeInsets.symmetric(horizontal: 7),
                  height: 1,
                  color: AppColors.borderLine,
                ),
                Container(
                  width: double.infinity,
                  //margin: EdgeInsets.symmetric(horizontal: 7),
                  height: 5,
                  color: AppColors.borderShadow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
