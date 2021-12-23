import 'dart:convert';

import '../../login/utils/custom_progress_dialog.dart';
import '../../model/payment_info.dart';
import '../../model/payment_method.dart';
import '../../repo/membership_repo.dart';
import '../../ui/donation/creditcard_payment_screen.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../rounded_button.dart';

enum TransactionType {
  MEMBERSHIP,
  DONATION,
}

class PaymentsWidget extends StatefulWidget {
  final Function(bool, String, String) paymentStatus;
  final GlobalKey globalKey;
  final String phoneNumber;
  final String name;
  final String email;
  final double totalAmount;
  final String paymentDescription;
  final TransactionType transactionType;
  final MembershipRepository repository;
  final bool isOnlyCard;

  const PaymentsWidget(
      {Key key,
      @required this.paymentStatus,
      @required this.globalKey,
      @required this.phoneNumber,
      @required this.name,
      @required this.email,
      @required this.totalAmount,
      this.paymentDescription,
      this.isOnlyCard,
      this.repository,
      @required this.transactionType})
      : super(key: key);

  @override
  _PaymentsWidgetState createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {
  PaymentMethod cashMethod = PaymentMethod(
      title: "Cash",
      description: "Default",
      id: "1",
      isAsset: true,
      icon: "assets/images/us_dollar.png");

  PaymentMethod cardMethod = PaymentMethod(
    title: "Credit Card",
    description: "**** **** **** ****",
    id: "2",
    icon: "assets/images/visa_card.png",
    isAsset: true,
  );
  List<PaymentMethod> methods = [];

  //   PaymentMethod(
  //       title: "Cash",
  //       description: "Default",
  //       id: "1",
  //       isAsset: true,
  //       icon: "assets/images/us_dollar.png"),
  //   PaymentMethod(
  //     title: "Credit Card",
  //     description: "**** **** **** ****",
  //     id: "2",
  //     icon: "assets/images/visa_card.png",
  //     isAsset: true,
  //   )
  // ];
  PaymentMethod selectedMethod;
  String confirmBtnText = "Confirm Payment";

  @override
  void initState() {
    super.initState();
    if (widget.isOnlyCard == false || widget.isOnlyCard == null) {
      methods = [cashMethod, cardMethod];
      selectedMethod = PaymentMethod(
          id: "1",
          title: "Cash",
          icon: "assets/images/us_dollar.png",
          description: "Default",
          isAsset: true);
    } else {
      methods = [cardMethod];
      selectedMethod = cardMethod;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        return buildPaymentMethod(methods[index]);
                      },
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      separatorBuilder: (context, index) => Container(
                        height: 18.0,
                      ),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: methods.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RoundedButton(
                  textColor: Colors.white,
                  text: confirmBtnText,
                  onTap: () async {
                    if (selectedMethod.title == "Cash") {
                      if (AppPreferences().role == Constants.USER_ROLE) {
                        showUserCashPaymentDialog(
                            "\"Please contact our head office at 1868 607 3288 to make your payment\" \nor \nVisit us at 10-12 Success St, to make your payment",
                            "NB: Your membership will only be approved once the payment has been made",
                            270);
                      } else {
                        //widget.hidePaymentMethodWidget(true);
                        // print(
                        // "email: ${widget.email},phone: ${widget.phoneNumber},name: ${widget.name},total: ${widget.totalAmount.toString()}");
                        CustomProgressLoader.showLoader(context);
                        http.Response response =
                            await widget.repository.cashInitiate(
                          email: widget.email,
                          phone: widget.phoneNumber,
                          name: widget.name,
                          total: widget.totalAmount.toString(),
                          paymentDescription: widget.paymentDescription,
                        );
                        // print("Response Body>> ${response.body}");
                        CustomProgressLoader.cancelLoader(context);
                        if (response != null &&
                            ValidationUtils.isSuccessResponse(
                                response.statusCode)) {
                          showPaymentSuccessDialog(
                              widget.globalKey.currentContext);
                          Future.delayed(const Duration(seconds: 1), () {
                            debugPrint("remove dialog...");
                            Navigator.pop(widget.globalKey.currentContext);
                            widget.paymentStatus(true, "Cash", "");
                          });
                        } else {
                          AlertUtils.showAlertDialog(
                              context,
                              jsonDecode(response.body)['message'] as String ??
                                  AppLocalizations.of(context)
                                      .translate("key_somethingwentwrong"));
                        }
                      }
                    } else {
                      String requestId = Uuid().v4();
                      PaymentInfo paymentInfo = PaymentInfo();
                      paymentInfo.currency = "USD";
                      paymentInfo.paymentSource = "MOBILE";
                      paymentInfo.requestId = requestId;
                      paymentInfo.totalAmount = widget.totalAmount;
                      paymentInfo.payeePhoneNumber = widget.phoneNumber;
                      paymentInfo.payeeName = widget.name;
                      paymentInfo.payeeEmail = widget.email;
                      paymentInfo.paymentDescription =
                          widget.paymentDescription;
                      if (widget.transactionType ==
                          TransactionType.MEMBERSHIP) {
                        paymentInfo.transactionType = "MEMBERSHIP";
                      } else {
                        paymentInfo.transactionType = "DONATION";
                      }

                      var status = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreditCardPaymentScreen(
                            paymentInfo: paymentInfo,
                          ),
                        ),
                      );
                      debugPrint("status --> $status");
                      //Future.delayed(Duration(seconds: 0), () {
                      if (status != null && status == "processed") {
                        widget.paymentStatus(true, "Card", requestId);
                      } else {
                        widget.paymentStatus(false, "Card", "");
                      }
                      //});
                    }
                  },
                  buttonColor: AppColors.primaryColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethod(PaymentMethod method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
          if (method.title == "Cash")
            confirmBtnText = "Confirm Payment";
          else if (method.title == "Credit Card")
            confirmBtnText = "Continue Payment";
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: Color(0xffeeeeee).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: (method.isAsset)
                  ? Image.asset(
                      method.icon,
                      width: 56.0,
                      height: 56.0,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      method.icon,
                      width: 56.0,
                      height: 56.0,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "${method.title}",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "${method.description}",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ],
              ),
            ),
            selectedMethod == method
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 28.0,
                  )
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  Widget buildInputWidget(String text, String hint, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xffeeeeee).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text ?? hint,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: text == null ? Colors.black45 : Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  showUserCashPaymentDialog(String title1, String title2, double dialogHeight) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Stack(
              children: [
                Container(
                  height: dialogHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Payment !!!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            height: (dialogHeight / 3) * 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.blueAccent)),
                            child: Scrollbar(
                                child: SingleChildScrollView(
                                    child: Column(
                              children: [
                                Text(
                                  title1,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                if (title2.isNotEmpty)
                                  SizedBox(
                                    height: 15,
                                  ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      title2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic),
                                    )),
                              ],
                            )))),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    child: Icon(
                      Icons.cancel,
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}

/// Card Popup if success payment
showPaymentSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: SimpleDialog(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
          color: Colors.white,
          child: Image.asset(
            "assets/images/checklist.png",
            height: 110.0,
            color: Colors.lightGreen,
          ),
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Payment Success!!",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),
        SizedBox(height: 30),
        // Center(
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
        //     child: Text(
        //       "Please submit your membership form",
        //       style: TextStyle(
        //         color: Colors.black38,
        //         fontSize: 13.5,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}
