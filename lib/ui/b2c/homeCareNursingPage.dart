import '../../model/user_info.dart' as u;
import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import '../../ui/b2c/repository/authentication_repository.dart'
    as Auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authFireBase;
// import 'package:firebase_database/firebase_database.dart';

class HomeCareNursingPage extends StatefulWidget {
  final String title;
  HomeCareNursingPage({Key key, this.title = "HomeCare Nursing"})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeCareState();
  }
}

class _HomeCareState extends State<HomeCareNursingPage> {
  var gridLists = List<DrawerLists>();
  var showTimer = false;
  int endTime = 0;

  gridPopulation() async {
    u.UserInfo userInfo = await AppPreferences.getUserInfo();
    debugPrint("userInfo.tempUserSubType");
    debugPrint(userInfo.tempUserSubType);
    if (userInfo.tempUserSubType.toLowerCase() == "User".toLowerCase()) {
      gridLists.add(DrawerLists(
          labelName: "Book Service",
          externalUrl: "",
          imageName: "assets/images/Book_Request.png",
          navigation: Routes.addRequest));

      gridLists.add(DrawerLists(
          labelName: "Transaction",
          externalUrl: "",
          imageName: "assets/images/ic_transaction_history.png",
          navigation: "doctor_schdule_screen.dart"));

      gridLists.add(DrawerLists(
          labelName: "Payments",
          externalUrl: "",
          imageName: "assets/images/Payments.png",
          navigation: Routes.requesterDashBoard));

      setState(() {});
    } else {
      gridLists.add(DrawerLists(
          labelName: "Service Registration",
          externalUrl: "",
          imageName: "assets/images/contact-form.png",
          navigation: Routes.service_registration));

      gridLists.add(new DrawerLists(
          labelName: "Schedule",
          externalUrl: "",
          imageName: "assets/images/physician.png",
          navigation: Routes.doctorSchduleScreen));
      gridLists.add(DrawerLists(
          labelName: "Service Request",
          externalUrl: "",
          imageName: "assets/images/user.png",
          navigation: Routes.matchedRequest));
      gridLists.add(DrawerLists(
          labelName: "Transaction",
          externalUrl: "",
          imageName: "assets/images/ic_transaction_history.png",
          navigation: Routes.payments_screen));

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    /// Static Authentication

    final _repository = Auth.AuthRepository();
    debugPrint("OLD Email: ${AppPreferences().email}");
    _repository.signInMultipartRequest("jhonmathewsjr@gmail.com", "provider")
        //.signInMultipartRequest(AppPreferences().email, "Memberly@123")
        .then((response) async {
      debugPrint("response.status.toString()");
      debugPrint(response.status.toString());
      if (response.status == 200) {
        AppPreferences.setUserGroup(response.userGroup);
        AppPreferences.setToken(response.token);
        AppPreferences.setEmail("jhonmathewsjr@gmail.com");
        await AppPreferences().init();
      } else {
        /*UserInfo userInfo = await AppPreferences.getUserInfo();
        debugPrint("userInfo.tempUserSubType");
        debugPrint(userInfo.tempUserSubType);
        String userType;
        if (userInfo.tempUserSubType == "User") {
          userType = "requester";
        } else {
          userType = "supplier";
        }
        debugPrint("userType");
        debugPrint(userType);
        _repository
            .signUpMultipartRequest(
                AppPreferences().email, "Memberly@123", userType)
            .then((response) async {
          // need to write status code based condition here
          print("test registration");
          print(response.statusCode.toString());
          print(response.toJson().toString());
          AppPreferences.setUserGroup(response.userGroup);
          AppPreferences.setToken(response.token);
        });*/
      }
    });

    /// End here
    // firebaseLogin();
    gridPopulation();
    initializeAd();
  }

  firebaseLogin() async {
    // var userCredential =
    //     await authFireBase.FirebaseAuth.instance.signInAnonymously();
    // print("FireBase Console Output");
    // print(userCredential.user.isAnonymous);
    // print(userCredential.user.uid);

    // userCredential.user.getIdToken().then((value) {
    //   print("token:");
    //   print(value.token);
    // });
    try {
      var userCredential = await authFireBase.FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: AppPreferences().email, password: "Memberly@123");
      print("signed in");
      print(userCredential.user.isAnonymous);
      print(userCredential.user.uid);
      print(userCredential.user.email);
    } catch (e) {
      print("Error in firebase sign in");
      print(e.toString());

      try {
        var userCredential = await authFireBase.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: AppPreferences().email, password: "Memberly@123");
        print("created user in");
        print(userCredential.user.isAnonymous);
        print(userCredential.user.uid);
        print(userCredential.user.email);

        u.UserInfo userInfo = await AppPreferences.getUserInfo();

        debugPrint("userInfo.tempUserSubType");
        debugPrint(userInfo.tempUserSubType);
        String userType;
        if (userInfo.tempUserSubType == "User") {
          userType = "requester";
        } else {
          userType = "supplier";
        }
        /* Map userDetail = {
          "email": userInfo.emailId,
          "token": userCredential.user.uid,
          "user_type": userType,
          "username": userInfo.userName
        };*/

        final CollectionReference userCollection =
            Firestore.instance.collection('Users');
        // userCollection.document.add(userDetail);
        userCollection.add({
          'email': userInfo.emailId,
          'token': userCredential.user.uid,
          'user_type': userType,
          'username': userInfo.userName
        });
      } catch (e) {
        print("error in registration");
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          //"Home Care Nursing",
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: gridLists == null || gridLists.isEmpty
                  ? Container(color: Colors.black)
                  : Stack(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            // child: Wrap(
                            //     children: gridLists.map((e) {
                            child: GridView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                itemCount: gridLists.length,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 0.90,
                                        crossAxisCount: 4),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Material(
                                      elevation: 5.0,
                                      // shadowColor: Colors.grey[800],

                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.14,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: InkWell(
                                          onTap: () async {
                                            if (gridLists[index].navigation ==
                                                "sos") {
                                              Fluttertoast.showToast(
                                                  msg: "SOS call",
                                                  gravity: ToastGravity.TOP);
                                              setState(() {
                                                showTimer = true;
                                                endTime = DateTime.now()
                                                        .millisecondsSinceEpoch +
                                                    1000 * 11;
                                              });
                                            } else {
                                              Navigator.pushNamed(
                                                context,
                                                gridLists[index].navigation,
                                              );
                                            }
                                          },
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              if (gridLists[index].imageName !=
                                                  null)
                                                gridLists[index]
                                                        .imageName
                                                        .startsWith('http')
                                                    ? Expanded(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFfbfbfb),
                                                            // color: Colors.grey,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10.0),
                                                            ),
                                                          ),
                                                          child: Center(
                                                              child:
                                                                  Image.network(
                                                            gridLists[index]
                                                                .imageName,
                                                            height: 25,
                                                            width: 25,
                                                            cacheHeight: 25,
                                                            cacheWidth: 25,
                                                            // alignment: Alignment.topCenter,
                                                          )),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFfbfbfb),
                                                            // border: Border.all(),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10.0),
                                                            ),
                                                          ),
                                                          child: gridLists[
                                                                          index]
                                                                      .navigation !=
                                                                  "sos"
                                                              ? Center(
                                                                  child: Image
                                                                      .asset(
                                                                    gridLists[
                                                                            index]
                                                                        .imageName,
                                                                    height:
                                                                        25.0,
                                                                    width: 25.0,
                                                                    // alignment: Alignment.topCenter,
                                                                  ),
                                                                )
                                                              : Image.asset(
                                                                  "assets/images/sos.png"),
                                                        ),
                                                      ),
                                              gridLists[index].navigation !=
                                                      "sos"
                                                  ? Expanded(
                                                      child: Container(
                                                        // color: Colors.red,
                                                        child: Center(
                                                          child: Text(
                                                              gridLists[index]
                                                                  .labelName,
                                                              maxLines: 2,
                                                              style: AppPreferences()
                                                                      .isLanguageTamil()
                                                                  ? TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)
                                                                  : GoogleFonts
                                                                      .montserrat(
                                                                      textStyle: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color: Colors.grey[
                                                                              600],
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                        showTimer
                            ? Container(
                                alignment: Alignment.center,
                                color: Colors.black.withOpacity(0.5),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Alert!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "SOS event will be activated after 10 seconds. Please press \"Cancel\" to cancel now.",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                // fontWeight: FontWeight.bold,
                                                ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      CountdownTimer(
                                        endTime: endTime,
                                        widgetBuilder:
                                            (_, CurrentRemainingTime time) {
                                          if (time == null) {
                                            return Text(
                                              'DONE!',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3
                                                  .copyWith(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            );
                                          }
                                          return Text(
                                            '${time.sec}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                .copyWith(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          );
                                        },
                                      ),
                                      /* Text(
                                        "10",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            .copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),*/
                                      SizedBox(
                                        height: 24,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            showTimer = false;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }
}

class DrawerLists {
  DrawerLists({
    this.isAssetsImage = true,
    this.labelName = '',
    this.icon,
    this.index,
    this.status,
    this.imageName = '',
    this.externalUrl,
    this.internalUrl,
    this.navigation,
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  int index;
  bool status;
  String externalUrl;
  String internalUrl;
  String navigation;
}
