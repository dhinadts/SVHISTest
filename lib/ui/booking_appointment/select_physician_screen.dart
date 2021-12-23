import 'dart:convert';

import '../../ui/tabs/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../ui_utils/ui_dimens.dart';

import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/booking_appointment/booking_appointment_screen.dart';
import '../../ui/booking_appointment/models/doctor_info.dart';
import '../../ui/booking_appointment/physician_details_screen.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import '../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'models/doctor.dart';

class SelectPhysicianScreen extends StatefulWidget {
  final String title;
  final Map patientDetails;

  const SelectPhysicianScreen({Key key, this.title, this.patientDetails})
      : super(key: key);

  @override
  _SelectPhysicianScreenState createState() => _SelectPhysicianScreenState();
}

class _SelectPhysicianScreenState extends State<SelectPhysicianScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  List<String> specialityList = List();
  List<Doctor> doctorList = List();
  List<Doctor> doctorFilteredList = List();
  List<Doctor> doctorSearchFilteredList = List();
  TextEditingController searchController = new TextEditingController();

  int selectedCategory = 0;

  bool _isLoading = false;
  bool _isDoctorLoading = false;
  bool searchIconPos = true;

  getSpecialistList() async {
    WebserviceHelper helper = WebserviceHelper();
    String loggedInUserName = await AppPreferences.getUsername();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    final response = await helper.get(
        WebserviceConstants.baseURL +
            "/subscription/references/values/SDX_APPOINTMENT_SPECIALITIES?sort=true&department_name=${AppPreferences().deptmentName}",
        headers: header,
        isOAuthTokenNeeded: false);
    // debugPrint("response - ${response.statusCode}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("specialityList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        setState(() {
          specialityList =
              List<String>.from(jsonMapData["specialityList"].map((x) => x));
          specialityList.insert(0, "All");
        });
      }
    }

    checkDoctorsList("All");

    setState(() {
      _isLoading = false;
    });
  }

  Future getDoctorsList() async {
    String username = await AppPreferences.getUsername();
    String deptName = await AppPreferences.getDeptName();

    Map<String, dynamic> request = {
      "columnList": [
        "firstName",
        "lastName",
        "active",
        "userFullName",
        "userName",
        "departmentName",
        "location",
        "specialities",
        "downloadProfileURL",
        "rating",
        "userCategory"
        // "fees",
      ],
      "entity": "User",
      "filterData": [
        {
          "columnName": "userCategory",
          "columnType": "STRING",
          "columnValue": ["DOCTOR"],
          "filterType": "EQUAL"
        },
        {
          "columnName": "departmentName",
          "columnType": "STRING",
          "columnValue": ['$deptName'],
          "filterType": "EQUAL"
        }
      ],
      "sortRequired": true
    };
    Map<String, String> header = {};

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);

    print("==================> CLient${AppPreferences().clientId}");
    String url = WebserviceConstants.baseAdminURL +
        "/sdxcontact" +
        "/users/dynamicsearch";
    print("URL : $url");
    print("request : ${request.toString()}");
    final response =
        await http.post(url, body: json.encode(request), headers: header);
    //print("Response body ${response.body}");

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("doctorList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        setState(() {
          doctorList = jsonMapData["doctorList"]
              .map<Doctor>((x) => Doctor.fromJson(x))
              .toList();
        });
      }
    }
    // doctorFilteredList = doctorList;
    doctorFilteredList.addAll(doctorList);
    getConsultantList();
    checkDoctorsList("All");

    setState(() {
      _isDoctorLoading = false;
      _isLoading = false;
    });
  }

  Future getConsultantList() async {
    String username = await AppPreferences.getUsername();
    String deptName = await AppPreferences.getDeptName();
    List<Doctor> consultantList = [];

    Map<String, dynamic> request = {
      "columnList": [
        "firstName",
        "lastName",
        "active",
        "userFullName",
        "userName",
        "departmentName",
        "location",
        "specialities",
        "downloadProfileURL",
        "rating",
        "userCategory"
        // "fees",
      ],
      "entity": "User",
      "filterData": [
        {
          "columnName": "userCategory",
          "columnType": "STRING",
          "columnValue": ["CONSULTANT"],
          "filterType": "EQUAL"
        },
        {
          "columnName": "departmentName",
          "columnType": "STRING",
          "columnValue": ['$deptName'],
          "filterType": "EQUAL"
        }
      ],
      "sortRequired": true
    };
    Map<String, String> header = {};

    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);

    print("==================> CLient${AppPreferences().clientId}");
    String url = WebserviceConstants.baseAdminURL +
        "/sdxcontact" +
        "/users/dynamicsearch";
    print("URL : $url");
    print("request : ${request.toString()}");
    final response =
        await http.post(url, body: json.encode(request), headers: header);
    //print("Response body ${response.body}");

    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("doctorList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }
      if (jsonData != null) {
        setState(() {
          consultantList = jsonMapData["doctorList"]
              .map<Doctor>((x) => Doctor.fromJson(x))
              .toList();
        });
      }
    }
    if (consultantList.length > 0) {
      for (int i = 0; i < consultantList.length; i++) {
        Doctor dObj = consultantList[i];
        dObj.isConsultant = true;
        doctorList.add(dObj);
      }
      doctorFilteredList.addAll(doctorList);
    }
    checkDoctorsList("All");

    setState(() {
      _isDoctorLoading = false;
      _isLoading = false;
    });
  }

  getDoctorsList1() async {
    WebserviceHelper helper = WebserviceHelper();
    String loggedInUserName = await AppPreferences.getUsername();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    final response = await helper.get(
        WebserviceConstants.baseAppointmentURL + "users/dynamicsearch",
        headers: header,
        isOAuthTokenNeeded: false);
    // debugPrint(WebserviceConstants.baseAppointmentURL + "/doctor_info");

    // debugPrint("response - ${response.toString()}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("doctorList", () => jsonData);
      } catch (_) {
        // print("" + _);
      }

      if (jsonData != null) {
        setState(() {
          doctorList = jsonMapData["doctorList"]
              .map<Doctor>((x) => Doctor.fromJson(x))
              .toList();
        });
      }
    }
    // doctorFilteredList = doctorList;
    doctorFilteredList.addAll(doctorList);
    checkDoctorsList("All");

    setState(() {
      _isDoctorLoading = false;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
      _isDoctorLoading = true;
    });
    getDoctorsList();
    getSpecialistList();

    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            },
          )
        ],
      ),
      body: _isLoading == false && _isDoctorLoading == false
          ? Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * .07,
                              child: doctorsCategories(),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              // height: MediaQuery.of(context).size.height * .08,
                              child: searchBox(),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .60,
                              color: Colors.white,
                              child: doctorSearchFilteredList.length != 0 ||
                                      searchController.text.isNotEmpty
                                  ? doctorsDetailList(doctorSearchFilteredList)
                                  : doctorsDetailList(doctorFilteredList),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Show Banner Ad
                  getSivisoftAdWidget(),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
    );
  }

  checkDoctorsList(String speciality) {
    doctorFilteredList.clear();
    for (int i = 0; i < doctorList.length; i++) {
      if (speciality == "All") {
        doctorFilteredList.add(doctorList[i]);
      }
      if (doctorList[i].speciality.join(',').contains(speciality)) {
        doctorFilteredList.add(doctorList[i]);
      }
    }
  }

//  onSearchTextChanged(){
//    doctorSearchFilteredList.clear();
//    for(int i =0; i < doctorFilteredList.length; i++){
//      if(searchController.text.toString() == doctorFilteredList[i].doctorName){
//        doctorSearchFilteredList.add(doctorFilteredList[i]);
//      }
//    }
//
//  }

  onSearchTextChanged(String text) async {
    doctorSearchFilteredList.clear();
    if (text.isEmpty) {
      doctorSearchFilteredList.clear();
      setState(() {});
      return;
    }

    for (int i = 0; i < doctorFilteredList.length; i++) {
      if (doctorFilteredList[i]
              .doctorName
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          doctorFilteredList[i]
              .location
              .toLowerCase()
              .contains(text.toLowerCase())) {
        doctorSearchFilteredList.add(doctorFilteredList[i]);
      }
    }

    setState(() {});
  }

  Widget doctorsCategories() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: specialityList.length,
      itemBuilder: (context, index) {
        return Container(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedCategory = index;
                checkDoctorsList(specialityList[index]);
                searchController.clear();
                doctorSearchFilteredList.clear();
              });
            },
            child: Card(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              color: selectedCategory == index
                  ? Colors.blue[900]
                  : Colors.blue[400],
              child: specialityList[index] == null
                  ? Text("")
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, bottom: 8.0, top: 8.0),
                        child: Text(
                          specialityList[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget searchBox() {
    FocusNode focusNode = FocusNode();
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.80,
              padding:
                  EdgeInsets.symmetric(horizontal: AppUIDimens.paddingSmall),
              child: TextFormField(
                focusNode: focusNode,
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search by name or location",
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
                },
              ),
            ),
            /* TextField(
              style: TextStyle(
                fontSize: 16.0,
              ),
              controller: searchController,
              enabled: doctorFilteredList.length > 0 ? true : false,
              decoration: new InputDecoration(
                hintText: 'Search by name or location',
                hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10.0),
                suffixIcon: IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    onSearchTextChanged(searchController.text);
                  },
                ),
              ),
              // onChanged: (value) => onSearchTextChanged(value),
            ), */
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
                      onSearchTextChanged(searchController.text);
                    }
                    if (searchController.text.length == 0) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .translate("key_entersometext"),
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 5,
                          gravity: ToastGravity.TOP);
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
    );
  }

  Future getUserInfo(String userName) async {
    Map<String, String> header = {};
    // String username = doctorFilteredList[index].doctorUserName;
    String username = userName;
    String deptName = await AppPreferences.getDeptName();

    //for QA tenant servicedx_qa
    //for Jamaica tenant servicedx
    header.putIfAbsent(
        WebserviceConstants.tenant, () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(
        WebserviceConstants.clientId, () => AppPreferences().clientId);
    WebserviceHelper helper = WebserviceHelper();

    String url = WebserviceConstants.baseAdminURL +
        "/departments/" +
        deptName +
        "/users/" +
        username;

    final response =
        await helper.get(url, headers: header, isOAuthTokenNeeded: false);
    Map<String, dynamic> jsonData;
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      try {
        // print('User Info Response...........${response.body.toString()}');
        jsonData = jsonDecode(response.body);
        UserAsDoctorInfo userDoctorInfo = UserAsDoctorInfo.fromJson(jsonData);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BookingAppointmentScreen(
                doctor: userDoctorInfo, patientDetails: widget.patientDetails),
          ),
        );

        setState(() {
          _isLoading = false;
        });
      } catch (e) {}
    }
  }

  Widget doctorsDetailList(List<Doctor> doctors) {
    int sheduleCount = 0;
    if (doctors.length == 0) {
      return Center(child: Text("No Data Available"));
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          print(
              "====================> Doctor Image  ${doctors[index].downloadProfileURL}");
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .95,
              // height: MediaQuery.of(context).size.height * .1,
              child: Card(
                //backgroundColor: Colors.transparent,
                //elevation: 8.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * .20,
                          //color: Colors.red,
                          child: doctors[index].downloadProfileURL.length == 0
                              ? Image.asset(
                                  'assets/images/doctor_image.png',
                                  width: 100.0,
                                  height: 100.0,
                                )
                              : CircleAvatar(
                                  radius: 60.0,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                      doctors[index].downloadProfileURL),
                                )),
                      SizedBox(
                        width: 6.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .60,
                        //color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 18.0, right: 0.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    // "${doctors[index].doctorName}",
                                    doctors[index].firstname +
                                        " " +
                                        doctors[index].lastname,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                                SizedBox(
                                  height: 6.0,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 18.0, right: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${doctors[index].speciality.join(', ')}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                          fontFamily: 'Montserrat'),
                                    )),
                                SizedBox(
                                  height: 6.0,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 18.0, right: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${doctors[index].location}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                          fontFamily: 'Montserrat'),
                                    )),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 18.0, right: 0.0, top: 5.0),
                                alignment: Alignment.centerLeft,
                                child: RatingBarIndicator(
                                  rating: doctors[index].rating,
                                  itemCount: 5,
                                  itemSize: 15.0,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                )),
                            Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0.0, right: 0.0, top: 2.0),
                                    height: 40.0,
                                    width: 80.0,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PhysicianDetailScreen(
                                              doctorObj: doctors[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0)),
                                        color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Center(
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    margin: const EdgeInsets.only(
                                        left: 0.0, right: 0.0, top: 2.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (sheduleCount == 0) {
                                          getUserInfo(
                                              doctors[index].doctorUserName);
                                          sheduleCount++;
                                        }
                                      },
                                      child: Card(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0)),
                                        color: Colors.lightBlue[700],
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Center(
                                            child: Text(
                                              "Schedule",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Montserrat'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // button 1
                                  // button 2
                                ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //GetAPI department

}
