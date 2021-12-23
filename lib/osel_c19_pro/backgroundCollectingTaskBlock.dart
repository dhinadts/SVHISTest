import 'dart:convert';

import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rxdart/rxdart.dart';

class DataSample {
  // double temperature1;
  // double temperature2;
  // double waterpHlevel;
  String tempData;
  DateTime timestamp;

  DataSample({
    // this.temperature1,
    // this.temperature2,
    // this.waterpHlevel,
    this.tempData,
    this.timestamp,
  });
}

class BackgroundCollectingTaskBloc {
  static BackgroundCollectingTaskBloc _instance =
      BackgroundCollectingTaskBloc._internal();

  factory BackgroundCollectingTaskBloc() => _instance;

  BackgroundCollectingTaskBloc._internal();

  var sampleDataSubject = PublishSubject<DataSample>();
  Stream<DataSample> get sampleDataList =>
      sampleDataSubject.stream.asBroadcastStream();

  @override
  void init() {}

  //Establishing the connection
  _fromConnection() {
    debugPrint(">>>_fromConnection");
    AppPreferences().connection.input.listen((data) {
      String receivedData = new String.fromCharCodes(data);
      // // print("Received data --> $receivedData");
      /*
       * As Confirmed by the C19 Pro Developers
       * Some Important points to read the temperature depending on thier level from C19 Pro
       * 1) Normal - 35.9 to 37.5 C - Read this "T body = 36.593 C, weak low" value
       * 2) High - 38.0 - 40 C - Read this "T body = 38.169, Against the heat balance" value
       * 3) Very High - above 40 C - Read this "T body = 182.967, Against the heat balance" value
       */

      if (receivedData.isNotEmpty) {
        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(receivedData);

        for (var i = 0; i < lines.length; i++) {
          // print('Line $i: ${lines[i]}');
          if (lines[i].contains("T body") &&
              (lines[i].contains("weak") || lines[i].contains("Against"))) {
            // print("Contains --> ${lines[i]}");
            List<String> resultArray = lines[i].split(",");
            if (resultArray.length > 0) {
              //T body = 28.446 C, ambience compensate
              List<String> temp = resultArray[0].split("=");
              if (temp.isNotEmpty) {
                // print("Temperature is ${Cel_To_Fah(temp[1].trim())}");
                final DataSample sample = DataSample(
                    tempData: Cel_To_Fah(temp[1].trim()),
                    timestamp: DateTime.now());
                sampleDataSubject.sink.add(sample);
              }
            }
          }
        }
      }
    }, onError: (error) {
      sampleDataSubject.sink.addError(error);
    }).onDone(() {});
    start();
  }

  /*
  * As Confirmed by the C19 Pro Developers
  * C19 Pro display rounds the values which are more than 100 F.
  * */
  String Cel_To_Fah(String n) {
    double tempInCel = double.parse(n.replaceAll(" C", ""));
    var temp = (tempInCel * 9.0 / 5.0) + 32.0;
    if (temp > 100) {
      return temp.roundToDouble().toString();
    } else {
      return temp.toStringAsFixed(1);
    }
  }

  String Fah_To_Cel(double tempInF) {
    //return ((tempInF − 32) * 5)/9;
    return ((tempInF * 5.0 / 9.0) - 32.0).toStringAsFixed(1);
  }

  Future<BackgroundCollectingTaskBloc> connect(BluetoothDevice server) async {
    debugPrint(">>>connect");
    BluetoothConnection connection;

    if (AppPreferences().connection == null) {
      try {
        connection = await BluetoothConnection.toAddress(server.address);
      } catch (ex) {
        connection = null;
      }
      if (connection != null) {
        await AppPreferences().setBluetoothConnection(connection);
        return _fromConnection();
      }
    }
    //_connection = connection;
    return null;
  }

  //Starts the connection
  Future<void> start() async {
    debugPrint(">>>Start");
    AppPreferences().connection.output.add(ascii.encode('start'));
    await AppPreferences().connection.output.allSent;
  }

  //Stops the connection
  Future<void> cancel() async {
    debugPrint(">>>cancel");
    if (getConnectionStatus()) {
      AppPreferences().connection.output.add(ascii.encode('stop'));
      await AppPreferences().connection.finish();
      AppPreferences().setBluetoothConnection(null);
    } else {
      AppPreferences().setBluetoothConnection(null);
    }
  }

  Future<void> pause() async {
    debugPrint(">>>pause");
    if (getConnectionStatus()) {
      AppPreferences().connection.output.add(ascii.encode('stop'));
    }
    await AppPreferences().connection.output.allSent;
  }

  Future<void> resume() async {
    debugPrint(">>>resume");
    AppPreferences().connection.output.add(ascii.encode('start'));
    await AppPreferences().connection.output.allSent;
  }

  getConnectionStatus() {
    if (AppPreferences().connection != null) {
      return AppPreferences().connection.isConnected;
    }
    return false;
  }

  @override
  void dispose() {
    sampleDataSubject.close();
    AppPreferences().connection.dispose();
  }
}
