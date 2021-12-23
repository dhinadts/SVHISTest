import 'chart_state.dart';
import 'line_chart.dart';
import 'report_card.dart';
import '../../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bp_report_card.dart';

class DetailsScreen<T extends ChartStateData> extends StatefulWidget {
  DateTime initialDateTime;
  int initialMonth;
  int initialYear;
  int initialTab;

  DetailsScreen({
    Key key,
    this.initialDateTime,
    this.initialMonth,
    this.initialYear,
    this.initialTab,
  }) : super(key: key);

  @override
  _DetailsScreenState<T> createState() => _DetailsScreenState<T>();
}

class _DetailsScreenState<T extends ChartStateData>
    extends State<DetailsScreen<T>> {
  bool showFullChart = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialTab != null) {
      switch (widget.initialTab) {
        case 0:
          Provider.of<DiastoleData>(context, listen: false)
              .fetchForDate(widget.initialDateTime ?? DateTime.now());
          Provider.of<SystoleData>(context, listen: false)
              .fetchForDate(widget.initialDateTime ?? DateTime.now());
          break;
        case 1:
          final initialMonthDateTime =
              DateTime(widget.initialYear, widget.initialMonth + 1);
          Provider.of<DiastoleData>(context, listen: false)
              .fetchForMonth(initialMonthDateTime);
          Provider.of<SystoleData>(context, listen: false)
              .fetchForMonth(initialMonthDateTime);
          break;
        case 2:
          Provider.of<DiastoleData>(context, listen: false)
              .fetchForYear(widget.initialYear);
          Provider.of<SystoleData>(context, listen: false)
              .fetchForYear(widget.initialYear);
          break;
      }
    } else {
      Future.delayed(Duration(milliseconds: 100), () {
        Provider.of<DiastoleData>(context, listen: false)
            .fetchForDate(DateTime.now());
        Provider.of<SystoleData>(context, listen: false)
            .fetchForDate(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<T>(context, listen: false).title),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0).copyWith(top: 0),
              child: Column(
                children: [
                  Provider.of<T>(context, listen: false).title ==
                          "Blood Pressure"
                      ? BPReportCard(
                          showTitle: false,
                          initialDateTime: widget.initialDateTime,
                          initialMonth: widget.initialMonth,
                          initialYear: widget.initialYear,
                          initialTab: widget.initialTab,
                          onNewDate: (newDate) {
                            Provider.of<DiastoleData>(context, listen: false)
                                .fetchForDate(newDate);
                            Provider.of<SystoleData>(context, listen: false)
                                .fetchForDate(newDate);
                          },
                          onNewMonth: (newMonth) {
                            Provider.of<DiastoleData>(context, listen: false)
                                .fetchForMonth(newMonth);
                            Provider.of<SystoleData>(context, listen: false)
                                .fetchForMonth(newMonth);
                          },
                          onNewYear: (newYear) {
                            Provider.of<DiastoleData>(context, listen: false)
                                .fetchForYear(newYear);
                            Provider.of<SystoleData>(context, listen: false)
                                .fetchForYear(newYear);
                          },
                        )
                      : ReportCard<T>(
                          showTitle: false,
                          initialDateTime: widget.initialDateTime,
                          initialMonth: widget.initialMonth,
                          initialYear: widget.initialYear,
                          initialTab: widget.initialTab,
                        ),
                  Container(height: 20),
                  if (Provider.of<T>(context, listen: false).title ==
                      "Blood Pressure")
                    Column(
                      children: [
                        buildLineCard<SystoleData, DiastoleData>(context),
                        Container(height: 20),
                      ],
                    ),
                ],
              ),
            ),
          ),
          showFullChart
              ? fullScreenLineChart()
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }

  Card
      buildLineCard<T extends LineChartStateData, S extends LineChartStateData>(
          BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Systolic/Diastolic",
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    setState(() {
                      if (showFullChart) {
                        showFullChart = false;
                      } else {
                        showFullChart = true;
                      }
                    });
                  },
                ),
              ],
            ),
            Container(
              height: 30,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.7,
              child: Consumer2<T, S>(
                builder: (context, chartData1, chartData2, child) {
                  if (chartData1.isLoading || chartData2.isLoading)
                    return Center(child: CircularProgressIndicator());
                  return SimpleLineChart.withChartData(
                    chartData1.data,
                    chartData2.data,
                    chartData1.mode,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildLineCardLadscape<T extends LineChartStateData,
      S extends LineChartStateData>(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 60,
          top: 20,
          bottom: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Systolic/Diastolic",
              style: TextStyle(fontSize: 18),
            ),
            Container(
              height: 30,
            ),
            Expanded(
              child: Consumer2<T, S>(
                builder: (context, chartData1, chartData2, child) {
                  if (chartData1.isLoading || chartData2.isLoading)
                    return Center(child: CircularProgressIndicator());
                  return SimpleLineChart.withChartData(
                    chartData1.data,
                    chartData2.data,
                    chartData1.mode,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Full Screen chart view
  Widget fullScreenLineChart() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColors.transparentBg,
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: buildLineCardLadscape<SystoleData, DiastoleData>(context),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                // color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (showFullChart) {
                    showFullChart = false;
                  } else {
                    showFullChart = true;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
