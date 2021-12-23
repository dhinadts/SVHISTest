import '../login/colors/color_info.dart';
import '../login/common_views.dart';
import '../login/utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';

class TermsAndConditionScreen extends StatefulWidget {
  @override
  TermsAndConditionScreenState createState() => TermsAndConditionScreenState();
}

class TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  bool isTermsAndConditionChecked = false;
  String text = "Disclaimer\n" +
      "The information provided by “SiviSoft Inc” on our mobile application is for general informational purposes only.\n All information on our mobile application is provided in good faith, however we make no representation or warranty of any kind, express or implied, regarding the accuracy, adequacy, validity, reliability, availability or completeness of any information on our mobile application.\n" +
      "Under no circumstance shall we have any liability to you for any loss or damage of any kind incurred as a result of the use of our mobile application or reliance on any information provided on our mobile application.\n Your use of our mobile application and your reliance on any information on our mobile application is solely at your own risk. This application is not substitute for medical advice.\n User of this application should consult their healthcare professional before making any health medicine or other decision based on the data contained herein.\n This disclaimer was created using “SiviSoft Inc” organization.";

  void _onRememberMeChanged(bool newValue) => setState(() {
        isTermsAndConditionChecked = newValue;

        if (isTermsAndConditionChecked) {
          // TODO: Here goes your functionality that remembers the user.
          isTermsAndConditionChecked = true;
        } else {
          // TODO: Forget the user
          isTermsAndConditionChecked = false;
        }

        setState(() {});
      });

  @override
  Widget build(BuildContext context) {
    /// Child View defined here///

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Material(
            child: Scaffold(
                resizeToAvoidBottomPadding: true,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: new Text(
                    "Terms & Conditions",
                    style: TextStyle(color: Colors.black),
                  ),
                  centerTitle: true,
                  elevation: 1.0,
                ),
                bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: isTermsAndConditionChecked,
                          activeColor: Color(ColorInfo.APP_BLUE),
                          onChanged: _onRememberMeChanged,
                        ),
                        new Text(
                          "Terms & Conditions",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color(ColorInfo.DARK_GRAY)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: new InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: new Container(
                                    height: 50.0,
                                    width: 120.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                      ),
                                      color: Color(ColorInfo.APP_BLUE),
                                    ),
                                    child: new Center(
                                        child: new Row(
                                      children: <Widget>[
                                        new Expanded(
                                          child: new Text(
                                            "Submit",
                                            style:
                                                CommonViews.textStyleWithWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                          flex: 1,
                                        ),
                                        new Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0, 15, 0),
                                            child: new Icon(
                                              Icons.play_circle_filled,
                                              size: 25.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          flex: 0,
                                        )
                                      ],
                                    )))),
                            onTap: () async {
                              //Click

                              if (isTermsAndConditionChecked) {
                                AppPreferences.setTermsAcceptance(true);
                                await AppPreferences().init();
                                Navigator.pushReplacementNamed(
                                    context, Routes.login);
                              } else {
                                Utils.toasterMessage(
                                    "Please accept the Terms & Conditions");
                              }
                            },
                          ),
                        ),
                      ],
                    )),
                backgroundColor: Colors.white,
                body: new Container(
                    margin: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.blueAccent)),
                    height: MediaQuery.of(context).size.height / 1.35,
                    //color: Colors.white,
                    child: Scrollbar(
                        child: SingleChildScrollView(
                            reverse: false,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Container(
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: Constants.LatoRegular),
                                  ),
                                )
                              ],
                            )))))));
  }
}
