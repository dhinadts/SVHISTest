import '../../../ui/b2c/bloc/supplierItemsList_bloc.dart';
import '../../../ui/b2c/model/supplier_item_inprocess_model.dart';
import '../../../ui/b2c/view/request_details_screen.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SupplyInProcessScreen extends StatefulWidget {
  @override
  _SupplyInProcessScreenState createState() => _SupplyInProcessScreenState();
}

class _SupplyInProcessScreenState extends State<SupplyInProcessScreen> {
  bool _isSupplierItemsInProcessListLoading = false;

  List<SupplierItemInProcessDataModel> supplierItemsInProcessList = new List();
  List<SupplierItemInProcessDataModel> supplierItemsInProcessFilteredList =
      List();
  TextEditingController searchController = new TextEditingController();

  void initState() {
    setState(() {
      _isSupplierItemsInProcessListLoading = true;
    });
    getRequestInProcessList();
    super.initState();
  }

  getRequestInProcessList() {
    SupplierItemsListBloc supplierItemsInProcessListBloc =
        SupplierItemsListBloc(context);
    supplierItemsInProcessList = new List();
    supplierItemsInProcessListBloc.fetchSupplierItemsInProcessList();
    supplierItemsInProcessListBloc.supplierItemsInProcessListFetcher
        .listen((value) async {
      value.forEach((element) {
        supplierItemsInProcessList.add(element);
      });
      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isSupplierItemsInProcessListLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items Requested"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, Routes.supplierDashBoard);
            }),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, Routes.supplierDashBoard);
                },
                child: Icon(Icons.home)),
          ),
        ],
      ),
      body: _isSupplierItemsInProcessListLoading == false
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
                              supplierItemsInProcessFilteredList.length > 0
                          ? ListView.builder(
                              itemCount:
                                  supplierItemsInProcessFilteredList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return supplierItemInProcessData(
                                    supplierItemsInProcessFilteredList[index]);
                              })
                          : searchController.text.isNotEmpty &&
                                  supplierItemsInProcessFilteredList.length == 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("No data found"),
                                  ),
                                )
                              : supplierItemsInProcessList.length > 0
                                  ? ListView.builder(
                                      itemCount:
                                          supplierItemsInProcessList.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return supplierItemInProcessData(
                                            supplierItemsInProcessList[index]);
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
                            //: AppColors.white,
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

  Widget supplierItemInProcessData(
      SupplierItemInProcessDataModel supplierItemInProcessData) {
    return Card(
      elevation: 5,
      child: ClipPath(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          //height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${supplierItemInProcessData.orderItem}",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 115,
                                  child: Text(
                                    "Requester Name : ",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        requesterDetailsDialog(
                                            supplierItemInProcessData);
                                      },
                                      child: Text(
                                        "${supplierItemInProcessData.orderBy}",
                                        style: TextStyle(
                                            // fontStyle: FontStyle.italic,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Requested Quantity : ${supplierItemInProcessData.orderQuantity}",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Collective : ${supplierItemInProcessData.chamberBuying}",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Requested On : ${supplierItemInProcessData.orderCreated}",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Requested Status : ${supplierItemInProcessData.orderStatus}",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                supplierItemInProcessData.orderStatus ==
                                        "Initiated"
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .30,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    RequestDetailsScreen(
                                                        supplierItemInProcessData:
                                                            supplierItemInProcessData),
                                              ),
                                            );
                                          },
                                          color: AppColors.primaryColor,
                                          child: Text(
                                            "Respond",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        child: RaisedButton(
                                          onPressed: () {},
                                          color: AppColors.warmGrey,
                                          //color: AppColors.grey,
                                          child: Text(
                                            "Responded",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ],
                        ),
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

  requesterDetailsDialog(
      SupplierItemInProcessDataModel supplierItemInProcessData) {
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
                                        "Requester Information",
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
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "Name : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${supplierItemInProcessData.biRequester["firstname"]} ${supplierItemInProcessData.biRequester["lastname"]}",
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
                                        children: <Widget>[
                                          Container(
                                              width: 90,
                                              child: Text(
                                                "Organization Name : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          Expanded(
                                            child: Container(
                                                child: Text(
                                              "${supplierItemInProcessData.biRequester["organization_name"]} ",
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
                                              "${supplierItemInProcessData.biRequester["job_title"]} ",
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
                                              "${supplierItemInProcessData.emailRequester} ",
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
                                              "${supplierItemInProcessData.biRequester["mobile"]} ",
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
                enabled: supplierItemsInProcessList.length > 0 ? true : false,
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
    supplierItemsInProcessFilteredList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < supplierItemsInProcessList.length; i++) {
      if (supplierItemsInProcessList[i]
          .orderItem
          .toLowerCase()
          .contains(text.toLowerCase())) {
        supplierItemsInProcessFilteredList.add(supplierItemsInProcessList[i]);
      }
    }

    setState(() {});
  }
}
