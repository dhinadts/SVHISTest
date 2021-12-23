import 'dart:convert';
import 'dart:typed_data';

import '../../model/user_info.dart';
import '../../repo/auth_repository.dart';
import '../../ui/custom_drawer/fintness_app_theme.dart';
import '../../ui_utils/app_colors.dart';

import 'remainders_list_data.dart';
import 'package:flutter/material.dart';

class RemaindersListView extends StatefulWidget {
  const RemaindersListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _RemaindersListViewState createState() => _RemaindersListViewState();
}

class _RemaindersListViewState extends State<RemaindersListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<RemaindersListData> remaindersListData;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 170,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: remaindersListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = remaindersListData.length > 10
                      ? 10
                      : remaindersListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return RemaindersView(
                    remaindersListData: remaindersListData[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class RemaindersView extends StatefulWidget {
  const RemaindersView({
    Key key,
    this.remaindersListData,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final RemaindersListData remaindersListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  _RemaindersViewState createState() => _RemaindersViewState();
}

class _RemaindersViewState extends State<RemaindersView>
    with TickerProviderStateMixin {
  Uint8List _bytesImage;
  String imagePath;
  UserInfo userInfo;
  Image imageDecoded;
  AuthRepository _authRepository;
  String bgIMage =
          "https://memberly-app.github.io/sivi/assets/images/bgs/birthday.png",
      startColor = "#1E1466",
      endColor = "#1E1466";
  @override
  void initState() {
    super.initState();
    // getuserPic();
    getDecData();
  }

  getDecData() {
    Map<String, List<String>> wishesTypes = {
      "Birthday": [
        "https://memberly-app.github.io/sivi/assets/images/bgs/birthday.png",
        "#1E1466",
        "#1E1466"
      ],
      "Anniversary": [
        "https://memberly-app.github.io/sivi/assets/images/bgs/work.png",
        "#012d19",
        "#012d19"
      ],
      "Others": [
        "https://memberly-app.github.io/sivi/assets/images/bgs/marriage.png",
        "#2d1e01",
        "#2d1e01"
      ],
    };
    print(wishesTypes.keys.contains(widget.remaindersListData.occasionalType));
    if (wishesTypes.keys.contains(widget.remaindersListData.occasionalType)) {
      setState(() {
        bgIMage = wishesTypes["${widget.remaindersListData.occasionalType}"][0];
        startColor =
            wishesTypes["${widget.remaindersListData.occasionalType}"][1];
        endColor =
            wishesTypes["${widget.remaindersListData.occasionalType}"][2];
      });
    } else {
      setState(() {
        bgIMage = wishesTypes["Others"][0];
        startColor = wishesTypes["Others"][1];
        endColor = wishesTypes["Others"][2];
      });
    }
  }

  // getuserPic() async {
  //   _authRepository = new AuthRepository();
  //   userInfo = new UserInfo();
  //   userInfo =
  //       await _authRepository.getUserInfo(widget.remaindersListData.pr);

  //   if (userInfo.profileImage != null) {
  //     setState(() {
  //       imagePath = userInfo.profileImage;
  //       _bytesImage = base64Decode(userInfo.profileImage);
  //     });
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // var messageInfo = widget.remaindersListData.messageInfo;

    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width * 0.75,
      child: AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
/*         print(messageInfo.keys.toList().length);
          print(messageInfo[messageInfo.keys.toList()]);
          print(messageInfo[messageInfo.keys.toList()[0]][0]["message"]); */
          return FadeTransition(
            opacity: widget.animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  100 * (1.0 - widget.animation.value), 0.0, 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 8, right: 8, bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple[900],
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: HexColor(endColor).withOpacity(0.6),
                                // Color(0xFF1E1466),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: [HexColor(startColor), HexColor(endColor)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(44.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 55, right: 16, bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                // widget.mealsListData.userName,
                                "${widget.remaindersListData.firstName} ${widget.remaindersListData.lastName}",
                                textAlign: TextAlign.left,
                                // maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.1,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${widget.remaindersListData.occasionalType}",
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: 0.2,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /* mealsListData.kacl != 0
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  mealsListData.kacl.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                    letterSpacing: 0.2,
                                                    color: FitnessAppTheme.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 4, bottom: 3),
                                                  child: Text(
                                                    'KKK',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10,
                                                      letterSpacing: 0.2,
                                                      color: FitnessAppTheme.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          :  */
                              Container(
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: FitnessAppTheme.nearlyBlack
                                            .withOpacity(0.4),
                                        offset: Offset(-18.0, 8.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                /*child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Icon( Icons.add, color: HexColor(mealsListData.endColor), size: 24,
                                                ),
                                              ),*/
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 55,
                      left: 0,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 99,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.white.withOpacity(0.1),
                                      BlendMode.dstATop),
                                  image:
                                      /* userInfo == null
                                      ? NetworkImage(
                                          "https://memberly-app.github.io/sivi/assets/images/bgs/birthday.png")
                                      :
                                      MemoryImage(
                                          base64Decode(userInfo.profileImage)), */
                                      NetworkImage(bgIMage),
                                  fit: BoxFit.cover,
                                ),
                                color: FitnessAppTheme.nearlyWhite
                                    .withOpacity(0.2),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(0.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(158.0),
                                )),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 0,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Container(
                          child: widget.remaindersListData.profilePic == null ||
                                  widget
                                      .remaindersListData.profilePic.isEmpty ||
                                  widget.remaindersListData.profilePic == ""
                              ? CircleAvatar(
                                  radius: 50,
                                  // backgroundColor: Colors.indigo,
                                  child: Center(
                                    child: Text(
                                        "${widget.remaindersListData.firstName[0]}${widget.remaindersListData.lastName == null || widget.remaindersListData.lastName.isEmpty || widget.remaindersListData.lastName == "" ? "" : widget.remaindersListData.lastName[0]}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0)),
                                  ))
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      widget.remaindersListData.profilePic ==
                                                  null ||
                                              widget.remaindersListData
                                                  .profilePic.isEmpty
                                          ? AssetImage("assets/images/user.png")
                                          : MemoryImage(base64Decode(widget
                                              .remaindersListData.profilePic))),

                          //  NetworkImage(imagePath)
                          // ),
                          decoration: new BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white.withOpacity(1),
                              //color:  HexColor(mealsListData.endColor).withOpacity(1.0),
                              width: 1.0,
                            ),
                          ),
                        ),
                        /*child: CircleAvatar(
                            radius: 20,
                            foregroundColor: Colors.white,
                            backgroundImage: NetworkImage(mealsListData.imagePath)
                        ),*/
                      ),
                    ),
                    /*       Positioned(
                        bottom: 2,
                        right: 10,
                        child: IconButton(
                          icon: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.green, width: 1.2)),
                            child: Icon(Icons.chat, color: Colors.teal[500]),
                          ),
                          onPressed: () async {
                            var textWish = TextEditingController();
                            await showDialog(
                                context: context,
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  contentPadding: EdgeInsets.only(top: 10.0),
                                  // title: Text("Wishes"),
                                  content: Stack(
                                    children: [
                                      Transform.translate(
                                        offset: Offset(-25, -45),
                                        child: CircleAvatar(
                                          // backgroundColor: Colors.red,
                                          radius: 35.0,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(35)),
                                              child: widget.remaindersListData
                                                              .profilePic ==
                                                          null ||
                                                      widget.remaindersListData
                                                          .profilePic.isEmpty
                                                  ? Image.asset(
                                                      "assets/images/user.png")
                                                  : Image.memory(base64Decode(
                                                      widget.remaindersListData
                                                          .profilePic))),
                                        ),
                                      ),
                                      Container(
                                        height: 250.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(25.0),
                                                child: Text(
                                                    "Send your wishes to ${widget.remaindersListData.userName}"),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
                                              child: new TextFormField(
                                                style: TextStyles
                                                    .mlDynamicTextStyle,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2,
                                                          horizontal: 16),
                                                  // hintMaxLines: 3,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  labelText:
                                                      "Please type your wishes",
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 2,
                                                controller: textWish,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                    color: Colors.indigo,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    onPressed: () async {
                                                      if (textWish
                                                              .text.isEmpty ||
                                                          textWish.text ==
                                                              null) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Type your wishes",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            timeInSecForIosWeb:
                                                                5,
                                                            gravity:
                                                                ToastGravity
                                                                    .TOP);
                                                      } else {
                                                        await CommonRepository()
                                                            .updateWishesList(
                                                                widget
                                                                    .remaindersListData,
                                                                widget
                                                                    .remaindersListData
                                                                    .anniversaryRemaindersId,
                                                                textWish.text,
                                                                widget
                                                                    .remaindersListData
                                                                    .userName);

                                                        await Fluttertoast.showToast(
                                                            msg:
                                                                "Successfully sent your wish to ${widget.remaindersListData.userName}",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            timeInSecForIosWeb:
                                                                5,
                                                            gravity:
                                                                ToastGravity
                                                                    .TOP);
                                                        // Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("Send",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15))),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ))
               */
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FlashCardDecoData {
  FlashCardDecoData({
    this.bgPath = '',
    this.wishType = '',
    this.startColor = '',
    this.endColor = '',
  });

  String bgPath;
  String wishType;

  String startColor;
  String endColor;
}

List<FlashCardDecoData> flashCardDecoData = [
  FlashCardDecoData(
    bgPath:
        'https://memberly-app.github.io/sivi/assets/images/bgs/birthday.png',
    wishType: "Birthday",
    startColor: '#1E1466',
    endColor: '#1E1466',
  ),
  FlashCardDecoData(
    bgPath: 'https://memberly-app.github.io/sivi/assets/images/bgs/work.png',
    wishType: "Work Anniversary",
    startColor: '#000000',
    endColor: '#000000',
  ),
  FlashCardDecoData(
    bgPath:
        'https://memberly-app.github.io/sivi/assets/images/bgs/birthday.png',
    wishType: "Birthday",
    startColor: '#FE95B6',
    endColor: '#FF5287',
  ),
  FlashCardDecoData(
    bgPath:
        'https://memberly-app.github.io/sivi/assets/images/bgs/marriage.png',
    wishType: "Marriage Anniversary",
    startColor: '#FA7D82',
    endColor: '#FFB295',
  ),
];
