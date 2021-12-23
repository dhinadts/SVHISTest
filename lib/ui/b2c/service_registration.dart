import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';

class ServiceRegistrationScreen extends StatefulWidget {
  ServiceRegistrationScreen({Key key}) : super(key: key);

  @override
  _ServiceRegistrationScreenState createState() =>
      _ServiceRegistrationScreenState();
}

class _ServiceRegistrationScreenState extends State<ServiceRegistrationScreen> {
  bool switchVal = true;
  TextEditingController expInYear = new TextEditingController();
  List offeredService = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    offeredService = ["One", "Two", "Three"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: AppColors.primaryColor,
        title:
            Text("Service Registration", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Are you interested in Home Care",
                          maxLines: 2,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      // Expanded(child: SizedBox()),
                      Expanded(
                        flex: 1,
                        child: Switch(
                          onChanged: (val) {
                            setState(() {
                              switchVal = val;
                            });
                          },
                          value: switchVal,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Previous Experience in Home Care (in years)",
                          maxLines: 2,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: new TextFormField(
                            controller: expInYear,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Types of Services offered",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18),
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    padding: EdgeInsets.only(left: 5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 15,
                        itemBuilder: (context, i) {
                          return Row(
                            children: [
                              Checkbox(value: true, onChanged: null),
                              Text(
                                "$i",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                      color: AppColors.primaryColor,
                      onPressed: () {},
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ))
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
