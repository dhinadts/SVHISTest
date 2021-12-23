import '../../login/colors/color_info.dart';
import '../../login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static SharedPreferences prefs;
  static const String USER_ID = 'userId';
  static const String ROLE_ID = 'RoleId';
  static const String USER_EMAIL = 'userEmail';
  static const String USER_NAME = 'userName';
  static const String LOGIN_STATUS = 'loginStatus';
  static const String ACCESS_TOKEN = 'accessToken';
  static const String IS_VERIFIED = 'isVerified';
  static const String IS_TUTORIAL_VISITED = 'isTutorialVisited';
  static const String IS_PLAN_PURCHASED = 'isPlanPurchased';
  static const String TPF_CODE = 'tpf_Code';
  static const String PLAN_NAME = 'plan_Name';
  static const String PLAN_ID = 'plan_id';
  static const String USER_IMAGE = 'userImage';
  static const String THEME_ID = 'themeId'; // 1 and 2 for  White and Black
  static const String FCM_TOKEN = 'fcmToken';
  static const String QUALIFIED_MEMBER = 'qualifiedMember';

  static const String IS_REFER_PAGE_VISITED = 'referPageVisisted';

  static const String IS_INVITATION_PAGE_VISITED = 'invitePageVisited';

  static const String PROFILE_URL_SHARING = 'invitePageVisited';

  static const String SHARED_TFP = 'sharedTfp';

  static const String REMEMBER_ME = 'remmeberMe';

  static const String MOBILE = 'mobile';

  static const String USER_TYPE = 'userTypes';

  static const String CART_COUNT = 'cartCount';

  static void setCartCount(String cartCount) {
    prefs.setString(CART_COUNT, cartCount);
  }

  static String getCartCount() {
    return prefs.getString(CART_COUNT);
  }

  static Future initSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void setMobile(String mobile) {
    prefs.setString(MOBILE, mobile);
  }

  static String getMobile() {
    return prefs.getString(MOBILE);
  }

  static void setUserType(String userType) {
    prefs.setString(USER_TYPE, userType);
  }

  static String getUserType() {
    return prefs.getString(USER_TYPE);
  }

  static void setRememberMe(bool status) {
    prefs.setBool(REMEMBER_ME, status);
  }

  static bool isRemeber() {
    return prefs.getBool(REMEMBER_ME);
  }

  static void initBoolData() {
    setLoginStatus(false);
  }

  static void setSharedTFP(String sharedOTP) {
    prefs.setString(SHARED_TFP, sharedOTP);
  }

  static String getSharedTFP() {
    return prefs.getString(SHARED_TFP);
  }

  static void setReferPageVistingStatus(bool status) {
    prefs.setBool(IS_REFER_PAGE_VISITED, status);
  }

  static bool getReferPageVistingStatus() {
    return prefs.getBool(IS_REFER_PAGE_VISITED);
  }

  static void setInvitationPageVisitingStatus(bool status) {
    prefs.setBool(IS_INVITATION_PAGE_VISITED, status);
  }

  static bool getInvitationPageVisitingStatus() {
    return prefs.getBool(IS_INVITATION_PAGE_VISITED);
  }

  static void setQualifiedMemberStatus(String status) {
    prefs.setString(QUALIFIED_MEMBER, status);
  }

  static String getQualifiedMemberStatus() {
    return prefs.getString(QUALIFIED_MEMBER);
  }

  static void setFcmToken(String status) {
    prefs.setString(FCM_TOKEN, status);
  }

  static String getFcmToken() {
    return prefs.getString(FCM_TOKEN);
  }

  static void setPlanName(String status) {
    prefs.setString(PLAN_NAME, status);
  }

  static String getPlanName() {
    return prefs.getString(PLAN_NAME);
  }

  static void setPlanId(String status) {
    prefs.setString(PLAN_ID, status);
  }

  static String getPlanId() {
    return prefs.getString(PLAN_ID);
  }

  static void setPlanPurchased(bool status) {
    prefs.setBool(IS_PLAN_PURCHASED, status);
  }

  static bool isPlanPurchased() {
    return prefs.getBool(IS_PLAN_PURCHASED);
  }

  static void setTutorialVisit(String status) {
    prefs.setString(IS_TUTORIAL_VISITED, status);
  }

  static String isTutorialVisited() {
    return prefs.getString(IS_TUTORIAL_VISITED);
  }

  static void setUserId(String userId) {
    prefs.setString(USER_ID, userId);
  }

  static String getUserId() {
    return prefs.getString(USER_ID);
  }

  static void setRoleId(String roleId) {
    prefs.setString(ROLE_ID, roleId);
  }

  static String getRoleId() {
    return prefs.getString(ROLE_ID);
  }

  static void setUserEmail(String email) {
    prefs.setString(USER_EMAIL, email);
  }

  static String getUserEmail() {
    return prefs.getString(USER_EMAIL);
  }

  static void setUserName(String name) {
    prefs.setString(USER_NAME, name);
  }

  static String getUserName() {
    return prefs.getString(USER_NAME);
  }

  static void setLoginStatus(bool status) {
    prefs.setBool(LOGIN_STATUS, status);
  }

  static bool getLoginStatus() {
    return prefs.getBool(LOGIN_STATUS);
  }

  static void setAccessToken(String token) {
    prefs.setString(ACCESS_TOKEN, token);
  }

  static String getAccessToken() {
    return prefs.getString(ACCESS_TOKEN);
  }

  static void setPlanPin(String pin) {
    prefs.setString(TPF_CODE, pin);
  }

  static String getPlanPin() {
    return prefs.getString(TPF_CODE);
  }

  static void setIsVerified(String status) {
    prefs.setString(IS_VERIFIED, status);
  }

  static String isVerified() {
    return prefs.get(IS_VERIFIED);
  }

  static void setTheme(String themeId) {
    prefs.setString(THEME_ID, themeId);
  }

  static String getTheme() {
    return prefs.get(THEME_ID);
  }

  static void logoutSession(BuildContext context, bool theme) {
    confirmationDialogBox(context, theme);
  }

  static String getImage() {
    if (prefs.getString(USER_IMAGE) != null) {
      return prefs.getString(USER_IMAGE);
    } else {
      return "";
    }
  }

  static void setImage(String status) {
    prefs.setString(USER_IMAGE, status);
  }

  static Future confirmationDialogBox(BuildContext context, bool isLightTheme) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: isLightTheme ? Colors.white : Color(0xff1d2025),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              height: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Alert!",
                        style: TextStyle(
                            fontSize: 24.0,
                            color: isLightTheme ? Colors.black : Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  new Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text("Do you really want to logout?",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: isLightTheme ? Colors.black : Colors.white,
                          )),
                    ),
                    flex: 0,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(90.0)),
                            onPressed: () {
                              cancel(context);
                            },
                            textColor: Colors.white,
                            color: Color(ColorInfo.APP_GRAY),
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                            child: new Text("Cancel",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isLightTheme
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          ),
                          new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(90.0)),
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                            textColor: Colors.white,
                            color: Color(ColorInfo.APP_RED),
                            onPressed: () {
                              logout(context);
                            },
                            child: new Text("Proceed",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isLightTheme
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }

  static void cancel(BuildContext context) {
    Navigator.pop(context);
  }

  static void logout(BuildContext context) {
    Navigator.pop(context);
    setLoginStatus(false);

    clearPreference();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  static void clearPreference() {
    prefs.clear();
  }
}
