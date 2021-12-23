import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/requestedItemsList_bloc.dart';
import '../../../ui/b2c/model/requested_item_model.dart';
import '../../../ui/b2c/view/profile_info_screen.dart';
import '../../../ui/b2c/view/request_inProcess_screen.dart';
import '../../../ui/b2c/view/request_screen.dart';
import '../../../ui/b2c/view/view_request_detail_screen.dart';
import '../../../ui_utils/app_colors.dart';
// import '../../../utils/app_pref_secure.dart';
import '../../../utils/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_admob/firebase_admob.dart';
import '../../../utils/app_preferences.dart';
import 'matched_request_screen.dart';

const String testDevice = 'Test'; //'A96B630756650D0AEAAA548C83712EFE';

class RequesterDashboardScreen extends StatefulWidget {
//  int pageId = Constants.PAGE_ID_REQUESTER_DASHBOARD;
//
//  RequesterDashboardScreen({this.pageId = Constants.PAGE_ID_REQUESTER_DASHBOARD});

  @override
  _RequesterDashboardScreenState createState() =>
      _RequesterDashboardScreenState();
}

class _RequesterDashboardScreenState extends State<RequesterDashboardScreen> {
  List<RequestedItemModel> requestedItemsList = new List();
  List<RequestedItemModel> requestedItemsFilteredList = List();

  bool _isRequestedItemsListLoading = false;

  TextEditingController searchController = new TextEditingController();

  /*  GOOGLE ADMOB*/

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  BannerAd _bannerAd;
  BannerAd createBannerAd() {
    return BannerAd(
        // adUnitId: BannerAd.testAdUnitId,
        adUnitId: "ca-app-pub-6897851980656595/2958474361",
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  void initState() {
    super.initState();
    setState(() {
      _isRequestedItemsListLoading = true;
    });
    getRequestedItemsList();
    /* FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6897851980656595~2732896044");
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show(
        anchorOffset: 0.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 0.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );*/
  }

  getRequestedItemsList() {
    RequestedItemsListBloc requestedItemsListBloc =
        RequestedItemsListBloc(context);
    requestedItemsList = new List();
    requestedItemsListBloc.fetchRequestedItemsList();
    requestedItemsListBloc.requestedItemsListFetcher.listen((value) {
      setState(() {
        requestedItemsList = value;
        _isRequestedItemsListLoading = false;
      });
    });
    /*requestedItemsListBloc.requestedItemsListFetcher.listen((value) async {
      value.forEach((element) {
        requestedItemsList.add(element);
      });
      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isRequestedItemsListLoading = false;
      });
    });*/
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text("Service Requested"),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
            // Navigator.pushReplacementNamed(
            //     context, Routes.requesterDashBoard);
          },
        ),
//        actions: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: InkWell(
//                onTap: () {
//                  Navigator.pushReplacementNamed(
//                      context, Routes.requesterDashBoard);
//                },
//                child: Icon(Icons.home)),
//          ),
//        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushReplacementNamed(context, Routes.addRequest);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => RequestScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      //   drawer: _drawer(),
      body: _isRequestedItemsListLoading == false
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: searchBox(),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .06,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                    ),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Service Requested",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                          ),
                        )),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * .68,
                      width: MediaQuery.of(context).size.width * .9,
                      child: searchController.text.isNotEmpty &&
                              requestedItemsFilteredList.length > 0
                          ? ListView.builder(
                              itemCount: requestedItemsFilteredList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return requestedItemData(
                                    requestedItemsFilteredList[index]);
                              })
                          : searchController.text.isNotEmpty &&
                                  requestedItemsFilteredList.length == 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("No data found"),
                                  ),
                                )
                              : requestedItemsList.length > 0
                                  ? ListView.builder(
                                      itemCount: requestedItemsList.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return requestedItemData(
                                            requestedItemsList[index]);
                                      })
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .1,
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text("No data found"),
                                      ),
                                    )),
                ],
              ),
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

  Widget requestedItemData(RequestedItemModel requestedItemData) {
    String allTags = requestedItemData.tags;
    List<String> allTagList = allTags.split(',');
    List<String> tagsList = [];
    allTagList.forEach((element) {
      if (element.length > 0) {
        tagsList.add(element);
      }
    });
    print("supplierItemData.allTags ${requestedItemData.tags}");
    return Container(
      alignment: Alignment.centerLeft,
//      height: MediaQuery
//          .of(context)
//          .size
//          .height * .12,
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                // color: AppColors.borderShadow,
              ),
//                height: MediaQuery
//                    .of(context)
//                    .size
//                    .height * .11,
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * .88,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${requestedItemData.item}",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  //  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .24,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Request Date : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800)),
                                            Text(
                                              //"${requestedItemData.itemUpdated}",
                                              "${convertedDate(requestedItemData.itemUpdated)}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // SizedBox(width: 30.0,),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .28,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ViewRequestDetailsScreen(
                                                              requestedItemData:
                                                                  requestedItemData),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.visibility,
                                                  color: AppColors.primaryColor,
                                                )),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          RequestScreen(
                                                              requestedItemData:
                                                                  requestedItemData),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.border_color,
                                                  color: AppColors.primaryColor,
                                                )),
                                            InkWell(
                                                onTap: () {
                                                  deleteDailog(
                                                      requestedItemData.id,
                                                      requestedItemData.item);
                                                },
                                                child: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red)),
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
//                                  width: MediaQuery.of(context).size.width *
//                                      .36,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
//                                        width: MediaQuery.of(context).size.width *
//                                            .16,
                                        child: Text(
                                          "Request Type : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                        /* child: Text(
                                          "Procure/Services : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),*/
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .20,
                                          child: Text(
                                              "${requestedItemData.procure}")),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Request Status : ",
                                      // "Item Updated : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text("${requestedItemData.quantity}"),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                  requestedItemData.tags.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                            height: 35.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 35,
                                  //  width: MediaQuery.of(context).size.width*.3,
                                  width: 115,
                                  child: Center(
                                      child: Text("Key Descriptors : ",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w800))),
                                ),
//                                Container(
//                                  height: 30.0,
//                                  width:
//                                      MediaQuery.of(context).size.width * .58,
//                                  alignment: Alignment.centerLeft,
//                                  child: ListView.builder(
//                                      itemCount: tagsList.length,
//                                      scrollDirection: Axis.horizontal,
//                                      itemBuilder: (context, index) {
//                                        return Card(
//                                          color: Colors.blue,
//                                          shape: RoundedRectangleBorder(
//                                            side: BorderSide(
//                                                color: Colors.grey, width: 1),
//                                            borderRadius:
//                                                BorderRadius.circular(40),
//                                          ),
//                                          child: Center(
//                                              child: Padding(
//                                            padding: const EdgeInsets.only(
//                                                left: 8.0, right: 8.0),
//                                            child: Text(
//                                              "${tagsList[index]}",
//                                              style: TextStyle(
//                                                  color: Colors.white),
//                                            ),
//                                          )),
//                                        );
//                                      }),
//                                ),

                                Expanded(
                                  child: Container(
                                    child: ListView.builder(
                                        itemCount: tagsList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Center(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Text(
                                                "${tagsList[index]}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 0),
            height: 5,
            color: AppColors.borderShadow,
          ),
        ],
      ),
    );
  }

  /* Widget _drawer() {
    return SizedBox(
      width: 250.0,
      child: new Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildUserAccountsDrawerHeader(),

//            ListTile(
//              onTap: () {
//                Navigator.pushReplacementNamed(
//                    context, Routes.requesterDashBoard);
//              },
//              leading: SizedBox(
//                  height: 30.0,
//                  width: 30.0, // fixed width and height
//                  child: Image.asset("assets/images/reserve_users.png")),
//              title: Text(
//                "Home",
//                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
//              ),
//            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfileInfoScreen(),
                  ),
                );
              },
              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Icon(
                    Icons.perm_identity,
                    color: Colors.cyan,
                    size: 30.0,
                  )),
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
            ListTile(
              onTap: () {
//                Navigator.of(context).push(
//                  MaterialPageRoute(
//                    builder: (BuildContext context) => RequestScreen(),
//                  ),
//                );
                Navigator.pushReplacementNamed(
                    context, Routes.requesterDashBoard);
              },
//              leading: SizedBox(
//                  height: 30.0,
//                  width: 30.0, // fixed width and height
//                  child: Image.asset("assets/images/ic_register.png")),
              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Icon(
                    Icons.note_add,
                    color: Colors.cyan,
                    size: 30.0,
                  )),
              title: Text(
                "New Request",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MatchedRequestScreen(),
                  ),
                );
              },
              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Icon(
                    Icons.youtube_searched_for,
                    color: Colors.cyan,
                    size: 30.0,
                  )),
              title: Text(
                "Matched Request",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => RequestInProcessScreen(),
                  ),
                );
              },
              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Icon(
                    Icons.restore,
                    color: Colors.cyan,
                    size: 30.0,
                  )),
              title: Text(
                "Request in Process",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
//            ListTile(
//
//              onTap: () {
//                //  AlertUtils.logoutAlert(context, "");
//              },
//
//
//              leading: SizedBox(
//                  height: 30.0,
//                  width: 30.0, // fixed width and height
//                  child: Image.asset("assets/images/conversation.png")),
//              title: Text(
//                "FAQ",
//                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
//              ),
//            ),
            */ /* ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChangePasswordScreen(),
                  ),
                );
              },
//              leading: SizedBox(
//                  height: 30.0,
//                  width: 30.0, // fixed width and height
//                  child: Image.asset("assets/images/updatePassword.png")),
              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Icon(
                    Icons.vpn_key,
                    color: Colors.cyan,
                    size: 30.0,
                  )),
              title: Text(
                "Change Password",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
            ListTile(
              onTap: () {
                AlertUtils.logoutAlert(context, AppPreferences().firstName);
              },
              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Image.asset("assets/images/logout.png")),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),*/ /*

            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserAccountsDrawerHeader() {
    return Container(
        width: 250.0,
        color: AppColors.primaryColor,
        padding: EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/user.png'),
                backgroundColor: Colors.white,
                child: Text(
                  "",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              // Text(AppPreferences().firstName,
              */ /* Text(AppPreferences().fullName,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),*/ /*
              SizedBox(height: 5),
              */ /*Text(
                AppPreferences().email,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),*/ /*
            ]));
  }*/

  Widget searchBox() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width * .10,
                child: Icon(Icons.search)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .70,
            child: Center(
              child: TextField(
                controller: searchController,
                enabled: requestedItemsList.length > 0 ? true : false,
                decoration: new InputDecoration(
                  hintText: 'Search Request',
                  border: InputBorder.none,
                ),
                onChanged: onSearchTextChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    requestedItemsFilteredList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < requestedItemsList.length; i++) {
      if (requestedItemsList[i]
          .item
          .toLowerCase()
          .contains(text.toLowerCase())) {
        requestedItemsFilteredList.add(requestedItemsList[i]);
      }
    }

    setState(() {});
  }

  deleteDailog(num itemId, String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are you sure you want to delete this request: $itemName ?",
            style: TextStyle(fontSize: 15.0, fontFamily: "customRegular"),
          ),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
                  style: new TextStyle(fontFamily: "customRegular")),
              onPressed: () {
                Navigator.of(context).pop(true);
                deleteRequestApiCall(itemId);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: new TextStyle(fontFamily: "customRegular"),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteRequestApiCall(num itemId) async {
    print("Hello Pranay Request is ready for deletion");
    CustomProgressLoader.showLoader(context);
    RequestedItemsListBloc _bloc = new RequestedItemsListBloc(context);
    _bloc.deleteRequest(itemId);
    _bloc.deleteRequestFetcher.listen((response) async {
      if (response.status == 200) {
        print("Hello Pranay Request submission is successful");

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Request deleted successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);

        CustomProgressLoader.cancelLoader(context);
        Navigator.pushReplacementNamed(context, Routes.requesterDashBoard);
      } else if (response.status == 404) {
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: response.error,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
      } else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: response?.error ?? AppPreferences().getApisErrorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String convertedDate(String dateString) {
    final DateFormat formatOld = DateFormat('MM-dd-yyyy HH:mm');
    var date = formatOld.parse(dateString);
    final DateFormat formatNew = DateFormat('dd/MM/yyyy');
    return formatNew.format(date);
  }
}
