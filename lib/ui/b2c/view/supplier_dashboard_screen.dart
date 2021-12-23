import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/supplierItemsList_bloc.dart';
import '../../../ui/b2c/model/supplier_item_model.dart';
import '../../../ui/b2c/view/profile_info_screen.dart';
import '../../../ui/b2c/view/supply_inProcess_screen.dart';
import '../../../ui/b2c/view/supply_screen.dart';
import '../../../ui/b2c/view/view_supply_details_screen.dart';
import '../../../ui_utils/app_colors.dart';
// import '../../../utils/app_pref_secure.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../utils/app_preferences.dart';
import 'matched_supplies_screen.dart';

class SupplierDashboardScreen extends StatefulWidget {
  @override
  _SupplierDashboardScreenState createState() =>
      _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState extends State<SupplierDashboardScreen> {
  List<SupplierItemModel> supplierItemsList = new List();
  List<SupplierItemModel> requestedItemsFilteredList = List();

  bool _isSupplierItemsListLoading = false;

  TextEditingController searchController = new TextEditingController();

  void initState() {
    setState(() {
      _isSupplierItemsListLoading = true;
    });
    getSupplierItemsList();
    super.initState();
  }

  getSupplierItemsList() {
    SupplierItemsListBloc supplierItemsListBloc =
        SupplierItemsListBloc(context);
    supplierItemsList = new List();
    supplierItemsListBloc.fetchSupplierItemsList();
    supplierItemsListBloc.supplierItemsListFetcher.listen((value) async {
      value.forEach((element) {
        supplierItemsList.add(element);
      });
      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isSupplierItemsListLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supply Items"),
        centerTitle: true,
//        actions: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: InkWell(
//                onTap: () {
//                  Navigator.pushReplacementNamed(
//                      context, Routes.supplierDashBoard);
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
              builder: (BuildContext context) => SupplyScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      drawer: _drawer(),
      body: _isSupplierItemsListLoading == false
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
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Supply Items",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0),
                      ),
                    ),
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
                              : supplierItemsList.length > 0
                                  ? ListView.builder(
                                      itemCount: supplierItemsList.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return requestedItemData(
                                            supplierItemsList[index]);
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
                                //: AppColors.white,
                                : AppColors.offWhite,
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

  Widget requestedItemData(SupplierItemModel supplierItemData) {
    String allTags = supplierItemData.allTags;
    List<String> allTagList = allTags.split(',');
    List<String> tagsList = [];
    allTagList.forEach((element) {
      if (element.length > 0) {
        tagsList.add(element);
      }
    });
    print("supplierItemData.allTags ${supplierItemData.allTags}");
    return Container(
      alignment: Alignment.centerLeft,
//      height: MediaQuery
//          .of(context)
//          .size
//          .height * .15,
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                // color: AppColors.borderShadow,
              ),
//              height: MediaQuery
//                  .of(context)
//                  .size
//                  .height * .15,
              alignment: Alignment.centerLeft,
              child: Row(
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
                              "${supplierItemData.item}",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text("Sell or Donate : ",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "${supplierItemData.capableSupplies} "),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .25,
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
                                                        ViewSupplyDetailsScreen(
                                                            supplierItemData:
                                                                supplierItemData),
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
                                                        SupplyScreen(
                                                            supplierItemData:
                                                                supplierItemData),
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
                                                    supplierItemData.id,
                                                    supplierItemData.item);
                                              },
                                              child: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .30,
                                  child: Row(
                                    children: <Widget>[
                                      Text("Unit: ",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600)),
                                      supplierItemData.unit.isEmpty
                                          ? Text("N/A")
                                          : Text("${supplierItemData.unit} "),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("#Days to Arrange : ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600)),
                                    supplierItemData.arrangeDate == 0
                                        ? Text("N/A")
                                        : Text(
                                            "${supplierItemData.arrangeDate} "),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .30,
                                  child: Row(
                                    children: <Widget>[
                                      Text("Quantity: ",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600)),
                                      supplierItemData.quantity == 0
                                          ? Text("N/A")
                                          : Text(
                                              "${supplierItemData.quantity} "),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Quantity Arranged : ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600)),
                                    supplierItemData.arrangeQuantity == 0
                                        ? Text("N/A")
                                        : Text(
                                            "${supplierItemData.arrangeQuantity} "),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text("Item Updated : ",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600)),
                                Text("${supplierItemData.itemUpdated} "),
                              ],
                            ),
                            // SizedBox(height: 5,),
                            supplierItemData.allTags.isNotEmpty
                                ? Container(
                                    height: 30.0,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 30,
                                          width: 110,
                                          child: Center(
                                              child: Text("Key Descriptors : ",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 30.0,
                                            child: ListView.builder(
                                                itemCount: tagsList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    color: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        "${tagsList[index]}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )),
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

  Widget _drawer() {
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
//                    context, Routes.supplierDashBoard);
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
//                    builder: (BuildContext context) => SupplyScreen(),
//                  ),
//                );
                Navigator.pushReplacementNamed(
                    context, Routes.supplierDashBoard);
              },
              //onTap: _signOutDialog,

              // onTap: callback,
              //*//*Navigator.of(context).push(CupertinoPageRoute(
              //builder: (BuildContext context) => LogOut()));*//*

              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Icon(
                    Icons.note_add,
                    color: Colors.cyan,
                    size: 30.0,
                  )),
              title: Text(
                "New Supply",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MatchedSupplyScreen(),
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
                ),
              ),
              title: Text(
                "Matched Supplies",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SupplyInProcessScreen()),
                );
              },
              leading: SizedBox(
                height: 30.0,
                width: 30.0, // fixed width and height
                child: Icon(
                  Icons.restore,
                  color: Colors.cyan,
                  size: 30.0,
                ),
              ),
              title: Text(
                "Supply in Process",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
//            ListTile(
//              onTap: () {
//                //  AlertUtils.logoutAlert(context, "");
//              },
//              leading: SizedBox(
//                  height: 30.0,
//                  width: 30.0, // fixed width and height
//                  child: Image.asset("assets/images/conversation.png")),
//              title: Text(
//                "FAQ",
//                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
//              ),
//            ),

            /// Commented on 21 Apr
            /* ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChangePasswordScreen(),
                  ),
                );
              },
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
            ),*/
            SizedBox(
              height: 100.0,
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
              Text(AppPreferences().fullName,
                  // Text(AppPreferences().firstName,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 5),
              Text(AppPreferences().email,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ]));
  }

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
                enabled: supplierItemsList.length > 0 ? true : false,
                decoration: new InputDecoration(
                  hintText: 'Search Item',
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

    for (int i = 0; i < supplierItemsList.length; i++) {
      if (supplierItemsList[i]
          .item
          .toLowerCase()
          .contains(text.toLowerCase())) {
        requestedItemsFilteredList.add(supplierItemsList[i]);
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
                deleteSupplyApiCall(itemId);
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

  deleteSupplyApiCall(num itemId) async {
    print("Hello Pranay supply is ready for deletion");
    CustomProgressLoader.showLoader(context);
    SupplierItemsListBloc _bloc = new SupplierItemsListBloc(context);
    _bloc.deleteSupply(itemId);
    _bloc.deleteSupplyFetcher.listen((response) async {
      if (response.status == 200) {
        print("Hello Pranay Request submission is successful");

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Supply deleted successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);

        CustomProgressLoader.cancelLoader(context);
        Navigator.pushReplacementNamed(context, Routes.supplierDashBoard);
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
}
