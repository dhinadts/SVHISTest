import '../../bloc/user_info_validation_bloc.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final int pageId;
  final UserInfoValidationBloc actionBloc;
  final TabBar tabBar;

  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.pageId,
    this.actionBloc,
    this.tabBar,
  }) : super(key: key);
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => (tabBar != null)
      ? Size.fromHeight(kToolbarHeight + kTextTabBarHeight + 30)
      : Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      iconTheme: new IconThemeData(color: Colors.white),
      title: Text(
        widget.title,
        style: AppPreferences().isLanguageTamil()
            ? TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
            : TextStyle(color: Colors.white),
      ),
      actions: (widget.pageId == Constants.PAGE_PERSONAL_INFORMATION)
          ? <Widget>[
              if (false)
                FlatButton(
                  onPressed: () async {
                    widget.actionBloc.actionCallAPI();
                  },
                  child: Container(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate("key_update"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
            ]
          : <Widget>[
              widget.pageId != Constants.PAGE_ID_HOME
                  ? Row(
                      children: <Widget>[
//                        widget.pageId == Constants.PAGE_ID_PEOPLE_LIST &&
//                                AppPreferences().role ==
//                                    Constants.supervisorRole
//                            ? IconButton(
//                                icon: Icon(
//                                  Icons.notifications_active,
//                                  color: Colors.white,
//                                ),
//                                onPressed: () {
//                                  Navigator.pushNamed(
//                                    context,
//                                    Routes.dailyWellnessReminderScreen,
//                                  );
//                                })
//                            : Container(),
                        IconButton(
                            icon: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              //replaceHome();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NavigationHomeScreen()),
                                  ModalRoute.withName(Routes.dashBoard));
                            }),
                      ],
                    )
                  : Container()
            ],
      bottom: widget.tabBar,
    );
  }
}
