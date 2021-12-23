import '../../login/colors/color_info.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/people.dart';
import '../../model/subscriptions_model.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/people_list_page.dart';
import '../../ui/subscription/bloc/subscription_bloc.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../widgets/basic_text_field_widget.dart';
import '../../widgets/linked_lable_checkbox.dart';
import '../../widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubscriptionScreen extends StatefulWidget {
  final SubscriptionsModel subscriptionsModel;

  SubscriptionScreen(this.subscriptionsModel);

  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

class SubscriptionScreenState extends State<SubscriptionScreen> {
  List<String> userList = [];
  List<String> sendingData = List();
  List<SelectedUser> constructingData = List();
  SubscriptionBloc _bloc;
  bool isLoaded = false;
  bool subscriptionStatus = false;
  String buttonText = "";
  List<String> unSubcribedUsers = [];
  SubscriptionRequest requestGlobal;
  bool activeState;

  @override
  void initState() {
    _bloc = SubscriptionBloc(context);
    setState(() {
      activeState = widget.subscriptionsModel.active;
    });

    _bloc.getSubscription(
        subscriptionName: widget.subscriptionsModel.subscriptionName);
    _bloc.subscriptionUserListFetcher.listen((value) {
      setState(() {
        constructingData = [];
        if (value?.users != null)
          for (String s in value?.users) {
            constructingData.add(SelectedUser(s, null, true));
          }
        isLoaded = true;
        if (constructingData.length > 0) {
          subscriptionStatus = true;
        }
      });
    });

    subscriptionController.text = widget.subscriptionsModel.subscriptionName;
    ruleController.text = widget.subscriptionsModel.ruleExpression;
    super.initState();

    /// Initialize Admob
    initializeAd();
  }

  TextEditingController subscriptionController = TextEditingController();
  TextEditingController ruleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Subscription Details"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(AppUIDimens.paddingXLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IgnorePointer(
                            child: BasicTextField(
                          readOnly: true,
                          controller: subscriptionController,
                          hint: "Subscription Name",
                          textStyle: TextStyle(color: Colors.grey),
                        )),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            height: 98,
                            child: BasicTextField(
                              readOnly: true,
                              controller: ruleController,
                              hint: "Rule Expression",
                              maxLine: null,
                              textStyle: TextStyle(color: Colors.grey),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Activate Subscription",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Switch(
                              value: activeState ?? false,
                              onChanged: (bo) {
                                setState(() {
                                  activeState = !(activeState ?? false);
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  constructingData.length > 0
                                      ? "Users to be notified (${constructingData.length}/25)"
                                      : "Users to be notified",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        listOfUsers(),
                        SizedBox(
                          height: 25,
                        ),
                        if (isLoaded)
                          Container(
                              alignment: Alignment.center,
                              child: Container(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Material(
                                    color: Color(ColorInfo.APP_BLUE),
                                    child: new InkWell(
                                      child: new Center(
                                        child: new Text(
                                          AppLocalizations.of(context)
                                              .translate("key_update"),
                                          style: TextStyle(
                                              color: Color(ColorInfo.WHITE),
                                              fontSize: 18.0,
                                              fontFamily:
                                                  Constants.LatoRegular),
                                        ),
                                      ),
                                      onTap: () async {
                                        requestGlobal = SubscriptionRequest();
                                        SubscriptionRequest unSubscribeRequest =
                                            SubscriptionRequest();
                                        unSubscribeRequest.departmentName =
                                            AppPreferences().deptmentName;
                                        unSubscribeRequest.userName = List();
                                        unSubscribeRequest.contactType = [
                                          "Push_Notification"
                                        ];

                                        requestGlobal.departmentName =
                                            AppPreferences().deptmentName;
                                        requestGlobal.userName = List();
                                        requestGlobal.contactType = [
                                          "Push_Notification"
                                        ];
                                        CustomProgressLoader.showLoader(
                                            context);
                                        for (SelectedUser user
                                            in constructingData) {
                                          if (user.checkboxValue) {
                                            requestGlobal.userName.add(
                                                user?.username ?? user.name);
                                          } else {
                                            unSubcribedUsers.add(
                                                user?.username ?? user.name);
                                          }
                                        }
                                        if (subscriptionStatus &&
                                            unSubcribedUsers.length > 0) {
                                          unSubscribeRequest.userName =
                                              unSubcribedUsers;
                                          // print(
                                          //     "UsersUnSubscribe  ${unSubscribeRequest.userName}");
                                          await subscriptionCall(
                                              unSubscribeRequest,
                                              unSubscribeCall: true);
                                        } else {
                                          // print("Users  ${requestGlobal.userName}");
                                          subscriptionCall(requestGlobal);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ))
                      ],
                    ),
                  )
                ],
              )),
            ),

            /// Show Banner Ad
            getSivisoftAdWidget(),
          ],
        ));
  }

  bool subscribeCall = false;

  Future<void> subscriptionCall(SubscriptionRequest request,
      {bool unSubscribeCall: false}) async {
    _bloc.updateSubscription(
        request: request,
        subscriptionName: widget.subscriptionsModel.subscriptionName,
        status: activeState,
        isSubscribeCall: !unSubscribeCall);

    _bloc.subscriptionAddFetcher.listen((value) {
      if (value.status > 199 || 300 > value.status) {
        Fluttertoast.showToast(
            msg: "Subscription updated successfully",
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
        if (!unSubscribeCall) {
          CustomProgressLoader?.cancelLoader(context);
          Navigator.pop(context, true);
        } else {
          if (!subscribeCall) {
            setState(() {
              subscribeCall = true;
            });
            // print("Users  ${requestGlobal.userName}");
            if (requestGlobal.userName.length == 0) {
              CustomProgressLoader?.cancelLoader(context);
              Navigator.pop(context, true);
            } else {
              subscriptionCall(requestGlobal);
            }
          }
        }
      } else {
        CustomProgressLoader?.cancelLoader(context);
        String messageBody = value?.message;
        AlertUtils.showAlertDialog(
            context,
            (messageBody != null && messageBody.isNotEmpty)
                ? messageBody
                : AppLocalizations.of(context)
                    .translate("key_somethingwentwrong"));
      }
    });
  }

  Widget listOfUsers() {
    return isLoaded
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blueAccent, width: 3)),
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width * 1,
            child: Stack(
              children: <Widget>[
                Scrollbar(
                    child: ListView.builder(
                  padding: EdgeInsets.only(top: 2),
                  itemCount: constructingData.length,
                  itemBuilder: (context, index) {
                    return Column(children: <Widget>[
                      LinkedLabelCheckbox(
                        onChanged: (bo) {
                          setState(() {
                            constructingData[index].checkboxValue =
                                !constructingData[index].checkboxValue;
                          });
                        },
                        value: constructingData[index].checkboxValue,
                        label: constructingData[index]?.name ??
                            constructingData[index]?.username,

                        /* controlAffinity: ListTileControlAffinity.leading,*/
                      ),
                      Container(
                        width: double.infinity,
                        //margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 1,
                        color: AppColors.borderLine,
                      ),
                      Container(
                        width: double.infinity,
                        //margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 3,
                        color: AppColors.borderShadow,
                      ),
                    ]);
                  },
                )),
                if (constructingData.length == 0)
                  Align(child: Text("No data available")),
                Positioned(
                    right: 12,
                    bottom: 12,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.person_add,
                        //size: 17,
                      ),
                      onPressed: () async {
                        if (constructingData.length < 25) {
                          List<People> peopleObjectList = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PeopleListPage(
                                      isCameFromSubscription: true,
                                      constructingDataList: constructingData,
                                    )),
                          );
                          if (peopleObjectList != null &&
                              peopleObjectList.length > 0) {
                            for (People peopleObject in peopleObjectList)
                              setState(() {
                                constructingData.add(SelectedUser(
                                    "${peopleObject.userName}",
                                    "${peopleObject.userName}",
                                    true));
                              });
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Already added maximum number of user",
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_LONG);
                        }
                      },
                    ))
              ],
            ))
        : Container(
            padding: EdgeInsets.only(top: AppUIDimens.paddingSmall),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blueAccent, width: 3)),
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width * 1,
            child: ListLoading(
              itemCount: 5,
            ));
  }
}

class SelectedUser {
  String name;
  String username;
  bool checkboxValue;

  SelectedUser(this.name, this.username, this.checkboxValue);
}

class SubscriptionRequest {
  String departmentName;
  List<String> contactType;
  List<String> userName;

  SubscriptionRequest({this.departmentName, this.userName});

  SubscriptionRequest.fromJson(Map<String, dynamic> json) {
    departmentName = json['departmentName'];
    contactType = json['contactType'].cast<String>();
    userName = json['userName'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactType'] = this.contactType;
    data['departmentName'] = this.departmentName;
    data['userName'] = this.userName;
    return data;
  }
}
