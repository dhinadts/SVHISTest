import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/requestedItemsList_bloc.dart';
import '../../../ui/b2c/bloc/staticDetails_bloc.dart';
import '../../../ui/b2c/model/requested_item_model.dart';
import '../../../ui/committees/widgets/formField_dropdown.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/network_check.dart';
import '../../../ui_utils/widget_styles.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../../utils/app_preferences.dart';
class RequestScreen extends StatefulWidget {
  final RequestedItemModel requestedItemData;

  const RequestScreen({Key key, this.requestedItemData}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> itemsList = new List();
  final List<DropdownMenuItem> dropDownItemsList = [];

  bool isItemsListLoading = false;
  bool _autoValidate = false;
  String selectedItem;
  String recommendedTags = "";
  final DateFormat gnatDobFormat = DateFormat("dd/MM/yyyy");
  bool _selectQtyActive = false;
  bool update = false;
  TextEditingController itemController = new TextEditingController();
  TextEditingController procureController = new TextEditingController();
  TextEditingController criticalController = new TextEditingController();
  TextEditingController transportController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController itemQtyController = new TextEditingController();
  TextEditingController needInDaysController = new TextEditingController();
  TextEditingController tagsController = new TextEditingController();

  String _chosenValue;

  var dateController = TextEditingController();

  // var focusNodeTransport = new FocusNode();

  @override
  void initState() {
    setState(() {
      isItemsListLoading = true;
    });
    if (widget.requestedItemData != null) {
      //  print("Hello Pranay if requestedItemData is not null");
      update = true;
      if (widget.requestedItemData.quantity > 0 ||
          widget.requestedItemData.arrangeDate > 0) {
        _selectQtyActive = true;
      }
      itemController.text = widget.requestedItemData.item;
      procureController.text = widget.requestedItemData.procure;
      criticalController.text = widget.requestedItemData.critical;
      descriptionController.text = widget.requestedItemData.description;
      itemQtyController.text = widget.requestedItemData.quantity.toString();
      transportController.text = widget.requestedItemData.transport;
      needInDaysController.text =
          widget.requestedItemData.arrangeDate.toString();
      tagsController.text = widget.requestedItemData.tags;
    } else {
      // print("Hello Pranay if requestedItemData is null");
      procureController.text = "Buy";
      criticalController.text = "Yes";
      transportController.text = "Yes";
      itemController.text = "";
    }

    getItemsList();
    getTodaysDate();
    super.initState();
  }

  getItemsList() {
    StaticDetailsBloc itemsListBloc = StaticDetailsBloc(context);
    itemsList = new List();
    /*itemsListBloc.fetchItemsList();
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
    });*/

    setState(() {
      dropDownItemsList.add(
        DropdownMenuItem(
            child: Text("Nursing Care for ICU"), value: "Nursing Care for ICU"),
      );
      dropDownItemsList.add(
        DropdownMenuItem(
            child: Text("Nursing Care for Esophageal cancer"),
            value: "Nursing Care for Esophageal cancer"),
      );
      dropDownItemsList.add(
        DropdownMenuItem(
            child: Text("Nursing Care for Lung Cancer"),
            value: "Nursing Care for Lung Cancer"),
      );
      dropDownItemsList.add(
        DropdownMenuItem(
            child: Text("Nursing care for patient attendant"),
            value: "Nursing care for patient attendant"),
      );
      isItemsListLoading = false;
    });
  }

  void _onActiveChanged(bool newValue) => setState(() {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectQtyActive = newValue;
      });

  getTodaysDate() {
    dateController.text = gnatDobFormat.format(DateTime.now());
  }

  openDateSelector() {
    FocusScope.of(context).requestFocus(new FocusNode());
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now().subtract(Duration(days: 5490)),
        minTime: DateTime.now().subtract(Duration(days: 43830)),
        theme: WidgetStyles.datePickerTheme, onChanged: (date) {
      // print('change $date in time zone ' +
      // date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      // print('confirm $date');

      setState(() {
        dateController.text = gnatDobFormat.format(date.toLocal());
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    // locale:
    //     AppPreferences().isLanguageTamil() ? LocaleType.ta : LocaleType.en);
  }

  @override
  Widget build(BuildContext context) {
    String allTags = recommendedTags;
    List<String> tagsList = allTags.split(',');
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: update ? Text("Update Request") : Text("Add Request"),
        centerTitle: true,
        /* leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
            // Navigator.pushReplacementNamed(
            //     context, Routes.requesterDashBoard);
          },
        ),*/
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10, bottom: 0, right: 20.0),
                            child: Row(
                              children: <Widget>[
                                Text("Service Available "),
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
                                        hint: "Service title",
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
                                            // print("selectedItem is ${itemController.text}");
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
                                                "Service cannot be empty",
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 20.0, bottom: 8.0),
                          child: Text(
                            "Request Date",
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(
                              labelText: "Select Date",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(12),
                              isDense: true,
                            ),
                            onTap: () {
                              openDateSelector();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 5.0),
                          child: Text(
                            "Request For",
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.grey[600],
                                  style: BorderStyle.solid,
                                  width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                focusColor: Colors.white,
                                value: _chosenValue,
                                isExpanded: true,
                                style: TextStyle(color: Colors.white),
                                iconEnabledColor: Colors.black,
                                items: <String>[
                                  'Full Day',
                                  'First Session',
                                  'Second Session',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Select",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    _chosenValue = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        /* Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 15, bottom: 5, right: 15.0),
                              child: Text(
                                  "Procure/Services(ability to procure these items?)"),
                            )),
                        Container(
                          //height: 50.0,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: DropDownFormField(
                            filled: false,
                            titleText: null,
                            hintText: "",
                            value: procureController.text,
                            onSaved: (value) {
                              setState(() {
                                procureController.text = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                procureController.text = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Buy",
                                "value": "Buy",
                              },
                              {
                                "display": "Donation",
                                "value": "Donation",
                              },
                              {
                                "display": "Hire",
                                "value": "Hire",
                              },
                              {
                                "display": "Hourly",
                                "value": "Hourly",
                              },
                              {
                                "display": "Contract",
                                "value": "Contract",
                              },
                              {
                                "display": "Permanent",
                                "value": "Permanent",
                              },
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),*/
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 12, bottom: 5, right: 15.0),
                              child: Text("Critical"),
                            )),
                        Container(
                          //height: 50.0,
                          padding: EdgeInsets.only(left: 16, right: 16),

                          child: DropDownFormField(
                            filled: false,
                            titleText: null,
                            hintText: "",
                            /* decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              isDense: true,
                            ),*/
                            value: criticalController.text,
                            onSaved: (value) {
                              setState(() {
                                criticalController.text = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                criticalController.text = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Yes",
                                "value": "Yes",
                              },
                              {
                                "display": "No",
                                "value": "No",
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
                                  left: 20, top: 12, bottom: 0, right: 15.0),
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
                        /* Container(
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
                        _selectQtyActive
                            ? Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 5,
                                            bottom: 0,
                                            right: 15.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text("Item Quantity "),
                                            Text(
                                              "* ",
                                              style:
                                                  TextStyle(color: Colors.red),
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
                                          controller: itemQtyController,
                                          inputFormatters: [
                                            new WhitelistingTextInputFormatter(
                                                RegExp("[0-9]")),
                                          ],
                                          keyboardType: TextInputType.number,
                                          autocorrect: false,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "Quantity",

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
                                            itemQtyController.text = val;
                                          },
                                          validator: (String arg) {
                                            if (arg.length > 0 &&
                                                int.parse(arg) > 0 &&
                                                int.parse(arg) < 10001) {
                                              return null;
                                            } else {
                                              return Constants
                                                  .VALIDATION_QUANTITY;
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
                                            bottom: 5,
                                            right: 15.0),
                                        child: Text(
                                            "Transport(Do i have transportation to pick up my supplies?)"),
                                      )),
                                  Container(
                                    //height: 50.0,
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),

                                    child: DropDownFormField(
                                      filled: false,
                                      titleText: null,
                                      hintText: "",
                                      value: transportController.text,
                                      onSaved: (value) {
                                        setState(() {
                                          transportController.text = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          //focusNodeTransport.requestFocus();
                                          transportController.text = value;
                                        });
                                      },
                                      dataSource: [
                                        {
                                          "display": "Yes",
                                          "value": "Yes",
                                        },
                                        {
                                          "display": "No",
                                          "value": "No",
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
                                            left: 20,
                                            top: 15,
                                            bottom: 0,
                                            right: 15.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                                "Need(need these supplies in the following days)"),
                                            Text(
                                              "* ",
                                              style:
                                                  TextStyle(color: Colors.red),
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
                                          controller: needInDaysController,
                                          inputFormatters: [
                                            new WhitelistingTextInputFormatter(
                                                RegExp("[0-9]")),
                                          ],
                                          keyboardType: TextInputType.number,
                                          autocorrect: false,
                                          textInputAction: TextInputAction.next,

                                          decoration: InputDecoration(
                                            hintText: "Days",
                                            fillColor: Colors.transparent,
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                          onSaved: (String val) {
                                            needInDaysController.text = val;
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
                            : Container(),*/
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 0, bottom: 0, right: 15.0),
                              child: Text("Key descriptors"),
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
                                    left: 20, top: 15, bottom: 0, right: 15.0),
                                child: Container(
                                  //height: 30.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              "Recommended Key Descriptors : ",
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
                        Center(
                          child: RaisedButton(
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
      //  print("Value of tags $value");

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
      // print("Value of Item ${itemController.text}");
      if (itemController.text.isNotEmpty) {
        //   print("Value of Item ${itemController.text}");
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

    RequestedItemModel newRequestData = new RequestedItemModel();

    newRequestData.item = itemController.text.toString();
    newRequestData.procure = procureController.text.toString();
    newRequestData.critical = criticalController.text.toString();
    newRequestData.description = descriptionController.text.toString();
    newRequestData.tags = tagsController.text.toString();
    _selectQtyActive && itemQtyController.text.isNotEmpty
        ? newRequestData.quantity = int.parse(itemQtyController.text.toString())
        : newRequestData.quantity = 0;
    _selectQtyActive
        ? newRequestData.transport = transportController.text.toString()
        : newRequestData.transport = "";
    _selectQtyActive && needInDaysController.text.isNotEmpty
        ? newRequestData.arrangeDate =
            int.parse(needInDaysController.text.toString())
        : newRequestData.arrangeDate = 0;
    newRequestData.comment = tagsController.text.toString();
    if (update) {
      newRequestData.id = widget.requestedItemData.id;
    }

    RequestedItemsListBloc _bloc = new RequestedItemsListBloc(context);
    _bloc.createOrUpdateRequest(newRequestData, isUpdate: update);
    _bloc.requestCreateFetcher.listen((response) async {
      if (response.status == 200) {
        //    print("Hello Pranay Request submission is successful");
        if (update) {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Request updated successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        } else {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Request submitted successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
        CustomProgressLoader.cancelLoader(context);
        Navigator.pushReplacementNamed(context, Routes.requesterDashBoard);
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
