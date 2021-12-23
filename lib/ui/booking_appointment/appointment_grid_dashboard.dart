import '../../model/passing_arg.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentGridDashboard extends StatefulWidget {
  final String from;

  AppointmentGridDashboard({this.from});

  AppointmentGridDashboardState createState() =>
      AppointmentGridDashboardState();
}

class AppointmentGridDashboardState extends State<AppointmentGridDashboard> {
  List<Items> myList = [];

  @override
  Future<void> initState() {
    super.initState();
    AppPreferences.getRole().then((value) => {_loadList(value)});
  }

//   //HOME Supervisor
//   homeSuperVisor() {
//     myList.add(new Items(
//         title: AppLocalizations.of(context).translate("key_addperson"),
//         img: "assets/images/user.png",
//         navigation: Routes.userInfoScreen));
//     if (AppPreferences().country != null && AppPreferences().country == "IN") {
//       myList.add(new Items(
//           title: AppLocalizations.of(context).translate("key_addFamily"),
//           img: "assets/images/family_icon.png",
//           navigation: Routes.familyInfoScreen));
//     }
//     myList.add(new Items(
//         title: AppPreferences().isTTDEnvironment()
//             ? AppLocalizations.of(context).translate("key_peoplelist_tt")
//             : AppLocalizations.of(context).translate("key_peoplelist"),
//         img: "assets/images/list.png",
//         navigation: Routes.peopleListScreen));
//     if (AppPreferences().country != null && AppPreferences().country == "IN") {
//       myList.add(new Items(
//           title: AppLocalizations.of(context).translate("key_searchpeople"),
//           img: "assets/images/search_people.png",
//           navigation: Routes.searchPeopleScreen));
//     }

//     if (AppPreferences().country != null && AppPreferences().country == "VC") {
//       myList.add(new Items(
//           title: "Port Monitoring",
//           img: "assets/images/porticon.png",
//           navigation: Routes.portScreeningListScreen));
//     }

//     myList.add(new Items(
//         title: AppLocalizations.of(context).translate("key_recentactivity"),
//         img: "assets/images/ic_recent.png",
//         navigation: Routes.noticeBoardScreen));

// //    myList.add(new Items(
// //        title: "Analytics",
// //        img: "assets/images/analytics_icon.png",
// //        navigation: Routes.analyticsScreen));
//   }

// //USER Home
//   homeUser() {
//     /*myList.add(new Items(
//         title: "Personal Information",
//         img: "assets/images/user.png",
//         navigation: Routes.personalHomeScreen));*/

//     myList.add(new Items(
//         title: AppLocalizations.of(context).translate("key_prevention"),
//         img: "assets/images/user.png",
//         navigation: Routes.personalHomeTabbedScreen));
//     myList.add(new Items(
//         title: "Daily Quarantine",
//         img: "assets/images/quarantine.png",
//         navigation: Routes.quarantineHistoryScreen));
//     myList.add(new Items(
//         title: "Daily Symptoms",
//         img: "assets/images/ic_daily_status.png",
//         navigation: Routes.dailyStatusHistoryScreen));
//     /* myList.add(new Items(
//         title: "Geo Fencing",
//         img: "assets/images/geo_fencing.png",
//         navigation: Routes.geoFencing));*/
//     myList.add(new Items(
//         title: "Contact Tracing",
//         img: "assets/images/contact_tracing.png",
//         navigation: Routes.contactTraceScreen));
//   }

  // USER personal info 2nd HOME
  // personalInfoScreenUser() {
  //   myList.add(new Items(
  //       title: "User Information",
  //       img: "assets/images/userInfo.png",
  //       navigation: Routes.userInfoScreen));
  //   /*myList.add(new Items(
  //       title: "Quarantine",
  //       img: "assets/images/quarantine.png",
  //       navigation: Routes.quarantineScreen));*/
  // }

  Future<void> bookAppointmentDashboard() async {
    String userCategory = await AppPreferences.getUserCategory();

    if (userCategory == "DOCTOR") {
      myList.add(new Items(
          title: "Doctor Schedule",
          img: "assets/images/schedule_planner.png",
          navigation: Routes.doctorProfileScreen));
      myList.add(new Items(
          title: "Appointment Confirmation",
          img: "assets/images/schedule.png",
          navigation: Routes.appointmentConfirmationListScreen));
      myList.add(new Items(
          title: "Appointment History",
          img: "assets/images/appoinment_history.png",
          navigation: Routes.appointmentHistoryScreen));
      /* myList.add(new Items(
          title: "Campign Feedback",
          img: "assets/images/feedback.png",
          navigation: Routes.campignFeedbackList));  */
    } else {
      // myList.add(new Items(
      //     title: "Book Appointment",
      //     img: "assets/images/physician.png",
      //     navigation: Routes.selectPhysicianScreen));
      myList.add(new Items(
          title: "Book Appointment",
          img: "assets/images/physician.png",
          navigation: Routes.selectPhysicianScreen));
      myList.add(new Items(
          title: "Appointment History",
          img: "assets/images/appoinment_history.png",
          navigation: Routes.appointmentHistoryScreen));

      // myList.add(new Items(
      //     title: "Reminders",
      //     img: "assets/images/userInfo.png",
      //     navigation: Routes.appointmentReminderScreen));

    }
  }

  _loadList(String role) {
    setState(() {
      if (widget.from != null) {
        if (widget.from == Constants.bookAppointmentDashboard) {
          bookAppointmentDashboard();
        } else {
          // debugPrint("Role----------" + role);
          //   if (role == Constants.supervisorRole || role == Constants.adminRole) {
          //     homeSuperVisor();
          //   } else {
          //     homeUser();
          //   }
          //   myList.add(new Items(
          //       title: AppLocalizations.of(context).translate("key_prevention"),
          //       img: "assets/images/prevention.png",
          //       navigation: Routes.preventionScreen));
          //   myList.add(new Items(
          //       title: AppLocalizations.of(context).translate("key_support"),
          //       img: "assets/images/conversation.png",
          //       navigation: Routes.supportScreen));
          //   myList.add(new Items(
          //       title: "Coping ?",
          //       img: "assets/images/list.png",
          //       navigation: Routes.dailyStatusHistoryScreen));
        }
      } else {
        if (role == Constants.supervisorRole) {
          myList.add(new Items(
              title: "User Information",
              img: "assets/images/userInfo.png",
              navigation: Routes.familyInfoScreen));
          /* myList.add(new Items(
              title: "First Time Quarantine Reporting",
              img: "assets/images/quarantine.png",
              navigation: Routes.quarantineScreen));*/

        } else {
          myList.add(new Items(
              title: "User Information",
              img: "assets/images/userInfo.png",
              navigation: Routes.userInfoScreen));
        }
      }
    });
  }

  var color = 0xFFEEEEEE;
  Widget menuGridBuilder() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        itemCount: myList.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0, crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          var color = Colors.white;
          //if (gridList[index].assetUrl != null)
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  if (myList[index].navigation != null)
                    Navigator.pushNamed(context, myList[index].navigation,
                        arguments: Args(arg: widget.from));
                },
                child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (myList[index].img != null)
                          myList[index].img.startsWith('http')
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.network(
                                    myList[index].img,
                                    height: 50,
                                    width: 50,
                                    cacheHeight: 50,
                                    cacheWidth: 50,
                                    alignment: Alignment.center,
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    myList[index].img,
                                    height: 50.0,
                                    width: 50.0,
                                    alignment: Alignment.center,
                                  )),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(myList[index].title,
                              maxLines: 2,
                              style: AppPreferences().isLanguageTamil()
                                  ? TextStyle(
                                      fontSize: 12,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      fontSize: 12,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(child: menuGridBuilder()

        // GridView.count(
        //   padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        //   childAspectRatio: 1.0,
        //   crossAxisCount: 2,
        //   crossAxisSpacing: 10,
        //   mainAxisSpacing: 10,
        //   children: myList.map((data) {
        //     return GestureDetector(
        //         onTap: () => {
        //               if (data.navigation != null)
        //                 Navigator.pushNamed(context, data.navigation,
        //                     arguments: Args(arg: widget.from))
        //             },
        //         child: Container(
        //           decoration: BoxDecoration(
        //               color: Color(color),
        //               borderRadius: BorderRadius.circular(18)),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: <Widget>[
        //               Image.asset(
        //                 data.img,
        //                 width: 90,
        //                 alignment: Alignment.center,
        //               ),
        //               Padding(
        //                   padding: EdgeInsets.all(10),
        //                   child: Text(data.title,
        //                       maxLines: 2,
        //                       style: TextStyle(
        //                           fontSize: AppPreferences().isLanguageTamil()
        //                               ? 15
        //                               : 15,
        //                           color: Colors.indigo,
        //                           fontWeight: FontWeight.bold),
        //                       textAlign: TextAlign.center)),
        //             ],
        //           ),
        //         ));
        //   }).toList(),
        // ),

        );
  }
}

class Items {
  String title;

  String img;

  String navigation;

  Items({this.title, this.img, this.navigation});
}
