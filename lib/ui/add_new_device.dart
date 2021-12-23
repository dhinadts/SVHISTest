import 'dart:async';

import '../ui_utils/app_colors.dart';

import '../osel_c19_pro/backgroundCollectingTaskBlock.dart';
import '../osel_c19_pro/selectBondedDevicePage.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
 
class AddNewDevice extends StatefulWidget {
  final String deviceName;

  const AddNewDevice({Key key, this.deviceName}) : super(key: key);

  @override
  _AddNewDeviceState createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevice> {
  bool isBluetoothEnabled = true;
  bool isStatusEnabled = false;

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  //BackgroundCollectingTask _collectingTask;

  bool _autoAcceptPairingRequests = false;
  bool showSelectedDevice = false;
  BluetoothDevice selectedConnectedDevice;
  var temperature = "";
  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // print("_bluetoothState $_bluetoothState");

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    // print("add_new_device _address $_address");

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // print("add_new_device _name $_name");

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });

    manageBluetoothConnection();
  }

  manageBluetoothConnection() async {
    // print("Connection Status >> ${BackgroundCollectingTaskBloc().getConnectionStatus()}");

    if(BackgroundCollectingTaskBloc().getConnectionStatus()){
      if(AppPreferences().selectedConnectedDevice != null){
        selectedConnectedDevice = AppPreferences().selectedConnectedDevice;
        showSelectedDevice = true;
        isStatusEnabled = true;
      }
    }
  }

  @override
  void dispose() {
    // FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    //_collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(widget.deviceName),
          centerTitle: true,
          /*actions: <Widget>[
            _bluetoothState.isEnabled ?FlatButton(
              onPressed: () async {
                final BluetoothDevice selectedDevice =
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DiscoveryPage();
                    },
                  ),
                );

                if (selectedDevice != null) {
                  // print('Discovery -> selected ' + selectedDevice.address);
                } else {
                  // print('Discovery -> no device selected');
                }
              },
              child: Text(
                "Discover",
                style: TextStyle(color: Colors.white),
              ),
            ):Container(),
          ],*/
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
//          new Padding(
//              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
//              child: new Theme(
//                  data: new ThemeData(
//                    primaryColor: Colors.black,
//                    primaryColorDark: Colors.black,
//                  ),
//                  child: TextFormField(
//                   // controller: myEmailController,
//                    autocorrect: false,
//                    textInputAction: TextInputAction.next,
//
//                   // validator: ValidationUtils.usernameValidation,
////                    onSaved: (String val) {
////                      _email = val;
////                    },
//                    obscureText: false,
//                    keyboardType: TextInputType.emailAddress,
//                   // style: style,
//                    decoration: InputDecoration(
//                        hintText: "Enter Device Name",
//                        hintStyle: Utils.hintStyleBlack,
//                        contentPadding:
//                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                        fillColor: Colors.transparent,
//                        filled: true,
//                        border: OutlineInputBorder(
//                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                            borderSide: BorderSide(color: Colors.black)),
//                       // enabledBorder: true
//                    ),
//                  ))),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: Text(
                        "Enable c19 pro",
                        style: TextStyle(
                            fontFamily: "Monteserrat",
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Switch(
                      value: AppPreferences().isUserEligibleForBluetooth,
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // Do the request and update with the true value then
                        future() async {
                          // async lambda seems to not working
                          AppPreferences.setUserEligibleForBluetooth(value);
                          //AppPreferences().isUserEligibleForBluetooth;
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    ),
                  ]),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
                child: Text(
                  "*Note : Ensure above switch is turned on to use thermometer.",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[500],
                      fontFamily: "Monteserrat",
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: Text(
                        "Enable Bluetooth",
                        style: TextStyle(
                            fontFamily: "Monteserrat",
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // Do the request and update with the true value then
                        future() async {
                          // async lambda seems to not working
                          if (value)
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                            showSelectedDevice = false;
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    ),
                  ]),
            ),

//            _bluetoothState.isEnabled
//                ? Container(
//                    width: 200.0,
//                    child: RaisedButton(
//                      color: Colors.indigo[700],
//                      onPressed: () async {
//                        final BluetoothDevice selectedDevice =
//                            await Navigator.of(context).push(
//                          MaterialPageRoute(
//                            builder: (context) {
//                              return DiscoveryPage();
//                            },
//                          ),
//                        );
//
//                        if (selectedDevice != null) {
//                          // print('Discovery -> selected ' +
//                              selectedDevice.address);
//                        } else {
//                          // print('Discovery -> no device selected');
//                        }
//                      },
//                      child: Text(
//                        "Discover Devices",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  )
//                : Container(),

            SizedBox(
              height: 10,
            ),

            _bluetoothState.isEnabled
                ? Container(
              width: 200.0,
              child: RaisedButton(
                color: Colors.indigo[700],
                child: const Text(
                  'Connect to paired device',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final BluetoothDevice selectedDevice =
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(
                            checkAvailability: false);
                      },
                    ),
                  );

                  if (selectedDevice != null) {
                    setState(() {
                      showSelectedDevice = true;
                      selectedConnectedDevice = selectedDevice;
                      AppPreferences().setSelectedConnectedDevice(selectedDevice);
                    });

                    // print(
                        // 'Connect -> selected ' + selectedDevice.address);
                    //  _startChat(context, selectedDevice);
                  } else {
                    // print('Connect -> no device selected');
                  }
                },
              ),
            )
                : Container(),

            showSelectedDevice
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            child: Text("Device Name - "),
                          ),
                          Container(
                            width: 200.0,
                            child: Text("${selectedConnectedDevice.name}"),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            child: Text("Mac address - "),
                          ),
                          Container(
                            width: 200.0,
                            child: Text("${selectedConnectedDevice.address}"),
                          )
                        ],
                      ),
                    ],
                  )),
            )
                : Container(),
//            showSelectedDevice
//                ?ListTile(
//                    leading: Icon(Icons
//                        .devices), // @TODO . !BluetoothClass! class aware icon
//                    title:
//                        Text(selectedConnectedDevice.name ?? "Unknown device"),
//                    subtitle: Text(selectedConnectedDevice.address.toString()),
//                    trailing:
//                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                      selectedConnectedDevice.isConnected
//                          ? Icon(Icons.import_export)
//                          : Container(width: 0, height: 0),
//                      selectedConnectedDevice.isBonded
//                          ? Icon(Icons.link)
//                          : Container(width: 0, height: 0),
//                    ]),
//                  )
//                : Container(),

            showSelectedDevice
                ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: Text(
                        "Connection Status",
                        style: TextStyle(
                            fontFamily: "Monteserrat",
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Switch(
                      value: isStatusEnabled,
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      onChanged: (value) async {
                        setState(() {
                          isStatusEnabled = value;
                        });

                        if(value){
                          //Connect
                          // print("Connect Now");
                          _startBackgroundTask(context, selectedConnectedDevice);
                        }else{
                          // print("Disconnect Now");
                          BackgroundCollectingTaskBloc().cancel();
                          //_bloc.pause();
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<DataSample>(
                        stream: BackgroundCollectingTaskBloc().sampleDataSubject,
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.active && snapshot.hasData){
                            temperature = snapshot.data.tempData + " \u2109";
                            return new Text(temperature);
                          } else if(snapshot.hasError){
                            temperature = snapshot.error.toString();
                            return new Text(temperature);
                          }else{
                            return new Text(temperature);
                          }
                        }
                    ),
                  ]),
            )
                : Container(),
//            showSelectedDevice ? RaisedButton(
//              color: Colors.indigo[700],
//              onPressed: () {},
//              child: Text(
//                "Submit",
//                style: TextStyle(color: Colors.white),
//              ),
//            ):Container()
          ],
        ));
  }

  Future<void> _startBackgroundTask(
      BuildContext context,
      BluetoothDevice server,
      ) async {
    try {
      var s = await BackgroundCollectingTaskBloc().connect(server);
      if(s == null){
        setState(() {
          if(!BackgroundCollectingTaskBloc().getConnectionStatus()){
            isStatusEnabled = false;
          }
        });
      }
    } catch (ex) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
