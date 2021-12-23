import 'dart:convert';

import '../../model/user_info.dart';
import '../../ui/membership/model/payment_info.dart';
import '../../ui/razorpay/model/razorpay_info.dart';
import '../../ui/razorpay/repo/razorpay_api_client.dart';
import '../../ui/razorpay/repo/razorpay_repo.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayScreen extends StatefulWidget {
  final Function(bool) paymentStatus;
  final PaymentInfo paymentInfo;

  const RazorpayScreen({Key key, this.paymentStatus, this.paymentInfo})
      : super(key: key);
  @override
  _RazorpayScreenState createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  Razorpay _razorpay;
  RazorpayRepository _razorpayRepository;
  RazorpayInfo _razorpayInfo;
  bool _isRazorpayOrderCreated = false;
  //bool showCloseBtn = false;

  @override
  void initState() {
    super.initState();
    _razorpayRepository = RazorpayRepository(
        razorpayApiClient: RazorpayApiClient(httpClient: http.Client()));
    _createRazorpayOrder();
  }

  @override
  void dispose() {
    super.dispose();
    if (_razorpay != null) _razorpay.clear();
  }

  _createRazorpayOrder() async {
    http.Response response = await _razorpayRepository.createRazorpayOrder(
        amount: widget.paymentInfo.totalAmount,
        currency: widget.paymentInfo.currency,
        customerName: widget.paymentInfo.payeeName,
        email: widget.paymentInfo.payeeEmail,
        departmentName: widget.paymentInfo.departmentName,
        phone: widget.paymentInfo.payeePhoneNumber,
        userName: widget.paymentInfo.userName,
        requestId: widget.paymentInfo.requestId);
    debugPrint("response --> ${response.statusCode}");
    debugPrint("body --> ${response.body}");
    setState(() {
      _isRazorpayOrderCreated = true;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      _razorpayInfo = RazorpayInfo.fromJson(jsonResponse["razorPay"]);
      if (_razorpayInfo != null) {
        _razorpay = new Razorpay();

        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
        _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
        openCheckout();
      }
    } else {
      String errorMsg = jsonDecode(response.body)['message'] as String;
      String errorMsg1 = (errorMsg == null || errorMsg.isEmpty)
          ? jsonDecode(response.body)['error'] as String
          : errorMsg;
      AlertUtils.showAlertDialog(
          context,
          errorMsg1 != null && errorMsg1.isNotEmpty
              ? errorMsg1
              : AppPreferences().getApisErrorMessage);
    }
  }

  _updateRazorpayOrder(Map<String, dynamic> orderInfo) async {
    setState(() {
      _isRazorpayOrderCreated = false;
    });
    http.Response response = await _razorpayRepository.updateRazorpayOrder(
        orderInfo, _razorpayInfo.paymentId);
    debugPrint(
        "updateRazorpayOrder response status code --> ${response.statusCode}");
    debugPrint("updateRazorpayOrder response body --> ${response.body}");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String paymentStatus =
          jsonResponse != null ? jsonResponse["transactionStatus"] : null;
      if (paymentStatus != null && paymentStatus == "success") {
        AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            title:
                'Your payment of INR ${widget.paymentInfo.totalAmount.toInt()} is successful',
            desc: 'Transaction ID : ${jsonResponse['transactionId']}',
            btnOkOnPress: () {
              debugPrint('OnClcik');
              Navigator.pop(context, "processed");
            },
            btnOkText: "Complete",
            //btnOkIcon: Icons.check_circle,
            onDissmissCallback: () {
              debugPrint('Dialog Dissmiss from callback');
            })
          ..show();
        // RazorpayResponse razorpayResponse = await _razorpayRepository
        //     .getRazorpayDetailsByRequestId(widget.paymentInfo.requestId);
        // if (razorpayResponse != null) {
        //   debugPrint("razorpayResponse --> ${razorpayResponse.toJson()}");
        // }
        // setState(() {
        //   showCloseBtn = true;
        // });
      } else {
        AlertUtils.showAlertDialog(context, "Transaction Failed");
      }
    } else {
      String errorMsg = jsonDecode(response.body)['message'] as String;
      AlertUtils.showAlertDialog(
          context,
          errorMsg != null && errorMsg.isNotEmpty
              ? errorMsg
              : AppPreferences().getApisErrorMessage);
    }

    setState(() {
      _isRazorpayOrderCreated = true;
    });
  }

  Future<void> handlerPaymentSuccess(PaymentSuccessResponse response) async {
    // print("Payment success");
    // print("Payment orderId --> ${response.orderId}");
    // print("Payment paymentId --> ${response.paymentId}");
    // print("Payment signature --> ${response.signature}");
    UserInfo userInfo = await AppPreferences.getUserInfo();
    String username = await AppPreferences.getUsername();
    String userFullName = userInfo.userFullName;

    Map<String, dynamic> orderInfo = {
      "currency": widget.paymentInfo.currency,
      "merchantName": _razorpayInfo.merchantName,
      "orderId": response.orderId,
      "payeeEmail": _razorpayInfo.payeeEmail,
      "payeeName": _razorpayInfo.payeeName,
      "payeePhoneNumber": _razorpayInfo.payeePhoneNumber,
      "paymentDescription": widget.paymentInfo.paymentDescription,
      "paymentId": response.paymentId,
      "requestId": _razorpayInfo.requestId,
      "signature": response.signature,
      "totalAmount": widget.paymentInfo.totalAmount,
      "transactionSource": widget.paymentInfo.paymentSource,
      "transactionType": widget.paymentInfo.transactionType,
      "transactionGateway": _razorpayInfo.transactionGateway,
      "departmentName": widget.paymentInfo.departmentName,
      'userFullName': userFullName,
      'userName': username
    };

    debugPrint("update orderInfo --> $orderInfo");
    _updateRazorpayOrder(orderInfo);
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    // print("Payment error");
    // print("Payment error code --> ${response.code}");
    // print("Payment error message --> ${response.message}");
    if (response.code == 2) {
      Navigator.pop(context, true);
    }
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    // print("External Wallet");
    // print("External walletName --> ${response.walletName}");
  }

  void openCheckout() {
    var options = {
      "key": _razorpayInfo.secretKey,
      "amount": widget.paymentInfo.totalAmount,
      "currency": widget.paymentInfo.currency,
      "name": _razorpayInfo.merchantName,
      //"description": _razorpayInfo.paymentDescription,
      "order_id": _razorpayInfo.orderId,
      "prefill": {
        "name": widget.paymentInfo.payeeName,
        "contact": widget.paymentInfo.payeePhoneNumber,
        "email": widget.paymentInfo.payeeEmail,
      },
      "theme": {"color": _razorpayInfo.theme}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to cancel the Payment?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "No",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Payment",
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
        ),
        body: !_isRazorpayOrderCreated
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ),
    );
  }
}
