import '../../../ui/b2c/model/matched_supply_data_model.dart';
import '../../../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MatchedSupplyRequesterDetailsScreen extends StatefulWidget {
  final MatchedSupplyDataModel matchedSupplyData;

  const MatchedSupplyRequesterDetailsScreen({Key key, this.matchedSupplyData})
      : super(key: key);

  @override
  _MatchedSupplyRequesterDetailsScreenState createState() =>
      _MatchedSupplyRequesterDetailsScreenState();
}

class _MatchedSupplyRequesterDetailsScreenState
    extends State<MatchedSupplyRequesterDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // actionController.text = "Accept";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requester Details"),
        centerTitle: true,
      ),
      body: Padding(
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
                                  "Requester Name :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.matchedSupplyData.firstName} ${widget.matchedSupplyData.lastName}"),
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.matchedSupplyData.organizationName}"),
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.matchedSupplyData.jobTitle}"),
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.matchedSupplyData.address}"),
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child:
                                      Text("${widget.matchedSupplyData.city}"),
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child:
                                      Text("${widget.matchedSupplyData.state}"),
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.matchedSupplyData.zipCode}"),
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.matchedSupplyData.description}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.matchedSupplyData.isSameItemName
                            ? SizedBox(
                                height: 5.0,
                              )
                            : Container(),
                        widget.matchedSupplyData.isSameItemName
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
                                            "${widget.matchedSupplyData.item}"),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        widget.matchedSupplyData.matchingTags.length > 0
                            ? SizedBox(
                                height: 5.0,
                              )
                            : Container(),
                        widget.matchedSupplyData.matchingTags.length > 0
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
                                            itemCount: widget.matchedSupplyData
                                                .matchingTags.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                color: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Text(
                                                    "${widget.matchedSupplyData.matchingTags[index]}",
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
                          "Item requested",
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
                              border:
                                  Border.all(width: 1.0, color: Colors.grey),
                              // color: AppColors.borderShadow,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${widget.matchedSupplyData.item}",
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
                                        "Requested Quantity : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${widget.matchedSupplyData.quantity}"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("In no. of days : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "${widget.matchedSupplyData.arrangeDate}"),
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
                SizedBox(
                  height: 30.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
