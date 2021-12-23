import '../../../model/people.dart';
import '../../../model/user_info.dart';
import '../../../repo/auth_repository.dart';
import '../../../ui/diabetes_risk_score/diabetes_risk_score_screen.dart';
import '../../../ui/diabetes_risk_score/model/health_score.dart';
import '../../../ui/diabetes_risk_score/widgets/diabetes_risk_score_list_item.dart';
import '../../../ui/tabs/app_localizations.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/widget_styles.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import 'package:flutter/material.dart';

class DiabetesRiskScoreListWidget extends StatefulWidget {
  final List<HealthScore> healthScore;
  final People people;

  DiabetesRiskScoreListWidget({this.healthScore, this.people});

  @override
  DiabetesRiskScoreListWidgetState createState() =>
      DiabetesRiskScoreListWidgetState();
}

class DiabetesRiskScoreListWidgetState
    extends State<DiabetesRiskScoreListWidget> {
  AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = new AuthRepository();
  }

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
                  return DiabetesRiskScoreListItem(
                    healthScoreData: widget.healthScore[index],
                    onPress: () async {
                      UserInfo userInfo;
                      if (AppPreferences().role == Constants.supervisorRole) {
                        userInfo = await _authRepository
                            .getUserInfo(widget.people.userName);
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiabetesRiskScoreScreen(
                            healthScoreData: widget.healthScore[index],
                            userInfo: userInfo,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                AppLocalizations.of(context).translate("key_date"),
                style: AppPreferences().isLanguageTamil()
                    ? TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
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
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.all(15),
              child: Text(
                AppLocalizations.of(context).translate("key_risk_level"),
                style: AppPreferences().isLanguageTamil()
                    ? TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
