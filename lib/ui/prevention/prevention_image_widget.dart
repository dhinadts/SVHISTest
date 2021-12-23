import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';

class PreventionImageWidget extends StatefulWidget {
  final String pageTitle;

  PreventionImageWidget({Key key, @required this.pageTitle}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreventionImageWidgetState();
}

class _PreventionImageWidgetState extends State<PreventionImageWidget> {
  @override
  void initState() {
    super.initState();

    /// Initialize Admob
    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = "assets/images/healthy_tips.png";
    if (widget.pageTitle == "Type 2 Diabetes") {
      imagePath = "assets/images/diabetes_2.png";
    } else if (widget.pageTitle == "Type 1 Diabetes") {
      imagePath = "assets/images/diabetes_1.png";
    }
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.pageTitle, pageId: Constants.PAGE_ID_PREVENTION),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.blue,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.fitWidth,
                  )),
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
      // Image.asset("prevention/Diabetes_1.png"),
    );
  }
}
