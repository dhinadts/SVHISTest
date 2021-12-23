import '../../bloc/user_info_bloc.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../ui/global_config/tabs/global_config_registration_screen.dart';
import '../../ui/global_configuration_page.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalConfigTabbedScreen extends StatefulWidget {
  final String token;
  UserInfoBloc bloc;

  GlobalConfigTabbedScreen({this.token, this.bloc});

  @override
  PersonalTabbedInfoState createState() => PersonalTabbedInfoState();
}

class PersonalTabbedInfoState extends State<GlobalConfigTabbedScreen>
    with SingleTickerProviderStateMixin {
  String token = "";

  @override
  void initState() {
    if (widget.bloc == null) {
      widget.bloc = UserInfoBloc(context);
    }
    setState(() {
      this.token = widget.token;
    });

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  TabController _tabController;

  @override
  void didChangeDependencies() {
    AppPreferences.setGCPageIsShowing(true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setContext(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.11),
          child: AppBar(
            // title: Text("Global Configuration"),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: Image.asset("assets/images/ic_config.png"),
                  child: Text(
                    "Have Promo Code?",
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
                Tab(
                    icon: Image.asset("assets/images/ic_register.png"),
                    child: Text(
                      "New Group / Organization?",
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    )),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: ScrollPhysics(parent: PageScrollPhysics()),
          children: [
            GlobalConfigurationPage(
              token: token,
              bloc: widget.bloc,
            ),
            GlobalConfigRegistrationTab(
              bloc: widget.bloc,
              simplifyLogDetailsCallBack: (simplifyLogDetails) {
                if (simplifyLogDetails?.userPromoCode != null &&
                    simplifyLogDetails.userPromoCode.isNotEmpty) {
                  _tabController.animateTo(0);
                  CustomProgressLoader.showLoader(context);
                  new Future.delayed(const Duration(milliseconds: 300), () {
                    widget.bloc.simplifyLoginDetails(simplifyLogDetails);
                    CustomProgressLoader.cancelLoader(context);
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    AppPreferences.setGCPageIsShowing(false);
    super.dispose();
  }
}
