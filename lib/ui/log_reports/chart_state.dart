import '../../ui/log_reports/chart_data.dart';
import '../../ui/log_reports/chart_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final datePickerFormat = DateFormat("MMM dd, yyyy");
final dateFormat = DateFormat("yyyy-MM-dd");
final dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:\'00\'');
final timeZoneOffset = DateTime.now().timeZoneOffset;

int _numDaysInMonth(int month, int year) {
  switch (month) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
      return 31;
    case 4:
    case 6:
    case 9:
    case 11:
      return 30;
    case 2:
      if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
        return 29;
      return 28;

    default:
      return 0;
  }
}

abstract class ChartStateData extends ChangeNotifier {
  ChartDataSeries get data;

  bool get isLoading;

  String get title;

  void fetchForDateRange(DateTime startDate, DateTime endDate);

  void fetchForMonth(String month, String year);
}

abstract class LineChartStateData extends ChangeNotifier {
  LineDataSeries get data;

  bool get isLoading;

  String get title;

  LineChartMode get mode;

  void fetchForDate(DateTime date);

  void fetchForMonth(DateTime date);

  void fetchForYear(int year);
}

String chartUser = "DATT";

class BloodPressureData extends ChartStateData {
  ChartDataSeries _diastolicData;
  ChartDataSeries _systolicData;
  bool _isLoading = true;

  String get title => "Blood Pressure";

  ChartDataSeries get diastolicData => _diastolicData;

  ChartDataSeries get systolicData => _systolicData;

  ChartDataSeries get data => _systolicData;

  bool get isLoading => _isLoading;

  void _fetch(String startDate, String endDate) async {
    _isLoading = true;
    notifyListeners();
    _systolicData = await fetchSystolicPie(startDate, endDate, chartUser);
    _diastolicData = await fetchDiastolicPie(startDate, endDate, chartUser);
    _isLoading = false;
    notifyListeners();
  }

  void fetchForDateRange(DateTime startDate, DateTime endDate) {
    _fetch(dateFormat.format(startDate), dateFormat.format(endDate));
  }

  void fetchForMonth(String month, String year) {
    // debugPrint("month --> $month");
    // debugPrint("year --> $year");
    DateTime now = new DateTime.now();
    DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
    print('$year-$month-01 $year-$month-${lastDayOfMonth.day}');
    _fetch('$year-$month-01', '$year-$month-${lastDayOfMonth.day}');
  }
}

class BMIData extends ChartStateData {
  ChartDataSeries _data;
  bool _isLoading = true;

  @override
  ChartDataSeries get data => _data;

  @override
  bool get isLoading => _isLoading;

  @override
  String get title => "BMI";

  void _fetch(String startDate, String endDate) async {
    _isLoading = true;
    notifyListeners();
    _data = await fetchBMIData(startDate, endDate, chartUser);
    _isLoading = false;
    notifyListeners();
  }

  @override
  void fetchForDateRange(DateTime startDate, DateTime endDate) {
    _fetch(dateFormat.format(startDate), dateFormat.format(endDate));
  }

  @override
  void fetchForMonth(String month, String year) {
    DateTime now = new DateTime.now();
    DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
    print('$year-$month-01 $year-$month-${lastDayOfMonth.day}');
    _fetch('$year-$month-01', '$year-$month-${lastDayOfMonth.day}');
  }
}

class BloodSugarData extends ChartStateData {
  ChartDataSeries _data;
  bool _isLoading = true;

  @override
  ChartDataSeries get data => _data;

  @override
  bool get isLoading => _isLoading;

  @override
  String get title => "Blood Sugar";

  void _fetch(String startDate, String endDate) async {
    _isLoading = true;
    notifyListeners();
    _data = await fetchBloodSugarData(startDate, endDate, chartUser);
    _isLoading = false;
    notifyListeners();
  }

  @override
  void fetchForDateRange(DateTime startDate, DateTime endDate) {
    _fetch(dateFormat.format(startDate), dateFormat.format(endDate));
  }

  @override
  void fetchForMonth(String month, String year) {
    DateTime now = new DateTime.now();
    DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
    print('$year-$month-01 $year-$month-${lastDayOfMonth.day}');
    _fetch('$year-$month-01', '$year-$month-${lastDayOfMonth.day}');
  }
}

class Hba1cData extends ChartStateData {
  ChartDataSeries _data;
  bool _isLoading = true;

  @override
  ChartDataSeries get data => _data;

  @override
  bool get isLoading => _isLoading;

  @override
  String get title => "HbA1c";

  void _fetch(String startDate, String endDate) async {
    _isLoading = true;
    notifyListeners();
    _data = await fetchHba1cData(startDate, endDate, chartUser);
    _isLoading = false;
    notifyListeners();
  }

  @override
  void fetchForDateRange(DateTime startDate, DateTime endDate) {
    _fetch(dateFormat.format(startDate), dateFormat.format(endDate));
  }

  @override
  void fetchForMonth(String month, String year) {
    DateTime now = new DateTime.now();
    DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
    print('$year-$month-01 $year-$month-${lastDayOfMonth.day}');
    _fetch('$year-$month-01', '$year-$month-${lastDayOfMonth.day}');
  }
}

enum LineChartMode { DAY, MONTH, YEAR }

class DiastoleData extends LineChartStateData {
  LineDataSeries _data;
  bool _isLoading = true;
  LineChartMode _mode = LineChartMode.DAY;

  @override
  LineChartMode get mode => _mode;

  @override
  LineDataSeries get data => _data;

  @override
  bool get isLoading => _isLoading;

  @override
  String get title => "Diastolic";

  void _fetch(String startDate, String endDate) async {
    _isLoading = true;
    notifyListeners();
    _data = await fetchDiastolic(startDate, endDate, chartUser);
    _isLoading = false;
    notifyListeners();
  }

  @override
  void fetchForDate(DateTime date) {
    _mode = LineChartMode.DAY;
    date = date.add(timeZoneOffset);
    final startDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 0);
    _fetch(
      dateTimeFormat.format(startDate),
      dateTimeFormat.format(endDate),
    );
  }

  @override
  void fetchForMonth(DateTime date) {
    _mode = LineChartMode.MONTH;
    date = date.add(timeZoneOffset);
    final startDate = DateTime(date.year, date.month, 1, 0, 0, 0);
    final endDate = DateTime(date.year, date.month,
        _numDaysInMonth(date.month, date.year), 23, 59, 0);
    _fetch(
      dateTimeFormat.format(startDate),
      dateTimeFormat.format(endDate),
    );
  }

  @override
  void fetchForYear(int year) {
    _mode = LineChartMode.YEAR;
    final startDate = DateTime(year, 1, 1, 0, 0, 0);
    final endDate = DateTime(year, 12, 31, 23, 59, 0);
    _fetch(
      dateTimeFormat.format(startDate),
      dateTimeFormat.format(endDate),
    );
  }
}

class SystoleData extends LineChartStateData {
  LineDataSeries _data;
  bool _isLoading = true;
  LineChartMode _mode = LineChartMode.DAY;

  @override
  LineChartMode get mode => _mode;

  @override
  LineDataSeries get data => _data;

  @override
  bool get isLoading => _isLoading;

  @override
  String get title => "Systolic";

  void _fetch(String startDate, String endDate) async {
    _isLoading = true;
    notifyListeners();
    _data = await fetchSystolic(startDate, endDate, chartUser);
    _isLoading = false;
    notifyListeners();
  }

  @override
  void fetchForDate(DateTime date) {
    _mode = LineChartMode.DAY;
    date = date.add(timeZoneOffset);
    final startDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 0);
    _fetch(
      dateTimeFormat.format(startDate),
      dateTimeFormat.format(endDate),
    );
  }

  @override
  void fetchForMonth(DateTime date) {
    _mode = LineChartMode.MONTH;
    date = date.add(timeZoneOffset);
    final startDate = DateTime(date.year, date.month, 1, 0, 0, 0);
    final endDate = DateTime(date.year, date.month,
        _numDaysInMonth(date.month, date.year), 23, 59, 0);
    _fetch(
      dateTimeFormat.format(startDate),
      dateTimeFormat.format(endDate),
    );
  }

  @override
  void fetchForYear(int year) {
    _mode = LineChartMode.YEAR;
    final startDate = DateTime(year, 1, 1, 0, 0, 0);
    final endDate = DateTime(year, 12, 31, 23, 59, 0);
    _fetch(
      dateTimeFormat.format(startDate),
      dateTimeFormat.format(endDate),
    );
  }
}
