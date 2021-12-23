import 'package:Memberly/utils/constants.dart';

import '../../../model/passing_arg.dart';
import '../../../ui/custom_drawer/navigation_home_screen.dart';
import '../../../ui/payment/bloc/payment_bloc.dart';
import '../../../ui/payment/model/payment_detail_response.dart';
import '../../../ui/payment/widget/transaction_list_item.dart';
import '../../../ui/tabs/app_localizations.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/icon_utils.dart';
import '../../../ui_utils/ui_dimens.dart';
import '../../../ui_utils/widget_styles.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/routes.dart';
import '../../../widgets/mode_tag.dart';
import '../../../widgets/transaction_list_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../model/payment_detail.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String title;
  const TransactionHistoryScreen({Key key, this.title}) : super(key: key);

  @override
  TransactionHistoryScreenState createState() =>
      TransactionHistoryScreenState();
}

class TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  PaymentBloc _bloc;
  final GlobalKey _settingsMenuKey = new GlobalKey();
  String dateLocal;
  bool isFirstLoad = true;

  String _startDate = "";
  String _endDate = "";
  DateTime _startDateFormat;
  DateTime _endDateFormat;

  String chipsValue = "Last 7 days";
  List<PaymentDetail> localPaymentList;
  String totalCount = "0";
  bool setAll = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    _bloc = PaymentBloc(context);

    if (AppPreferences().role == Constants.supervisorRole) {
      setState(() {
        chipsValue = "Last 7 days";
        setAll = false;
      });
    } else {
      setState(() {
        chipsValue = "All";
        setAll = true;
      });
    }

    _bloc.countFetcher.listen((value) {
      if (!isFirstLoad) {
        setState(() {
          totalCount = value != null ? value.toString() : "0";
        });
      }
    });
    initializeData();
    // print("ROLE --> ");
    // print(AppPreferences().role);
  }

  void initializeData() {
    _bloc.getPaymentHistory();
  }

  sendAlertMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg, gravity: ToastGravity.TOP, toastLength: Toast.LENGTH_LONG);
  }

  showCustomDateAlertDialog(BuildContext context) {
    // set up the AlertDialog
    _startDate = "";
    _endDate = "";
    AlertDialog alert = AlertDialog(
      title: Text("Select Date Range"),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter changeState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("Start Date"),
                  flex: 2,
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      openDateSelector("start", changeState);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_startDate),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.date_range_outlined)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text("End Date"),
                  flex: 2,
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      openDateSelector("end", changeState);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_endDate),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.date_range_outlined)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      }),
      actions: [
        FlatButton(
          child: Text("SUBMIT"),
          onPressed: () {
            if (_startDate == '' && _endDate == '') {
              sendAlertMessage("Please select Dates");
            } else if (_startDate == '') {
              sendAlertMessage("Please select Start Date");
            } else if (_endDate == '') {
              sendAlertMessage("Please select End Date");
            } else {
              chipsValue = "Custom";
              filterFunctionality(chipsValue, false);
              Navigator.pop(context);
            }
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  openDateSelector(String type, StateSetter changeState) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime:
            _endDate == "" || type == "end" ? DateTime.now() : _endDateFormat,
        minTime: _startDate == "" || type == "start"
            ? DateTime.now().subtract(Duration(days: 365))
            : _startDateFormat,
        theme: WidgetStyles.datePickerTheme,
        onChanged: (date) {}, onConfirm: (date) {
      changeState(() {
        if (type == "start") {
          _startDate = setCreatedDate(date, "start");
          DateTime time = date;
          time = new DateTime(
            time.year,
            time.month,
            time.day,
            0,
            0,
            0,
          );

          setState(() {
            _startDateFormat = time;
          });
        } else {
          _endDate = setCreatedDate(date, "end");
          // _endDateFormat = date;
          var newHour = 23;
          DateTime time = date;
          time = new DateTime(
            time.year,
            time.month,
            time.day,
            23,
            59,
            59,
          );

          setState(() {
            _endDateFormat = time;
          });
        }
      });
    },
        currentTime: DateTime.now(),
        locale:
            /*AppPreferences().isLanguageTamil() ? LocaleType.ta :*/ LocaleType
                .en);

    // print("DATE");
    // print(_endDateFormat);
    // print(_startDateFormat);
  }

  String setCreatedDate(DateTime _date, String type) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    final String formatted = formatter.format(_date);
    if (type == "start") {
    } else if (type == "end") {
      // DateTime dateTime = DateFormat('dd-MM-yyyy h:mm:ssa', 'en_US').parseLoose('01-11-2020 2:00:00AM');
    }

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final popupSettingMenu = new PopupMenuButton(
        child: InkWell(
            onTap: () {
              dynamic state = _settingsMenuKey.currentState;
              state.showButtonMenu();
            },
            child: ModeTag(
              chipsValue,
              leading: true,
            )),
        key: _settingsMenuKey,
        itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(child: const Text('All'), value: 'All'),
              new PopupMenuItem<String>(
                  child: const Text('Last 7 days'), value: 'Last 7 days'),
              new PopupMenuItem<String>(
                  child: const Text('Last 1 month'), value: 'Last 1 month'),
              new PopupMenuItem<String>(
                  child: const Text('Custom'), value: 'Custom'),
            ],
        onSelected: (val) async {
          if (localPaymentList != null && localPaymentList.length > 0) {
            if (val == "Custom") {
              await showCustomDateAlertDialog(context);
            } else {
              setState(() {
                chipsValue = val;
              });
              if (val == 'All') {
                await filterFunctionality(chipsValue, true);
              } else {
                await filterFunctionality(chipsValue, false);
              }
            }
          } else {
            localPaymentList = [];
            if (val == "Custom") {
              await showCustomDateAlertDialog(context);
            } else {
              setState(() {
                chipsValue = val;
              });
              if (val == 'All') {
                await filterFunctionality(chipsValue, true);
              } else {
                await filterFunctionality(chipsValue, false);
              }
            }
          }
        });

    return Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: AppUIDimens.paddingXMedium),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration:
                      BoxDecoration(boxShadow: WidgetStyles.cardBoxShadow),
                  child: Column(
                    children: <Widget>[
                      // _titleTransaction()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Filter",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                popupSettingMenu
                              ],
                            ))),
                    Text("Total Count : ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$totalCount",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                    stream: _bloc.paymentFetcher,
                    builder: (context,
                        AsyncSnapshot<PaymentDetailResponse> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data is PaymentDetailResponse) {
                          List<PaymentDetail> paymentList =
                              snapshot.data.paymentDetailList;
                          //Sort option based on date
                          paymentList.sort((a, b) {
                            DateTime aDate = DateTime.parse(
                                a.transactionDate ?? a.createdOn);
                            DateTime bDate = DateTime.parse(
                                b.transactionDate ?? b.createdOn);
                            return bDate.compareTo(aDate);
                          });
                          if (paymentList.length > 0) {
                            //return DailyStatusListWidget(sym, widget.people);
                            if (localPaymentList == null) {
                              localPaymentList = paymentList;
                              if (AppPreferences().role ==
                                  Constants.supervisorRole) {
                                chipsValue = "Last 7 days";
                                filterFunctionality(chipsValue, false);
                              } else {
                                chipsValue = 'All';
                                // localPaymentList = paymentList;
                                // print("963852741");
                                filterFunctionality(chipsValue, true);
                              }
                            }
                            return isFirstLoad
                                ? TransactionListLoadingWidget()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: paymentList.length,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        dateLocal =
                                            DateUtils.convertUTCToLocalDate(
                                                paymentList[index]
                                                        .transactionDate ??
                                                    paymentList[index]
                                                        .createdOn);
                                      }
                                      bool showDate = false;
                                      showDate = dateLocal !=
                                              DateUtils.convertUTCToLocalDate(
                                                  paymentList[index]
                                                          .transactionDate ??
                                                      paymentList[index]
                                                          .createdOn) ||
                                          index == 0;
                                      if (showDate) {
                                        dateLocal =
                                            DateUtils.convertUTCToLocalDate(
                                                paymentList[index]
                                                        .transactionDate ??
                                                    paymentList[index]
                                                        .createdOn);
                                      }

                                      return (paymentList[index]
                                                      .transactionStatus !=
                                                  null &&
                                              paymentList[index]
                                                  .transactionStatus
                                                  .isNotEmpty)
                                          ? TransactionListItem(
                                              paymentList[index],
                                              showDate: showDate,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    Routes
                                                        .transactionDetailsScreen,
                                                    arguments: Args(
                                                        paymentDetail:
                                                            paymentList[
                                                                index]));
                                              },
                                            )
                                          : Container();
                                    },
                                  );
                          }
                        }
                        return Text(AppLocalizations.of(context)
                            .translate("key_no_data_found"));
                      }
                      return TransactionListLoadingWidget();
                    }),
              ],
            )));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.grey, //                   <--- border color
        width: 5.0,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      title: Text(
        widget.title != null ? widget.title : "Transaction History",
        style: AppPreferences().isLanguageTamil()
            ? TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
            : TextStyle(color: Colors.white),
      ),
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
              //replaceHome();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            })
      ],
    );
  }

  filterFunctionality(String value, bool fix) {
    var now = new DateTime.now();
    if (value == "Last 7 days") {
      var weeklyDate = now.subtract(Duration(days: 7));
      filterFromListAndPopulateUI(now, weeklyDate);
    } else if (value == "Last 1 month") {
      var monthlyDate = new DateTime(now.year, now.month - 1, now.day);
      filterFromListAndPopulateUI(now, monthlyDate);
    } else if (value == "Custom") {
      filterFromListAndPopulateUI(_endDateFormat, _startDateFormat);
    } else if (value == "All") {
      PaymentDetailResponse response = PaymentDetailResponse();
      response.paymentDetailList = localPaymentList;

      _bloc.paymentFetcher.sink.add(null);
      Future.delayed(Duration(seconds: 1), () async {
        // print("Length : ${response.paymentDetailList.length}");
        if (response.paymentDetailList == null) {
          setState(() {
            totalCount = "0";
            isFirstLoad = false;
          });
        } else {
          setState(() {
            totalCount = response.paymentDetailList.length.toString();
            isFirstLoad = false;
          });
        }

        _bloc.paymentFetcher.sink.add(response);
      });
    }
  }

  filterFromListAndPopulateUI(DateTime fromDate, DateTime toDate) {
    // print("timing");
    // print(fromDate);
    // print(toDate);
    List<PaymentDetail> listPayment = List();
    for (PaymentDetail detail in localPaymentList) {
      if (toDate.isBefore(
              DateTime.parse(detail.createdOn ?? detail.transactionDate)) &&
          fromDate.isAfter(
              DateTime.parse(detail.createdOn ?? detail.transactionDate))) {
        listPayment.add(detail);
      }
    }
    PaymentDetailResponse response = PaymentDetailResponse();
    response.paymentDetailList = listPayment;
    _bloc.paymentFetcher.sink.add(null);
    Future.delayed(Duration(seconds: 1), () async {
      // print("Length : ${response.paymentDetailList.length}");
      setState(() {
        totalCount = response.paymentDetailList.length.toString();
        if (isFirstLoad) {
          isFirstLoad = false;
        }
      });
      _bloc.paymentFetcher.sink.add(response);
    });
  }
}
