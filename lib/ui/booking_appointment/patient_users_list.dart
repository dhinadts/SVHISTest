import 'dart:async';
import 'dart:convert';

import '../../ui/tabs/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../ui_utils/ui_dimens.dart';

import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../custom_drawer/custom_app_bar.dart';
import 'models/patient_model.dart';
import 'select_physician_screen.dart';

class PatientUserList extends StatefulWidget {
  @override
  _PatientUserListState createState() => _PatientUserListState();
}

class _PatientUserListState extends State<PatientUserList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  List<PatientModel> patientList = [];
  List<PatientModel> patientListFiltered = [];

  TextEditingController searchPatientController = TextEditingController();
  bool searchIconPos = true;
  @override
  initState() {
    apiCall();
    super.initState();
    initializeAd();
  }

  Future<Null> apiCall({String query}) async {
    http.Response res = await http.get(WebserviceConstants.baseFilingURL +
        "/campaignData/${AppPreferences().deptmentName}");
    if (res.statusCode == 200) {
      List list = json.decode(res.body);

      setState(() {
        patientList = list.map((e) => PatientModel.fromJson(e)).toList();
      });
    }
  }

  onSearchTextChanged(String text) async {
    patientListFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    patientList.forEach((userDetail) {
      if ((userDetail.emailId != null &&
              userDetail.emailId.toLowerCase().contains(text)) ||
          (userDetail.mobileNo != null &&
              userDetail.mobileNo.toLowerCase().contains(text)) ||
          (userDetail.userName != null &&
              userDetail.userName.toLowerCase().contains(text)))
        patientListFiltered.add(userDetail);
    });

    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "User List",
          pageId: 0,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            child: Column(children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        padding: EdgeInsets.symmetric(
                            //vertical: AppUIDimens.paddingSmall,
                            horizontal: AppUIDimens.paddingSmall),
                        child: TextFormField(
                            focusNode: focusNode,
                            controller: searchPatientController,
                            decoration: InputDecoration(
                              labelText: "Search by name",
                              // helperText: "",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: AppUIDimens.paddingSmall,
                                  horizontal: AppUIDimens.paddingSmall),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                //fillColor: Colors.green
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isNotEmpty) {
                                return value.length > 1
                                    ? null
                                    : "Search string must be 2 characters";
                              } else {
                                return null;
                              }
                            }),
                      ),
                      Transform.translate(
                        offset: Offset(0, searchIconPos ? 0 : -13),
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.blueGrey,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.search),
                            color: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                onSearchTextChanged(
                                    searchPatientController.text);
                              }
                              if (searchPatientController.text.length == 0) {
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)
                                        .translate("key_entersometext"),
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 5,
                                    gravity: ToastGravity.TOP);
                                focusNode.requestFocus();
                              }
                              if (_formKey.currentState.validate() == false) {
                                setState(() {
                                  searchIconPos = false;
                                });
                              } else {
                                setState(() {
                                  searchIconPos = true;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              patientList == null ||
                      patientList.isEmpty ||
                      patientList.length == 0
                  ? Expanded(child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: patientListFiltered.length != 0 ||
                                  searchPatientController.text.isNotEmpty
                              ? patientListFiltered.length == 0
                                  ? 1
                                  : patientListFiltered.length
                              : patientList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return patientListFiltered.length == 0 &&
                                    searchPatientController.text.isNotEmpty
                                ? Center(child: Text("No data"))
                                : getListItem(patientListFiltered.length != 0 ||
                                        searchPatientController.text.isNotEmpty
                                    ? patientListFiltered[i]
                                    : patientList[i]);
                          })),

              /// Show Banner Ad
              getSivisoftAdWidget(),
            ]),
          ),
        ));
  }

  Widget getListItem(PatientModel e) {
    return InkWell(
      onTap: () {
        String fulNameDummy = e.firstName.isNotEmpty &&
                (e.lastName != null || e.lastName.isNotEmpty)
            ? e.firstName + " " + e.lastName
            : e.firstName;
        var patientDetails = {
          'userName': e.userName ?? '',
          'firstName': e.firstName ?? '',
          'lastName': e.lastName ?? '',
          'fullName': fulNameDummy,
        };
        // debugPrint("testlaya");
        // debugPrint(patientDetails.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          // print(e.userName);
          // print(e.lastName);
          // print(e.firstName);
          // print(patientDetails['fullName']);
          return SelectPhysicianScreen(
              title: "Select Doctor", patientDetails: patientDetails);
        }));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/images/userInfo.png"),
        ),
        title: Text(e.userName != null ? e.userName : ""),
        subtitle: Column(
          children: [
            Row(
              children: [
                Icon(Icons.phone, size: 15),
                Text(
                  e.mobileNo != null ? e.mobileNo : "",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.mail, size: 15),
                Text(e.emailId != null ? e.emailId : "",
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
