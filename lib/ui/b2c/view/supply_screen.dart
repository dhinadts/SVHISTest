import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/staticDetails_bloc.dart';
import '../../../ui/b2c/bloc/supplierItemsList_bloc.dart';
import '../../../ui/b2c/model/supplier_item_model.dart';
import '../../../ui/committees/widgets/formField_dropdown.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/network_check.dart';
import '../../../utils/constants.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SupplyScreen extends StatefulWidget {
  final SupplierItemModel supplierItemData;

  const SupplyScreen({Key key, this.supplierItemData}) : super(key: key);

  @override
  _SupplyScreenState createState() => _SupplyScreenState();
}

class _SupplyScreenState extends State<SupplyScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> itemsList = new List();
  final List<DropdownMenuItem> dropDownItemsList = [];

  bool isItemsListLoading = false;
  bool _autoValidate = false;
  String selectedItem;

  bool _selectQtyActive = false;
  bool update = false;
  String recommendedTags = "";
  TextEditingController itemController = new TextEditingController();
  TextEditingController capableSuppliesController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController unitController = new TextEditingController();
  TextEditingController itemQtyController = new TextEditingController();
  TextEditingController qtyArrangedController = new TextEditingController();

  TextEditingController daysToArrangeController = new TextEditingController();
  TextEditingController tagsController = new TextEditingController();

  //var focusNodeTransport = new FocusNode();

  @override
  void initState() {
    setState(() {
      isItemsListLoading = true;
    });
    if (widget.supplierItemData != null) {
      print("Hello Pranay if requestedItemData is not null");
      update = true;
      if (widget.supplierItemData.quantity > 0 ||
          widget.supplierItemData.arrangeQuantity > 0 ||
          widget.supplierItemData.arrangeDate > 0) {
        _selectQtyActive = true;
      }
      itemController.text = widget.supplierItemData.item;
      capableSuppliesController.text = widget.supplierItemData.capableSupplies;
      descriptionController.text = widget.supplierItemData.description;
      unitController.text = widget.supplierItemData.unit.toString();
      itemQtyController.text = widget.supplierItemData.quantity.toString();
      qtyArrangedController.text =
          widget.supplierItemData.arrangeQuantity.toString();
      daysToArrangeController.text =
          widget.supplierItemData.arrangeDate.toString();
      tagsController.text = widget.supplierItemData.allTags;
    } else {
      print("Hello Pranay if requestedItemData is null");
      capableSuppliesController.text = "Sell";
      itemController.text = "";
    }

    getItemsList();
    super.initState();
  }

  getItemsList() {
    StaticDetailsBloc itemsListBloc = StaticDetailsBloc(context);
    itemsList = new List();
    itemsListBloc.fetchItemsList();
    itemsListBloc.itemsListFetcher.listen((value) async {
      value.forEach((element) {
        // itemsList.add(element);

        dropDownItemsList.add(DropdownMenuItem(
          child: Text(element.toString()),
          value: element.toString(),
        ));
      });

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        isItemsListLoading = false;
      });
    });
  }

  void _onActiveChanged(bool newValue) => setState(() {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectQtyActive = newValue;
      });

  @override
  Widget build(BuildContext context) {
    String allTags = recommendedTags;
    List<String> tagsList = allTags.split(',');
    return Scaffold(
      appBar: AppBar(
        title: update ? Text("Update Supply") : Text("Add Supply"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, Routes.supplierDashBoard);
            }),
        centerTitle: true,
      ),
      body: isItemsListLoading == false
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 15, bottom: 0, right: 15.0),
                            child: Row(
                              children: <Widget>[
                                Text("Item Name "),
                                Text(
                                  "*",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                        update
                            ? Container(
                                //width: MediaQuery.of(context).size.width*.8,
                                height: 60.0,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 5, bottom: 0, right: 20.0),
                                  child: TextFormField(
                                    controller: itemController,
                                    enabled: false,

//                              inputFormatters: [
//                                new WhitelistingTextInputFormatter(
//                                    RegExp("[0-9]")),
//                              ],
                                    //keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.next,

                                    decoration: InputDecoration(
                                      //hintText: "Unit",

                                      //hintStyle: Utils.hintStyleBlack,
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    onSaved: (String val) {
                                      itemController.text = val;
                                    },
                                  ),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 0, bottom: 0, right: 15.0),
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.grey[500],
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: SearchableDropdown.single(
                                        items: dropDownItemsList,
                                        value: itemController.text,
                                        hint: "Item Name",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black),
                                        searchHint: "Search Item",
                                        underline: null,
                                        onChanged: (value) {
                                          setState(() {
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                            if (value == null)
                                              itemController.text = "";
                                            else
                                              itemController.text = value;
                                            print(
                                                "selectedItem is ${itemController.text}");
                                            getItemRelatedTagList(
                                                itemController.text);
                                          });
                                        },
                                        dialogBox: false,
                                        isExpanded: true,
                                        menuConstraints: BoxConstraints.tight(
                                            Size.fromHeight(350)),
                                        validator: (_autoValidate)
                                            ? (selectedItemsForValidator) {
                                                if (selectedItemsForValidator ==
                                                    null) {
                                                  return ("");
                                                }
                                                return (null);
                                              }
                                            : null,
                                      ),
                                    ),
                                    (_autoValidate &&
                                            itemController.text.isEmpty)
                                        ? Container(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: Text(
                                                "Item cannot be empty",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xffD32F2F)),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 15, bottom: 0, right: 15.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Description "),
                                  Text(
                                    "* ",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Text("(Min. 10 and Max. 120 chars. ):")
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
                                  hintText: "Description",

                                  //hintStyle: Utils.hintStyleBlack,
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                                validator: (String arg) {
                                  if (arg.length == 0) {
                                    return "Description cannot be empty";
                                  } else if (arg.length < 10) {
                                    return "(Min. 10 and Max. 120 chars. )";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (String val) {
                                  descriptionController.text = val;
                                },
                              ),
                            )),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 15, bottom: 5, right: 15.0),
                              child: Text("Sell/Donate"),
                            )),
                        Container(
                          //height: 50.0,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: DropDownFormField(
                            filled: false,
                            titleText: null,
                            hintText: "",
                            value: capableSuppliesController.text,
                            onSaved: (value) {
                              setState(() {
                                capableSuppliesController.text = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                capableSuppliesController.text = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Sell",
                                "value": "Sell",
                              },
                              {
                                "display": "Donate",
                                "value": "Donate",
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
                                  left: 20, top: 0, bottom: 0, right: 15.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Select to enter quantity "),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Switch(
                                    value: _selectQtyActive,
                                    onChanged: _onActiveChanged,
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            )),
                        if (_selectQtyActive)
                          Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 5,
                                        bottom: 0,
                                        right: 15.0),
                                    child: Text("Unit "),
                                  )),
                              Container(
                                  //width: MediaQuery.of(context).size.width*.8,
                                  height: 60.0,
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 5,
                                        bottom: 0,
                                        right: 20.0),
                                    child: TextFormField(
                                      controller: unitController,

//                              inputFormatters: [
//                                new WhitelistingTextInputFormatter(
//                                    RegExp("[0-9]")),
//                              ],
                                      //keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,

                                      decoration: InputDecoration(
                                        hintText: "Unit",

                                        //hintStyle: Utils.hintStyleBlack,
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      onSaved: (String val) {
                                        unitController.text = val;
                                      },
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 15,
                                        bottom: 0,
                                        right: 15.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text("Item Quantity"),
                                        Text(
                                          "* ",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                  //width: MediaQuery.of(context).size.width*.8,
                                  height: 60.0,
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 5,
                                        bottom: 0,
                                        right: 20.0),
                                    child: TextFormField(
                                      //focusNode: focusNodeTransport,
                                      controller: itemQtyController,
                                      inputFormatters: [
                                        new WhitelistingTextInputFormatter(
                                            RegExp("[0-9]")),
                                      ],
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,

                                      decoration: InputDecoration(
                                        hintText: "Item Quantity",
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      onSaved: (String val) {
                                        itemQtyController.text = val;
                                      },
                                      validator: (String arg) {
                                        if ((arg.length > 0 &&
                                            int.parse(arg) > 0 &&
                                            int.parse(arg) < 100001)) {
                                          return null;
                                        } else {
                                          return Constants
                                              .VALIDATION_SUPPLY_QUANTITY;
                                        }
                                      },
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 15,
                                        bottom: 0,
                                        right: 15.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text("Quantity Arranged"),
                                        Text(
                                          "* ",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                  //width: MediaQuery.of(context).size.width*.8,
                                  height: 60.0,
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 5,
                                        bottom: 0,
                                        right: 20.0),
                                    child: TextFormField(
                                      //focusNode: focusNodeTransport,
                                      controller: qtyArrangedController,
                                      inputFormatters: [
                                        new WhitelistingTextInputFormatter(
                                            RegExp("[0-9]")),
                                      ],
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,

                                      decoration: InputDecoration(
                                        hintText: "Quantity Arranged",
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      onSaved: (String val) {
                                        qtyArrangedController.text = val;
                                      },
                                      validator: (String arg) {
                                        if ((arg.length > 0 &&
                                            int.parse(arg) > 0 &&
                                            int.parse(arg) < 100001)) {
                                          return null;
                                        } else {
                                          return Constants
                                              .VALIDATION_SUPPLY_QUANTITY;
                                        }
                                      },
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 15,
                                        bottom: 0,
                                        right: 15.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text("#Days to Arrange"),
                                        Text(
                                          "* ",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                  //width: MediaQuery.of(context).size.width*.8,
                                  height: 60.0,
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 5,
                                        bottom: 0,
                                        right: 20.0),
                                    child: TextFormField(
                                      //focusNode: focusNodeTransport,
                                      controller: daysToArrangeController,
                                      inputFormatters: [
                                        new WhitelistingTextInputFormatter(
                                            RegExp("[0-9]")),
                                      ],
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,

                                      decoration: InputDecoration(
                                        hintText: "Days to Arrange",
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      onSaved: (String val) {
                                        daysToArrangeController.text = val;
                                      },
                                      validator: (String arg) {
                                        if ((arg.length > 0 &&
                                            int.parse(arg) > -1 &&
                                            int.parse(arg) < 32)) {
                                          return null;
                                        } else {
                                          return Constants.VALIDATION_DAYS;
                                        }
                                      },
                                    ),
                                  )),
                            ],
                          )
                        else
                          Container(),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 15, bottom: 0, right: 15.0),
                              child: Text("Key Descriptors"),
                            )),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 5, bottom: 0, right: 20.0),
                              child: TextFormField(
                                controller: tagsController,
                                maxLines: 3,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                decoration: InputDecoration(
                                  hintText: "Key descriptors",
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                                onSaved: (String val) {
                                  tagsController.text = val;
                                },
                              ),
                            )),
                        recommendedTags.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 15, bottom: 0, right: 12.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  // height: 30.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                        //width: MediaQuery.of(context).size.width*.8,
                                        alignment: Alignment.centerLeft,
                                        // width: MediaQuery.of(context).size.width*.3,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              "Recommended descriptor Keys : ",
                                              style: TextStyle(fontSize: 14.0)),
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        alignment: Alignment.centerLeft,
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
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          onPressed: () {
                            onSubmitClick();
                          },
                          elevation: 10.0,
                          color: AppColors.primaryColor,
                          child: update
                              ? Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
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

  getItemRelatedTagList(String itemName) async {
    var connectivityResult = await NetworkCheck().check();
    if (connectivityResult) {
      getItemRelatedTagListApiCall(itemName);
    } else {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: Constants.NO_INTERNET_CONNECTION,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  getItemRelatedTagListApiCall(String itemName) {
    CustomProgressLoader.showLoader(context);
    recommendedTags = "";
    //tagsController.clear();

    StaticDetailsBloc itemsListBloc = StaticDetailsBloc(context);
    itemsList = new List();
    itemsListBloc.fetchItemRelatedTagList(itemName);
    itemsListBloc.itemRelatedTagListFetcher.listen((value) async {
      print("Value of tags $value");

      setState(() {
        recommendedTags = value;
        // itemsList.add(element);

        tagsController.text = recommendedTags;
      });
    });

    CustomProgressLoader.cancelLoader(context);
  }

  void onSubmitClick() {
    _validateInputsForNewRequest();
  }

  void _validateInputsForNewRequest() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (itemController.text.isNotEmpty) {
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
      } else {
        setState(() {
          _autoValidate = true;
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Please fill or check the mandatory fields",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Please fill or check the mandatory fields",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      });
    }
  }

  apiCall() async {
    CustomProgressLoader.showLoader(context);

    SupplierItemModel newSupplyData = new SupplierItemModel();

    newSupplyData.item = itemController.text.toString();
    newSupplyData.description = descriptionController.text.toString();
    newSupplyData.capableSupplies = capableSuppliesController.text.toString();
    _selectQtyActive
        ? newSupplyData.unit = unitController.text.toString()
        : newSupplyData.unit = "";
    _selectQtyActive && itemQtyController.text.isNotEmpty
        ? newSupplyData.quantity = int.parse(itemQtyController.text.toString())
        : newSupplyData.quantity = 0;
    _selectQtyActive && qtyArrangedController.text.isNotEmpty
        ? newSupplyData.arrangeQuantity =
            int.parse(qtyArrangedController.text.toString())
        : newSupplyData.arrangeQuantity = 0;
    _selectQtyActive && daysToArrangeController.text.isNotEmpty
        ? newSupplyData.arrangeDate =
            int.parse(daysToArrangeController.text.toString())
        : newSupplyData.arrangeDate = 0;
    newSupplyData.allTags = tagsController.text.toString();
    if (update) {
      newSupplyData.id = widget.supplierItemData.id;
    }

    SupplierItemsListBloc _bloc = new SupplierItemsListBloc(context);
    _bloc.createOrUpdateSupply(newSupplyData, isUpdate: update);
    _bloc.supplyCreateFetcher.listen((response) async {
      if (response.status == 200) {
        print("Hello Pranay Request submission is successful");
        if (update) {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Supply details updated successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        } else {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Supply request submitted successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
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
