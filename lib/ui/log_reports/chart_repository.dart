import 'dart:convert';

import '../../repo/common_repository.dart';
import '../../ui/log_reports/chart_data.dart';
import 'package:http/http.dart' as http;

http.Client _httpClient = http.Client();

Future<Map<String, dynamic>> _fetchChart(Map<String, dynamic> body) async {
  final response = await _httpClient.post(
    '${WebserviceConstants.baseURL}/report/chart',
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );
  // print("${WebserviceConstants.baseURL}/report/chart");
  // print("_fetchChart body --> $body");
  // print("_fetchChart response --> ${response.body}");
  final responseBody = response.body;
  final decoded = jsonDecode(responseBody);
  // print(decoded);

  return decoded.keys.length > 0 ? decoded[decoded.keys.first] : {};
  // return jsonDecode("NULL");
}

Future<ChartDataSeries> fetchBPData(
    String startDate, String endDate, String user) async {
  String query = "";
  if (startDate == endDate) {
    query =
        "select t.Blood_Pressure, count(t.user_name) from ( select check_in.user_name,check_in.Blood_Pressure,check_in.Blood_Sugar from check_in  where check_in.user_name = '$user' and DATE(created_on)='$startDate' and blood_pressure!= '') as t group by t.Blood_Pressure";
  } else {
    query =
        "select t.Blood_Pressure, count(t.user_name) from ( select check_in.user_name,check_in.Blood_Pressure,check_in.Blood_Sugar from check_in  where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and blood_pressure!= '') as t group by t.Blood_Pressure";
  }
  print("BP DATA");
  print(query);
  var body = {
    "query": query,
    "xAxis": "Blood_Pressure",
    "yAxis": "user_name",
    "xAxisDuration": null,
    "chartType": "PIE_CHART",
    "dateRange": "CUSTOM",
    "startDate": startDate,
    "endDate": endDate,
    "ignoreNull": true,
    "plotType": "Count",
    "range": 0,
    "maxValue": 0
  };
  print(body);
  final responseJson = await _fetchChart(body);

  // debugPrint("_fetchChart body --> $body");
  // debugPrint("_fetchChart responseJson --> $responseJson");

  return ChartDataSeries.fromJson("Blood Pressure", responseJson);
}

Future<ChartDataSeries> fetchBMIData(
    String startDate, String endDate, String user) async {
  String query = "";
  if (startDate == endDate) {
    query =
        "select t.BMI, count(t.user_name) from ( select check_in.column2,check_in.BMI,check_in.user_name from check_in  where check_in.user_name = '$user' and DATE(created_on)='$startDate' and BMI!= '') as t group by t.BMI";
  } else {
    query =
        "select t.BMI, count(t.user_name) from ( select check_in.column2,check_in.BMI,check_in.user_name from check_in  where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and BMI!= '') as t group by t.BMI";
  }
  print("BMI DATA");
  print(query);
  var body = {
    "query": query,
    "xAxis": "BMI",
    "yAxis": "user_name",
    "xAxisDuration": null,
    "chartType": "PIE_CHART",
    "dateRange": "CUSTOM",
    "startDate": startDate,
    "endDate": endDate,
    "ignoreNull": true,
    "plotType": "Count",
    "range": 0,
    "maxValue": 0
  };
  print(body);
  final responseJson = await _fetchChart(body);
  return ChartDataSeries.fromJson("Blood Pressure", responseJson);
}

Future<ChartDataSeries> fetchBloodSugarData(
    String startDate, String endDate, String user) async {
  String query = "";
  if (startDate == endDate) {
    query =
        "select t.Blood_Sugar, count(t.user_name) from ( select check_in.user_name,check_in.Blood_Sugar from check_in  where check_in.user_name = '$user' and DATE(created_on)='$startDate' and Blood_Sugar!= '') as t group by t.Blood_Sugar";
  } else {
    query =
        "select t.Blood_Sugar, count(t.user_name) from ( select check_in.user_name,check_in.Blood_Sugar from check_in  where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and Blood_Sugar!= '') as t group by t.Blood_Sugar";
  }
  print("Blood Sugar DATA");
  print(query);
  var body = {
    "query": query,
    "xAxis": "Blood_Sugar",
    "yAxis": "user_name",
    "xAxisDuration": null,
    "chartType": "PIE_CHART",
    "dateRange": "CUSTOM",
    "startDate": startDate,
    "endDate": endDate,
    "ignoreNull": true,
    "plotType": "Count",
    "range": 0,
    "maxValue": 0
  };
  print(body);
  final responseJson = await _fetchChart(body);
  return ChartDataSeries.fromJson("Blood Pressure", responseJson);
}

Future<ChartDataSeries> fetchHba1cData(
    String startDate, String endDate, String user) async {
  String query = "";
  if (startDate == endDate) {
    query =
        "select t.HbA1C, count(t.user_name) from ( select check_in.user_name,check_in.column8,check_in.HbA1C from check_in  where check_in.user_name = '$user' and DATE(created_on)='$startDate' and HbA1C!= '') as t group by t.HbA1C";
  } else {
    query =
        "select t.HbA1C, count(t.user_name) from ( select check_in.user_name,check_in.column8,check_in.HbA1C from check_in  where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and HbA1C!= '') as t group by t.HbA1C";
  }
  print("Hba1cData");
  print(query);
  var body = {
    "query": query,
    "xAxis": "HbA1C",
    "yAxis": "user_name",
    "xAxisDuration": null,
    "chartType": "PIE_CHART",
    "dateRange": "CUSTOM",
    "startDate": startDate,
    "endDate": endDate,
    "ignoreNull": true,
    "plotType": "Count",
    "range": 0,
    "maxValue": 0
  };
  print(body);
  final responseJson = await _fetchChart(body);
  return ChartDataSeries.fromJson("Blood Pressure", responseJson);
}

Future<LineDataSeries> fetchDiastolic(
  String startDate,
  String endDate,
  String user,
) async {
  String query =
      "select created_on as created_on, column4 from check_in where user_name = '$user' and check_in.created_on >= '$startDate' and check_in.created_on <= '$endDate' order by created_on asc";
  var body = {
    "chartType": "AREA_CHART",
    "ignoreNull": true,
    "maxValue": 0,
    "plotType": "Raw",
    "query": query,
    "range": 0,
    "xAxis": "created_on",
    "xAxisDuration": "TIME",
    "xAxisLimit": "25",
    "yAxis": "column4"
  };
  final responseJson = await _fetchChart(body);
  //debugPrint("_fetchChart body Diastole --> $body");
  //debugPrint("_fetchChart responseJson Diastole --> $responseJson");
  return LineDataSeries.fromJson("Diastole", responseJson);
}

Future<LineDataSeries> fetchSystolic(
  String startDate,
  String endDate,
  String user,
) async {
  String query =
      "select created_on as created_on, column3 from check_in where user_name = '$user' and check_in.created_on >= '$startDate' and check_in.created_on <= '$endDate' order by created_on asc";

  var body = {
    "chartType": "AREA_CHART",
    "ignoreNull": true,
    "maxValue": 0,
    "plotType": "Raw",
    "query": query,
    "range": 0,
    "xAxis": "created_on",
    "xAxisDuration": "TIME",
    "xAxisLimit": "25",
    "yAxis": "column3"
  };
  final responseJson = await _fetchChart(body);
  //debugPrint("_fetchChart body Systolic --> $body");
  //debugPrint("_fetchChart responseJson Systolic --> $responseJson");
  return LineDataSeries.fromJson("Systole", responseJson);
}

Future<ChartDataSeries> fetchSystolicPie(
    String startDate, String endDate, String user) async {
  String query = "";
  if (startDate == endDate) {
    query =
        "select t.blood_pressure_systolic as Systolic, count(t.user_name) from ( select check_in.user_name,check_in.blood_pressure_systolic,check_in.Blood_Sugar from check_in where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and blood_pressure_systolic!= '') as t group by t.blood_pressure_systolic";
  } else {
    query =
        "select t.blood_pressure_systolic as Systolic, count(t.user_name) from ( select check_in.user_name,check_in.blood_pressure_systolic,check_in.Blood_Sugar from check_in where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and blood_pressure_systolic!= '') as t group by t.blood_pressure_systolic";
  }
  print("SystolicPie");
  print(query);
  var body = {
    "chartType": "PIE_CHART",
    "ignoreNull": true,
    "maxValue": 0,
    "plotType": "Raw",
    "query": query,
    "range": 0,
    "xAxis": "systolic",
    "xAxisDuration": null,
    "xAxisLimit": "25",
    "yAxis": "created_on"
  };
  print(body);
  final responseJson = await _fetchChart(body);
  //debugPrint("_fetchChart body Systolic --> $body");
  //debugPrint("_fetchChart responseJson Systolic --> $responseJson");
  return ChartDataSeries.fromJson("Blood Pressure", responseJson);
}

Future<ChartDataSeries> fetchDiastolicPie(
  String startDate,
  String endDate,
  String user,
) async {
  String query = "";
  if (startDate == endDate) {
    query =
        "select t.blood_pressure_diastolic as Diastolic, count(t.user_name) from ( select check_in.user_name,check_in.blood_pressure_diastolic,check_in.Blood_Sugar from check_in where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and blood_pressure_diastolic!= '') as t group by t.blood_pressure_diastolic";
  } else {
    query =
        "select t.blood_pressure_diastolic as Diastolic, count(t.user_name) from ( select check_in.user_name,check_in.blood_pressure_diastolic,check_in.Blood_Sugar from check_in where check_in.user_name = '$user' and DATE(created_on) >='$startDate' and DATE(created_on) <='$endDate' and blood_pressure_diastolic!= '') as t group by t.blood_pressure_diastolic";
  }
  print("DiastolicPie");
  print(query);
  var body = {
    "chartType": "PIE_CHART",
    "ignoreNull": true,
    "maxValue": 0,
    "plotType": "Raw",
    "query": query,
    "range": 0,
    "xAxis": "Diastolic",
    "xAxisDuration": null,
    "xAxisLimit": "25",
    "yAxis": "created_on"
  };
  print(body);
  final responseJson = await _fetchChart(body);
  //debugPrint("_fetchChart body Systolic --> $body");
  //debugPrint("_fetchChart responseJson Systolic --> $responseJson");
  return ChartDataSeries.fromJson("Blood Pressure", responseJson);
}
