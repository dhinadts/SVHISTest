import '../login/preferences/user_preference.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../ui_utils/app_colors.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';

import 'colors/color_info.dart';

class CommonViews {
  static var textStyleWithBlack = TextStyle(
      color: Color(ColorInfo.BLACK),
      //fontFamily: Constants.LatoRegular,
      fontSize: 18.0);
  static var textStyleWithWhite =
      TextStyle(color: Colors.white, fontSize: 14.0);

  static bool isSearchEnable = false;

  static Widget getAppBar(String screenTitle, String uiPath,
      BuildContext context, String count, _scaffoldKey) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(ColorInfo.WHITE)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryColor,
      titleSpacing: 2.0,
      elevation: 0.0,
      brightness: Brightness.light,
      title: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(screenTitle,
              textAlign: TextAlign.center,
              style: AppPreferences().isLanguageTamil()
                  ? TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)
                  : TextStyle(color: Colors.white)),
        ],
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.navigatorHomeScreen));
            })
      ],
    );
  }

  static Widget getButtonView(
      double width, String text, int color, int textColor) {
    return new Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Color(color),
      ),
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: new Container(
            width: width,
            height: 40.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5), color: Colors.white),
            child: Center(
              child: new Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Color(textColor))),
            ),
          )),
    );
  }

  static Widget getRoundedButton(
      String buttonText, int colorName, double height, double textSize) {
    return new Padding(
        padding: new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: new GestureDetector(
          child: new Container(
              child: new Container(
            height: height,
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
              color: new Color(colorName),
              borderRadius: new BorderRadius.all(const Radius.circular(25.0)),
            ),
            child: new Padding(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                child: new Text(
                  buttonText,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                  ),
                )),
          )),
        ));
  }

  static var textStyleWithBlackNormal = TextStyle(
      color: Color(ColorInfo.BLACK).withOpacity(0.4),
      fontSize: 16.0);

  static Widget getAppBarWithBack(
      String screenTitle, String uiPath, BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(ColorInfo.APP_GRAY)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(
            screenTitle,
            textAlign: TextAlign.center,
            style: textStyleWithBlack,
          ),
        ],
      ),
      actions: <Widget>[
        new Container(
          width: 50.0,
        )
      ],
    );
  }

  static Widget getAppBarWithBackWithCart(String screenTitle, String uiPath,
      BuildContext context, String cartCount) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(ColorInfo.APP_GRAY)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(
            screenTitle,
            textAlign: TextAlign.center,
            style: textStyleWithBlack,
          ),
        ],
      ),
      actions: <Widget>[
        InkWell(
          child: new Stack(
            children: <Widget>[
              new Container(
                height: 60.0,
                width: 45.0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: new Icon(
                    Icons.shopping_cart,
                    color: Colors.black45,
                    size: 35.0,
                  ),
                ),
              ),
              new Positioned(
                child: new Container(
                  height: 20.0,
                  width: 20.0,
                  //I used some padding without fixed width and height
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    // You can use like this way or like the below line
                    //borderRadius: new BorderRadius.circular(30.0),
                    color: Color(ColorInfo.APP_RED).withOpacity(0.9),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: new Text(
                      UserPreference.getCartCount() != null &&
                              UserPreference.getCartCount() != "0"
                          ? UserPreference.getCartCount()
                          : "",
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ),
                ), //............
              ),
            ],
          ),
          onTap: () {},
        ),
      ],
    );
  }

  static Widget getBlackAppBarWithBack(
      String screenTitle, String uiPath, BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new Text(
              screenTitle,
              textAlign: TextAlign.center,
              style: textStyleWithWhite,
            ),
            flex: 1,
          )
        ],
      ),
      actions: <Widget>[
        new Container(
          width: 50.0,
        )
      ],
    );
  }

  static TextStyle getStyle(int colorName) {
    var textStyleWithBlack = TextStyle(
        color: Color(colorName),
        fontFamily: Constants.LatoBold,
        fontSize: 18.0);

    return textStyleWithBlack;
  }

  static Widget getTrioxAppBar(context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(ColorInfo.APP_GRAY)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        new InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: new Icon(
                Icons.filter_list,
                color: Colors.black45,
                size: 30.0,
              ),
            ),
            onTap: () {}),
        new InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: new Icon(
                Icons.shopping_cart,
                color: Colors.black45,
                size: 30.0,
              ),
            ),
            onTap: () {}),
      ],
      title: new Row(
        children: <Widget>[
          new Center(
              child: new Text(
            "Add Customer",
            textAlign: TextAlign.center,
            style: getStyle(ColorInfo.APP_GRAY),
          )),
        ],
      ),
    );
  }

  static Widget getUserAppBar(
      String screenTitle, String uiPath, BuildContext context, String count) {
    return AppBar(
      title: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            width: 10.0,
          ),
          new Text(
            screenTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(ColorInfo.APP_GRAY),
                fontFamily: Constants.LatoRegular,
                fontSize: 14.0),
          ),
        ],
      ),
      actions: <Widget>[
        InkWell(
          child: new Stack(
            children: <Widget>[
              new Container(
                  height: 60.0,
                  width: 45.0,
                  child: new InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: new Icon(
                          Icons.shopping_cart,
                          color: Colors.black45,
                          size: 35.0,
                        ),
                      ),
                      onTap: () {})),
              new Positioned(
                child: new Container(
                  height: 20.0,
                  width: 20.0,
                  //I used some padding without fixed width and height
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    // You can use like this way or like the below line
                    //borderRadius: new BorderRadius.circular(30.0),
                    color: Color(ColorInfo.APP_RED).withOpacity(0.9),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: new Text(
                      UserPreference.getCartCount() != null &&
                              UserPreference.getCartCount() != "0"
                          ? UserPreference.getCartCount()
                          : "",
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ),
                  // You can add a Icon instead of text also, like below.
                  //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                ), //............
              ),
            ],
          ),
          onTap: () {
            // print("Alok");
          },
        ),
      ],
    );
  }

  static Widget getBlankDataView() {
    return new Column(
      children: <Widget>[
        Image.asset(
          'assets/images/no_category.png',
          width: 200.0,
          height: 200.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: new Text(
            "No records found for this selection.",
            style: TextStyle(
                color: Color(ColorInfo.APP_RED),
                fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  static Widget getBlankDataViewWithSmily() {
    return new Container(
        child: new Column(
      children: <Widget>[
        Image.asset(
          'assets/images/no_product.png',
          width: 200.0,
          height: 200.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: new Text(
            "No records found.",
            style: TextStyle(
                color: Color(ColorInfo.APP_RED),
                fontSize: 22.0),
          ),
        ),
      ],
    ));
  }
}
