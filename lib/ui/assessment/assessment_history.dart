import 'package:flutter/material.dart';
import '../custom_drawer/custom_app_bar.dart';
import '../../utils/app_preferences.dart';
import 'assessmentInappWebview.dart';
import 'package:http/http.dart' as http;
import '../../repo/common_repository.dart';
import 'dart:convert';
import '../booking_appointment/models/doctor_info.dart';
import 'models/assessment_history_model.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../ui_utils/icon_utils.dart';
import 'package:flutter/cupertino.dart';
import '../../ui_utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssessmentHistory extends StatefulWidget {
  final String selectedLabel;
  final String username;
  final String departmentName;
  final String email;
  final String phoneNo;
  final bool showFab;
  AssessmentHistory(this.selectedLabel,
      {this.username,
      this.departmentName,
      this.showFab,
      this.email,
      this.phoneNo});
  @override
  _AssessmentHistoryState createState() => _AssessmentHistoryState();
}

class _AssessmentHistoryState extends State<AssessmentHistory> {
  List<AssessmentHistoryModel> assessmentHistoryList = [];
  List<AssessmentHistoryModel> assessmentHistoryListFilter = [];
  var controller = TextEditingController();
  bool loading = true;
  bool error = false;

  @override
  initState() {
    fetchAssessmentHistoryList();
    super.initState();
  }

  fetchAssessmentHistoryList() async {
    var response = await http.get(WebserviceConstants.baseAdminURL +
        "/departments/${widget.departmentName}/users/${widget.username}");
    if (response.statusCode > 199 && response.statusCode < 300) {
      var jsonData = UserAsDoctorInfo.fromJson(json.decode(response.body));
      var assessmentsResponse = await http.get(WebserviceConstants
              .baseFilingURL +
          "/campaignData/formId/${jsonData.sourceReferenceId}/user/${widget.username}");
      if (assessmentsResponse.statusCode > 199 &&
          assessmentsResponse.statusCode < 300) {
        List<dynamic> data = json.decode(assessmentsResponse.body);
        data.forEach((e) {
          assessmentHistoryList.add(AssessmentHistoryModel.fromJson(e));
          assessmentHistoryList.sort((a, b) {
            return DateTime.parse(b.createdOn)
                .compareTo(DateTime.parse(a.createdOn));
          });
        });
        assessmentHistoryListFilter.addAll(assessmentHistoryList);
        loading = false;
        setState(() {});
      } else {
        setState(() {
          error = true;
          loading = false;
        });
      }
    } else {
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  filterRecords() {
    assessmentHistoryListFilter = assessmentHistoryList.where((element) {
      print(element.createdOn);
      return element.createdOn.contains(controller.text);
    }).toList();
    setState(() {});
  }

  Future<DateTime> showDatePicker() {
    DateTime dateTime = DateTime.now();
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Dismiss"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(dateTime);
                    String selectedDate =
                        new DateFormat(DateUtils.defaultDateFormat)
                            .format(dateTime);
                    // print(selectedDate);
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CupertinoDatePicker(
                minimumDate: DateTime.parse("2021-01-01"),
                maximumDate: DateTime.now().add(Duration(days: 365 * 2)),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (newDate) {
                  dateTime = newDate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.selectedLabel,
        pageId: null,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppUIDimens.paddingSmall),
                        child: InkWell(
                          onTap: () async {
                            var date = await showDatePicker();
                            if (date != null) {
                              controller.text = date.year.toString() +
                                  "-" +
                                  (date.month < 10
                                      ? "0" + date.month.toString()
                                      : date.month.toString()) +
                                  "-" +
                                  (date.day < 10
                                      ? "0" + date.day.toString()
                                      : date.day.toString());
                            }
                          },
                          child: TextFormField(
                            onChanged: (data) {
                              //_filter(data);

                              if (data.length == 0) {
                                setState(() {
                                  // appointmentDataFilterList =
                                  //     widget.appointmentHistoryDataList;
                                });
                              }
                            },
                            enabled: false,
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: "Search by date",
                              fillColor: Colors.white,
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
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
                                    : "Please select a date to search the assessments";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.blueGrey,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          if (controller.text.length > 0) {
                            filterRecords();
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please select a date to search the assessments",
                                gravity: ToastGravity.TOP);
                          }
                        },
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Date",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                          ),
                          loading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(),
                          (assessmentHistoryListFilter.length == 0 &&
                                      !loading ||
                                  error)
                              ? Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                      child: Container(
                                          child: Text("No Data Found"))),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: assessmentHistoryListFilter
                                      .map(
                                        (e) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                    onTap: () async {
                                                      var refresh = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => PatientAssessmentInappWebview(
                                                                  title:
                                                                      "Assessment",
                                                                  departmentName:
                                                                      AppPreferences()
                                                                          .deptmentName,
                                                                  userName:
                                                                      AppPreferences()
                                                                          .username,
                                                                  emailId:
                                                                      AppPreferences()
                                                                          .email,
                                                                  mobileNo:
                                                                      AppPreferences()
                                                                          .phoneNo,
                                                                  formId: e.id,
                                                                  userCategory:
                                                                      AppPreferences()
                                                                          .userCategory)));
                                                      refreshList(refresh);
                                                    },
                                                    child: Text(
                                                        DateUtils
                                                            .convertUTCToLocalTime(
                                                                e.createdOn),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17))),
                                              ),
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      )
                                      .toList()),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.showFab != null && widget.showFab
          ? FloatingActionButton(
              onPressed: () async {
                var refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PatientAssessmentInappWebview(
                              title: "Assessment",
                              departmentName: widget.departmentName,
                              userName: widget.username,
                              emailId: AppPreferences().email,
                              mobileNo: AppPreferences().phoneNo,
                            )));
                refreshList(refresh);
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  refreshList(bool refresh) {
    if (refresh != null && refresh) {
      assessmentHistoryList.clear();
      fetchAssessmentHistoryList();
    }
  }
}
