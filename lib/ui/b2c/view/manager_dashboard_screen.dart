import '../../../ui/b2c/bloc/reports_bloc.dart';
import '../../../ui/b2c/model/providersAndSuppliersActiveStatus_model.dart';
import '../../../ui/b2c/model/requestCompleteVsIncomplete_model.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../utils/alert_utils.dart';
import '../../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../model/countrywiseHealthcareProviders_model.dart';

class ManagerDashboardScreen extends StatefulWidget {
  @override
  _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  List<CountrywiseHealthcareProvidersModel> countrywiseProvidersList =
      new List();
  ProvidersAndSuppliersActiveStatusModel providersAndSuppliersActiveStatusData =
      new ProvidersAndSuppliersActiveStatusModel();
  RequestCompleteVsIncompleteModel requestCompleteVsIncompleteData =
      new RequestCompleteVsIncompleteModel();

  bool _isCountrywiseProvidersLoading = false;
  bool _isProvidersSuppliersStatusLoading = false;
  bool _isRequestCompleteIncompleteLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isCountrywiseProvidersLoading = true;
      _isProvidersSuppliersStatusLoading = true;
      _isRequestCompleteIncompleteLoading = true;
      // CustomProgressLoader.showLoader(context);
    });
    // ReportsBloc reportsBloc = ReportsBloc(context);
    getCountrywiseHealthcareProvidersList(
        reportType: "g1", dateFilter: "Today", userGroup: "Nmb2b");

    //ReportsBloc reportsBloc = ReportsBloc(context);
    getProvidersAndSuppliersActiveStatusList(
        reportType: "g2", dateFilter: "Today", userGroup: "Nmb2b");

    getRequestCompleteVsIncompleteList(
        reportType: "g3", dateFilter: "Today", userGroup: "Nmb2b");

    super.initState();
  }

  getCountrywiseHealthcareProvidersList(
      {String reportType, String dateFilter, String userGroup}) {
//    setState(() {
//      // CustomProgressLoader.cancelLoader(context);
//      _isCountrywiseProvidersLoading = true;
//    });
    ReportsBloc reportsBloc = ReportsBloc(context);
    countrywiseProvidersList = new List();
    reportsBloc.fetchCountrywiseHealthcareProvidersList(
      reportType: reportType,
      dateFilter: dateFilter,
      userGroup: userGroup,
      //userGroup: "Nmb2b",
    );
    reportsBloc.countrywiseHealthcareProvidersListFetcher.listen((value) async {
      value.forEach((element) {
        countrywiseProvidersList.add(element);
      });
      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isCountrywiseProvidersLoading = false;
      });
    });
  }

  getProvidersAndSuppliersActiveStatusList(
      {String reportType, String dateFilter, String userGroup}) {
    ReportsBloc reportsBloc = ReportsBloc(context);
    reportsBloc.fetchProvidersAndSuppliersActiveStatusList(
      reportType: reportType,
      dateFilter: dateFilter,
      userGroup: userGroup,
      //userGroup: "Nmb2b",
    );
    reportsBloc.healthcareProvidersAndSuppliersActiveStatusListFetcher
        .listen((value) async {
      print("Value of Active Status ${value.activeProvider}");
      providersAndSuppliersActiveStatusData = value;
      print(
          "Value of providersAndSuppliersActiveStatusData Status ${providersAndSuppliersActiveStatusData.activeProvider}");

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isProvidersSuppliersStatusLoading = false;
      });
    });
  }

  getRequestCompleteVsIncompleteList(
      {String reportType, String dateFilter, String userGroup}) {
//    setState(() {
//      // CustomProgressLoader.cancelLoader(context);
//      _isRequestCompleteIncompleteLoading = true;
//    });
    requestCompleteVsIncompleteData = new RequestCompleteVsIncompleteModel();
    ReportsBloc reportsBloc = ReportsBloc(context);
    reportsBloc.fetchRequestCompleteVsIncompleteList(
      reportType: reportType,
      dateFilter: dateFilter,
      userGroup: userGroup,
      //userGroup: "Nmb2b",
    );
    reportsBloc.requestCompleteVsIncompleteListFetcher.listen((value) async {
      print("Value of Active Status ${value.complete}");
      requestCompleteVsIncompleteData = value;
      print(
          "Value of requestCompleteVsIncompleteData Status ${requestCompleteVsIncompleteData.complete}");

      setState(() {
        // CustomProgressLoader.cancelLoader(context);
        _isRequestCompleteIncompleteLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: _isCountrywiseProvidersLoading == false &&
              _isProvidersSuppliersStatusLoading == false &&
              _isRequestCompleteIncompleteLoading == false
          ? Container(
              color: Color(0xffE5E5E5),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: countryWiseHealthCareProvider(
                          "Countywise Healthcare Providers"),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: providersAndSuppliersActiveStatusGraph(
                          "Healthcare Providers And Suppliers Active Status"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: requestCompleteVsIncompleteGraph(
                          "Request Complete Vs In Complete"),
                    ),
                    SizedBox(
                      height: 20.0,
                    )
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: myCircularItems(
//                      "Healthcare Providers and Suppliers Active Status"),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: myBarItems(
//                      "Healthcare Providers and Suppliers Active Status"),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: myDonutItems(
//                      "Healthcare Providers and Suppliers Active Status"),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: myTextItems("Mktg. Spend", "48.6M"),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: myTextItems("Users", "25.5M"),
//                ),
                  ],
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 60,
                    width: 60,
                    //color: Colors.white,
                    child: SpinKitFoldingCube(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? AppColors.primaryColor
                                : AppColors.offWhite,
                            // : AppColors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _drawer() {
    return SizedBox(
      width: 250.0,
      child: new Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildUserAccountsDrawerHeader(),
            ListTile(
              onTap: () {
                AlertUtils.logoutAlert(context, "");
              },
              //onTap: _signOutDialog,

              // onTap: callback,
              //*//*Navigator.of(context).push(CupertinoPageRoute(
              //builder: (BuildContext context) => LogOut()));*//*

              leading: SizedBox(
                  height: 30.0,
                  width: 30.0, // fixed width and height
                  child: Image.asset("assets/images/logout.png")),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserAccountsDrawerHeader() {
    return Container(
        width: 250.0,
        color: AppColors.primaryColor,
        padding: EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/user.png'),
                backgroundColor: Colors.white,
                child: Text(
                  "",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              //Text(AppPreferences().firstName,
              Text(AppPreferences().fullName,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 5),
              Text(AppPreferences().email,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ]));
  }

  List<charts.Series<CountrywiseHealthcareProvidersModel, String>>
      countrywiseHealthcareProvidersList() {
    return [
      new charts.Series<CountrywiseHealthcareProvidersModel, String>(
        id: 'countrywiseHealthcareProviders',
        domainFn:
            (CountrywiseHealthcareProvidersModel countrywiseHealthcareProviders,
                    _) =>
                countrywiseHealthcareProviders.name,
        measureFn:
            (CountrywiseHealthcareProvidersModel countrywiseHealthcareProviders,
                    _) =>
                countrywiseHealthcareProviders.value,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.cyan[600]),
//        labelAccessorFn: (CountrywiseHealthcareProvidersModel countrywiseHealthcareProviders, _) =>
//        '${countrywiseHealthcareProviders.value}',
//        insideLabelStyleAccessorFn: (CountrywiseHealthcareProvidersModel countrywiseHealthcareProviders, _) {
//          return new charts.TextStyleSpec(color: charts.MaterialPalette.red.shadeDefault);
//        },
        labelAccessorFn:
            (CountrywiseHealthcareProvidersModel countrywiseHealthcareProviders,
                    _) =>
                '${countrywiseHealthcareProviders.value.toString()}',
        data: countrywiseProvidersList,

        // Set a label accessor to control the text of the arc label.
//        labelAccessorFn: (CountrywiseHealthcareProvidersModel row, _) =>
//        '${row.name}: ${row.value}',
      )
    ];
  }

  List<charts.Series<LinearData, String>> _createPieChartData() {
    final data = [
      LinearData(
          "Active Providers",
          providersAndSuppliersActiveStatusData.activeProvider,
          charts.ColorUtil.fromDartColor(Colors.red[700])),
      LinearData(
          "Not Active Providers",
          providersAndSuppliersActiveStatusData.notActiveProvider,
          charts.ColorUtil.fromDartColor(Colors.red[300])),
      LinearData(
          "Not Active Suppliers",
          providersAndSuppliersActiveStatusData.notActiveSupplier,
          charts.ColorUtil.fromDartColor(Colors.blue[300])),
      LinearData(
          "Active Suppliers",
          providersAndSuppliersActiveStatusData.activeSupplier,
          charts.ColorUtil.fromDartColor(Colors.blue[700])),
    ];

    return [
      new charts.Series<LinearData, String>(
        id: 'SupliersOrProviders',
        domainFn: (LinearData supliersOrProviders, _) =>
            supliersOrProviders.name,
        measureFn: (LinearData supliersOrProviders, _) =>
            supliersOrProviders.value,
        colorFn: (LinearData supliersOrProviders, _) =>
            supliersOrProviders.color,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearData row, _) => '${row.name}: ${row.value}',
      )
    ];
  }

  List<charts.Series<LinearData, String>> _createDonutPieChartData() {
    final data = [
      LinearData("Completed", requestCompleteVsIncompleteData.complete,
          charts.ColorUtil.fromDartColor(Colors.cyan[700])),
      LinearData("Incompleted", requestCompleteVsIncompleteData.incomplete,
          charts.ColorUtil.fromDartColor(Colors.purple[400])),
      //LinearData("Incomplete", 5,charts.MaterialPalette.purple.shadeDefault.lighter),
    ];

    return [
      new charts.Series<LinearData, String>(
        id: 'SupliersOrProviders',
        domainFn: (LinearData supliersOrProviders, _) =>
            supliersOrProviders.name,
        measureFn: (LinearData supliersOrProviders, _) =>
            supliersOrProviders.value,
        colorFn: (LinearData supliersOrProviders, _) =>
            supliersOrProviders.color,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearData row, _) => '${row.name}: ${row.value}',
      )
    ];
  }

  Material countryWiseHealthCareProvider(String title) {
    return Material(
      color: Colors.white,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .95,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .55,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: _normalDown("countryWiseHealthCareProvider"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200.0,
              width: 800.0,
              child: countrywiseProvidersList.length > 0
                  ? barLabeledChart(countrywiseHealthcareProvidersList(), true)
                  : Center(
                      child: Text(
                      "No data found",
                      style: TextStyle(color: Colors.grey[700]),
                    )),
            ),
          ),
        ],
      ),
    );
  }

  Material providersAndSuppliersActiveStatusGraph(String title) {
    return Material(
      color: Colors.white,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .95,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .55,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: providerSuppliersStatusDropdown(
                        "countryWiseHealthCareProvider"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: SizedBox(
              height: 200.0,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: providersAndSuppliersActiveStatusData
                                .notActiveProvider ==
                            0 &&
                        providersAndSuppliersActiveStatusData.activeProvider ==
                            0 &&
                        providersAndSuppliersActiveStatusData.activeSupplier ==
                            0 &&
                        providersAndSuppliersActiveStatusData
                                .notActiveSupplier ==
                            0
                    ? Center(
                        child: Text(
                        "No data found",
                        style: TextStyle(color: Colors.grey[700]),
                      ))
                    : circularLabeledPieChart(_createPieChartData(), true),
              ),
            ),
          ),
          providersAndSuppliersActiveStatusData.notActiveProvider == 0 &&
                  providersAndSuppliersActiveStatusData.activeProvider == 0 &&
                  providersAndSuppliersActiveStatusData.activeSupplier == 0 &&
                  providersAndSuppliersActiveStatusData.notActiveSupplier == 0
              ? Center(
                  child: Text(
                  "",
                  style: TextStyle(color: Colors.grey[700]),
                ))
              : Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.blue[700],
                                  //Color(charts.MaterialPalette.cyan.shadeDefault.darker),
                                  width: 15.0,
                                  height: 15.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Active Suppliers"),
                                Text(
                                    "-${providersAndSuppliersActiveStatusData.activeSupplier}")
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.blue[300],
                                  //Color(charts.MaterialPalette.cyan.shadeDefault.darker),
                                  width: 15.0,
                                  height: 15.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Not Active Suppliers"),
                                Text(
                                    "-${providersAndSuppliersActiveStatusData.notActiveSupplier}")
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.red[700],
                                  //Color(charts.MaterialPalette.cyan.shadeDefault.darker),
                                  width: 15.0,
                                  height: 15.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Active Providers"),
                                Text(
                                    "-${providersAndSuppliersActiveStatusData.activeProvider}")
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.red[300],
                                  //Color(charts.MaterialPalette.cyan.shadeDefault.darker),
                                  width: 15.0,
                                  height: 15.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Not Active Providers"),
                                Text(
                                    "-${providersAndSuppliersActiveStatusData.notActiveProvider}")
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Material requestCompleteVsIncompleteGraph(String title) {
    return Material(
      color: Colors.white,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .95,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .55,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: requestCompleteIncompleteDropdown(
                        "countryWiseHealthCareProvider"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200.0,
              width: 800.0,
              child: requestCompleteVsIncompleteData != null &&
                      requestCompleteVsIncompleteData?.complete == 0 &&
                      requestCompleteVsIncompleteData?.incomplete == 0
                  ? Center(
                      child: Text(
                      "No data found",
                      style: TextStyle(color: Colors.grey[700]),
                    ))
                  : donutLabeledPieChart(_createDonutPieChartData(), true),
            ),
          ),
          requestCompleteVsIncompleteData != null &&
                  requestCompleteVsIncompleteData?.complete == 0 &&
                  requestCompleteVsIncompleteData?.incomplete == 0
              ? Center(child: Text(""))
              : Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              color: Colors.cyan[700],
                              //Color(charts.MaterialPalette.cyan.shadeDefault.darker),
                              width: 15.0,
                              height: 15.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text("Completed"),
                            Text("-${requestCompleteVsIncompleteData.complete}")
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              color: Colors.purple[400],
                              //Color(charts.MaterialPalette.cyan.shadeDefault.darker),
                              width: 15.0,
                              height: 15.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text("Incompleted"),
                            Text(
                                "-${requestCompleteVsIncompleteData.incomplete}")
                          ],
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  String _value;
  DropdownButton _normalDown(String graphName) {
    //if(graphName == "countryWiseHealthCareProvider")

    return DropdownButton<String>(
      items: [
        DropdownMenuItem(
          value: "Today",
          child: Text(
            "Today",
          ),
        ),
        DropdownMenuItem(
          value: "Yesterday",
          child: Text(
            "Yesterday",
          ),
        ),
        DropdownMenuItem(
          value: "Last 7 Days",
          child: Text(
            "Last 7 Days",
          ),
        ),
        DropdownMenuItem(
          value: "Last 30 Days",
          child: Text(
            "Last 30 Days",
          ),
        ),
        DropdownMenuItem(
          value: "This Month",
          child: Text(
            "This Month",
          ),
        ),
        DropdownMenuItem(
          value: "Last Month",
          child: Text(
            "Last Month",
          ),
        ),
      ],
      hint: Text("Today"),
      onChanged: (value) {
        setState(() {
          print("Value selected $value");
          _value = value;
          getCountrywiseHealthcareProvidersList(
              userGroup: "Nmb2b", dateFilter: value, reportType: "g1");
          print("_value selected $_value");
        });
      },
      value: _value,
    );
  }

  String _value1;
  DropdownButton providerSuppliersStatusDropdown(String graphName) {
    //if(graphName == "countryWiseHealthCareProvider")

    return DropdownButton<String>(
      items: [
        DropdownMenuItem(
          value: "Today",
          child: Text(
            "Today",
          ),
        ),
        DropdownMenuItem(
          value: "Yesterday",
          child: Text(
            "Yesterday",
          ),
        ),
        DropdownMenuItem(
          value: "Last 7 Days",
          child: Text(
            "Last 7 Days",
          ),
        ),
        DropdownMenuItem(
          value: "Last 30 Days",
          child: Text(
            "Last 30 Days",
          ),
        ),
        DropdownMenuItem(
          value: "This Month",
          child: Text(
            "This Month",
          ),
        ),
        DropdownMenuItem(
          value: "Last Month",
          child: Text(
            "Last Month",
          ),
        ),
      ],
      hint: Text("Today"),
      onChanged: (value) {
        setState(() {
          print("Value selected $value");
          _value1 = value;

          getProvidersAndSuppliersActiveStatusList(
              userGroup: "Nmb2b", dateFilter: value, reportType: "g2");
          // print("_value selected $_value");
        });
      },
      value: _value1,
    );
  }

  String _value2;
  DropdownButton requestCompleteIncompleteDropdown(String graphName) {
    //if(graphName == "countryWiseHealthCareProvider")

    return DropdownButton<String>(
      items: [
        DropdownMenuItem(
          value: "Today",
          child: Text(
            "Today",
          ),
        ),
        DropdownMenuItem(
          value: "Yesterday",
          child: Text(
            "Yesterday",
          ),
        ),
        DropdownMenuItem(
          value: "Last 7 Days",
          child: Text(
            "Last 7 Days",
          ),
        ),
        DropdownMenuItem(
          value: "Last 30 Days",
          child: Text(
            "Last 30 Days",
          ),
        ),
        DropdownMenuItem(
          value: "This Month",
          child: Text(
            "This Month",
          ),
        ),
        DropdownMenuItem(
          value: "Last Month",
          child: Text(
            "Last Month",
          ),
        ),
      ],
      hint: Text("Today"),
      onChanged: (value) {
        setState(() {
          print("Value selected $value");
          _value2 = value;

          getRequestCompleteVsIncompleteList(
              userGroup: "Nmb2b", dateFilter: value, reportType: "g3");
          // print("_value selected $_value");
        });
      },
      value: _value2,
    );
  }

  Widget barLabeledChart(
      List<charts.Series<CountrywiseHealthcareProvidersModel, String>>
          countrywiseHealthcareProvidersList,
      bool animate) {
    return new charts.BarChart(
      countrywiseHealthcareProvidersList,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }

  Widget circularLabeledPieChart(
      List<charts.Series<LinearData, String>> _createPieChartData,
      bool animate) {
    return charts.PieChart(
      _createPieChartData,
      animate: animate,
//        behaviors: [
//          new charts.SeriesLegend(position: charts.BehaviorPosition.bottom),
//        ],

      defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.auto,
            outsideLabelStyleSpec: new charts.TextStyleSpec(
              fontSize: 14,
            ),
          ),
        ],
      ),
//      behaviors: [
//        new charts.DatumLegend(
//            position: charts.BehaviorPosition.end, desiredMaxRows: 2)
//      ],
    );
  }

  Widget donutLabeledPieChart(
      List<charts.Series<LinearData, String>> _createDonutPieChartData,
      bool animate) {
    return charts.PieChart(
      _createDonutPieChartData,
      animate: animate,
      // Configure the width of the pie slices to 60px. The remaining space in
      // the chart will be left as a hole in the center.
      defaultRenderer:
          new charts.ArcRendererConfig(arcWidth: 20, arcRendererDecorators: [
        new charts.ArcLabelDecorator(
          labelPosition: charts.ArcLabelPosition.outside,
          outsideLabelStyleSpec: new charts.TextStyleSpec(
            fontSize: 14,
          ),
        ),
      ]),
    );
  }
}

class LinearData {
  final String name;

  final int value;
  final charts.Color color;

  LinearData(
    this.name,
    this.value,
    this.color,
  );
}
