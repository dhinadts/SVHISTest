import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/requestedItemsList_bloc.dart';
import '../../../ui/b2c/model/requested_item_inprocess_model.dart';
import '../../../ui/committees/widgets/formField_dropdown.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/network_check.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../utils/app_preferences.dart';
class RequestInProcessScreen extends StatefulWidget {
  @override
  _RequestInProcessScreenState createState() => _RequestInProcessScreenState();
}

class _RequestInProcessScreenState extends State<RequestInProcessScreen> {
  bool _isRequestedItemsInProcessListLoading = false;

  List<RequestedItemInProcessDataModel> requestedItemsInProcessList =
      new List();
  List<RequestedItemInProcessDataModel> requestedItemsInProcessFilteredList =
      List();
  TextEditingController searchController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();

  void initState() {
    setState(() {
      _isRequestedItemsInProcessListLoading = true;
    });
    statusController.text = "Completed";
    getMatchedRequestList();
    super.initState();
  }

  getMatchedRequestList() {
    RequestedItemsListBloc requestedItemsInProcessListBloc =
        RequestedItemsListBloc(context);
    requestedItemsInProcessList = new List();
    requestedItemsInProcessListBloc.fetchRequestedItemsInProcessList();
    requestedItemsInProcessListBloc.requestedItemsInProcessListFetcher
        .listen((value) async {
      value.forEach((element) {
        requestedItemsInProcessList.add(element);
      });
      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isRequestedItemsInProcessListLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Requested Items"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pushReplacementNamed(
                  context, Routes.requesterDashBoard);
            }),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, Routes.requesterDashBoard);
                },
                child: Icon(Icons.home)),
          ),
        ],
      ),
      body: _isRequestedItemsInProcessListLoading == false
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
                      height: MediaQuery.of(context).size.height * .8,
                      width: MediaQuery.of(context).size.width * .95,
                      child: searchController.text.isNotEmpty &&
                              requestedItemsInProcessFilteredList.length > 0
                          ? ListView.builder(
                              itemCount:
                                  requestedItemsInProcessFilteredList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return requestedItemInProcessData(
                                    requestedItemsInProcessFilteredList[index]);
                              })
                          : searchController.text.isNotEmpty &&
                                  requestedItemsInProcessFilteredList.length ==
                                      0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("No data found"),
                                  ),
                                )
                              : requestedItemsInProcessList.length > 0
                                  ? ListView.builder(
                                      itemCount:
                                          requestedItemsInProcessList.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return requestedItemInProcessData(
                                            requestedItemsInProcessList[index]);
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

  Color getStatusColorForMessageStatus(String messageStatus) {
    if (messageStatus == "Completed") {
      return Colors.green;
    } else if (messageStatus == "Incompleted") {
      return Colors.red;
    } else if (messageStatus == "Initiated") {
      return Colors.cyan[700];
    } else if (messageStatus == "Accepted") {
      return Colors.blue[700];
    } else if (messageStatus.contains("Rejected")) {
      return Colors.yellow[700];
    }
    print(" Message Status $messageStatus");
    return Colors.red;
  }

  Widget requestedItemInProcessData(
      RequestedItemInProcessDataModel requestedItemInProcessData) {
    return Card(
      elevation: 5,
      child: ClipPath(
        child: Container(
          //height: 100,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: getStatusColorForMessageStatus(
                          requestedItemInProcessData.orderStatus.toString()),
                      width: 8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * .85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${requestedItemInProcessData.orderItem}",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      //   width:MediaQuery.of(context).size.width*.30,
                                      width: 105,
                                      child: Text(
                                        "Supplier Name : ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    requestedItemInProcessData.orderStatus
                                                .toString() ==
                                            "Initiated"
                                        ? Expanded(
                                            child: Container(
                                              //width:MediaQuery.of(context).size.width*.55,
                                              child: Text(
                                                // "${requestedItemInProcessData.biSupplier["organization_name"]}",
                                                "${requestedItemInProcessData.orderTo}",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.grey[700]),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              supplierDetailsDialog(
                                                  requestedItemInProcessData);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .55,
                                              child: Text(
                                                // "${requestedItemInProcessData.biSupplier["organization_name"]}",
                                                "${requestedItemInProcessData.orderTo}",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Qty : ${requestedItemInProcessData.orderQuantity}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700]),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          "Created On : ${requestedItemInProcessData.orderCreated}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // color: Colors.green,
                                      width: MediaQuery.of(context).size.width *
                                          .30,
                                      child: Column(
                                        children: <Widget>[
                                          requestedItemInProcessData.orderStatus
                                                      .toString() ==
                                                  "Accepted"
                                              ? InkWell(
                                                  onTap: () {
                                                    print(
                                                        "Hello Pranay in Complete");
                                                    onCompleteClick(
                                                        requestedItemInProcessData);
                                                  },
                                                  child: Container(
                                                    child: Container(
                                                        margin:
                                                            EdgeInsets.all(8),
                                                        height: 30,
                                                        decoration: new BoxDecoration(
                                                            color: AppColors
                                                                .primaryColor,
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .all(
                                                                    Radius.circular(
                                                                        5.0))),
                                                        child: Center(
                                                          child: Text(
                                                            "Complete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "${requestedItemInProcessData.orderStatus.toString()}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: getStatusColorForMessageStatus(
                                        requestedItemInProcessData.orderStatus
                                            .toString(),
                                      ),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      ),
    );
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
                enabled: requestedItemsInProcessList.length > 0 ? true : false,
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
    requestedItemsInProcessFilteredList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < requestedItemsInProcessList.length; i++) {
      if (requestedItemsInProcessList[i]
          .orderItem
          .toLowerCase()
          .contains(text.toLowerCase())) {
        requestedItemsInProcessFilteredList.add(requestedItemsInProcessList[i]);
      }
    }

    setState(() {});
  }

  supplierDetailsDialog(
      RequestedItemInProcessDataModel requestedItemInProcessData) {
    return showDialog<void>(
        context: context,
        //barrierDismissible: false, // user must tap button!
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width * .5,
                child: Card(
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.cyan, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            height: MediaQuery.of(context).size.height * .45,
                            width: MediaQuery.of(context).size.width * .85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Supplier Information",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0),
                                      )),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              //alignment: Alignment.centerLeft,
                                              width: 90,
                                              child: Text(
                                                "Name : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                //alignment: Alignment.centerLeft,
                                                // width: MediaQuery.of(context).size.width * .35,
                                                child: Text(
                                              "${requestedItemInProcessData.biSupplier["firstname"]} ${requestedItemInProcessData.biSupplier["lastname"]} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              // alignment: Alignment.centerLeft,
                                              width: 90,
                                              child: Text(
                                                "Organization Name : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
//                                                    alignment: Alignment.centerLeft,
//                                                    width: MediaQuery.of(context).size.width * .35,
                                                child: Text(
                                              "${requestedItemInProcessData.biSupplier["organization_name"]} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "Job Title : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${requestedItemInProcessData.biSupplier["job_title"]} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "Address : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${requestedItemInProcessData.biSupplier["address1"]} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "City : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${requestedItemInProcessData.biSupplier["city"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "State : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${requestedItemInProcessData.biSupplier["state"]} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "Email : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${requestedItemInProcessData.emailSupplier} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "Mobile : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${requestedItemInProcessData.biSupplier["mobile"]} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "Comment : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${requestedItemInProcessData.commentSupplier} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .85,
                            child: Align(
                              // These values are based on trial & error method
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> onCompleteClick(
      RequestedItemInProcessDataModel requestedItemInProcessData) async {
    return showDialog<void>(
        context: context,
        //barrierDismissible: false, // user must tap button!
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * .35,
                width: MediaQuery.of(context).size.width * .5,
                child: Card(
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.cyan, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topCenter,
                              // height: MediaQuery.of(context).size.height * .5,
                              width: MediaQuery.of(context).size.width * .8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0),
                                      )),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Choose the Status ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    // alignment: Alignment.topCenter,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .4,
                                      //height: 50.0,
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: DropDownFormField(
                                        filled: false,
                                        titleText: null,
                                        hintText: "",
                                        value: statusController.text,
                                        onSaved: (value) {
                                          setState(() {
                                            statusController.text = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            statusController.text = value;
                                          });
                                        },
                                        dataSource: [
                                          {
                                            "display": "Completed",
                                            "value": "Completed",
                                          },
                                          {
                                            "display": "Incompleted",
                                            "value": "Incompleted",
                                          },
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    //alignment: Alignment.topCenter,
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: RaisedButton(
                                        color: AppColors.darkGrassGreen,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _completeOrderStatus(
                                              requestedItemInProcessData);
                                        },
                                        child: Text(
                                          "Submit ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            child: Align(
                              // These values are based on trial & error method
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void _completeOrderStatus(
      RequestedItemInProcessDataModel requestedItemInProcessData) async {
    var connectivityResult = await NetworkCheck().check();
    if (connectivityResult) {
      apiCall(requestedItemInProcessData);
    } else {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: Constants.NO_INTERNET_CONNECTION,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  apiCall(RequestedItemInProcessDataModel requestedItemInProcessData) async {
    CustomProgressLoader.showLoader(context);
    String orderConfirm;
    if (statusController.text.toString() == "Completed") {
      orderConfirm = "Yes";
    } else {
      orderConfirm = "No";
    }

    RequestedItemsListBloc _bloc = new RequestedItemsListBloc(context);
    _bloc.completeOrderStatus(orderConfirm, requestedItemInProcessData.orderId);
    _bloc.completeOrderStatusFetcher.listen((response) async {
      if (response.status == 200) {
        print("Hello Pranay connectSupplier is successful ${response.status}");

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Status changed Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
        Navigator.pushReplacementNamed(context, Routes.requestInProcess);
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
