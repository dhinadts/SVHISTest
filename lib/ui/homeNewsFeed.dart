// confetti: ^0.5.4+1

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import '../model/user_info.dart';
import '../repo/auth_repository.dart';
import '../repo/common_repository.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../ui/custom_drawer/remainders_list_data.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/text_styles.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
// import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:getwidget/size/gf_size.dart';
// import 'package:confetti/confetti.dart';
/* class NewsFeed extends StatefulWidget {
  NewsFeed({Key key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  InAppWebViewController webView;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    delay();
  }

  delay() async {
    await Future.delayed(Duration(seconds: 5), () async {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Flexible(
            flex: 5,
            child: InAppWebView(
              initialUrl:
                  "https://memberly-app.github.io/sites/TEST_PAGES/newsfeed.html",
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    debuggingEnabled: true,
                    minimumFontSize: 100,
                    cacheEnabled: true,
                    clearCache: false,
                    preferredContentMode: UserPreferredContentMode.MOBILE),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {},
              onLoadStop:
                  (InAppWebViewController controller, String url) async {},
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                if (progress == 100) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
          );
  }
} */

class FlashCards extends StatefulWidget {
  FlashCards({Key key, this.remaindersListData}) : super(key: key);
  final List<RemaindersListData> remaindersListData;

  @override
  _FlashCardsState createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> with TickerProviderStateMixin {
  // TabController _controller;
  List<Tab> tabBar = [];
  UserInfo userInfo;
  AnimationController animationController; // , animationControllerText;
  int count = 9;
  AnimationController animationControllerText;
  Uint8List _bytesImage;
  String imagePath;

  Image imageDecoded;
  AuthRepository _authRepository;
  List<RemaindersListData> birthdays = [];
  List<RemaindersListData> anniversaries = [];
  List<RemaindersListData> others = [];
  bool isLoading = true;
  // ConfettiController _controllerCenter;
  Animation<double> animation; // , animationText;
  Animation<double> animationText;
  bool centerWidget = false;
  double _width;
  double _height;
  Color _color;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);
  // AnimationController animationController;
  // ConfettiController _controllerCenterRight;
  // ConfettiController _controllerCenterLeft;
  // ConfettiController _controllerTopCenter;
  // ConfettiController _controllerBottomCenter;

  final random = Random();
  bool setVisible = false;

  @override
  void initState() {
    // _controllerCenter =
    // ConfettiController(duration: const Duration(seconds: 5));
    // _controllerCenterRight =
    //     ConfettiController(duration: const Duration(seconds: 10));
    // _controllerCenterLeft =
    //     ConfettiController(duration: const Duration(seconds: 10));
    // _controllerTopCenter =
    //     ConfettiController(duration: const Duration(seconds: 10));
    // _controllerBottomCenter =
    //     ConfettiController(duration: const Duration(seconds: 10));
    // _controllerCenter.play();
    /* animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1000));
    animation = Tween<double>(begin: 0, end: -200).animate(animationController)
      ..addListener(() {
        // animationController.reverse();
        setState(() {});
      }); */
    super.initState();
    // _controllerCenter =
    //     ConfettiController(duration: const Duration(seconds: 10));
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 30));

    animation =
        Tween<double>(begin: 1000, end: -5000).animate(animationController)
          ..addListener(() {
            setState(() {
              animationController.forward().whenComplete(() {
                // put here the stuff you wanna do when animation completed!
              });
            });
          });

    // _controller = new TabController(
    //   length: 3,
    //   vsync: this,
    // );
    // _controllerCenter.play();
    types();
    // summa();
  }

  @override
  void dispose() {
    // _controllerCenter.dispose();
    // _controllerCenterRight.dispose();
    // _controllerCenterLeft.dispose();
    // _controllerTopCenter.dispose();
    // _controllerBottomCenter.dispose();
    animationController.dispose();

    super.dispose();
  }

  /* summa() async {
    if (WebserviceConstants.baseURL != null) {
      List<RemaindersListData> reaindersListData =
          await CommonRepository().getWishesList();
      // var dial = jsonDecode(suu);
      // print(suu[1].kacl);
      // print(suu[1].messageInfo);

      setState(() {});
    }
  } */

  types() {
    birthdays.clear();
    anniversaries.clear();
    others.clear();

    if (widget.remaindersListData.length > 0) {
      for (var i = 0; i < widget.remaindersListData.length; i++) {
        // print(widget.remaindersListData[i].occasionalType);
        if (widget.remaindersListData[i].occasionalType.toLowerCase() ==
                "birthday" ||
            widget.remaindersListData[i].occasionalType.toLowerCase() ==
                "birth anniversary") {
          setState(() {
            birthdays.add(widget.remaindersListData[i]);
          });
        } else if (widget.remaindersListData[i].occasionalType.toLowerCase() ==
            "anniversary") {
          setState(() {
            anniversaries.add(widget.remaindersListData[i]);
          });
        } else {
          setState(() {
            others.add(widget.remaindersListData[i]);
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  openSendWishesAlert(RemaindersListData index) {
    var textWish = TextEditingController();
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          // title: Text("Wishes"),
          content: Stack(
            children: [
              Transform.translate(
                offset: Offset(-25, -45),
                child: index.profilePic == null ||
                        index.profilePic.isEmpty ||
                        index.profilePic == ""
                    ? CircleAvatar(
                        radius: 35.0,
                        child: Center(
                          child: Text(
                              "${index.firstName[0]}${index.lastName == null || index.lastName.isEmpty || index.lastName == "" ? "" : index.lastName[0]}",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white)),
                        ))
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 35.0,
                        backgroundImage: index.profilePic == null ||
                                index.profilePic.isEmpty ||
                                index.profilePic == ""
                            ? AssetImage("assets/images/userInfo.png")
                            : MemoryImage(base64Decode(index.profilePic)),
                      ),
              ),
              Container(
                height: 250.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                            "Send your wishes to ${index.firstName} ${index.lastName == null || index.lastName.isEmpty || index.lastName == "" ? "" : index.lastName}"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new TextFormField(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Type your wish";
                          } else
                            return null;
                        },
                        style: TextStyles.mlDynamicTextStyle,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          // hintMaxLines: 3,

                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          labelText: "Please type your wishes",
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        controller: textWish,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color: Colors.indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () async {
                              final value =
                                  await onSendPressed(index, textWish);
                              print(value);
                              Navigator.pop(context);
                              if (value == null) {
                                setState(() {
                                  dummyName =
                                      index.firstName + " " + index.lastName;
                                  setVisible = true;
                                });

                                // await animationController.forward();
                                // animationController.forward().whenComplete(() {
                                //   animationController.reset();
                                //   setState(() {
                                //     setVisible = false;
                                //   });
                                // });
                              } else {}
                            },
                            child: Text("Send",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))),
                      ),
                    ),
                  ],
                ),
              ),

              // Positioned(
              //     child: ConfettiWidget(
              //   confettiController: _controllerCenter,
              //   blastDirectionality: BlastDirectionality.explosive,
              //   particleDrag: 0.05,
              //   emissionFrequency: 0.05,
              //   numberOfParticles: 50,
              //   gravity: 0.05,
              //   shouldLoop: true,
              //   colors: const [
              //     Colors.green,
              //     Colors.blue,
              //     Colors.pink,
              //     Colors.orange,
              //     Colors.purple
              //   ], // manually specify the colors to be used
              // ))
            ],
          ),
        ));
  }

  animationdialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Container(
            height: 25,
            child: Image.asset("assets/images/wishes1.png", height: 25.0));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, -1)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<bool> onSendPressed(index, val) {
    if (val.text.isEmpty || val.text == null) {
      Fluttertoast.showToast(
          msg: "Type your wishes",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          gravity: ToastGravity.TOP);
      return Future.value(false);
    } else {
      CommonRepository()
          .updateWishesList(
              index, index.anniversaryRemaindersId, val.text, index.userName)
          .then((value) async {
        if (value != null) {
          // Navigator.pop(context);
          // print("---->>> $value");
          if (value) {
            Fluttertoast.showToast(
                msg: "Successfully sent your wish to ${index.userName}",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                gravity: ToastGravity.TOP);
            return Future.value(true);
          } else {
            Fluttertoast.showToast(
                msg: "Oops, some error happened !",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                gravity: ToastGravity.TOP);
            return false;
          }
        }
      });
      // return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                // centerTitle: true,
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                iconTheme: new IconThemeData(color: Colors.white),
                // brightness: Brightness.light,
                actions: [
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavigationHomeScreen(
                                    drawerIndex: Constants.PAGE_ID_HOME,
                                  )),
                          ModalRoute.withName(Routes.navigatorHomeScreen));
                    },
                  )
                ],
                bottom: PreferredSize(
                  preferredSize: new Size(double.maxFinite, 60.0),
                  child: TabBar(
                    unselectedLabelColor: Colors.white54,
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    indicatorWeight: 2.0,
                    tabs: [
                      Tab(
                        icon: FaIcon(FontAwesomeIcons.birthdayCake, size: 20),
                        child: Center(
                          child: Column(
                            children: [
                              Text("Birthdays",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12)),
                              SizedBox(height: 5.0),
                              birthdays == null ||
                                      birthdays.isEmpty ||
                                      birthdays.length == 0
                                  ? SizedBox.shrink()
                                  : GFBadge(
                                      child: Text(
                                        "${birthdays.length}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.red[900],
                                      shape: GFBadgeShape.pills,
                                      size: GFSize.SMALL,
                                    )
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.card_giftcard, size: 25),
                        child: Center(
                            child: Column(
                          children: [
                            Text("Anniversaries",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12)),
                            SizedBox(height: 5.0),
                            anniversaries == null ||
                                    anniversaries.isEmpty ||
                                    anniversaries.length == 0
                                ? SizedBox.shrink()
                                : GFBadge(
                                    child: Text(
                                      "${anniversaries.length}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.red[900],
                                    shape: GFBadgeShape.pills,
                                    size: GFSize.SMALL,
                                  )
                          ],
                        )),
                      ),
                      Tab(
                        icon: FaIcon(FontAwesomeIcons.calendar, size: 20),
                        child: Center(
                            child: Column(
                          children: [
                            Text("Others",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12)),
                            SizedBox(height: 5.0),
                            others == null ||
                                    others.isEmpty ||
                                    others.length == 0
                                ? SizedBox()
                                : GFBadge(
                                    child: Text(
                                      "${others.length}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.red[900],
                                    shape: GFBadgeShape.pills,
                                    size: GFSize.SMALL,
                                  ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  'Flash cards',
                ),
              ),
              body: Stack(children: [
                TabBarView(
                  children: [
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SafeArea(
                            child: Container(
                                child: birthdays.length == 0
                                    ? Center(child: Text("No Birthdays today"))
                                    : birthdayList(birthdays))),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SafeArea(
                            child: Container(
                                child: anniversaries.length == 0
                                    ? Center(
                                        child: Text("No Anniversaries today"))
                                    : birthdayList(anniversaries))),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SafeArea(
                            child: Container(
                                child: others.length == 0
                                    ? Center(child: Text("No others today"))
                                    : birthdayList(others)))
                  ],
                ),
              ])),
          /* Center(
            child: AnimatedContainer(
              // Use the properties stored in the State class.
              
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: _borderRadius,
              ),
              // Define how long the animation should take.
              duration: Duration(seconds: 5),
              // Provide an optional curve to make the animation feel smoother.
              curve: Curves.bounceInOut,
              /* child: Text(
                      dummyName,
                    ), */
            ),
          ), */
          // Center(
          //   child: ConfettiWidget(
          //     confettiController: _controllerCenter,
          //     blastDirectionality: BlastDirectionality.explosive,
          //     particleDrag: 0.05,
          //     emissionFrequency: 0.05,
          //     numberOfParticles: 75,
          //     gravity: 0.05,
          //     shouldLoop: false,
          //     canvas: Size(MediaQuery.of(context).size.width,
          //         MediaQuery.of(context).size.height),
          //     /* child: Image.asset(
          //       "assets/images/userInfo.png",
          //       height: 50.0,
          //       width: 50.0,
          //     ), */
          //     colors: const [
          //       Colors.green,
          //       Colors.blue,
          //       Colors.pink,
          //       Colors.orange,
          //       Colors.purple,
          //       Colors.black
          //     ], // manually specify the colors to be used
          //   ),
          // ),
          // Transform.translate(
          //     offset: Offset((MediaQuery.of(context).size.width - 250) / 2,
          //         animation.value),
          //     child:
          //         /* Icon(
          //     Icons.favorite,height: 25.0
          //     color: Colors.pink,
          //     size: 50,
          //   ), */
          //         Image.asset("assets/images/wishes1.png")),
          // Transform.translate(
          //   offset: Offset(10, animation.value - 10),
          //   child: Icon(
          //     Icons.favorite,
          //     color: Colors.pink,
          //     size: 50,
          //   ),
          // ),
          // Transform.translate(
          //   offset: Offset(
          //       (MediaQuery.of(context).size.width - 80), animation.value - 30),
          //   child: Icon(
          //     Icons.favorite,
          //     color: Colors.pink,
          //     size: random.nextInt(50).toDouble(),
          //   ),
          // ),
          // for (var i = 0; i < 10; i++)
          //   Visibility(
          //     visible: setVisible,
          //     child: Transform.translate(
          //       offset: Offset(random.nextInt(400).toDouble() + 20,
          //           animation.value - random.nextInt(400).toDouble()),
          //       child: Icon(
          //         Icons.favorite,
          //         color: Colors.pink,
          //         size: random.nextInt(50).toDouble(),
          //       ),
          //     ),
          //   ),
          // for (var i = 0; i < 10; i++)
          //   Visibility(
          //     visible: setVisible,
          //     child: Transform.translate(
          //       offset: Offset(random.nextInt(400).toDouble() + 20,
          //           animation.value + random.nextInt(800).toDouble()),
          //       child: Icon(
          //         Icons.favorite,
          //         color: Colors.pink,
          //         size: random.nextInt(50).toDouble(),
          //       ),
          //     ),
          //   ),
          // Transform.translate(
          //   offset: Offset(20, 700),
          //   child: Transform.translate(
          //       offset: Offset(20, animation.value),
          //       child: Text(
          //         dummyName,
          //         style: TextStyle(
          //             decoration: TextDecoration.none,
          //             fontStyle: FontStyle.italic,
          //             fontSize: 35,
          //             color: Colors.pink),
          //       )),
          // )
        ],
      ),
    );
  }

  String dummyName = "Many more whishes";
  String imageDummy = "";
  // Future<String> createName(RemaindersListData dummy) {}
  Widget birthdayList(List<RemaindersListData> birthdays) {
    return SingleChildScrollView(
      child: Column(children: [
        ListView. /* separated */ builder(
            shrinkWrap: true,
            itemCount: birthdays.length,
            /* separatorBuilder: (context, index) => Divider(
                                    color: Colors.grey,
                                  ), */
            itemBuilder: (BuildContext context, int index) {
              // var messageInfo =
              //     remaindersListData[index].messageInfo;

              // dummyName =
              //     birthdays[index].firstName + " " + birthdays[index].lastName;
              // print(
              //     birthdays[index].firstName + " " + birthdays[index].lastName);
              // imageDummy = birthdays[index].profilePic ?? null;
              return Container(
                color: Colors.white,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    // elevation: 4.0,
                                    shape: StadiumBorder(),
                                    child:
                                        /* CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 20.0,
                                        backgroundImage:
                                            /* birthdays[index].profilePic == null ||
                                                  birthdays[index].profilePic ==
                                                      "" ||
                                                  birthdays[index]
                                                      .profilePic
                                                      .isEmpty */
                                            /* ?  */ AssetImage(
                                                "assets/images/userInfo.png")
                                        /* : MemoryImage(base64Decode(
                                                  birthdays[index].profilePic)), */
                                        ), */
                                        birthdays[index].profilePic == null ||
                                                birthdays[index]
                                                    .profilePic
                                                    .isEmpty
                                            ? CircleAvatar(
                                                // backgroundColor: Colors.white,
                                                child: Text(
                                                    "${birthdays[index].firstName[0]}${birthdays[index].lastName == null || birthdays[index].lastName == "" || birthdays[index].lastName.isEmpty ? "" : birthdays[index].lastName[0]}",
                                                    style: TextStyle(
                                                        color: Colors.white)))
                                            : CircleAvatar(
                                                radius: 25.0,
                                                /* backgroundImage: remaindersListData[index]
                                                .profilePic ==
                                            null ||
                                        remaindersListData[index]
                                            .profilePic
                                            .isEmpty
                                    ? AssetImage("assets/images/user.png")
                                    : MemoryImage(base64Decode(
                                        remaindersListData[index].profilePic)), */
                                                backgroundImage: MemoryImage(
                                                    base64Decode(
                                                        birthdays[index]
                                                            .profilePic)),
                                              ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          // messageInfo[messageInfo.keys.toList()[0]][0]
                                          //     ["userName"],
                                          "${birthdays[index].firstName} ${birthdays[index].lastName == null || birthdays[index].lastName.isEmpty || birthdays[index].lastName == "" ? "" : birthdays[index].lastName}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Monteserrat"),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      /*      Text(
                                          // messageInfo[messageInfo.keys.toList()[0]][0]
                                          //     ["message"],
                                          birthdays[index].occasionalType,

                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Monteserrat",
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ), */
                                      // GestureDetector(
                                      //     child: Container(
                                      //       // decoration: BoxDecoration(
                                      //       //   color: Colors.red,
                                      //       //   border: Border.all(color: Colors.blueAccent),
                                      //       //   borderRadius:
                                      //       //       BorderRadius.all(Radius.circular(5.0)),
                                      //       // ),
                                      //       child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           RotatedBox(
                                      //               quarterTurns: 0,
                                      //               child: FaIcon(
                                      //                   FontAwesomeIcons
                                      //                       .solidComment,
                                      //                   color: Colors.indigo)),
                                      //           SizedBox(width: 5.0),
                                      //           Text(
                                      //             "Send Wishes",
                                      //             style: TextStyle(
                                      //                 color: Colors.indigo,
                                      //                 fontFamily:
                                      //                     "Monteserrat"),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       openSendWishesAlert(
                                      //           birthdays[index]);
                                      //     }),
                                    ],
                                  ),
                                ),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /* Column(
                                children: [
                                  Text(
                                    "Wishes",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: "Monteserrat"),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      /*  if (birthdays[index].messageInfo !=
                                              null &&
                                          birthdays[index]
                                                  .messageInfo["wishesList"]
                                                  .length >
                                              0) {
                                        showGeneralDialog(
                                          barrierLabel: "Barrier",
                                          barrierDismissible: true,
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          transitionDuration:
                                              Duration(milliseconds: 700),
                                          context: context,
                                          pageBuilder: (_, __, ___) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0))),
                                              title: Text("Wishes"),
                                              contentPadding: EdgeInsets.zero,
                                              content: Container(
                                                // height: 300,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        // 100,
                                                        birthdays[index]
                                                            .messageInfo[
                                                                "wishesList"]
                                                            .length,
                                                    itemBuilder: (context, i) {
                                                      int ii = i + 1;
                                                      // return Text("$ii");
                                                      return RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "$ii. ${birthdays[index].messageInfo["wishesList"][i]["userName"]}",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                fontSize: 18),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    ' wishes that ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    " ${birthdays[index].messageInfo["wishesList"][i]["message"]}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .indigo,
                                                                    fontSize:
                                                                        18),
                                                              )
                                                            ]),
                                                      );
                                                    }),
                                                margin: EdgeInsets.only(
                                                    bottom: 50,
                                                    left: 12,
                                                    right: 12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            );
                                          },
                                          transitionBuilder:
                                              (_, anim, __, child) {
                                            /* AnimationController _controller1;
                                            Animation<Offset> _animation1;
                                            _controller1 = AnimationController(
                                              duration:
                                                  const Duration(seconds: 3),
                                              vsync: this,
                                            )..forward();

                                            _animation1 = Tween<Offset>(
                                              begin: const Offset(1, 0.0),
                                              end: const Offset(0, 0.0),
                                            ).animate(CurvedAnimation(
                                              parent: _controller1,
                                              curve: Curves.easeInCubic,
                                            )); */
                                            return SlideTransition(
                                              // transformHitTests: true,
                                              position: Tween(
                                                      begin: Offset(0, 1),
                                                      end: Offset(0, 0))
                                                  .animate(anim),

                                              child: child,
                                            );
                                          },
                                        );
                                        /*            await showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              content: Material(
                                                // height: 200.0,
                                                // width: MediaQuery.of(context).size.width-20,
                                                child: Container(
                                                  height: 200.0,
                                                  child: Column(
                                                    children: [
                                                      /* Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                                child: Text(
                                                                    "S.No.")),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Center(
                                                                child: Text(
                                                                    "userName")),
                                                          ),
                                                          // Text("--"),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Center(
                                                                child: Text(
                                                                    "message")),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        height: 2.0,
                                                        color: Colors.pink,
                                                      ), */
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: birthdays[
                                                                  index]
                                                              .messageInfo[
                                                                  "wishesList"]
                                                              .length,
                                                          itemBuilder:
                                                              (context, i) {
                                                            int ii = i + 1;
                                                            return Column(
                                                              children: [
                                                                /* Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Center(
                                                                          child: Text(
                                                                              "$ii")),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Text(
                                                                            "${birthdays[index].messageInfo["wishesList"][i]["userName"]}"),
                                                                      ),
                                                                    ),
                                                                    // Text("--"),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Text(
                                                                            "${birthdays[index].messageInfo["wishesList"][i]["message"]}"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ), */
                                                                RichText(
                                                                  text: TextSpan(
                                                                      text:
                                                                          "$ii. ${birthdays[index].messageInfo["wishesList"][i]["userName"]}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .pink,
                                                                          fontSize:
                                                                              18),
                                                                      children: <
                                                                          TextSpan>[
                                                                        TextSpan(
                                                                          text:
                                                                              ' wishes that ',
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Colors.blueAccent,
                                                                              fontSize: 18),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              " ${birthdays[index].messageInfo["wishesList"][i]["message"]}",
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Colors.indigo,
                                                                              fontSize: 18),
                                                                        )
                                                                      ]),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ));
                              */
                                      } */
                                    },
                                    child: Container(
                                        child: Text(
                                      birthdays[index].messageInfo == null
                                          ? ""
                                          : "${birthdays[index].messageInfo["wishesList"].length}",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontFamily: "Monteserrat"),
                                    )),
                                  ),
                                ],
                              ), */
                              SizedBox(width: 5),

                              /* IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.countertops,
                                        color: Colors.pink[900], size: 20)), */
                              // IconButton(
                              //     icon: Icon(Icons.arrow_forward_ios, size: 15.0),
                              //     onPressed: () {})
                            ],
                          )
                        ],
                      ),
                      // Transform.translate(
                      //   offset: Offset(0, -15),
                      //   child: Center(
                      //     child: GestureDetector(
                      //         child: Container(
                      //           // decoration: BoxDecoration(
                      //           //   color: Colors.red,
                      //           //   border: Border.all(color: Colors.blueAccent),
                      //           //   borderRadius:
                      //           //       BorderRadius.all(Radius.circular(5.0)),
                      //           // ),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               RotatedBox(
                      //                   quarterTurns: 0,
                      //                   child: FaIcon(FontAwesomeIcons.solidComment,
                      //                       color: Colors.indigo)),
                      //               SizedBox(width: 5.0),
                      //               Text(
                      //                 "Send Wishes",
                      //                 style: TextStyle(
                      //                     color: Colors.indigo,
                      //                     fontFamily: "Monteserrat"),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         onTap: () {
                      //           print("Send Wisahes");
                      //           openSendWishesAlert(birthdays[index]);
                      //         }),
                      //   ),
                      // ),
                      // SizedBox(height: 2.0),
                      /* Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.translate(
                          offset: Offset(animation.value, 0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('assets/images/userInfo.png'),
                            )),
                          ),
                        ),
                      ), */
                    ],
                  ),
                ),
              );
            })
      ]),
    );
  }
}
/* ListView.builder(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    shrinkWrap: true,
                                                    itemCount: birthdays[index]
                                                        .messageInfo[
                                                            "wishesList"]
                                                        .length,
                                                    itemBuilder: (context, i) {
                                                      int ii = i + 1;
                                                      return RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "$ii. ${birthdays[index].messageInfo["wishesList"][i]["userName"]}",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                fontSize: 18),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    ' wishes that ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    " ${birthdays[index].messageInfo["wishesList"][i]["message"]}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .indigo,
                                                                    fontSize:
                                                                        18),
                                                              )
                                                            ]),
                                                      );
                                                    }), */
