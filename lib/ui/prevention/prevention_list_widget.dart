import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui/prevention/prevention_image_widget.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';

class PreventionListWidget extends StatefulWidget {
  final String title;
  const PreventionListWidget({Key key, this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PreventionListWidgetState();
}

class _PreventionListWidgetState extends State<PreventionListWidget>  {
  List<String> preventionList = [
    "Type 1 Diabetes",
    "Type 2 Diabetes",
    "Health Tips"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.title,
          // title: widget.title,
          pageId: Constants.PAGE_ID_PREVENTION),
      body: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: preventionList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                InkWell(
                  child: Card(
                    color: Colors.green,
                    margin: EdgeInsets.all(20),
                    elevation: 18.0,
                    // shape: CircleBorder(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 44,
                      child: Center(
                          child: Text(
                        preventionList[index],
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PreventionImageWidget(
                                  pageTitle: preventionList[index],
                                )));
                  },
                ),
              ],
            );
          }),
    );
  }
}
