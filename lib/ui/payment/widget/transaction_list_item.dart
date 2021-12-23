import '../../../ui/payment/model/payment_detail.dart';
import '../../../ui_utils/icon_utils.dart';
import '../../../utils/app_preferences.dart';
import '../../../widgets/status_tag.dart';
import 'package:flutter/material.dart';

class TransactionListItem extends StatefulWidget {
  final PaymentDetail paymentDetail;
  final VoidCallback onPressed;
  final bool showDate;

  TransactionListItem(this.paymentDetail, {this.onPressed, this.showDate});

  @override
  TransactionListItemState createState() => TransactionListItemState();
}

class TransactionListItemState extends State<TransactionListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.showDate) titleDateWidget(),
      InkWell(
          onTap: widget.onPressed,
          child: Card(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            paymentDescAndMode(),
                            StatusTag(widget.paymentDetail.transactionStatus)
                          ]),
                      Text(
                        "${widget.paymentDetail.departmentName ?? "${AppPreferences().deptmentName}"}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.paymentDetail.paymentMode == "CASH"
                                ? orderID()
                                : transactionID(),
                            Image.asset((widget.paymentDetail.paymentMode !=
                                        null &&
                                    widget.paymentDetail.paymentMode == "CASH")
                                ? "assets/images/ic_cash.png"
                                : "assets/images/ic_card.png"),
                            SizedBox(
                              width: 5,
                            ),
                            totalAmount(),
                            SizedBox(
                              width: 10,
                            )
                          ])
                    ],
                  ))))
    ]);
  }

  Widget totalAmount() {
    return Text(
      // widget.paymentDetail.currency == "INR"
      AppPreferences().defaultCurrencySymbol +
          widget.paymentDetail.totalAmount.toString() +
          " " +
          AppPreferences().defaultCurrencySuffix,
      // AppPreferences().defaultCurrency == "USD"
      //     ? "\$ ${widget.paymentDetail.totalAmount}"
      //     : "₹ ${widget.paymentDetail.totalAmount}",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  Widget titleDateWidget() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Colors.grey[200],
        child: Text(
          DateUtils.convertUTCToLocalDate(
                  widget.paymentDetail.transactionDate ??
                      widget.paymentDetail.createdOn)
              .toUpperCase(),
          style: TextStyle(fontSize: 17, color: Colors.grey[700]),
        ));
  }

  Widget transactionID() {
    return Expanded(
        child: Text(
      "Transaction ID : " +
          (widget.paymentDetail.transactionId != null &&
                  widget.paymentDetail.transactionId.isNotEmpty
              ? widget.paymentDetail.transactionId
              : "NIL"),
      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
    ));
  }

  Widget orderID() {
    return Expanded(
        child: Text(
      "Order ID : " + (widget.paymentDetail.orderId ?? ""),
      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
    ));
  }

  Widget paymentDescAndMode() {
    return Expanded(
        child: Container(
            width: (MediaQuery.of(context).size.width / 3) * 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Text(
                  widget.paymentDetail.paymentDescription == null ||
                          widget.paymentDetail.paymentDescription == "null"
                      ? "Payment Description"
                      : widget.paymentDetail.paymentDescription,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )),
                SizedBox(
                  width: 10,
                ),
                //ModeTag(widget.paymentDetail.paymentMode ?? "CARD"),
              ],
            )));
  }
}
