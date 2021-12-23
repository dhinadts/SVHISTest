import 'package:flutter/material.dart';

class ChartData {
  String label;
  num value;
  String colorCode;

  ChartData(this.label, this.value, {this.colorCode});

  Color get color => _colorFromHex(colorCode);

  Color _colorFromHex(String hexColor) {
    if (hexColor == null) {
      // print("Null color for label: $label");
      return Colors.transparent;
    }
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class ChartDataSeries {
  String title;
  List<ChartData> chartDataList;

  ChartDataSeries(this.title, this.chartDataList);

  void add(ChartData chartData) => chartDataList.add(chartData);

  factory ChartDataSeries.fromJson(String title, Map<String, dynamic> json) {
    final series = ChartDataSeries(title, []);
    int i = 0;
    for (var key in json.keys) {
      //debugPrint("key --> $key");
      series.add(ChartData(key, json[key], colorCode: _colors[key]));
      i++;
    }
    return series;
  }
}

const Map<String, String> _colors = {
  "Low": "#0070C0",
  "Normal": "#00B050",
  "High-Normal": "#FFC000",
  "Grade 1 HTN": '#FF0000',
  // "Grade 2 HTN": '#7030A0',
  "Grade 2 HTN": '#b260f0',
  "Severe HTN": '#7030A0',
  "Underweight": '#0070C0',
  "Overweight": '#FFC000',
  "Obese": '#FF0000',
  "Severely Obese": '#7030A0',
  "Good": '#00B050',
  "Elevated": '#FFC000',
  "High": '#FF0000',
  "Very High": '#7030A0',
  "Unknown": '#000000',
  "NULL": '#000000',
  "VeryHigh": '#7030A0',
  "VeryLow": "#0000C0"
};

class LinearData {
  final String label;
  final double value;
  final int index;

  LinearData(this.label, this.value, this.index);
}

class LineDataSeries {
  String title;
  List<LinearData> data;

  LineDataSeries(this.title, this.data);

  void add(LinearData chartData) => data.add(chartData);

  factory LineDataSeries.fromJson(String title, Map<String, dynamic> json) {
    final series = LineDataSeries(title, []);
    int i = 0;
    for (var key in json.keys) {
      //debugPrint("series key --> ${key}");
      series.add(LinearData(
          key, double.tryParse(json[key].toString() ?? "0") ?? 0, i));
      i++;
    }
    return series;
  }
}
