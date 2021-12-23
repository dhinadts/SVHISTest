import '../../../ui/advertise/adWidget.dart';
import '../../../ui/b2c/model/matched_request_data_model.dart';
import '../../../ui/b2c/view/supply_details_screen.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'matchedList_bloc.dart';

class MatchedRequestScreen extends StatefulWidget {
  @override
  _MatchedRequestScreenState createState() => _MatchedRequestScreenState();
}

class _MatchedRequestScreenState extends State<MatchedRequestScreen> {
  bool _isMatchedRequestListLoading = false;

  List<MatchedRequestDataModel> matchedRequestList = new List();
  List<MatchedRequestDataModel> matchedRequestFilteredList = List();
  TextEditingController searchController = new TextEditingController();

  void initState() {
    setState(() {
      _isMatchedRequestListLoading = true;
    });
    getMatchedRequestList();
    super.initState();

    initializeAd();
  }

  getMatchedRequestList() {
    MatchedListBloc matchedRequestListBloc = MatchedListBloc(context);
    matchedRequestList = new List();
    try {
      matchedRequestListBloc.fetchMatchedRequestList();
      matchedRequestListBloc.matchedRequestListFetcher.listen((value) async {
        if (value != null) {
          value.forEach((element) {
            matchedRequestList.add(element);
          });
          setState(() {
            // CustomProgressLoader.cancelLoader(context);
            _isMatchedRequestListLoading = false;
          });
        } else {
          _isMatchedRequestListLoading = false;
          matchedRequestList = [];
        }
      });
    } catch (e) {
      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isMatchedRequestListLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matched Requests"),
        centerTitle: true,
        /*leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pushReplacementNamed(
                  context, Routes.requesterDashBoard);
            }),*/
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
      body: Column(
        children: [
          Expanded(
            child: _isMatchedRequestListLoading == false
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .07,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                    matchedRequestFilteredList.length > 0
                                ? ListView.builder(
                                    itemCount:
                                        matchedRequestFilteredList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return matchedRequestData(
                                          matchedRequestFilteredList[index]);
                                    })
                                : searchController.text.isNotEmpty &&
                                        matchedRequestFilteredList.length == 0
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .1,
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text("No data found"),
                                        ),
                                      )
                                    : matchedRequestList.length > 0
                                        ? ListView.builder(
                                            itemCount:
                                                matchedRequestList.length,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              return matchedRequestData(
                                                  matchedRequestList[index]);
                                            })
                                        : Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .1,
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
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
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }

  Widget matchedRequestData(MatchedRequestDataModel matchedRequestData) {
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
                  "${matchedRequestData.item}",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Supplier Name : ${matchedRequestData.organizationName}",
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
                            "Qty Available : ${matchedRequestData.quantity}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Qty can be Arranged : ${matchedRequestData.arrangeQuantity}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "In no. of days : ${matchedRequestData.arrangeDate}",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Sell/Donate : ${matchedRequestData.capableSupplies}",
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
                                          "${matchedRequestData.totalDistance}"),
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
                                        SupplyDetailsScreen(
                                            matchedRequestData:
                                                matchedRequestData),
                                  ),
                                );
                              },
                              color: AppColors.primaryColor,
                              child: Text(
                                "Connect",
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
//                                Text("Critical : ${matchedRequestData.providerItemInfo['critical']}"),
//                                SizedBox(width: 30.0,),
//                                Text("Procure : ${matchedRequestData.providerItemInfo['procure']}"),
//                              ],
//                            ),
//                            Text("Item Updated : ${matchedRequestData.providerItemInfo['itemUpdated']}"),
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
                enabled: matchedRequestList.length > 0 ? true : false,
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
    matchedRequestFilteredList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < matchedRequestList.length; i++) {
      if (matchedRequestList[i]
          .item
          .toLowerCase()
          .contains(text.toLowerCase())) {
        matchedRequestFilteredList.add(matchedRequestList[i]);
      }
    }

    setState(() {});
  }
}
