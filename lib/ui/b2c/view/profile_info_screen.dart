import '../../../login/preferences/user_preference.dart';
import '../../../ui/b2c/bloc/staticDetails_bloc.dart';
import '../../../ui/b2c/bloc/userDetails_bloc.dart';
import '../../../ui/b2c/model/category_model.dart';
import '../../../ui/b2c/model/user_details_model.dart';
import '../../../ui/b2c/view/profile_category_tab_screen.dart';
import '../../../ui/b2c/view/profile_update_tab_screen.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileInfoScreen extends StatefulWidget {
  final UserDetailsModel userDetailsData;
  final bool isProfile;

  const ProfileInfoScreen({Key key, this.userDetailsData, this.isProfile})
      : super(key: key);

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen>
    with SingleTickerProviderStateMixin {
  static final myTabbedPageKey = new GlobalKey<_ProfileInfoScreenState>();

  int _tabIndex = 0;

  TabController tabController;

  List<String> countyList = new List();
  List<String> stateList = new List();
  List<String> categoryList = new List();
  List<ProfileCategoryModel> profileCategoryList = new List();
  final List<DropdownMenuItem> dropDownCountyList = [];
  final List<DropdownMenuItem> dropDownStateList = [];
  final List<DropdownMenuItem> dropDownCategoryList = [];
  List<String> subCategoryList = new List();
  List<DropdownMenuItem> dropDownSubCategoryList = [];
  List<DropdownMenuItem> dropDownMatchedSubCategoryList = [];

  UserDetailsModel userDetailsData = new UserDetailsModel();

  bool isUserDetailLoading = false;
  bool isProfileCategoryListLoading = false;
  bool isCountyListLoading = false;
  bool isStateListLoading = false;
  bool isCategoryListLoading = false;
  bool isNewUser = false;

  @override
  void initState() {
    // print("widget.isProfile ${widget.isProfile}");
    tabController = new TabController(
      length: 2,
      vsync: this,
    );

    setState(() {
      widget.isProfile == false
          ? isUserDetailLoading = false
          : isUserDetailLoading = true;
      widget.isProfile == false
          ? isProfileCategoryListLoading = false
          : isProfileCategoryListLoading = true;
      isCountyListLoading = true;
      isStateListLoading = true;
      isCategoryListLoading = true;
    });
    if (widget.isProfile == false) {
    } else {
      getUserProfileDetails();
      getProfileCategoryList();
    }

    getCountyList();
    getStateList();
    getCategoryList();

    super.initState();
  }

  void _toggleTab() {
    _tabIndex = tabController.index + 1;
    tabController.animateTo(_tabIndex);
  }

  getUserProfileDetails() {
    UserDetailsBloc _userBloc = new UserDetailsBloc(context);
    _userBloc.fetchUserDetails(UserPreference.ACCESS_TOKEN);
    //_userBloc.fetchUserDetails(AppPreferences().token);
    _userBloc.userDetailsFetcher.listen((userResponse) async {
      userDetailsData = userResponse;

      print("Value of userResponse.status ${userResponse.status}");

      print("Value of User Group ${userDetailsData.firstName}");
      print("Value of  userResponse.county ${userResponse.county}");
      print("Value of  userResponse.state ${userResponse.state}");

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        isUserDetailLoading = false;
      });
    });
  }

  getProfileCategoryList() {
    UserDetailsBloc _userBloc = new UserDetailsBloc(context);

    profileCategoryList = new List();
    _userBloc.fetchProfileCategoryList();
    _userBloc.profileCategoryListFetcher.listen((value) async {
      print("List of Profile Category length ${value.length}");

      // itemsList.add(element);

      value.forEach((element) {
        profileCategoryList.add(element);
      });

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        isProfileCategoryListLoading = false;
      });
    });
  }

  getCountyList() {
    StaticDetailsBloc staticDetailsBloc = StaticDetailsBloc(context);
    countyList = new List();
    staticDetailsBloc.fetchCountyList();
    staticDetailsBloc.countyListFetcher.listen((value) async {
      value.forEach((element) {
        dropDownCountyList.add(DropdownMenuItem(
          child: Text(element.toString()),
          value: element.toString(),
        ));
      });

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        isCountyListLoading = false;
      });
    });
  }

  getStateList() {
    StaticDetailsBloc staticDetailsBloc = StaticDetailsBloc(context);
    stateList = new List();
    staticDetailsBloc.fetchStateList();
    staticDetailsBloc.stateListFetcher.listen((value) async {
      value.forEach((element) {
        // itemsList.add(element);

        dropDownStateList.add(DropdownMenuItem(
          child: Text(element.toString()),
          value: element.toString(),
        ));
      });

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        isStateListLoading = false;
      });
    });
  }

  getCategoryList() {
    StaticDetailsBloc staticDetailsBloc = StaticDetailsBloc(context);
    categoryList = new List();
    staticDetailsBloc.fetchCategoryList();
    staticDetailsBloc.categoryListFetcher.listen((value) async {
      value.forEach((element) {
        // itemsList.add(element);

        dropDownCategoryList.add(DropdownMenuItem(
          child: Text(element.toString()),
          value: element.toString(),
        ));
      });

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        isCategoryListLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppPreferences().userGroup == "Provider"
            ? Text("Requester Information")
            : AppPreferences().userGroup == "Supplier"
                ? Text("Supplier Information")
                : Text("Manager Information"),
//        leading: new IconButton(icon: new Icon(Icons.arrow_back), onPressed: ()async{
//          Navigator.pushReplacementNamed(context, Routes.supplierDashBoard);
//        }),
        leading: widget.isProfile == false
            ? new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, Routes.login);
                })
            : AppPreferences().userGroup == "Provider"
                ? new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () async {
                      Navigator.pushReplacementNamed(
                          context, Routes.requesterDashBoard);
                    })
                : AppPreferences().userGroup == "Supplier"
                    ? IconButton(
                        icon: new Icon(Icons.arrow_back),
                        onPressed: () async {
                          Navigator.pushReplacementNamed(
                              context, Routes.supplierDashBoard);
                        })
                    : IconButton(
                        icon: new Icon(Icons.arrow_back),
                        onPressed: () async {
                          Navigator.pushReplacementNamed(
                              context, Routes.managerDashBoard);
                        }),
        centerTitle: true,

        bottom: isCountyListLoading == false &&
                isStateListLoading == false &&
                isCategoryListLoading == false &&
                isUserDetailLoading == false &&
                isProfileCategoryListLoading == false
            ? new TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(0xFFFFFFFF),
                tabs: [
                  Tab(
                    icon: Icon(Icons.person),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                      icon: Icon(Icons.category),
                      child: Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                ],
              )
            : TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(0xFFFFFFFF),
                tabs: [
                  Tab(
                    icon: Icon(Icons.person),
                    child: Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                      icon: Icon(Icons.category),
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                ],
              ),
      ),
      key: myTabbedPageKey,
      body: isCountyListLoading == false &&
              isStateListLoading == false &&
              isCategoryListLoading == false &&
              isUserDetailLoading == false &&
              isProfileCategoryListLoading == false
          ? new TabBarView(
              controller: tabController,
              children: <Widget>[
                new ProfileTabScreen(
                    dropDownCountyList, dropDownStateList, widget.isProfile,
                    userDetailsData: userDetailsData),
                new ProfileCategoryTabScreen(
                    dropDownCategoryList: dropDownCategoryList,
                    isProfile: widget.isProfile,
                    profileCategoryList: profileCategoryList),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 60,
                    width: 60,
                    //color: Colors.white,
                    child: SpinKitFoldingCube(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? AppColors.primaryColor
                                : AppColors.offWhite,
                            // : AppColors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
