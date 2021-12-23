import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/advertise/adWidget.dart';
import '../../../ui/b2c/model/matched_request_data_model.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/network_check.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'matchedList_bloc.dart';
import '../../../utils/app_preferences.dart';

class SupplyDetailsScreen extends StatefulWidget {
  final MatchedRequestDataModel matchedRequestData;

  const SupplyDetailsScreen({Key key, this.matchedRequestData})
      : super(key: key);

  @override
  _SupplyDetailsScreenState createState() => _SupplyDetailsScreenState();
}

class _SupplyDetailsScreenState extends State<SupplyDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // actionController.text = "Accept";
    super.initState();
    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplier Inventory Details"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "Supplier Name :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.firstName} ${widget.matchedRequestData.lastName}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "Organisation Name :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.organizationName}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "Job Title :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.jobTitle}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "Address :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.address}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "City/Town :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.city}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "State/Province :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.state}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "ZIP/Postal Code :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.zipCode}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: Text(
                                        "Item Description :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${widget.matchedRequestData.description}"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.matchedRequestData.isSameItemName
                                  ? SizedBox(
                                      height: 5.0,
                                    )
                                  : Container(),
                              widget.matchedRequestData.isSameItemName
                                  ? Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 90,
                                            child: Text(
                                              "Matched By Item Name :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                  "${widget.matchedRequestData.item}"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              widget.matchedRequestData.matchingTags.length > 0
                                  ? SizedBox(
                                      height: 5.0,
                                    )
                                  : Container(),
                              widget.matchedRequestData.matchingTags.length > 0
                                  ? Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 90,
                                            child: Text(
                                              "Matched By Key Descriptors :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 30.0,
                                              child: ListView.builder(
                                                  itemCount: widget
                                                      .matchedRequestData
                                                      .matchingTags
                                                      .length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Card(
                                                      color: Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                      ),
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Text(
                                                          "${widget.matchedRequestData.matchingTags[index]}",
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            width: MediaQuery.of(context).size.width * .9,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Item you selected",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * .9,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey),
                                    // color: AppColors.borderShadow,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${widget.matchedRequestData.item}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Quantity Available : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${widget.matchedRequestData.quantity}"),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("Quantity can be arranged : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "${widget.matchedRequestData.arrangeQuantity}"),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("In no. of days : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "${widget.matchedRequestData.arrangeDate}"),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 0),
                                  height: 5,
                                  color: AppColors.borderShadow,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                // _connectSupplier();
                              },
                              color: Colors.green,
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                // _connectSupplier();
                              },
                              color: Colors.red,
                              child: Text(
                                "Deny",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                _connectSupplier();
                              },
                              color: AppColors.primaryColor,
                              child: Text(
                                "Request Item",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }

  void _connectSupplier() async {
    var connectivityResult = await NetworkCheck().check();
    if (connectivityResult) {
      apiCall();
    } else {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: Constants.NO_INTERNET_CONNECTION,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  apiCall() async {
    CustomProgressLoader.showLoader(context);

    MatchedListBloc _bloc = new MatchedListBloc(context);
    _bloc.connectSupplier(
        widget.matchedRequestData.id,
        widget.matchedRequestData.providerItemInfo["quantity"],
        widget.matchedRequestData.providerItemInfo["critical"]);
    _bloc.connectSupplierFetcher.listen((response) async {
      if (response.status == 200) {
        print("Hello Pranay connectSupplier is successful ${response.status}");

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Request sent Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
        Navigator.pushReplacementNamed(context, Routes.matchedRequest);
        //   Navigator.pushAndRemoveUntil(context, Routes.supplyInProcess);
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
