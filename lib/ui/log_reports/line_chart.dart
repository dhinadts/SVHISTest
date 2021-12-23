import '../../ui/log_reports/chart_data.dart';
import 'package:charts_common/common.dart' as common
    show BasicDateTimeTickFormatterSpec;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chart_state.dart';

final dateFormat = DateFormat("dd/MM/yy hh:mm a");

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  List<charts.TickSpec<DateTime>> ticks = [];
  String tickFormat;

  factory SimpleLineChart.withChartData(
    LineDataSeries chartData1,
    LineDataSeries chartData2,
    LineChartMode mode,
  ) {
    //debugPrint("title --> ${chartData.title}");
    //debugPrint("chartData --> ${chartData.data.}");
    final instance = SimpleLineChart(
      [
        new charts.Series<LinearData, DateTime>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearData linData, _) {
            final temp = dateFormat.parse(linData.label).add(timeZoneOffset);
            //print("${linData.label} ==> $temp");
            return temp;
          },
          measureFn: (LinearData linData, _) => linData.value,
          data: chartData1.data,
        ),
        new charts.Series<LinearData, DateTime>(
          id: 'Sales1',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (LinearData linData, _) =>
              dateFormat.parse(linData.label).add(timeZoneOffset),
          measureFn: (LinearData linData, _) => linData.value,
          data: chartData2.data,
        ),
      ],
      animate: true,
    );
    switch (mode) {
      case LineChartMode.DAY:
        instance.tickFormat = "hh:mm a";
        break;
      case LineChartMode.MONTH:
        instance.tickFormat = "d MMM";
        break;
      case LineChartMode.YEAR:
        instance.tickFormat = "MMM";
        break;
    }
    // List<String> existing = [];
    // DateFormat testFormat = DateFormat(instance.tickFormat);
    chartData1.data.forEach((lineData) {
      final dateTime = dateFormat.parse(lineData.label);
      // final tick = testFormat.format(dateTime);
      // if (existing.contains(tick)) return;
      // existing.add(tick);
      instance.ticks
          .add(charts.TickSpec<DateTime>(dateTime.add(timeZoneOffset)));
    });

    return instance;
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 45,
        ),
        tickProviderSpec: charts.StaticDateTimeTickProviderSpec(ticks),
        tickFormatterSpec: common.BasicDateTimeTickFormatterSpec.fromDateFormat(
          DateFormat(tickFormat),
        ),
      ),
    );
  }
}
