import 'package:flutter/material.dart';
import '../../ui/membership/widgets/payments_widget.dart';
import '../../utils/app_preferences.dart';
import '../../model/user_info.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  var email = "";
  var phone = "";
  var name = "";
  var transactionType = "";
  var totalAmount = TextEditingController();
  var enablePaymentMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    UserInfo userinfo = AppPreferences().userInfo;
    email = userinfo.emailId;
    phone = userinfo.mobileNo;
    name = userinfo.userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
        centerTitle: true,
      ),
      body: enablePaymentMode
          ? Center(
            child: PaymentsWidget(
                email: email,
                globalKey: _scaffoldKey,
                name: name,
                paymentStatus: (boolean, data2, data) {},
                phoneNumber: phone,
                totalAmount: int.parse(totalAmount.text) + 0.0,
                transactionType: TransactionType.DONATION,
                isOnlyCard: true, departmentName: AppPreferences().username,
              ),
          )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: totalAmount,
                    decoration: InputDecoration(labelText: "Price"),
                  ),
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (totalAmount.text.length > 0) {
                        setState(() {
                          enablePaymentMode = !enablePaymentMode;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
    );
  }
}
