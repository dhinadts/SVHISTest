import '../../../ui/b2c/model/requested_item_model.dart';
import '../../../ui/committees/widgets/formField_dropdown.dart';
import '../../../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewRequestDetailsScreen extends StatefulWidget {
  final RequestedItemModel requestedItemData;

  const ViewRequestDetailsScreen({Key key, this.requestedItemData})
      : super(key: key);

  @override
  _ViewRequestDetailsScreenState createState() =>
      _ViewRequestDetailsScreenState();
}

class _ViewRequestDetailsScreenState extends State<ViewRequestDetailsScreen> {
  TextEditingController actionController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  var selectedStatus = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String allTags = widget.requestedItemData.tags;
    List<String> allTagList = allTags.split(',');
    List<String> tagsList = [];
    allTagList.forEach((element) {
      if (element.length > 0) {
        tagsList.add(element);
      }
    });
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text("View Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Text(
                                  "Service Requested :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child:
                                      Text("${widget.requestedItemData.item}"),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Text(
                                  "Fees :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: widget.requestedItemData.quantity == 0
                                      ? Text("N/A")
                                      : Text("Rs. 1200"),
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
                                width: 120,
                                child: Text(
                                  "Description :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.requestedItemData.description}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        /* Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Text(
                                  "Quantity :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: widget.requestedItemData.quantity == 0
                                      ? Text("N/A")
                                      : Text(
                                          "${widget.requestedItemData.quantity}"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),*/
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Text(
                                  "Request Date : ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.requestedItemData.itemUpdated}"),
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
                                width: 120,
                                child: Text(
                                  "Request Type :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.requestedItemData.procure}"),
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
                                width: 120,
                                child: Text(
                                  "Request Status :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    "Accepted",
                                  ),
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
                                width: 120,
                                child: Text(
                                  "Updated : ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                      "${widget.requestedItemData.itemUpdated}"),
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
                                width: 120,
                                child: Text(
                                  "OTP : ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    "75849",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
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
                                width: 120,
                                child: Text(
                                  "Status : ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: DropDownFormField(
                                    filled: false,
                                    titleText: null,
                                    hintText: "Select",
                                    value: selectedStatus,
                                    /*onSaved: (value) {
                                      setState(() {
                                        selectedStatus = value;
                                      });
                                    },*/
                                    onChanged: (value) {
                                      setState(() {
                                        // FocusScope.of(context)
                                        //     .requestFocus(new FocusNode());
                                        selectedStatus = value;
                                      });
                                    },
                                    dataSource: [
                                      {
                                        "display": "Completed",
                                        "value": "completed",
                                      },
                                      {
                                        "display": "In Progress",
                                        "value": "in_progress",
                                      },
                                    ],
                                    textField: 'display',
                                    valueField: 'value',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: AppColors.primaryColor,
                        )
                        /* widget.requestedItemData.tags.isNotEmpty
                            ? Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      child: Center(
                                          child: Text("Key Descriptors : ",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight:
                                                      FontWeight.w800))),
                                      //height: 50.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        //height: 50.0,
                                        height: 30.0,
                                        child: ListView.builder(
                                            itemCount: tagsList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                color: Colors.blue,
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
                              )
                            : Container(),*/
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertedDate(String dateString) {
    final DateFormat formatOld = DateFormat('MM-dd-yyyy HH:mm');
    var date = formatOld.parse(dateString);
    final DateFormat formatNew = DateFormat('dd/MM/yyyy');
    return formatNew.format(date);
  }
}
