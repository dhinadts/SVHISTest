import '../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/routes.dart';

class HomeNursingServices extends StatefulWidget {
  final String title;
  HomeNursingServices({Key key, this.title = "HealCare Nursing"})
      : super(key: key);

  @override
  _HomeNursingServicesState createState() => _HomeNursingServicesState();
}

class _HomeNursingServicesState extends State<HomeNursingServices> {
  List<DrawerLists> gridLists = [];
  @override
  void initState() {
    super.initState();
    gridPopulation();
  }

  gridPopulation() {
    gridLists.add(new DrawerLists(
        labelName: "Schedule",
        externalUrl: "",
        imageName: "assets/images/user.png",
        navigation: Routes.doctorSchduleScreen));

    gridLists.add(DrawerLists(
        labelName: "Service Request",
        externalUrl: "",
        imageName: "assets/images/user.png",
        navigation: "doctor_schdule_screen.dart"));

    gridLists.add(DrawerLists(
        labelName: "Transaction",
        externalUrl: "",
        imageName: "assets/images/user.png",
        navigation: "doctor_schdule_screen.dart"));

    gridLists.add(DrawerLists(
        labelName: "Book Service",
        externalUrl: "",
        imageName: "assets/images/user.png",
        navigation: "doctor_schdule_screen.dart"));

    gridLists.add(DrawerLists(
        labelName: "Service Request",
        externalUrl: "",
        imageName: "assets/images/user.png",
        navigation: "doctor_schdule_screen.dart"));

    gridLists.add(DrawerLists(
        labelName: "Transaction",
        externalUrl: "",
        imageName: "assets/images/user.png",
        navigation: "doctor_schdule_screen.dart"));

    gridLists.add(DrawerLists(
        labelName: "Payments",
        externalUrl: "",
        imageName: "assets/images/user.png",
        navigation: Routes.doctorSchduleScreen));

    setState(() {});
    print(gridLists);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body:
            /* Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorSchedulerScreen()));
                },
                child: Container(
                  color: Colors.blue,
                  height: 50.0,
                  child: Text("Schedule"),
                ),
              ),
              Container(color: Colors.black, height: 50.0),
              Container(color: Colors.black, height: 50.0),
            ],
          ),
        )); */
            gridLists == null || gridLists.isEmpty
                ? Container(color: Colors.black)
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    // child: Wrap(
                    //     children: gridLists.map((e) {
                    child: GridView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        itemCount: gridLists.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.90, crossAxisCount: 4),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              elevation: 5.0,
                              // shadowColor: Colors.grey[800],

                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.pushNamed(
                                      context,
                                      gridLists[index].navigation,
                                    );
                                  },
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      if (gridLists[index].imageName != null)
                                        gridLists[index]
                                                .imageName
                                                .startsWith('http')
                                            ? Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFfbfbfb),
                                                    // color: Colors.grey,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      topRight:
                                                          Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Image.network(
                                                      gridLists[index]
                                                          .imageName,
                                                      /* width: gridList[index].index ==
                                             Constants.PAGE_ID_PEOPLE_LIST
                                              ? 20
                                              : 20,
                                              height: 20.0, */
                                                      height: 25,
                                                      width: 25,
                                                      cacheHeight: 25,
                                                      cacheWidth: 25,
                                                      // alignment: Alignment.topCenter,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFfbfbfb),
                                                    // border: Border.all(),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      topRight:
                                                          Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      gridLists[index]
                                                          .imageName,
                                                      /* width: gridList[index].index ==
                                           Constants.PAGE_ID_PEOPLE_LIST
                                            ? 20
                                            : 20,
                                              height: 20.0, */
                                                      height: 25.0, width: 25.0,
                                                      // alignment: Alignment.topCenter,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      Expanded(
                                        child: Container(
                                          // color: Colors.red,
                                          child: Center(
                                            child: Text(
                                                gridLists[index].labelName,
                                                maxLines: 2,
                                                style: AppPreferences()
                                                        .isLanguageTamil()
                                                    ? TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.indigo,
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    : /* TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Vernada",
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold), */
                                                    GoogleFonts.montserrat(
                                                        textStyle: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .grey[600],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })));

    /*  GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    itemCount: gridLists.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.0, crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Material(
                          elevation: 5.0,
                          // shadowColor: Colors.grey[800],

                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            width: MediaQuery.of(context).size.width * 0.20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.white.withOpacity(0.2),
                                //     spreadRadius: 15,
                                //     blurRadius: 10,
                                //     offset: Offset(3, 3),
                                //   ),
                                // ],
                                // border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                              // borderRadius: BorderRadius.circular(16),
                              onTap: () async {},
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  if (gridLists[index].imageName != null)
                                    gridLists[index]
                                            .imageName
                                            .startsWith('http')
                                        ? Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFfbfbfb),
                                                // color: Colors.grey,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Image.network(
                                                  gridLists[index].imageName,
                                                  height: 25,
                                                  width: 25,
                                                  cacheHeight: 25,
                                                  cacheWidth: 25,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFfbfbfb),
                                                // border: Border.all(),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  gridLists[index].imageName,
                                                  height: 25.0,
                                                  width: 25.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                  Expanded(
                                    child: Container(
                                      // color: Colors.red,
                                      child: Center(
                                        child: Text(gridLists[index].labelName,
                                            maxLines: 2,
                                            style: AppPreferences()
                                                    .isLanguageTamil()
                                                ? TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.bold)
                                                : GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey[600],
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }));
   */
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
