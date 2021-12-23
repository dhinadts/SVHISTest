import 'package:flutter/material.dart';

import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/widget_styles.dart';
import '../../../utils/app_preferences.dart';
import '../../tabs/app_localizations.dart';
import '../diabetes_risk_score_screen.dart';
import '../model/health_score.dart';
import 'prospect_risk_score_list_item.dart';

class ProspectsRiskScoreListWidget extends StatefulWidget {
  final List<HealthScore> healthScore;

  //final People people;

  ProspectsRiskScoreListWidget({this.healthScore});

  @override
  ProspectsRiskScoreListWidgetState createState() =>
      ProspectsRiskScoreListWidgetState();
}

class ProspectsRiskScoreListWidgetState
    extends State<ProspectsRiskScoreListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: WidgetStyles.cardBoxShadow),
        child: Column(
          children: <Widget>[
            _userTitleText(),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: widget.healthScore.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProspectsRiskScoreListItem(
                    healthScoreData: widget.healthScore[index],
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiabetesRiskScoreScreen(
                            healthScoreData: widget.healthScore[index],
                            //people: widget.people,
                            isProspect: true,
                          ),
                        ),
                      );
                    },
                  );
                }),
          ],
        ));
  }

  Widget _userTitleText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.arrivedColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          )),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 37,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 90,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Date",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Container(
              width: 80,
              margin: EdgeInsets.only(left: 5.0),
              padding: EdgeInsets.all(15),
              child: Text(
                AppLocalizations.of(context).translate("key_score"),
                style: AppPreferences().isLanguageTamil()
                    ? TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
