import '../../../ui_utils/app_colors.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'matchedList_bloc.dart';
import '../model/matched_supply_data_model.dart';
import 'matched_supply_requester_details_screen.dart';

class MatchedSupplyScreen extends StatefulWidget {
  @override
  _MatchedSupplyScreenState createState() => _MatchedSupplyScreenState();
}

class _MatchedSupplyScreenState extends State<MatchedSupplyScreen> {
  bool _isMatchedSupplyListLoading = false;

  List<MatchedSupplyDataModel> matchedSupplyList = new List();
  List<MatchedSupplyDataModel> matchedSupplyFilteredList = List();
  TextEditingController searchController = new TextEditingController();

  void initState() {
    setState(() {
      _isMatchedSupplyListLoading = true;
    });
    getMatchedSupplyList();
    super.initState();
  }

  getMatchedSupplyList() {
    MatchedListBloc matchedSupplyListBloc = MatchedListBloc(context);
    matchedSupplyList = new List();
    try {
      matchedSupplyListBloc.fetchMatchedSupplyList();
      matchedSupplyListBloc.matchedSupplyListFetcher.listen((value) async {
        value.forEach((element) {
          matchedSupplyList.add(element);
        });
        setState(() {
          // CustomProgressLoader.cancelLoader(context);
          _isMatchedSupplyListLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isMatchedSupplyListLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matched Supplies"),
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, Routes.supplierDashBoard);
            }),
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
      body: _isMatchedSupplyListLoading == false
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
                              matchedSupplyFilteredList.length > 0
                          ? ListView.builder(
                              itemCount: matchedSupplyFilteredList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return MatchedSupplyData(
                                    matchedSupplyFilteredList[index]);
                              })
                          : searchController.text.isNotEmpty &&
                                  matchedSupplyFilteredList.length == 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("No data found"),
                                  ),
                                )
                              : matchedSupplyList.length > 0
                                  ? ListView.builder(
                                      itemCount: matchedSupplyList.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return MatchedSupplyData(
                                            matchedSupplyList[index]);
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
                                //  : AppColors.white,
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

  Widget MatchedSupplyData(MatchedSupplyDataModel matchedSupplyData) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey[500],
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              //width: MediaQuery.of(context).size.width*.65,
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${matchedSupplyData.item}",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Requester Name : ${matchedSupplyData.organizationName}",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Requested Qty : ${matchedSupplyData.quantity}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "In no. of days : ${matchedSupplyData.arrangeDate}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Critical : ${matchedSupplyData.critical}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Procure/Services : ${matchedSupplyData.procure}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * .3,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.map,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                          "${matchedSupplyData.totalDistance}"),
                                      Text("(in miles)"),
                                    ],
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .3,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MatchedSupplyRequesterDetailsScreen(
                                            matchedSupplyData:
                                                matchedSupplyData),
                                  ),
                                );
                              },
                              color: AppColors.primaryColor,
                              child: Text(
                                "View",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

//                            Row(
//                              children: <Widget>[
//                                Text("Critical : ${MatchedSupplyData.providerItemInfo['critical']}"),
//                                SizedBox(width: 30.0,),
//                                Text("Procure : ${MatchedSupplyData.providerItemInfo['procure']}"),
//                              ],
//                            ),
//                            Text("Item Updated : ${MatchedSupplyData.providerItemInfo['itemUpdated']}"),
              ],
            ),
          )),
        ],
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
                enabled: matchedSupplyList.length > 0 ? true : false,
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
    matchedSupplyFilteredList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < matchedSupplyList.length; i++) {
      if (matchedSupplyList[i]
          .item
          .toLowerCase()
          .contains(text.toLowerCase())) {
        matchedSupplyFilteredList.add(matchedSupplyList[i]);
      }
    }

    setState(() {});
  }
}
