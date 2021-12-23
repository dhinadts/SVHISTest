import '../../../ui/diabetes_risk_score/model/health_score.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';

class DiabetesRiskScoreListItem extends StatelessWidget {
  final HealthScore healthScoreData;
  final GestureTapCallback onPress;

  DiabetesRiskScoreListItem({
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
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, right: 15, left: 15),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 7,
                      ),
                      // Image.asset(
                      //   "assets/images/search_icon.png",
                      //   height: 30,
                      //   width: 30,
                      // ),
                      // SizedBox(
                      //   width: 10.0,
                      // ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                DateUtils.convertUTCToLocalTime(
                                    healthScoreData.createdOn),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${healthScoreData.scorePoints.toInt()}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                healthScoreData.riskLevel,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
