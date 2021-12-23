import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/supplierItemsList_bloc.dart';
import '../../../ui/b2c/model/supplier_item_inprocess_model.dart';
import '../../../ui/committees/widgets/formField_dropdown.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/network_check.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../utils/app_preferences.dart';

class RequestDetailsScreen extends StatefulWidget {
  final SupplierItemInProcessDataModel supplierItemInProcessData;

  const RequestDetailsScreen({Key key, this.supplierItemInProcessData})
      : super(key: key);

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  TextEditingController actionController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    actionController.text = "Accept";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Details"),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .32,
                                child: Text(
                                  "Request Id :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .52,
                                child: Text(
                                    "${widget.supplierItemInProcessData.id}"),
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
                                width: MediaQuery.of(context).size.width * .32,
                                child: Text(
                                  "Request Item :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .52,
                                child: Text(
                                    "${widget.supplierItemInProcessData.orderItem}"),
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
                                width: MediaQuery.of(context).size.width * .32,
                                child: Text(
                                  "Request Quantity :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .52,
                                child: Text(
                                    "${widget.supplierItemInProcessData.orderQuantity}"),
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
                                width: MediaQuery.of(context).size.width * .32,
                                child: Text(
                                  "Request By :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .52,
                                child: Text(
                                    "${widget.supplierItemInProcessData.orderBy}"),
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
                                width: MediaQuery.of(context).size.width * .32,
                                child: Text(
                                  "Request Created on :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .52,
                                child: Text(
                                    "${widget.supplierItemInProcessData.orderCreated}"),
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
                                width: MediaQuery.of(context).size.width * .32,
                                child: Text(
                                  "Request Status :",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .52,
                                child: Text(
                                    "${widget.supplierItemInProcessData.orderStatus}"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 15, bottom: 5, right: 15.0),
                      child: Text("Action",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    )),
                Container(
                  //height: 50.0,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DropDownFormField(
                    filled: false,
                    titleText: null,
                    hintText: "",
                    value: actionController.text,
                    onSaved: (value) {
                      setState(() {
                        actionController.text = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        actionController.text = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Accept",
                        "value": "Accept",
                      },
                      {
                        "display": "Reject",
                        "value": "Reject",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 15, bottom: 0, right: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text("Comment :",
                              style: TextStyle(fontWeight: FontWeight.w700)),
//                    Text(
//                      "* ",
//                      style: TextStyle(color: Colors.red),
//                    ),
                          // Text("(Min. 10 and Max. 120 chars. ):")
                        ],
                      ),
                    )),
                Container(
                    //width: MediaQuery.of(context).size.width*.8,
                    //height: 50.0,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 5, bottom: 0, right: 20.0),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                        ),
                        maxLength: 120,
                        decoration: InputDecoration(
                          hintText: "Comment",

                          //hintStyle: Utils.hintStyleBlack,
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
//                  validator: (String arg) {
//                    if (arg.length == 0) {
//                      return "Description cannot be empty";
//                    } else if (arg.length < 10) {
//                      return "(Min. 10 and Max. 120 chars. )";
//                    } else {
//                      return null;
//                    }
//                  },
                        onSaved: (String val) {
                          descriptionController.text = val;
                        },
                      ),
                    )),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      _acceptOrRejectRequestDetails();
                    },
                    color: AppColors.primaryColor,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
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
    );
  }

  void _acceptOrRejectRequestDetails() async {
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
    String orderConfirm;

    if (actionController.text.toString() == "Accept") {
      orderConfirm = "Yes";
    } else {
      orderConfirm = "No";
    }

    SupplierItemsListBloc _bloc = new SupplierItemsListBloc(context);
    _bloc.acceptRejectOrder(orderConfirm, widget.supplierItemInProcessData.id,
        descriptionController.text.toString());
    _bloc.acceptRejectOrderFetcher.listen((response) async {
      if (response.status == 200) {
        print("Hello Pranay Login is successful ${response.status}");

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Responded Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
        Navigator.pushReplacementNamed(context, Routes.supplyInProcess);
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
