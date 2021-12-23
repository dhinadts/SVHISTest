import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'chart_data.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  factory DonutAutoLabelChart.withChartData(ChartDataSeries chartDataSeries) {
    List<charts.Series<ChartData, String>> series;
    if (chartDataSeries.chartDataList.isNotEmpty)
      series = [
        new charts.Series<ChartData, String>(
          id: "ChartData",
          domainFn: (ChartData chartData, _) => chartData.label,
          measureFn: (ChartData chartData, _) => chartData.value,
          data: chartDataSeries.chartDataList,
          // Set a label accessor to control the text of the arc label.
          labelAccessorFn: (ChartData row, _) => '${row.value}',
          colorFn: (ChartData chartData, _) =>
              charts.Color.fromHex(code: chartData.colorCode),
        )
      ];
    return new DonutAutoLabelChart(series, animate: true);
  }

  @override
  Widget build(BuildContext context) {
    if (seriesList == null)
      return Container(
        child: Center(
          child: Text("No Data Available"),
        ),
      );
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(),
        ],
      ),
    );
  }
}

class PieData {
  final String label;
  final num value;
  final String colorCode;

  PieData(this.label, this.value, {this.colorCode});
}
