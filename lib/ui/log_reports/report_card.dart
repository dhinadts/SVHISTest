import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'chart_data.dart';
import 'chart_state.dart';
import 'details_screen.dart';
import 'pie_chart.dart';

final List<String> _months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

//List<String> useableMonths;

List<String> get months {
  //if (useableMonths == null) {
  //useableMonths = _months.sublist(0, 9);
  //}
  //debugPrint("useableMonths length --> ${useableMonths.length}");
  // debugPrint(
  //     "useableMonths length --> ${_months.sublist(0, DateTime.now().month).length}");
  return _months.sublist(0, DateTime.now().month);
}

final numberFormatter = NumberFormat("00");
final monthYearFormatter = DateFormat("MMMM yyyy");

List<int> _years;

List<int> get years {
  if (_years == null) {
    int currYear = DateTime.now().year;
    _years = [];
    for (int i = currYear - 20; i <= currYear; i++) _years.add(i);
  }
  return _years;
}

class ReportCard<T extends ChartStateData> extends StatefulWidget {
  final bool showTitle;
  final bool showDetails;
  DateTime initialDateTime;
  int initialMonth;
  int initialYear;
  int initialTab;

  ReportCard(
      {Key key,
      this.showTitle = true,
      this.showDetails = false,
      this.initialDateTime,
      this.initialMonth,
      this.initialYear,
      this.initialTab})
      : super(key: key);

  @override
  _ReportCardState createState() => _ReportCardState<T>();
}

class _ReportCardState<T extends ChartStateData> extends State<ReportCard>
    with TickerProviderStateMixin {
  StreamController<int> chosenTabController = StreamController<int>();
  StreamController<DateTime> chosenDateController =
      StreamController<DateTime>.broadcast();
  BehaviorSubject<int> chosenMonthController = BehaviorSubject<int>();
  BehaviorSubject<int> chosenYearController = BehaviorSubject<int>();
  int currentTabIndex = 0;

  int currMonth = DateTime.now().month - 1;
  int currYear = DateTime.now().year;
  TabController _tabControllerActual;
  DateTime currDateTime;

  @override
  void dispose() {
    chosenTabController.close();
    chosenDateController.close();
    chosenMonthController.close();
    chosenYearController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    chosenDateController.stream.listen((event) {
      currDateTime = event;
    });
    _tabControllerActual = TabController(
      initialIndex: currentTabIndex,
      length: 3,
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      if (widget.initialTab != null) {
        currentTabIndex = widget.initialTab;
        _tabControllerActual.animateTo(currentTabIndex);
        chosenTabController.sink.add(widget.initialTab);
        onTabChanged();
      } else {
        DateTime currentDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        // if (widget.initialDateTime != null) currentDate = widget.initialDateTime;
        Provider.of<T>(context, listen: false).fetchForDateRange(
          currentDate,
          currentDate,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildCard(Provider.of<T>(context, listen: false).title);
  }

  onTabChanged() {
    switch (currentTabIndex) {
      case 0:
        DateTime currentDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        if (widget.initialDateTime != null) {
          currentDate = widget.initialDateTime;
          chosenDateController.add(currentDate);
          widget.initialDateTime = null;
        }
        Provider.of<T>(context, listen: false).fetchForDateRange(
          currentDate,
          currentDate,
        );
        break;
      case 1:
        if (widget.initialMonth != null) {
          debugPrint("widget.initialMonth not null");
          currMonth = widget.initialMonth;
          chosenMonthController.add(currMonth);
          widget.initialMonth = null;
          debugPrint("currYear before... $currYear");
          debugPrint("widget.initialYear before... ${widget.initialYear}");
          currYear = widget.initialYear;
          debugPrint("currYear after... $currYear");
          chosenYearController.add(currYear);
          widget.initialYear = null;
        } else {
          debugPrint("widget.initialMonth null");
          debugPrint("currYear ... $currYear");
          debugPrint("widget.initialYear ... ${widget.initialYear}");
        }
        String monthString = "${numberFormatter.format(currMonth + 1)}";
        String yearString = currYear.toString();

        debugPrint(
            "onTabChanged case 1 : monthString --> $monthString, yearString --> $yearString");
        Provider.of<T>(context, listen: false).fetchForMonth(
          monthString,
          yearString,
        );
        break;
      case 2:
        if (widget.initialYear != null) {
          currYear = widget.initialYear;
          chosenYearController.add(currYear);

          /// Need to check with Akash. To resolve null value issue(on tab switch), I have commented.
          //widget.initialYear = null;
        }
        DateTime startDate = DateTime(currYear, 1, 1);
        DateTime endDate = DateTime(currYear, currMonth + 1, 30);

        Provider.of<T>(context, listen: false)
            .fetchForDateRange(startDate, endDate);
        break;
      default:
    }
  }

  Widget buildCard(String title) => Container(
        margin: const EdgeInsets.only(top: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: double.infinity),
                widget.showTitle
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(fontSize: 18),
                          ),
                          widget.showDetails
                              ? FlatButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailsScreen<T>(
                                          initialDateTime: currDateTime,
                                          initialMonth: currMonth,
                                          initialYear: currYear,
                                          initialTab: currentTabIndex,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Details",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Container(),
                Container(
                  height: 20,
                ),
                SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Consumer<T>(
                    builder: (context, data, child) => data.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : data.data.chartDataList.isEmpty
                            ? Center(
                                child: Text("No Data Available"),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildLegend(data.data),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: DonutAutoLabelChart.withChartData(
                                        data.data),
                                  ),
                                ],
                              ),
                  ),
                ),
                Column(
                  children: [
                    Container(height: 30),
                    StreamBuilder<int>(
                      stream: chosenTabController.stream,
                      builder: (context, snapshot) => AnimatedSwitcher(
                        duration: Duration(milliseconds: 100),
                        child: getPicker(snapshot.data ?? 0),
                      ),
                    ),
                    Container(height: 10),
                    TabBar(
                      onTap: (i) {
                        currentTabIndex = i;
                        chosenTabController.sink.add(i);
                        debugPrint("Tab clicked...");
                        onTabChanged();
                      },
                      labelColor: Colors.black,
                      controller: _tabControllerActual,
                      tabs: [
                        Tab(
                          text: "Date",
                        ),
                        Tab(
                          text: "Month",
                        ),
                        Tab(
                          text: "Year",
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Widget getPicker(int tabIndex) {
    //print("Chosen Tab $this");
    //print(tabIndex);
    switch (tabIndex) {
      case 0:
        return buildDateButton();
      case 1:
        return buildMonthYearButton();
      case 2:
        return buildYearButton();
    }
    return Container();
  }

  Widget buildYearButton() {
    return Material(
      color: Colors.white,
      child: StreamBuilder<int>(
          stream: chosenYearController.stream,
          builder: (context, snapshot) {
            return InkWell(
              onTap: () async {
                final newYear = await showYearPicker(
                  context,
                  DateTime.now().year,
                );
                if (newYear == null) return;
                currYear = newYear;
                // String monthString = "${numberFormatter.format(currMonth + 1)}";
                // String yearString = currYear.toString();

                DateTime startDate = DateTime(currYear, 1, 1);
                DateTime endDate = DateTime(currYear, 12, 30);

                Provider.of<T>(context, listen: false)
                    .fetchForDateRange(startDate, endDate);

                // Provider.of<T>(context, listen: false).fetchForMonth(
                //   monthString,
                //   yearString,
                // );
                chosenYearController.sink.add(currYear);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      // snapshot.data == null
                      //     ? monthYearFormatter.format(DateTime.now())
                      currYear.toString(),
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget buildDateButton() {
    return Material(
      color: Colors.white,
      child: StreamBuilder<DateTime>(
          stream: chosenDateController.stream,
          builder: (context, snapshot) {
            return InkWell(
              onTap: () async {
                final newDate = await showDatePicker(
                    context, snapshot.data ?? DateTime.now());
                if (newDate != null) {
                  chosenDateController.sink.add(newDate);
                  debugPrint(
                      "startDate --> ${newDate.subtract(Duration(days: 365))}");
                  debugPrint("newDate --> $newDate");

                  Provider.of<T>(context, listen: false)
                      .fetchForDateRange(newDate, newDate);

                  // Provider.of<T>(context, listen: false)
                  //     .fetchForDateRange(newDate, newDate);
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      datePickerFormat.format(
                        snapshot.data ?? DateTime.now(),
                      ),
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<int> showYearPicker(BuildContext context, int year) {
    int newYear = year;
    return showCupertinoModalPopup<int>(
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
                    Navigator.of(context).pop(newYear);
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
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: years.indexOf(currYear)),
                onSelectedItemChanged: (int value) {
                  // print(years[value]);
                  newYear = years[value];
                },
                itemExtent: 50,
                children: years
                    .map<Widget>((year) => Center(child: Text(year.toString())))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMonthYearButton() {
    debugPrint("buildMonthYearButton called...");
    return Material(
      color: Colors.white,
      child: StreamBuilder<int>(
          stream: chosenMonthController.stream,
          builder: (context, snapshot) {
            return InkWell(
              onTap: () async {
                final monthYear = await showMonthYearPicker(
                  context,
                  DateTime.now().month - 1,
                  DateTime.now().year,
                );
                debugPrint("monthYear --> $monthYear");
                if (monthYear == null) return;
                currMonth = monthYear['month'];
                currYear = monthYear['year'];
                String monthString =
                    "${numberFormatter.format(monthYear['month'] + 1)}";
                String yearString = monthYear['year'].toString();
                debugPrint(
                    "buildMonthYearButton : monthString --> $monthString, yearString --> $yearString");
                Provider.of<T>(context, listen: false).fetchForMonth(
                  monthString,
                  yearString,
                );
                chosenMonthController.sink.add(monthYear['month']);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      // snapshot.data == null
                      //     ? monthYearFormatter.format(DateTime.now())
                      "${months[currMonth]} $currYear",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<DateTime> showDatePicker(BuildContext context, DateTime chosenDate) {
    DateTime dateTime = chosenDate;
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
                maximumDate: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: chosenDate,
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

  Future<Map<String, int>> showMonthYearPicker(
      BuildContext context, int month, int year) {
    int newMonth = month;
    int newYear = year;
    return showCupertinoModalPopup<Map<String, int>>(
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
                    Navigator.of(context)
                        .pop({"month": newMonth, "year": newYear});
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
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CupertinoPicker(
                      scrollController:
                          FixedExtentScrollController(initialItem: currMonth),
                      onSelectedItemChanged: (int value) {
                        // print(months[value]);
                        newMonth = value;
                      },
                      itemExtent: 50,
                      children: months
                          .map<Widget>((month) => Center(child: Text(month)))
                          .toList(),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: years.indexOf(currYear)),
                      onSelectedItemChanged: (int value) {
                        // print(years[value]);
                        newYear = years[value];
                      },
                      itemExtent: 50,
                      children: years
                          .map<Widget>(
                              (year) => Center(child: Text(year.toString())))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildLegend(ChartDataSeries dataSeries) {
    return Column(
      children: dataSeries.chartDataList
          .map<Widget>(
            (data) => Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: data.color),
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                ),
                Text(
                  data.label,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          )
          .toList(),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
