import '../../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui_utils/app_colors.dart';
import 'package:http/http.dart' as http;
import '../../repo/common_repository.dart';
import '../../utils/app_preferences.dart';
import 'dart:convert';
import 'models/campaign_feedback_model.dart';
import 'campaign_feedback_inapp_webview.dart';
import 'package:intl/intl.dart';

class CampaignFeedbackList extends StatefulWidget {
  @override
  _CampaignFeedbackListState createState() => _CampaignFeedbackListState();
}

class _CampaignFeedbackListState extends State<CampaignFeedbackList> {
  Future<List<FeedbackList>> feedbackListFuture;
  List<FeedbackList> feedbackList = [];
  final DateFormat formatter = DateFormat(AppPreferences().defaultDateFormat);
  // final String formatted = formatter.format(_date);
  @override
  initState() {
    feedbackListFuture = getFeedbackList();
    super.initState();
  }

  Future<List<FeedbackList>> getFeedbackList() async {
    var response = await http.get(WebserviceConstants.baseFilingURL +
        '/formInfoPromoList/{departmentName}?departmentName=${AppPreferences().deptmentName}');
    List<dynamic> data = json.decode(response.body) as List<dynamic>;
    setState(() {
      for (var i = 0; i < data.length; i++) {
        feedbackList.add(FeedbackList.fromJson(data[i]));
      }
    });
    return feedbackList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          pageId: null,
          title: "Campaign Feedback List",
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 25.0, left: 8, right: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                campaignTitleText(),
                StreamBuilder(
                    stream: feedbackListFuture.asStream(),
                    builder: (context, AsyncSnapshot<List<FeedbackList>> snp) {
                      if (snp.connectionState == ConnectionState.done) {
                        print(snp.data.length);
                        return snp.data.length != 0
                            ? Column(children: feedbackListItem(snp.data))
                            : Center(
                                child: Text("No Data Avaliable"),
                              );
                      } else if (snp.connectionState ==
                          ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: Center(
                              child: Column(
                            children: [
                              Center(child: CircularProgressIndicator()),
                            ],
                          )),
                        );
                      } else if (snp.hasError) {
                        return Container();
                      } else {
                        return Container();
                      }
                    }),
              ],
            ),
          ),
        ));
  }

  List<Widget> feedbackListItem(List<FeedbackList> feedbackList) {
    List<Widget> widgets = [];
    feedbackList.forEach((e) {
      widgets.add(InkWell(
        onTap: () async {
          bool refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CampaignFeedbackWebviewScreen(
                      departmentName: e.departmentName,
                      formId: e.formid,
                      id: e.id)));
          refreshPage(refresh);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/userInfo.png",
                      width: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${e.user}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Appointment Date : ${DateUtils.convertUTCToLocalTime(e.createdOn)}",
                            style: TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Campaign : " + e.campaignName,
                            style: TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  //margin: EdgeInsets.symmetric(horizontal: 7),
                  height: 1,
                  color: AppColors.borderLine,
                ),
                Container(
                  width: double.infinity,
                  //margin: EdgeInsets.symmetric(horizontal: 7),
                  height: 5,
                  color: AppColors.borderShadow,
                ),
              ],
            ),
          ),
        ),
      ));
    });
    return widgets;
  }

  refreshPage(bool refresh) {
    if (refresh != null && refresh) {
      setState(() {
        feedbackList = [];
        feedbackListFuture = getFeedbackList();
      });
    }
  }

  campaignTitleText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.arrivedColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Feedbacks",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
