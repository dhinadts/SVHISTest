import 'dart:convert';
import 'dart:math' as math;

import '../../country_picker_util/country_code_picker.dart';
import '../../login/colors/color_info.dart';
import '../../login/utils.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/donation_model.dart';
import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui/donation/donation_list_screen.dart';
import '../../ui/membership/api/membership_api_client.dart';
import '../../ui/membership/membership_screen.dart';
import '../../ui/membership/model/payment_info.dart';
import '../../ui/membership/repo/membership_repo.dart';
import '../../ui/membership/widgets/payment_cancel_dialog.dart';
import '../../ui/membership/widgets/payments_widget.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/text_styles.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/linked_lable_checkbox.dart';
import '../../widgets/submit_button.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const String KEY_DONATION_PURPOSE = "DONATION_PURPOSE";

typedef VoidCallback = void Function(bool isDonationUpdated);

class DonationScreen extends StatefulWidget {
  final VoidCallback callbackForDonationUpdate;

  final String title;
  final Donation dObj;

  const DonationScreen(
      {Key key,
      this.title,
      @required this.dObj,
      @required this.callbackForDonationUpdate})
      : super(key: key);

  @override
  DonationScreenState createState() => DonationScreenState();
}

class DonationScreenState extends State<DonationScreen> {
  // List<int> amount = [25, 50, 75, 100, 200, 500];
  List<int> amount = [100, 500, 1000];
  double rawAmount = 25;

  // int selectedIndex = 0;
  final amountController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var departName = TextEditingController();
  var addressController = TextEditingController();
  var address2Controller = TextEditingController();
  var countyController = TextEditingController();
  var commnetsController = TextEditingController();
  var zipcodeController = TextEditingController();
  var otherEventsController = TextEditingController();
  String currency = "";
  String amountLimitMessage = "";
  bool initCall = false;
  String initCountry = "IN";
  String countryCodeDialCode = Constants.INDIA_CODE;
  String country = AppPreferences().country;
  TextStyle countryCodeStyle = TextStyle(
    fontFamily: Constants.LatoRegular,
    color: Colors.grey,
    fontSize: 15.0,
  );
  String phoneCountryCode;
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double totalAmount = 0;
  bool hasBasicInfoValidated = false;
  bool paymentStatus = false, readOnly = false;
  bool paymentStatusLoading = false;

  String doneeUserName = "";
  List<String> donationPurposesStr = [];
  String selectedDonationPurpose = "General"; // = "Birthday";
  MembershipRepository _membershipRepository;
  PaymentInfo paymentInfoObj;

  List<String> _reminderArray = [
    "Monthly",
    "Quarterly",
    "Half Yearly",
    "Annually",
    "One-time Entry"
  ];
  String _selectedReminder = "Monthly";

  String countryCode;
  String defaultCurrency;
  String currencySuffix;

  List<DropdownMenuItem<PageReferenceData>> _donationCauseDropdownMenuItems;

  bool isDataLoaded = false;

  List<String> _defaultSupportingDoc = [];
  List<String> _supportingDocs = [];
  String _supportingDocDeclarationText = "";
  double minAmount = 5.0;
  double maxAmount = 5000.0;
  List<String> hasTags = [];
  List<Color> hasTagColors = [];

  // Future fetchDonationCauses() async {
  //   String url =
  //       '${AppPreferences().apiURL}/subscription/references/values/DONATION_PURPOSE';
  //   final headers = {
  //     "username": AppPreferences().username,
  //   };
  //   final response = await http.get(url, headers: headers);
  //   if (response.statusCode == 200) {
  //     donationPurposesStr = [];
  //     for (var cause in jsonDecode(response.body)) {
  //       donationPurposesStr.add(cause.toString());
  //     }
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    super.initState();
    selectedDonationPurpose = widget.dObj.causeTitle;
    if (widget.dObj.minAmount > 0) {
      minAmount = widget.dObj.minAmount;
    }

    if (widget.dObj.targetAmount > 0) {
      maxAmount = widget.dObj.targetAmount;
    }
    hasTags = widget.dObj.hashtags.split(',');

    for (int i = 0; i < hasTags.length; i++) {
      hasTagColors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0));
    }
    setupSupportingDocuments();
    _fetchPageReferenceData();
    getCurrency();
    amountController.text = amount[0].toString();
    calculateTotalAmount(amountController.text);
    populateUserInfo();
    _membershipRepository = MembershipRepository(
        membershipApiClient: MembershipApiClient(httpClient: http.Client()));

    setState(() {});
    //fetchDonationCauses();

    initializeAd();
  }

  getCurrency() async {
    defaultCurrency = await AppPreferences.getDefaultCurrency();
    currencySuffix = AppPreferences().defaultCurrencySuffix;
    setState(() {
      currency = defaultCurrency;
      if (currency == "INR") {
        currency = '\u{20B9} ';
      } else {
        currency = '\u{0024} ';
      }
      amountLimitMessage = "Please enter the amount between" +
          currency +
          minAmount.toString() +
          " to" +
          currency +
          maxAmount.toString();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    amountController.dispose();
    commnetsController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departName.dispose();
    addressController.dispose();
    address2Controller.dispose();
    zipcodeController.dispose();
    super.dispose();
  }

  Future<void> setupSupportingDocuments() async {
    //String departmentName = await AppPreferences.getDeptName();

    // debugPrint(
    //     "getSupportDocument --> ${await AppPreferences.getSupportDocument()}");
    // debugPrint(
    //     "getMembershipWorkFlow --> ${await AppPreferences.getMembershipWorkFlow()}");

    List<String> supportDoc = await AppPreferences.getSupportDocument();
    String declrationText = await AppPreferences.getDeclaration();
    /* _defaultSupportingDoc.add(
        "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/docs/donation/supportingdoc.pdf");
*/
    if (widget.dObj.supportingDocs.isEmpty) {
      if (supportDoc != null && supportDoc.length > 0) {
        _supportingDocs = supportDoc;
      }
      if (declrationText != null) {
        _supportingDocDeclarationText = declrationText;
      }
    } else {
      _supportingDocs = [widget.dObj.supportingDocs];
      _supportingDocDeclarationText =
          extractFileName(widget.dObj.supportingDocs).toUpperCase();
    }
    // await AppPreferences.getEnvProps().then((envProps) {
    //   if (envProps.supportingDocs != null) {
    //   }
    //   _supportingDocs = envProps.supportingDocs;
    //   if (declrationText == null) {
    //     _supportingDocDeclarationText = envProps.supportingDocDeclarationText;
    //   } else {
    //     _supportingDocDeclarationText = declrationText;
    //   }
    // });

    setState(() {
      _supportingDocs = _supportingDocs;
    });
  }

  Future<void> _fetchPageReferenceData() async {
    // String clientId = await AppPreferences.getClientId();

    // final url =
    //     WebserviceConstants.baseAdminURL + "/page/reference-data/DONATION_FORM";

    // Map<String, String> header = {};
    // String username = await AppPreferences.getUsername();
    // header.putIfAbsent(WebserviceConstants.contentType,
    //     () => WebserviceConstants.applicationJson);
    // header.putIfAbsent(WebserviceConstants.username, () => username);
    // header.putIfAbsent("clientid", () => clientId);
    // final response = await http.get(url, headers: header);
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> donationPageReferenceJson =
    //       jsonDecode(response.body);
    //   print("donation---> ${jsonDecode(response.body)}");
    //   if (donationPageReferenceJson.containsKey(KEY_DONATION_PURPOSE)) {
    //     List<dynamic> donationCauseList =
    //         donationPageReferenceJson[KEY_DONATION_PURPOSE];
    //     if (donationCauseList != null) {
    //       List<PageReferenceData> donationPurposeList = [];
    //       donationPurposeList.add();
    //       _donationCauseDropdownMenuItems =
    //           buildDropDownMenuItems(donationPurposeList);
    //       donationCauseList.forEach((element) {
    //         donationPurposeList.add(PageReferenceData(
    //             element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
    //         _donationCauseDropdownMenuItems =
    //             buildDropDownMenuItems(donationPurposeList);
    //       });
    //     }PageReferenceData("General", "General")
    //   }
    // } else {
    //   String errorMsg = jsonDecode(response.body)['message'] as String;
    //   AlertUtils.showAlertDialog(
    //       context,
    //       errorMsg != null && errorMsg.isNotEmpty
    //           ? errorMsg
    //           : AppPreferences().getApisErrorMessage);
    // }
    //Here we are getting data from listscreen , so no need of API call
    buildDropDownMenuItems(
        [PageReferenceData(widget.dObj.causeTitle, widget.dObj.causeTitle)]);
    setState(() {
      isDataLoaded = true;
    });
  }

  List<DropdownMenuItem<PageReferenceData>> buildDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<PageReferenceData>> items = List();
    for (PageReferenceData listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.fieldDisplayValue),
          value: listItem,
        ),
      );
    }
    return items;
  }

  populateUserInfo() async {
    await AppPreferences.getEmail().then((value) {
      emailController.text = value;
    });
    departName.text = await AppPreferences.getDeptName();
    print("data");
    await AppPreferences.getAddress().then((value) {
      print(value);
      if (value != null && value != "") {
        var arr = value.split("@@");
        print(arr);
        print(arr.length);
        if (arr.length >= 3) {
          zipcodeController.text = arr[4];
          String addr = "";
          addressController.text = arr[0];
          //streetController.text = arr[0];
          //areaController.text = arr[1];
          cityController.text = arr[1];
          stateController.text = arr[2];
          countryController.text = arr[3];
        }
      }
    });

    AppPreferences.getPhone().then((value) {
      if (value != null && value != "") {
        phoneController.text = value.substring(value.length - 10);
      }
    });

    await AppPreferences.getUserInfo()?.then((value) {
      setState(() {
        countryCode = value?.countryCode ?? AppPreferences().country;

        firstNameController.text = value.firstName;
        lastNameController.text = value.lastName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setGlobalContext(context);
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
                title: widget.title != null ? widget.title : "Donation",
                pageId: Constants.PAGE_ID_DONATION),
            body: (!isDataLoaded)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : hasBasicInfoValidated
                    ? donationPaymentWidget()
                    : basicInfoWidget()));
  }

  Widget causeBody() {
    print("body is " + widget.dObj.causeBody);
    print("body mime is" + widget.dObj.causeBodyMime);
    if (widget.dObj.causeBody.isEmpty) {
      return buildBodyText(
          "Charitable deeds are just not to help someone in need. Charity improves the self, makes you happy and contented. Charity is a privilege and makes one empowering if you think you're ready to help, we are here to help you co-ordinate!");
    } else if (widget.dObj.causeBodyMime == "text/plain") {
      return buildBodyText(widget.dObj.causeBody);
    } else if (widget.dObj.causeBodyMime.trim() == "images/*") {
      if (widget.dObj.causeBody.contains("http://") ||
          widget.dObj.causeBody.contains("https://")) {
        return Image.network(widget.dObj.causeBody);
      } else {
        return Image.memory(base64Decode(widget.dObj.causeBody));
      }
    } else if (widget.dObj.causeBodyMime.toString().trim() == "text/html") {
      return Container(
          height: 200,
          child: InAppWebView(
            // TODO: Dynamic URL formation
            // initialUrl:"${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/${AppPreferences().deptmentName}-Membership.html?clientId=${widget.clientId}&departmentName=${widget.departmentName}&userName=${widget.userName}&loggedInRole=${widget.loggedInRole}&membershipId=${widget.membershipId}",
            initialData: InAppWebViewInitialData(data: widget.dObj.causeBody),
            initialHeaders: {},
            contextMenu: ContextMenu(),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    clearCache: true,
                    javaScriptEnabled: true,
                    supportZoom: false,
                    preferredContentMode: UserPreferredContentMode.MOBILE),
                android: AndroidInAppWebViewOptions()),
            onLoadStart: (InAppWebViewController controller, String url) {
              debugPrint("onLoadStart $url");
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              debugPrint("onLoadStop $url");
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {},
            onUpdateVisitedHistory: (InAppWebViewController controller,
                String url, bool androidIsReload) {
              debugPrint("onUpdateVisitedHistory $url");
            },
            onConsoleMessage: (controller, consoleMessage) {
              debugPrint("consoleMessage --> $consoleMessage");
            },
            /*  onLoadHttpError: (controller, url, errorCode, errorMessage) {
        if (errorCode >= 400 && errorCode <= 499) {
          _webViewController.loadFile(
              assetFilePath: "assets/static/400.html");
        } else if (errorCode >= 500) {
          _webViewController.loadFile(
              assetFilePath: "assets/static/500.html");
        }
      }, */
          ));
    } else {
      return Container();
    }
    // else if (widget.dObj.causeBodyMime.toLowerCase().contains('html')) {
    //   var document = parse(widget.dObj.causeBody);
    //   print(document.outerHtml);
    //   return document.toString();
    // }
  }

  buildBodyText(String value) {
    return Text(value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontFamily: Constants.LatoBold));
  }

  buildDonationTitleCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          buildCircularPercent(),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Raised",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text.rich(
                  TextSpan(
                      text: currency +
                          widget.dObj.achieved_amount.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' of ' +
                              currency +
                              widget.dObj.targetAmount.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        )
                      ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildCircularPercent() {
    double percentage = 0;
    percentage = (widget.dObj.achieved_amount / widget.dObj.targetAmount) * 100;
    return Center(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
                border: new Border.all(
                    width: 4, color: Color(0xFF2633C5).withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    percentage.toStringAsFixed(1) + "%",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CustomPaint(
              painter: CurvePainter(
                colors: [
                  Colors.red,
                  Colors.yellow,
                  Colors.blue,
                  Colors.green,
                ],
                angle: ((percentage / 100) * 360),
              ),
              child: SizedBox(
                width: 78,
                height: 78,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDonationAmountBox() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          border: Border.all(color: Colors.grey[300])),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Donation Amount",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(amount.length, (index) {
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: amount[index].toDouble() == rawAmount
                          ? Colors.blue[600]
                          : Colors.white,
                      border: Border.all(color: Colors.grey[300])),
                  margin: EdgeInsets.all(6),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          // selectedIndex = index;
                          rawAmount = amount[index].toDouble();
                          amountController.text = amount[index].toString();
                          calculateTotalAmount(amountController.text);
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Center(
                                child: Text(
                              currency + " " + amount[index].toString(),
                              style: TextStyle(
                                  color: amount[index].toDouble() == rawAmount
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 17,
                                  fontFamily: Constants.LatoBold),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ));
            }),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.grey[300])),
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            currency,
                            style: amountTextStyle,
                          ),
                          Expanded(
                              child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 27,
                                fontWeight: FontWeight.w700),
                            maxLength: 7,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              hintText: "Amount",
                              counterText: "",
                              border: InputBorder.none,
                            ),
                            controller: amountController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            onChanged: (value) {
                              calculateTotalAmount(value);
                            },
                            onSubmitted: (text) {
                              showDonationAmountAlert();
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 1.2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 5),
                    child: Text(
                      defaultCurrency,
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (String item in _reminderArray)
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300])),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedReminder = item;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  if (_selectedReminder == item)
                                    Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                      size: 22,
                                    ),
                                  Text(
                                    item,
                                    style: TextStyle(
                                        fontWeight: _selectedReminder == item
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: _selectedReminder == item
                                            ? Theme.of(context).primaryColor
                                            : null),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget basicInfoWidget() {
    print("Inside the basicInfoWidget");
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
              child: new Form(
                  onChanged: () {
                    // debugPrint("change detected");
                  },
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: [
                      descriptionCard(causeBody()),
                      widget.dObj.isFundRaiser
                          ? buildDonationTitleCard()
                          : Container(),
                      widget.dObj.hashtags.length > 0
                          ? hashTagChips()
                          : Container(),
                      pdfDocumentWidget(),
                      /*SizedBox(
                        height: 10,
                      ),*/
                      /*Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                //padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
                                child: Text(
                              "Cause of\ndonation",
                              style: TextStyles.mlDynamicTextStyle,
                            )),
                            SizedBox(width: 40),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              // child: new Center(
                              //     child: new DropdownButton(
                              //   items: new List.generate(donationPurposesStr.length,
                              //       (int index) {
                              //     return new DropdownMenuItem(
                              //         child: new Container(
                              //       child: new Text(donationPurposesStr[index]),
                              //       width: 200.0, //200.0 to 100.0
                              //     ));
                              //   }),
                              //   onChanged: (value) {
                              //     setState(() {
                              //       selectedDonationPurpose = value;
                              //     });
                              //   },
                              // )),
                              // )
                              child: DropdownButtonFormField<PageReferenceData>(
                                //value: selectedDonationPurpose,
                                hint: Text(
                                  selectedDonationPurpose == null
                                      ? 'Select'
                                      : selectedDonationPurpose,
                                  style: TextStyles.mlDynamicTextStyle,
                                ),
                                items: _donationCauseDropdownMenuItems,
                                validator: (PageReferenceData pageReferenceData) {
                                  if (selectedDonationPurpose == null) {
                                    return "Cause of donation is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    selectedDonationPurpose = value.fieldValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),*/
                      if (selectedDonationPurpose == "Other events")
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20),
                          child: TextFormField(
                            style: TextStyles.mlDynamicTextStyle,
                            controller: otherEventsController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              border: OutlineInputBorder(),
                              labelText: "Other Events",
                            ),
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value.isEmpty)
                                return "Other events cannot be blank";
                              else
                                return null;
                            },
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildDonationAmountBox(),
                      //dottedCard("Select Amount"),
                      /* SizedBox(
                        height: 10,
                      ),*/
                      // donationAmountGridView(),
                      /* SizedBox(
                        height: 10,
                      ),*/
                      /*Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, //change here don't //worked
                        children: [enterAmountWidget()],
                      ),*/
                      /*SizedBox(
                        height: 10,
                      ),*/
                      /* Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          shadowColor: Colors.blue,
                          elevation: 6,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ),
                                    child: Text(
                                      "Remind Me To Donate Again, If You Need",
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  for (String item in _reminderArray)
                                    _createReminderWidget(item),
                                  SizedBox(
                                    height: 45,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),*/
                      dottedCard("Personal Information"),
                      formUI(),
                      dottedCard("Payment"),
                      totalAmountCard(),
                      donateButton(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ))),
        ),

        /// Show Banner Ad
        getSivisoftAdWidget(),
      ],
    );
  }

  Widget _createReminderWidget(String item) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: LinkedLabelCheckbox(
              value: _selectedReminder == item ? true : false,
              onChanged: (value) {
                _handleCheckBoxChange(value, item);
              },
              label: item,
            ),
          ),
        ],
      ),
    );
  }

  Widget dottedCard(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontFamily: Constants.LatoBold),
      ),
    );
  }

  Widget descriptionCard(Widget causeBody) {
    return Card(
        shadowColor: Colors.blue,
        elevation: 6,
        color: Colors.white,
        margin: EdgeInsets.all(12),
        child: Container(
            margin: EdgeInsets.all(10),
            child: Center(
                child: Column(children: [
              if (widget.dObj.causeTitle == "General")
                Text("The more you give, the more you get!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              SizedBox(height: 10),
              causeBody,
            ]))));
  }

  Widget hashTagChips() {
    List<Widget> chips = [];
    for (int i = 0; i < hasTags.length; i++) {
      chips.add(_buildChip(hasTags[i].replaceAll(" ", ""), hasTagColors[i]));
    }
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chips,
    );
  }

  Widget _buildChip(String label, Color color) {
    return InkWell(
        onTap: () async {
          await canLaunch(label)
              ? await launch(label)
              : throw 'Could not launch $label';
        },
        child: Chip(
          labelPadding: EdgeInsets.all(2.0),
          avatar: CircleAvatar(
            backgroundColor: Colors.white70,
            child: Text(label[1].toUpperCase()),
          ),
          label: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: color,
          elevation: 6.0,
          shadowColor: Colors.grey[60],
          padding: EdgeInsets.all(8.0),
        ));
  }

  String extractFileName(String urlPath) {
    if (urlPath != null && urlPath.isNotEmpty) {
      String fileName = urlPath.split('/').last;
      return fileName.length > 0 ? fileName.split(".")[0] : "";
    }
    return "";
  }

  Widget pdfItemWidget(String docURL) {
    return GestureDetector(
      onTap: () async {
        CustomProgressLoader.showLoader(context);
        final response = await http.head(docURL);
        CustomProgressLoader.cancelLoader(context);
        if (response.statusCode == 200) {
          PDFDocument document = await PDFDocument.fromURL(docURL);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PDFViewer(
                      document: document,
                      indicatorPosition: IndicatorPosition.topLeft,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        } else {
          AlertUtils.showAlertDialog(
              context, "Invalid supporting document URL");
        }
      },
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 5.0, 8.0, 5.0),
          child: Row(
            children: <Widget>[
              Text(
                _supportingDocs.length > 0
                    ? extractFileName(docURL)
                    : "Supporting document",
                style: TextStyle(color: Colors.blue[900], fontSize: 15),
              ),
              if (_supportingDocs.length > 0 &&
                  _supportingDocs[_supportingDocs.length - 1] != docURL)
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  color: Colors.grey,
                  width: 1,
                  height: 25,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pdfDocumentWidget() {
    return Card(
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Supporting documents',
                style: TextStyles.mlDynamicTextStyle,
              ),
            ),
          ),
          /*const SizedBox(
            height: 30,
          ),*/
          if (_supportingDocs.length > 0)
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _supportingDocDeclarationText,
                  style: TextStyles.mlDynamicTextStyle,
                ),
              ),
            ),
          Container(
            child: Wrap(
              children: [
                if (_supportingDocs.length > 0)
                  for (String docURL in _supportingDocs) pdfItemWidget(docURL)
/*                else if (_defaultSupportingDoc.length > 0)
                  for (String docURL in _defaultSupportingDoc)
                    pdfItemWidget(docURL)*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget enterAmountWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Card(
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Colors.brown,
            width: 0.5,
          ),
        ),
        elevation: 10,
        color: Colors.white,
        margin: EdgeInsets.all(10),
        child: Container(
          height: 50,
          width: 150,
          child: Row(
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                currency,
                style: amountTextStyle,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                  child: TextField(
                keyboardType: TextInputType.number,
                maxLength: 7,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  hintText: "Amount",
                  counterText: "",
                  border: InputBorder.none,
                ),
                controller: amountController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  calculateTotalAmount(value);
                },
                onSubmitted: (text) {
                  showDonationAmountAlert();
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  void calculateTotalAmount(String amount) {
    if (amount.length > 0) {
      String donationAmount =
          amountController.text.length == 0 ? 0 : amountController.text;
      rawAmount = double.parse(donationAmount);
      double totalDonationAmtWithServiceCharge = double.parse(donationAmount) +
          ((double.parse(donationAmount) / 100) * 4);
      totalAmount = totalDonationAmtWithServiceCharge;
      // showDonationAmountAlert();
      setState(() {});
    }
  }

  void showDonationAmountAlert() {
    String donationAmount =
        amountController.text.length == 0 ? 0 : amountController.text;
    if (double.parse(donationAmount) < minAmount ||
        double.parse(donationAmount) > maxAmount) {
      // print(" Submitted text field: $amountController.text");
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: amountLimitMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
  }

  Widget donateButton() {
    return SubmitButton(
      text: "           Donate           ",
      textStyle: amountWhiteTextStyle,
      onPress: () {
        createDonationInfo();
      },
    );
  }

  Widget donationAmountGridView() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          shrinkWrap: true,
          physics: PageScrollPhysics(),
          children: List.generate(amount.length, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  // selectedIndex = index;
                  rawAmount = amount[index].toDouble();
                  amountController.text = amount[index].toString();
                  calculateTotalAmount(amountController.text);
                });
              },
              child: Card(
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Colors.blue[600],
                    width: 1.5,
                  ),
                ),
                elevation: 3,
                color: amount[index].toDouble() == rawAmount
                    ? Colors.blue[600]
                    : Colors.white,
                margin: EdgeInsets.all(6),
                child: Center(
                    child: Text(
                  currency + " " + amount[index].toString(),
                  style: TextStyle(
                      color: amount[index].toDouble() == rawAmount
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontFamily: Constants.LatoBold),
                )),
              ),
            );
          })),
    );
  }

  Widget formUI() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  SizedBox(
                    height: 20,
                  ),
                  /* Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, top: 2, bottom: 0, right: 12),
                      child: TextFormField(
                        enabled: true,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                          hintText: "Name",
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        onSaved: (String val) {},
                      ),
                    ),
                  ), */
                  Container(
                    color: Colors.white,
                    child: new TextFormField(
                      style: readOnly
                          ? TextStyles.grayedOutTextStyle
                          : TextStyles.blackOutTextStyle,
                      controller: firstNameController,
                      //enabled: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        border: OutlineInputBorder(),
                        labelText: "First Name",
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      ],
                      validator: (String value) {
                        if (value.isEmpty)
                          return "First Name cannot be blank";
                        // if(value.)
                        else
                          return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    child: new TextFormField(
                      style: readOnly
                          ? TextStyles.grayedOutTextStyle
                          : TextStyles.blackOutTextStyle,
                      controller: lastNameController,
                      //enabled: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        border: OutlineInputBorder(),
                        labelText: "Last Name",
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      ],
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty)
                          return "LastName cannot be blank";
                        else
                          return null;
                      },
                    ),
                  ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      color: Colors.white,
                      child: new TextFormField(
                        style: readOnly
                            ? TextStyles.grayedOutTextStyle
                            : TextStyles.blackOutTextStyle,
                        //enabled: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("key_email"),
                        ),
                        validator: (String value) {
                          if (ValidationUtils.isEmail(value))
                            return null;
                          else
                            return "Please input valid email";
                        },
                        keyboardType: TextInputType.emailAddress,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  phoneWidget(),
                  Container(
                    color: Colors.white,
                    child: new TextFormField(
                      style: readOnly
                          ? TextStyles.grayedOutTextStyle
                          : TextStyles.blackOutTextStyle,
                      //enabled: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                        labelText: (AppPreferences().setAddress2ForDonation)
                            ? "Address1"
                            : "Address",
                      ),
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty)
                          return AppPreferences().setAddress2ForDonation
                              ? "Address1 cannot be blank"
                              : "Address cannot be blank";
                        else
                          return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppPreferences().setAddress2ForDonation
                      ? Container(
                          color: Colors.white,
                          child: new TextFormField(
                            style: readOnly
                                ? TextStyles.grayedOutTextStyle
                                : TextStyles.blackOutTextStyle,
                            //enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              errorMaxLines: 2,
                              border: OutlineInputBorder(),
                              labelText: "Address2",
                            ),
                            controller: address2Controller,
                            keyboardType: TextInputType.text,
                            // validator: (String value) {
                            //   if (value.isEmpty)
                            //     return "Address2 cannot be blank";
                            //   else
                            //     return null;
                            // },
                          ),
                        )
                      : SizedBox.shrink(),
                  AppPreferences().setAddress2ForDonation
                      ? SizedBox(
                          height: 20,
                        )
                      : SizedBox.shrink(),
//                   Container(
//                       height: 60,
//                       child: Stack(
//                         alignment: Alignment.topCenter,
//                         children: <Widget>[
//                           Container(
//                             child: TextFormField(
//                               readOnly: false,
//                               style: style,
//                               // decoration: WidgetStyles.decoration(
//                               //     AppLocalizations.of(context)
//                               //         .translate("key_country")
//                               //         ),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                               ),
//                               initialValue: "",
//                               keyboardType: TextInputType.text,
//                               // validator: (String value) {
//                               //   if (value.isEmpty)
//                               //     return "Select Country";
//                               //   else
//                               //     return null;
//                               // },
//                             ),
//                           ),
//                           CountryCodePicker(
//                             onChanged: _onChanged,
//                             initialSelection: initCountry,
// //                  onLoadShow: showOnload,
//                             showFlag: false,
//                             showCountryOnly: true,
//                             showFlagMain: true,
//                             showFlagDialog: true,
//                             builder: _builderMethod,
//                             //comparator: (a, b) => a.name.compareTo(b.name),
//                             onInit: (code) => print(
//                                 "${code.name} ${code.dialCode} ${code.code}"),
//                           ),
//                         ],
//                       )),
                  Container(
                    child: new TextFormField(
                      style: TextStyles.mlDynamicTextStyle,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("key_country"),
                          errorMaxLines: 2),
                      controller: countryController,
                      keyboardType: TextInputType.text,
                      validator: ValidationUtils.countryValidation,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    child: new TextFormField(
                        style: readOnly
                            ? TextStyles.grayedOutTextStyle
                            : TextStyles.blackOutTextStyle,
                        //enabled: false,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                          labelText: "State",
                        ),
                        controller: stateController,
                        keyboardType: TextInputType.text,
                        validator: ValidationUtils.stateValidation),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextFormField(
                        style: readOnly
                            ? TextStyles.grayedOutTextStyle
                            : TextStyles.blackOutTextStyle,
                        controller: cityController,
                        //enabled: false,
                        //maxLength: 13,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 16),
                            border: OutlineInputBorder(),
                            labelText: "City"),
                        keyboardType: TextInputType.text,
                        validator: ValidationUtils.cityValidation),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  AppPreferences().setcountyEnabledforDonataion
                      ? Container(
                          color: Colors.white,
                          child: TextFormField(
                            style: readOnly
                                ? TextStyles.grayedOutTextStyle
                                : TextStyles.blackOutTextStyle,
                            controller: countyController,
                            //enabled: false,
                            //maxLength: 13,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 16),
                                border: OutlineInputBorder(),
                                labelText: AppPreferences()
                                        .setcountyEnabledforDonataion
                                    ? AppPreferences().countyLabelDonation
                                    : "County"),
                            keyboardType: TextInputType.text,
                            // validator: ValidationUtils.countyValidation
                          ),
                        )
                      : SizedBox.shrink(),
                  AppPreferences().setcountyEnabledforDonataion
                      ? SizedBox(
                          height: 20,
                        )
                      : SizedBox.shrink(),
                  Container(
                    color: Colors.white,
                    child: TextFormField(
                      style: readOnly
                          ? TextStyles.grayedOutTextStyle
                          : TextStyles.blackOutTextStyle,
                      controller: zipcodeController,
                      //enabled: false,
                      //maxLength: 13,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                          border: OutlineInputBorder(),
                          labelText:
                              AppPreferences().setzipcodeLabelDonation == null
                                  ? AppLocalizations.of(context)
                                      .translate("key_zip")
                                  : AppPreferences().setzipcodeLabelDonation),
                      keyboardType: AppPreferences().setzipcodeLabelDonation ==
                                  null ||
                              AppPreferences().setzipcodeValidationDonation ==
                                  "NUMBER-ONLY"
                          ? TextInputType.number
                          : TextInputType.text,

                      inputFormatters: [
                        if (AppPreferences().setzipcodeValidationDonation ==
                            "ALPHA-ONLY")
                          FilteringTextInputFormatter.allow(RegExp("[A-Za-z]"))
                        else if (AppPreferences()
                                .setzipcodeValidationDonation ==
                            "NUMBER-ONLY")
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        else
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z0-9]")),
                        LengthLimitingTextInputFormatter(
                            int.parse(AppPreferences().zipcodeLengthDonation)),
                      ],
                      validator: (String value) {
                        /* if (value.isEmpty)
                          return defaultCurrency == "INR"
                              ? AppLocalizations.of(context)
                                  .translate("key_pincode_empty")
                              : "Zipcode cannot be blank";
                        else if (value.length < 2)
                          return defaultCurrency == "INR"
                              ? AppLocalizations.of(context)
                                  .translate("key_pincodeerror")
                              : "At least 2 digits";
                        else
                          return null; */
                        if (AppPreferences().setzipcodeValidationDonation ==
                            "NO VALIDATION") {
                          return null;
                        } else {
                          if (value.isEmpty)
                            return AppPreferences().setzipcodeLabelDonation ==
                                    null
                                ? AppLocalizations.of(context)
                                        .translate("key_zip") +
                                    " cannot be blank"
                                : AppPreferences().setzipcodeLabelDonation +
                                    " cannot be blank";
                          else {
                            if (value.length < 1)
                              return "At least 1 digits";
                            else
                              return null;
                            /* var conditions = AppPreferences().setzipAdditional;
                            var s = jsonDecode(conditions);
                            // print(s.keys.toList());
                            // print(s.values.toList());
                            var valueCond = s.values.toList();
                            // var maxLength = s.values.toList()
                            if (valueCond == null || valueCond.isEmpty) {
                              return null;
                            } else {
                              if (value.length <
                                  int.parse(
                                      AppPreferences().zipcodeLengthDonation))
                                return "At least " +
                                    AppPreferences()
                                        .zipcodeLengthDonation
                                        .toString() +
                                    " digits";
                              else
                                return null;
                            } */
                          }
                        }
                      },
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget phoneWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width / 7,
            child: Stack(
                // alignment: Alignment.center,
                children: <Widget>[
                  TextFormField(
                      initialValue: " ",
                      readOnly: true,
                      validator: (arg) {
                        if (country == "" || country == null) {
                          return "Country cannot be blank ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        border: OutlineInputBorder(),
                      )),
                  Center(
                    child: CountryCodePicker(
                      onChanged: (code) {
                        setState(() {
                          countryCodeDialCode = code.dialCode;
                          country = code.name;
                        });
                      },
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      initialSelection:
                          (country == "" || country == null) ? "IN" : country,
                      showFlag: true,
                      showFlagDialog: false,
                      enabled: true,
                      onInit: (code) {},
                      builder: (code) {
                        if (country == null || country == "") {
                          return Padding(
                              padding: EdgeInsets.all(13),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      AppLocalizations.of(context)
                                          .translate("key_select"),
                                      textAlign: TextAlign.center,
                                      style: countryCodeStyle,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Icon(Icons.keyboard_arrow_down),
                                    //SizedBox(width: 10)
                                  ]));
                        } else {
                          countryCodeDialCode = code.dialCode;
                          phoneCountryCode = code.code;
                          country = code.name;
                          return Padding(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      code.dialCode.toUpperCase(),
                                      style: style,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ]));
                        }
                      },
                    ),
                  ),
                ]),
          )),
          SizedBox(
            width: 3,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.6,
              child: TextFormField(
                readOnly: false,
                controller: phoneController,
                maxLength: 10,
                textInputAction: TextInputAction.next,
                style: false ? TextStyle(color: Colors.grey) : TextStyle(),
                // decoration: WidgetStyles.decoration(
                //         AppLocalizations.of(context).translate("key_phone")) ??
                //     InputDecoration(
                //         errorMaxLines: 2,
                //         border: OutlineInputBorder(),
                //         labelText: 'Phone')
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                  border: OutlineInputBorder(),
                ),

                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                validator: (String value) {
                  if (ValidationUtils.isValidPhoneNumber(value))
                    return null;
                  else
                    return "Mobile Number not valid";
                },
                //ValidationUtils.mobileValidation,
              )),
        ]);
  }

  void _handleCheckBoxChange(bool value, String item) => setState(() {
        if (value) {
          setState(() {
            _selectedReminder = item;
          });
        }
      });

  String getTodayDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now);
    // print(formattedDate); // 2016-01-25
    return formattedDate;
  }

  void goBack() {
    Future.delayed(Duration(milliseconds: 50), () {
      widget.callbackForDonationUpdate(true);
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => NavigationHomeScreen(
      //               drawerIndex: Constants.PAGE_ID_HOME,
      //             )));
    });
  }

///// SHOW PAYMNET WIDGET////
  Widget donationPaymentWidget() {
    return Center(
      child: (paymentStatus == true || paymentStatusLoading == true)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 380,
                child: Column(
                  children: [
                    // Image.asset(
                    //   "assets/images/checklist.png",
                    //   height: 110.0,
                    //   color: Colors.lightGreen,
                    // ),
                    Text("Please wait...",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 380,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                            child: Container(
                              //color: AppColors.primaryColor,
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
                                      Text("Payment Method",
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
                                                        // debugPrint(
                                                        // "PaymentCancellationDialog on tap...");
                                                        setState(() {
                                                          hasBasicInfoValidated =
                                                              false;
                                                          // Future.delayed(
                                                          //     const Duration(
                                                          //         milliseconds: 500), () {
                                                          //   _scrollController.jumpTo(
                                                          //       _scrollController.position
                                                          //           .maxScrollExtent);
                                                          // });
                                                        });
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
                              child: PaymentsWidget(
                                totalAmount: totalAmount,
                                name: doneeUserName,
                                isOnlyCard: true,
                                email: emailController.text,
                                phoneNumber: phoneController.text,
                                departmentName: departName.text,
                                paymentDescription:
                                    "Donation by ${firstNameController.text}  ${lastNameController.text}",
                                paymentStatus: (bool payStatus,
                                    String paymentMode,
                                    String requestId) async {
                                  // debugPrint("payStatus --> $payStatus");
                                  // debugPrint("paymentMode --> $paymentMode");
                                  // debugPrint("requestId --> $requestId");
                                  setState(() {
                                    paymentStatusLoading = true;
                                  });
                                  if (paymentMode == "Card") {
                                    // print('++++++++++++payStatus++++++');

                                    if (payStatus) {
                                      List<PaymentInfo> paymentInfoList =
                                          await _membershipRepository
                                              .getMembershipTransactionDetails(
                                                  requestId: requestId,
                                                  transactionType: "DONATION");
                                      if (paymentInfoList.isNotEmpty &&
                                          paymentInfoList[0]
                                                  .transactionStatus ==
                                              "success") {
                                        //Utils.toasterMessage(" Payment Success");

                                        paymentInfoObj = paymentInfoList[0];
                                        setState(() {
                                          paymentStatus = true;
                                          paymentStatusLoading = false;
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          donationAPICall();
                                        });
                                      } else {
                                        //Utils.toasterMessage(" transaction failed");
                                        setState(() {
                                          paymentStatus = false;
                                          paymentStatusLoading = false;
                                          hasBasicInfoValidated = false;
                                        });
                                      }

                                      ///
                                    } else {
                                      setState(() {
                                        paymentStatus = false;
                                        paymentStatusLoading = false;
                                        hasBasicInfoValidated = false;
                                      });
                                    }
                                  } else {
                                    // print('++++++++++++payStatus Failed++++++');

                                    //Utils.toasterMessage(" Payment failed");
                                    setState(() {
                                      paymentStatus = false;
                                      paymentStatusLoading = false;
                                      hasBasicInfoValidated = false;
                                    });
                                  }
                                },
                                globalKey: _scaffoldKey,
                                transactionType: TransactionType.DONATION,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Show Banner Ad
                getSivisoftAdWidget(),
              ],
            ),
    );
  }

///// SHOW PAYMNET WIDGET////
  Widget totalAmountCard() {
    return Column(
      children: [
        Card(
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: Colors.brown,
                width: 0.5,
              ),
            ),
            elevation: 10,
            color: Colors.grey[100],
            margin: EdgeInsets.all(12),
            child: Container(
              // height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Image.asset("assets/images/donationGiving.png",
                        height: 60),
                  ),
                  Text(
                    'Donation Amount: ' + currency + amountController.text,
                    style: amountBlackTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Service Charges: 4%',
                    style: amountBlackTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Total: ' +
                              currency +
                              '' +
                              double.parse((totalAmount).toStringAsFixed(2))
                                  .toString() +
                              " $currencySuffix",
                          style: totalTextStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ))
      ],
    );
  }

  _onChanged(CountryCode code) async {
    setState(() {
      initCall = true;
    });
  }

  _builderMethod(code) {
    if (initCall) {
      countryController.text = code.name;
    }
    return Padding(
        padding: EdgeInsets.symmetric(/*vertical: 10,*/ horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Expanded(
              child: Text(
                  !initCall
                      ? AppLocalizations.of(context).translate("key_contry")
                      : code.name,
                  style: !initCall ? countryStyle : style)),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {},
          )
        ]));
  }

  void createDonationInfo() async {
    String donationAmount =
        amountController.text.length == 0 ? 0 : amountController.text;

    if (double.parse(donationAmount) < minAmount ||
        double.parse(donationAmount) > maxAmount) {
      AlertUtils.showAlertDialog(context, amountLimitMessage);
    }
    // else if (selectedDonationPurpose.length == 0) {
    //   AlertUtils.showAlertDialog(
    //     context,
    //     "Please select cause of donation on the top",
    //   );
    // }
    else {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        doneeUserName = await AppPreferences.getUsername();
        setState(() {
          hasBasicInfoValidated = true;
        });
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }
  }

  void updateDonationAPICall() async {
    Donation donationObj = widget.dObj;
    debugPrint("raw amount");
    debugPrint(rawAmount.toString());
    debugPrint("donationObj.achieved_amount");
    debugPrint(donationObj.achieved_amount.toString());
    donationObj.achieved_amount = /* donationObj.achieved_amount + */ rawAmount;
    Map<String, dynamic> data = donationObj.toJson();

    CustomProgressLoader.showLoader(context);
    String body = json.encode(data);
    String url = WebserviceConstants.baseFilingURL +
        "/donationcause/${donationObj.causeId}";
    String clientId = await AppPreferences.getClientId();
    Map<String, String> header = {};
    header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.username, () => doneeUserName);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent("clientid", () => clientId);

    http.Response response = await http
        .put(url, headers: header, body: body)
        .timeout(
            Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
            onTimeout: _onTimeOut);

    CustomProgressLoader.cancelLoader(context);

    // debugPrint(
    //     "+__+____+_______+__)))())_____response+__+____+_______+__)))())_____");
    // print(
    //     "+__+____+_______+__)))())_____response+__+____+_______+__)))())_____");

    debugPrint(data.toString());
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201 || response.statusCode == 200) {
      Utils.toasterMessage(" Donation updated");

      goBack();
    } else {
      AlertUtils.showAlertDialog(context, "Error");
    }
  }

  void donationAPICall() async {
    if (widget.dObj.causeTitle != "General") {
      var dateTimeArray = getTodayDate().split(" ");
      var dateateTimeInUTC = dateTimeArray[0] + "T" + dateTimeArray[1];
      // debugPrint(dateateTimeInUTC);

      DonationModel info = new DonationModel();
      info.active = true;
      info.firstName =
          firstNameController.text == null ? "" : firstNameController.text;
      info.lastName =
          lastNameController.text == null ? "" : lastNameController.text;
      info.city = cityController.text == null ? "" : cityController.text;
      info.countryCodeValue = countryCodeDialCode.replaceAll("+", "");
      info.countryCode = phoneCountryCode;
      info.mobileNumber =
          countryCodeDialCode.replaceAll("+", "") + phoneController.text;
      info.emailId = emailController.text == null ? "" : emailController.text;
      info.country =
          countryController.text == null ? "" : countryController.text;
      info.state = stateController.text == null ? "" : stateController.text;
      info.address =
          addressController.text == null ? "" : addressController.text;
      // info.address = address2Controller.text == null ? "" : address2Controller.text;
      // info.county = countyController.text == null ? "" : countyController.text;
      info.comments =
          commnetsController.text == null ? "" : commnetsController.text;
      info.createdBy = doneeUserName;
      info.createdOn = dateateTimeInUTC;
      if (selectedDonationPurpose != "Other events")
        info.donatedTo = selectedDonationPurpose;
      else
        info.donatedTo = otherEventsController.text;
      // info.donatedTo =
      //     selectedDonationPurpose == null ? "" : selectedDonationPurpose;
      info.donationAmount = amountController.text;
      info.donationDescription =
          "Donation by ${firstNameController.text}  ${lastNameController.text}";
      info.donationType = selectedDonationPurpose;
      info.modifiedBy = doneeUserName;
      info.modifiedOn = dateateTimeInUTC;
      info.donationStatus = "SUCCESS";
      info.paymentId = paymentInfoObj.paymentId;
      info.donationCurrency = AppPreferences().defaultCurrency;
      info.transactionId = paymentInfoObj.transactionId;
      info.reminder = _selectedReminder;
      info.zipcode = zipcodeController.text;

      // print("++++++++**********");

      // print("Info ${info.toJson()}");

      Map<String, dynamic> data = info.toJson();

      CustomProgressLoader.showLoader(context);
      String body = json.encode(data);
      String url = WebserviceConstants.baseFilingURL + "/donation";
      String clientId = await AppPreferences.getClientId();
      Map<String, String> header = {};
      header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
      header.putIfAbsent(WebserviceConstants.username, () => doneeUserName);
      header.putIfAbsent(WebserviceConstants.contentType,
          () => WebserviceConstants.applicationJson);
      header.putIfAbsent("clientid", () => clientId);

      http.Response response = await http
          .post(url, headers: header, body: body)
          .timeout(
              Duration(seconds: WebserviceConstants.apiServiceTimeOutInSeconds),
              onTimeout: _onTimeOut);

      CustomProgressLoader.cancelLoader(context);

      // debugPrint(
      //     "+__+____+_______+__)))())_____response+__+____+_______+__)))())_____");
      // print(
      //     "+__+____+_______+__)))())_____response+__+____+_______+__)))())_____");

      // debugPrint(response.body);
      // print(response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Utils.toasterMessage(" Donation updated");
        info = DonationModel.fromJson(jsonDecode(response.body));
        updateDonationAPICall();
      } else {
        AlertUtils.showAlertDialog(context, "Error");
      }
    } else {
      Utils.toasterMessage("Payment Successfull");
      Navigator.pop(context);
    }
  }

  Future<http.Response> _onTimeOut() {}
  TextStyle countryStyle = TextStyle(
    fontFamily: Constants.LatoRegular,
    color: Colors.black38,
    fontSize: 15.0,
  );
  TextStyle style = TextStyle(
      fontFamily: Constants.LatoRegular,
      fontSize: 15.0,
      color: Color(ColorInfo.BLACK));

  final TextStyle amountTextStyle = TextStyle(
      fontSize: 20, fontFamily: Constants.LatoBold, color: Colors.black);
  final TextStyle amountWhiteTextStyle = TextStyle(
      fontSize: 20, fontFamily: Constants.LatoBold, color: Colors.white);

  final TextStyle amountBlackTextStyle = TextStyle(
      fontSize: 20, fontFamily: Constants.LatoBold, color: Colors.black);

  final TextStyle totalTextStyle = TextStyle(
    fontSize: 40,
    fontFamily: Constants.LatoBold,
    color: Colors.black,
  );
}
