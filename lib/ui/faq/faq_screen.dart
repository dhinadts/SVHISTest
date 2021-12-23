import 'dart:async';
import 'dart:convert';

import '../../login/colors/color_info.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui/faq/model/faq.dart';
import '../../utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class FaqScreen extends StatefulWidget {
  final String title;
  const FaqScreen({Key key, this.title}) : super(key: key);
  @override
  FaqScreenState createState() => FaqScreenState();
}

class FaqScreenState extends State<FaqScreen> {
  List<MemberShipFaq> membershipFaqList = [];
  List<Diabetes> diabetesFaqList = [];

  List<MemberShipFaq> backupMembershipFaqList = [];
  List<Diabetes> backupDiabetesFaqList = [];

  PublishSubject<String> searchSubject = PublishSubject<String>();

  @override
  void dispose() {
    searchSubject.close();
    super.dispose();
  }

  void populateFAQDataFromLocalJsonFile() async {
    String data = "";
    data = await rootBundle.loadString('assets/faq.json');
    // debugPrint("Local Json from asset--- ${data.toString()}");

    List<dynamic> jsonData = json.decode(data);
    Faq faqs = Faq.fromJson(jsonData[0]);
    populateDataFromJson(faqs);
  }

  void populateDataFromJson(Faq value) {
    membershipFaqList = value.memberShipFaq;
    diabetesFaqList = value.diabetes;
    if (membershipFaqList != null) {
      backupMembershipFaqList.addAll(membershipFaqList);
    }
    if (diabetesFaqList != null) {
      backupDiabetesFaqList.addAll(diabetesFaqList);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:
            CustomAppBar(title: widget.title, pageId: Constants.PAGE_ID_FAQ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (newText) => searchSubject.sink.add(newText),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: bodyWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget() {
    List<Widget> widgets = [];
    if (membershipFaqList.length == 0 && diabetesFaqList.length == 0) {
      widgets.add(SizedBox(
        height: 25,
      ));
      widgets.add(Center(child: Text("No data available")));
      widgets.add(SizedBox(
        height: 15,
      ));
    } else {
      for (var index = 0; index < membershipFaqList.length; index++) {
        widgets.add(faqDetails(membershipFaqList[index], index));
      }
      widgets.add(SizedBox(
        height: 25,
      ));
      if (diabetesFaqList != null)
        widgets.add(Text(
          "Diabetes",
          style: boldTextStyle,
          textAlign: TextAlign.left,
        ));
      widgets.add(SizedBox(
        height: 15,
      ));
      if (diabetesFaqList != null) {
        for (var index = 0; index < diabetesFaqList.length; index++) {
          widgets.add(diabetesDetails(diabetesFaqList[index], index));
        }
      }
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }

  Widget faqListWidget() {
    return ListView.builder(
        itemCount: membershipFaqList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return faqDetails(membershipFaqList[index], index);
        });
  }

  Widget diabetesListWidget() {
    return ListView.builder(
        itemCount: diabetesFaqList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return diabetesDetails(diabetesFaqList[index], index);
        });
  }

  Widget bulletTextWidget(List<String> texts) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }

  Widget faqDetails(MemberShipFaq mFAQ, num index) {
    Widget headingWidget;
    if (mFAQ.heading.trim().contains('\n')) {
      headingWidget = Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: mFAQ.heading
              .trim()
              .split('\n')
              .map<Widget>(
                (point) => SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          margin: const EdgeInsets.only(
                            top: 7,
                            left: 30,
                            right: 6,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            point,
                            style: regularTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    } else {
      headingWidget = Text(
        mFAQ.heading,
        style: regularTextStyle,
        textAlign: TextAlign.left,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (index + 1).toString() + ". " + mFAQ.title,
          style: headingTextStyle,
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 10,
        ),
        headingWidget,
        mFAQ.subHeading.length > 0
            ? Container(
                margin: EdgeInsets.fromLTRB(30, 10, 0, 1),
                child: bulletTextWidget(mFAQ.subHeading))
            : Container(),
        Container(
          height: 1,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget diabetesDetails(Diabetes dFAQ, num index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (index + 1).toString() + ". " + dFAQ.title,
          style: headingTextStyle,
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          dFAQ.heading,
          style: regularTextStyle,
          textAlign: TextAlign.left,
        ),
        dFAQ.subHeading != null
            ? Container(
                margin: EdgeInsets.fromLTRB(30, 1, 0, 1),
                child: bulletTextWidget(dFAQ.subHeading))
            : Container(),
        dFAQ.comments.length > 0
            ? Text(
                dFAQ.comments,
                style: regularTextStyle,
                textAlign: TextAlign.left,
              )
            : Container(),
        dFAQ.commentArray != null
            ? Container(
                margin: EdgeInsets.fromLTRB(30, 1, 0, 1),
                child: bulletTextWidget(dFAQ.commentArray))
            : Container(),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    populateFAQDataFromLocalJsonFile();
    searchSubject
        .debounceTime(Duration(milliseconds: 300))
        .forEach((searchString) {
      Future.delayed(Duration(seconds: 0), () {
        membershipFaqList?.clear();
        diabetesFaqList?.clear();
        if (searchString == null || searchString.length == 0) {
          membershipFaqList?.addAll(backupMembershipFaqList);
          diabetesFaqList?.addAll(backupDiabetesFaqList);
        } else {
          final a = backupMembershipFaqList.where((mFaq) {
            final test = (mFaq.heading
                        ?.toLowerCase()
                        ?.contains(searchString.toLowerCase()) ??
                    false) ||
                (mFaq.title
                        ?.toLowerCase()
                        ?.contains(searchString.toLowerCase()) ??
                    false) ||
                ((mFaq.subHeading?.join(" ")?.toLowerCase() ?? "")
                        .contains(searchString.toLowerCase()) ??
                    false);
            return test;
          });
          membershipFaqList?.addAll(a);
          final b = backupDiabetesFaqList.where((dFaq) {
            final test = (dFaq.heading
                        ?.toLowerCase()
                        ?.contains(searchString.toLowerCase()) ??
                    false) ||
                (dFaq.title
                        ?.toLowerCase()
                        ?.contains(searchString.toLowerCase()) ??
                    false) ||
                ((dFaq.subHeading?.join(" ")?.toLowerCase() ?? "")
                        .contains(searchString.toLowerCase()) ??
                    false) ||
                (dFaq.comments
                        ?.toLowerCase()
                        ?.contains(searchString.toLowerCase()) ??
                    false) ||
                ((dFaq.commentArray?.join(" ")?.toLowerCase() ?? "")
                    .contains(searchString.toLowerCase()));
            return test;
          });
          diabetesFaqList?.addAll(b);
        }
        // print(
        //   "New Length: ${membershipFaqList.length + diabetesFaqList.length}");
        setState(() {});
      });
    });
  }
}

final TextStyle regularTextStyle = TextStyle(
    fontFamily: Constants.LatoRegular,
    fontSize: 14.0,
    color: Color(ColorInfo.BLACK));

final TextStyle headingTextStyle = TextStyle(
    fontSize: 14.0,
    fontFamily: Constants.LatoBold,
    color: Colors.black,
    fontWeight: FontWeight.w600);

final TextStyle boldTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: Constants.LatoBold,
    color: Colors.black,
    fontWeight: FontWeight.bold);

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• "),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: regularTextStyle,
          ),
        ),
      ],
    );
  }
}
