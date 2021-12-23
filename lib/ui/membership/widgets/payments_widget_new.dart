import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/membership/api/membership_api_client.dart';
import '../../../ui/membership/model/payment_info.dart';
import '../../../ui/membership/model/payment_method.dart';
import '../../../ui/membership/repo/membership_repo.dart';
import '../../../ui/membership/widgets/payment_cancel_dialog.dart';
import '../../../ui/membership/widgets/rounded_button.dart';
import '../../../ui/paypal/paypal_payment_screen.dart';
import '../../../ui/razorpay/razorpay_screen.dart';
import '../../../ui/tabs/app_localizations.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/text_styles.dart';
import '../../../utils/alert_utils.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../../../utils/validation_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../wipay/wipay_creditcard_payment_screen.dart';

enum TransactionType {
  MEMBERSHIP,
  DONATION,
}

class PaymentsWidgetNew extends StatefulWidget {
  final Function(bool, http.Response, String) paymentStatus;
  final String phoneNumber;
  final String name;
  final String email;
  final double totalAmount;
  final String paymentDescription;
  final TransactionType transactionType;
  final bool isOnlyCard;
  final String currency;
  final String departmentName;

  const PaymentsWidgetNew(
      {Key key,
      @required this.paymentStatus,
      @required this.phoneNumber,
      @required this.name,
      @required this.email,
      @required this.totalAmount,
      @required this.currency,
      @required this.departmentName,
      this.paymentDescription,
      this.isOnlyCard,
      @required this.transactionType})
      : super(key: key);

  @override
  _PaymentsWidgetNewState createState() => _PaymentsWidgetNewState();
}

class _PaymentsWidgetNewState extends State<PaymentsWidgetNew> {
  final GlobalKey<FormState> _alertFormKey = GlobalKey<FormState>();
  PaymentMethod cashMethod;
  PaymentMethod cardMethod;
  List<PaymentMethod> methods = [];

  PaymentMethod selectedMethod;
  String confirmBtnText = "Proceed to Payment";

  bool isCashPaymentSuccess = false;

  MembershipRepository _membershipRepository;
  http.Response _httpResponse;

  bool formAutoValidate = false;

  var receiptNumberController = TextEditingController();
  var description1;

  var clicked = true;
  @override
  void initState() {
    super.initState();
    descrp();
    getCurrencyIcon();

    debugPrint("widget.currency --> ${widget.currency}");

    _membershipRepository = MembershipRepository(
      membershipApiClient: MembershipApiClient(
        httpClient: http.Client(),
      ),
    );
  }

  descrp() async {
    description1 = await AppPreferences.getCashPaymentDesciption();
  }

  getCurrencyIcon() async {
    String defaultCurrency = await AppPreferences.getDefaultCurrency();

    String currencyIconPath = (defaultCurrency == "INR")
        ? "assets/images/inr_icon.png"
        : (defaultCurrency == "USD")
            ? "assets/images/us_dollar.png"
            : "assets/images/inr_icon.png";

    cashMethod = PaymentMethod(
      title: "Cash",
      description: "Default",
      id: "1",
      isAsset: true,
      icon: currencyIconPath,
    );

    cardMethod = PaymentMethod(
      title: "Online Payment",
      description: "**** **** **** ****",
      id: "2",
      icon: "assets/images/visa_card.png",
      isAsset: true,
    );

    // if (widget.isOnlyCard == false || widget.isOnlyCard == null) {
    //   methods = [cashMethod, cardMethod];
    //   selectedMethod = PaymentMethod(
    //       id: "1",
    //       title: "Cash",
    //       icon: currencyIconPath,
    //       description: "Default",
    //       isAsset: true);
    // } else {
    //   methods = [cardMethod];
    //   selectedMethod = cardMethod;
    // }
    AppPreferences.getCashPaymentEnable().then((value) async {
      var description = await AppPreferences.getCashPaymentDesciption();
      if (value) {
        setState(() {
          methods = [cashMethod, cardMethod];
          selectedMethod = PaymentMethod(
              id: "1",
              title: "Cash",
              icon: "assets/images/us_dollar.png",
              description: "Default",
              isAsset: true);
          // if (AppPreferences().role == Constants.USER_ROLE) {
          //   showUserCashPaymentDialog(description, "", 315);
          // }
        });
      } else {
        setState(() {
          methods = [cardMethod];
          selectedMethod = cardMethod;
        });
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        debugPrint("PaymentCancellationDialog...");
        widget.paymentStatus(true, null, null);
        // Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Scaffold(
        body: !isCashPaymentSuccess
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 380,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                            child: Container(
                              color: Color(0xFF1A237E),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Payment method",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PaymentCancellationDialog(
                                                      onTap: () {
                                                        debugPrint(
                                                            "PaymentCancellationDialog...");
                                                        widget.paymentStatus(
                                                            true, null, null);
                                                        Navigator.pop(context);
                                                      },
                                                    ));
                                          },
                                          color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          child: Container(
                            color: AppColors.primaryColor,
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16.0),
                              height:
                                  MediaQuery.of(context).size.height * 1 / 1.6,
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 15,
                                              ),
                                              ListView.separated(
                                                itemBuilder: (context, index) {
                                                  return buildPaymentMethod(
                                                      methods[index]);
                                                },
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.0),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        Container(
                                                  height: 18.0,
                                                ),
                                                physics:
                                                    ClampingScrollPhysics(),
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
                                              if (selectedMethod.title ==
                                                  "Cash") {
                                                if (AppPreferences().role ==
                                                    Constants.USER_ROLE) {
                                                  await widget.paymentStatus(
                                                      false, null, null);

                                                  showUserCashPaymentDialog(
                                                      description1, "", 315);
                                                  // Navigator.pop(context);
                                                } else {
                                                  debugPrint(
                                                      "email: ${widget.email},phone: ${widget.phoneNumber},name: ${widget.name},total: ${widget.totalAmount.toString()}");
                                                  showReceiptNoDialogue(
                                                      context);
                                                  /* CustomProgressLoader
                                                      .showLoader(context);

                                                  _httpResponse =
                                                      await _membershipRepository
                                                          .cashInitiate(
                                                    email: widget.email,
                                                    phone: widget.phoneNumber,
                                                    name: widget.name,
                                                    total: widget.totalAmount
                                                        .toString(),
                                                    paymentDescription: widget
                                                        .paymentDescription,
                                                    departmentName:
                                                        widget.departmentName,
                                                  );
                                                  debugPrint(
                                                      "Response Body>> ${_httpResponse.body}");
                                                  CustomProgressLoader
                                                      .cancelLoader(context); */

                                                  /* if (_httpResponse != null &&
                                                      ValidationUtils
                                                          .isSuccessResponse(
                                                              _httpResponse
                                                                  .statusCode)) {
                                                    setState(() {
                                                      isCashPaymentSuccess =
                                                          true;
                                                    });
                                                    showReceiptNoDialogue(
                                                        context);
                                                  } else {
                                                    AlertUtils.showAlertDialog(
                                                        context,
                                                        jsonDecode(_httpResponse
                                                                        .body)[
                                                                    'message']
                                                                as String ??
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    "key_somethingwentwrong"));
                                                  } */
                                                }
                                              } else {
                                                //String clientId = await AppPreferences.getClientId();
                                                //String currency = "INR";
                                                String requestId = Uuid().v4();
                                                PaymentInfo paymentInfo =
                                                    PaymentInfo();
                                                paymentInfo.currency =
                                                    widget.currency;
                                                paymentInfo.paymentSource =
                                                    "MOBILE";
                                                paymentInfo.requestId =
                                                    requestId;
                                                paymentInfo.departmentName =
                                                    widget.departmentName;
                                                paymentInfo.totalAmount =
                                                    widget.totalAmount;
                                                paymentInfo.payeePhoneNumber =
                                                    widget.phoneNumber;
                                                paymentInfo.payeeName =
                                                    widget.name;
                                                paymentInfo.payeeEmail =
                                                    widget.email;
                                                paymentInfo.paymentDescription =
                                                    widget.paymentDescription;
                                                if (widget.transactionType ==
                                                    TransactionType
                                                        .MEMBERSHIP) {
                                                  paymentInfo.transactionType =
                                                      "MEMBERSHIP";
                                                } else if (widget
                                                        .transactionType ==
                                                    TransactionType.DONATION) {
                                                  paymentInfo.transactionType =
                                                      "DONATION";
                                                }

                                                var status;
                                                String paymentGateway =
                                                    await AppPreferences
                                                        .getDefaultPaymentGateway();
                                                // await AppPreferences.getEnvProps()
                                                //     .then((envProps) {
                                                //   paymentGateway =
                                                //       envProps.paymentGateway;
                                                // });
                                                debugPrint(
                                                    "paymentGateway --> $paymentGateway");
                                                if (paymentGateway ==
                                                    "RAZORPAY") {
                                                  status = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RazorpayScreen(
                                                        paymentInfo:
                                                            paymentInfo,
                                                      ),
                                                    ),
                                                  );
                                                } else if (paymentGateway ==
                                                    "WIPAY") {
                                                  status = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WiPayCreditCardPaymentScreen(
                                                        paymentInfo:
                                                            paymentInfo,
                                                      ),
                                                    ),
                                                  );
                                                } else if (paymentGateway ==
                                                    "PAYPAL") {
                                                  status = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PayPalPaymentScreen(
                                                        paymentInfo:
                                                            paymentInfo,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                debugPrint(
                                                    "status -->6 $status");

                                                if (status != null &&
                                                    status == "processed") {
                                                  CustomProgressLoader
                                                      .showLoader(context);

                                                  _httpResponse =
                                                      await _membershipRepository
                                                          .getMembershipTransactionDetailsByRequestId(
                                                              requestId:
                                                                  requestId,
                                                              transactionType:
                                                                  "MEMBERSHIP");
                                                  CustomProgressLoader
                                                      .cancelLoader(context);

                                                  widget.paymentStatus(false,
                                                      _httpResponse, null);
                                                  Navigator.pop(context);
                                                } else {
                                                  widget.paymentStatus(
                                                      true, null, null);
                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                            buttonColor: AppColors.primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget buildPaymentMethod(PaymentMethod method) {
    return GestureDetector(
      onTap: () async {
        var description = await AppPreferences.getCashPaymentDesciption();
        setState(() {
          selectedMethod = method;
          if (method.title == "Cash") {
            if (AppPreferences().role == Constants.USER_ROLE) {
              showUserCashPaymentDialog(description, "", 315);
            }
            confirmBtnText = "Proceed to Payment";
          } else if (method.title == "Online Payment")
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
            selectedMethod.title == method.title
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "$title1",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
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

  showCashpaymentSuccessDialog(BuildContext context) async {
    AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'Payment Success!!',
        desc: "",
        btnOkOnPress: () {
          debugPrint('OnClcik');
          // Close success dialog
          //Navigator.pop(context);

          // Close the page
          //Navigator.pop(context);

          //widget.paymentStatus(false, _httpResponse, 22323);
        },
        btnOkText: "Complete",
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        })
      ..show();
  }

  showReceiptNoDialogue(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      child: WillPopScope(
        onWillPop: () async => true,
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Receipt Number"),
              InkWell(
                child: Icon(Icons.close),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: Form(
                    key: _alertFormKey,
                    autovalidate: formAutoValidate,
                    child: TextFormField(
                      controller: receiptNumberController,
                      inputFormatters: <TextInputFormatter>[
                        BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
                        // Fit the validating format.
                      ],
                      style: TextStyles.mlDynamicTextStyle,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter receipt number",
                          errorMaxLines: 2),
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.receiptNoValidation,
                      onChanged: (str) {},
                    )),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('Confirm'),
                onPressed: clicked
                    ? () async {
                        if (_alertFormKey.currentState.validate()) {
                          setState(() {
                            clicked = false;
                          });
                          CustomProgressLoader.showLoader(context);
                          _httpResponse =
                              await _membershipRepository.cashInitiate(
                                  email: widget.email,
                                  phone: widget.phoneNumber,
                                  name: widget.name,
                                  total: widget.totalAmount.toString(),
                                  paymentDescription: widget.paymentDescription,
                                  departmentName: widget.departmentName,
                                  receiptNo: receiptNumberController.text);

                          debugPrint("Response Body>> ${_httpResponse.body}");
                          debugPrint(
                              "Response statusCode >> ${_httpResponse.statusCode}");
                          CustomProgressLoader.cancelLoader(context);

                          if (_httpResponse != null &&
                              ValidationUtils.isSuccessResponse(
                                  _httpResponse.statusCode)) {
                            await showCashpaymentSuccessDialog(context);
                            Navigator.pop(context);
                            await widget.paymentStatus(false, _httpResponse,
                                receiptNumberController.text);
                            setState(() {
                              isCashPaymentSuccess = true;
                            });
                            // showReceiptNoDialogue(context);
                            Navigator.pop(context);

                            // Close the page
                            Navigator.pop(context);
                          } else {
                            print("What is messgae");
                            // AlertUtils.showAlertDialog(
                            //     context,
                            //     jsonDecode(_httpResponse.body)['message']
                            //             as String ??
                            //         AppLocalizations.of(context)
                            //             .translate("key_somethingwentwrong"));
                            Fluttertoast.showToast(
                                msg: "Receipt Number is already exist",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 5,
                                gravity: ToastGravity.TOP);
                          }

                          // Close the receipt dialog
                          // Navigator.pop(context);

                          // Close the page
                          // Navigator.pop(context);
                        } else {
                          setState(() {
                            formAutoValidate = true;
                          });
                        }
                      }
                    : () {})
          ],
        ),
      ),
    );
  }
}
