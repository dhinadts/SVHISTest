import '../../model/subscriptions_model.dart';
import '../../ui/subscription/subscription_screen.dart';
import '../../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

class SubscriptionListWidget extends StatefulWidget {
  final List<SubscriptionsModel> subscriptionList;
  final ValueChanged<bool> onBackCall;

  SubscriptionListWidget(this.subscriptionList, {this.onBackCall});

  @override
  SubscriptionListWidgetState createState() => SubscriptionListWidgetState();
}

class SubscriptionListWidgetState extends State<SubscriptionListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      _widgetTitle(context),
      ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: widget.subscriptionList?.length,
          itemBuilder: (BuildContext context, int index) {
            return _widgetBody(context, index);
          })
    ]);
  }

  Widget _widgetTitle(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 10, left: 10),
        decoration: BoxDecoration(
            color: AppColors.arrivedColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            )),
        child: SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 7,
            ),
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 15),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Subscription",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))),
            Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(15),
                child: Text(
                  "Status",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
            SizedBox(
              height: 7,
            ),
          ],
        )),
      ),
    );
  }

  Widget _widgetBody(BuildContext context, int index) {
    return InkWell(
        onTap: () async {
          bool status = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SubscriptionScreen(widget.subscriptionList[index])),
          );
          if (status ?? false) {
            widget.onBackCall(status);
          }
        },
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 25),
                      padding: EdgeInsets.all(15),
                      child: Text(
                        widget.subscriptionList[index].subscriptionName,
                      ))),
              Container(
                margin: EdgeInsets.only(right: 35),
                padding: EdgeInsets.all(15),
                child: Icon(Icons.offline_pin,
                    color: (widget.subscriptionList[index]?.active ?? false)
                        ? Colors.green
                        : Colors.grey),
              ),
              SizedBox(
                height: 7,
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: 1,
            color: AppColors.borderLine,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: 5,
            color: AppColors.borderShadow,
          ),
        ]));
  }
}
