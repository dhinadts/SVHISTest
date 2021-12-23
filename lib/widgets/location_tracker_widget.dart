import 'dart:async';
import 'dart:convert';

import '../bloc/geo_bloc.dart';
import '../bloc/user_info_bloc.dart';
import '../country_picker_util/country_code_picker.dart';
import '../login/colors/color_info.dart';
import '../model/contact.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/location_utils.dart';
import '../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationTrackerWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController zipCodeController;

  final TextEditingController addressController;
  final TextEditingController addressController2;

  final TextEditingController stateController;
  final TextEditingController cityController;

  final TextEditingController countryController;
  final ValueChanged<bool> onChangeHome;
  final ValueChanged<String> onLatLongInfo;
  final UserInfoBloc bloc;
  final bool isEnabledGPS;
  final bool mandatory;
  final bool isFieldEnabled;
  LocationTrackerWidget(
      {Key key,
      this.title,
      this.formKey,
      this.addressController,
      this.addressController2,
      this.stateController,
      this.cityController,
      this.countryController,
      this.zipCodeController,
      this.bloc,
      this.onLatLongInfo,
      this.isEnabledGPS: true,
      this.mandatory: true,
      this.onChangeHome,
      this.isFieldEnabled})
      : super(key: key);
  final String title;

  @override
  _LocationTrackerWidgetState createState() =>
      new _LocationTrackerWidgetState();
}

class _LocationTrackerWidgetState extends State<LocationTrackerWidget> {
  Completer<GoogleMapController> _controller = Completer();
  static double lat;
  static double long;
  bool initCall = false;
  String initCountry = "IN";

  TextStyle style = TextStyle(
      fontFamily: Constants.LatoRegular,
      fontSize: 15.0,
      color: Color(ColorInfo.BLACK));

  /*var zipCodeController = TextEditingController();
  var addressController = TextEditingController();
  var stateController = TextEditingController();
  var cityController = TextEditingController();
  var countryController = TextEditingController();*/
  Map<String, dynamic> countryList = Map();
  String country;
  Contact newContact = new Contact();
  var enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));
  GeoBloc _bloc;

  Future<void> getCountryList() async {
    String articleJsonStr =
        await rootBundle.loadString('assets/api/country.json');
    countryList = jsonDecode(articleJsonStr);
  }

  @override
  void initState() {
    super.initState();
    getCountryList();
    if (widget.isEnabledGPS) {
      locationRequest();
    } else if (widget.bloc != null) {
      widget.bloc.countryCodeFetcher.listen((value) {
        setState(() {
          initCall = true;
          initCountry = value;
        });
      });
    }
  }

  TextStyle countryStyle = TextStyle(
    fontFamily: Constants.LatoRegular,
    color: Colors.black38,
    fontSize: 15.0,
  );

  _builderMethod(code) {
    if (initCall) {
      widget.countryController.text = code.name;
    }
    return Padding(
        padding: EdgeInsets.symmetric(/*vertical: 10,*/ horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Expanded(
              child: Text(
                  !initCall
                      ? AppLocalizations.of(context).translate("key_contry")
                      : code.name,
                  style: !initCall ? countryStyle : style)),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {},
          )
        ]));
  }

  locationRequest() async {
    LocationData _locationData;
    Location location = await LocationUtils.getLocationObject();
    if (location != null) {
      _locationData = await location.getLocation();
      // print(
      // "Location data ${_locationData.latitude} , ${_locationData.longitude}");
      setState(() {
        lat = _locationData.latitude;
        long = _locationData.longitude;
      });

      _bloc = new GeoBloc(context);
      _bloc.fetchAddress(lat, long);
      await AppPreferences.setLatLang("$lat,$long");
      widget.onLatLongInfo("$lat,$long");
      _bloc.geoFetcher.listen((value) async {
        if (value?.status != "false") {
          String address = "";
          if (value.stnumber.replaceAll("{}", "").isNotEmpty) {
            address = "${value.stnumber.replaceAll("{}", "")}, ";
          }
          address = address + value.staddress.replaceAll("{}", "");
          widget.addressController.text = address;
          widget.cityController.text = value.city;
          widget.stateController.text = value.state;
          //widget.countryController.text = value.prov;
          setState(() {
            country = countryList[value.prov];
            initCall = true;
            initCountry = value.prov;
            widget.bloc.countryCodeFetcher.sink.add(initCountry);
            //widget.onChangeCountry(initCountry);
          });
          widget.countryController.text = countryList[value.prov];
          await AppPreferences.setCountry(value.prov);
          if (value.region != null) {
            var region = value.region.split(",");
            if (region.length > 1) {
              widget.cityController.text = region[0];
              widget.stateController.text = region[1];
            }
            widget.zipCodeController.text = value.postal.replaceAll("{}", "");
          }
        } else {
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context).translate("key_unable_to_load"),
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              gravity: ToastGravity.TOP);
        }
      });
    }
  }

  bool isHome = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: TextFormField(
          enabled: widget.isFieldEnabled,
          controller: widget.addressController,
          decoration: WidgetStyles.decoration(
              AppLocalizations.of(context).translate("key_address1")),
          keyboardType: TextInputType.text,
          validator: widget.mandatory ? ValidationUtils.streetValidation : null,
          style: style,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        child: TextFormField(
          enabled: widget.isFieldEnabled,

          controller: widget.addressController2,
          decoration: WidgetStyles.decoration(
              AppLocalizations.of(context).translate("key_address2")),
          keyboardType: TextInputType.text,
          // validator: widget.mandatory ? ValidationUtils.streetValidation : null,
          style: style,
        ),
      ),
      Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: TextFormField(
                    enabled: widget.isFieldEnabled,
                    style: style,
                    controller: widget.cityController,
                    decoration: WidgetStyles.decoration(
                        AppLocalizations.of(context).translate("key_city")),
                    keyboardType: TextInputType.text,
                    validator: widget.mandatory
                        ? ValidationUtils.cityValidation
                        : null,
                    onSaved: (String val) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Expanded(
                child: Container(
                  child: TextFormField(
                    enabled: widget.isFieldEnabled,
                    style: style,
                    decoration: WidgetStyles.decoration(
                        AppLocalizations.of(context).translate("key_state")),
                    controller: widget.stateController,
                    keyboardType: TextInputType.text,
                    validator: widget.mandatory
                        ? ValidationUtils.stateValidation
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          /* Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[*/

          Container(
              child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                child: TextFormField(
                  enabled: widget.isFieldEnabled,
                  readOnly: false,
                  style: style,
                  decoration: WidgetStyles.decoration(
                      AppLocalizations.of(context).translate("key_country")),
                  initialValue: " ",
                  keyboardType: TextInputType.text,
                  validator: widget.mandatory
                      ? (String value) {
                          if (!initCall)
                            return AppLocalizations.of(context)
                                .translate("key_selectCountry");
                          else
                            return null;
                        }
                      : null,
                ),
              ),
              CountryCodePicker(
                enabled: widget.isFieldEnabled,

                onChanged: _onChanged,
                initialSelection: initCountry,
//                  onLoadShow: showOnload,
                showFlag: false,
                showCountryOnly: true,
                showFlagMain: true,
                showFlagDialog: true,
                builder: _builderMethod,
                //comparator: (a, b) => a.name.compareTo(b.name),
                onInit: (code) =>
                    print("${code.name} ${code.dialCode} ${code.code}"),
              ),
            ],
          )),
          /*],
          ),*/
          Row(
            children: <Widget>[
              SizedBox(
                width: 0,
              ),
//                Spacer(),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  enabled: widget.isFieldEnabled,
                  style: style,
                  controller: widget.zipCodeController,
                  maxLength: 6,
                  validator: widget.mandatory
                      ? (String value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate("key_pincode_empty");
                          } else if (value.length < 6)
                            return AppLocalizations.of(context)
                                .translate("key_pincodeerror");
                          else
                            return null;
                        }
                      : (String value) {
                          if (value.isNotEmpty && value.length < 6) {
                            return AppLocalizations.of(context)
                                .translate("key_pincodeerror");
                          } else
                            return null;
                        },
                  decoration: WidgetStyles.decoration(
                      AppLocalizations.of(context).translate("key_zip")),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          if (lat != null && long != null && widget.isEnabledGPS)
            Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: isHome,
                    activeColor: Color(ColorInfo.APP_BLUE),
                    onChanged: (isClicked) {
                      setState(() {
                        isHome = isClicked;
                        widget.onChangeHome(isHome);
                      });
                    },
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("key_homelocation"),
                    style: TextStyle(
                        fontSize: 14.0, color: Color(ColorInfo.DARK_GRAY)),
                  ),
                ]),
          SizedBox(
            width: 10,
          ),
          if (lat != null && long != null && widget.isEnabledGPS)
            Stack(
              children: <Widget>[
                _mapContainer(context),
              ],
            ),
//          )
        ],
      )
    ]);
  }

  Widget _mapContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.blueAccent, width: 3)),
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width * 1,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, long), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: MarkerId('gramercy'),
            position: LatLng(lat, long),
            infoWindow: InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
          )
        },
      ),
    );
  }

  _onChanged(CountryCode code) async {
    setState(() {
      initCall = true;
      AppPreferences().setterCountry = code.code;
      // if (widget.bloc != null)
      //   widget.bloc.countryCodeFetcher.sink.add(code.code);
    });
    await AppPreferences.setCountry(code.code);
  }
}
