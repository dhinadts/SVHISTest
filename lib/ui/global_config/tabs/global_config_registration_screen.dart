import '../../../bloc/global_configuration_bloc.dart';
import '../../../bloc/user_info_bloc.dart';
import '../../../country_picker_util/country_code_picker.dart';
import '../../../login/colors/color_info.dart';
import '../../../login/utils/custom_progress_dialog.dart';
import '../../../login/utils/utils.dart';
import '../../../model/global_config_reg_request.dart';
import '../../../model/simplify_login_model.dart';
import '../../../ui_utils/network_check.dart';
import '../../../ui_utils/text_styles.dart';
import '../../../ui_utils/ui_dimens.dart';
import '../../../ui_utils/widget_styles.dart';
import '../../../utils/alert_utils.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/basic_text_field_widget.dart';
import '../../../widgets/reset_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalConfigRegistrationTab extends StatefulWidget {
  final ValueChanged<SimplifyLoginModel> simplifyLogDetailsCallBack;
  final UserInfoBloc bloc;

  GlobalConfigRegistrationTab({this.simplifyLogDetailsCallBack, this.bloc});

  @override
  GlobalConfigRegistrationTabState createState() =>
      GlobalConfigRegistrationTabState();
}

class GlobalConfigRegistrationTabState
    extends State<GlobalConfigRegistrationTab>
    with AutomaticKeepAliveClientMixin<GlobalConfigRegistrationTab> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final organizationController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final dateController = TextEditingController();
  final daysController = TextEditingController();
  final maxUsersController = TextEditingController();

  final countryController = TextEditingController();
  final passwordController = TextEditingController();

  String countryCodeDialCode = Constants.INDIA_CODE;
  String country, maxUsers;
  bool _autoValidate = false;
  List<String> maxUsersArr = List();

  @override
  void initState() {
    super.initState();
    for (int i = 5; i <= 30; i += 5) {
      maxUsersArr.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setGlobalContext(context);
    return Scaffold(
        body: Form(
            key: registerFormKey,
            autovalidate: _autoValidate,
            child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppUIDimens.paddingMedium,
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    BasicTextField(
                      controller: firstNameController,
                      hint: "Firstname",
                      textStyle: TextStyles.textStyle100,
                      validator: ValidationUtils.firstNameValidation,
                    ),
                    BasicTextField(
                      controller: lastNameController,
                      hint: "Lastname",
                      textStyle: TextStyles.textStyle100,
                      validator: ValidationUtils.lastNameValidation,
                    ),
                    BasicTextField(
                      controller: userNameController,
                      hint: "Username",
                      textStyle: TextStyles.textStyle100,
                      validator: ValidationUtils.usernameValidation,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ResetPasswordWidget(
                      passwordController: passwordController,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    phoneNo(),
                    BasicTextField(
                      controller: emailController,
                      hint: "Email",
                      textStyle: TextStyles.textStyle100,
                      validator: ValidationUtils.emailValidation,
                    ),
                    BasicTextField(
                      controller: organizationController,
                      hint: "Organization",
                      validator: (s) {
                        if (s == null || s.trim().isEmpty || isNumeric(s)) {
                          return "Please enter valid Organization";
                        } else {
                          return null;
                        }
                      },
                      textStyle: TextStyles.textStyle100,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text("Number Of Users")),
                        Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Stack(
//                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Container(
                                    child: TextFormField(
                                      readOnly: false,
                                      style: TextStyles.textStyle100,
                                      decoration: WidgetStyles.decoration(
                                          "Number of Users"),
                                      initialValue: " ",
                                      keyboardType: TextInputType.text,
                                      validator: (s) {
                                        if (maxUsers == null) {
                                          return "Please select Number of users";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  Center(
                                      child: DropdownButton<String>(
                                    isExpanded: true,
                                    underline: Container(),
                                    hint: Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        maxUsers == null ? 'Select' : maxUsers,
                                        style: maxUsers == null
                                            ? TextStyle(fontSize: 16)
                                            : TextStyles.textStyle100,
                                      ),
                                    ),
                                    items: maxUsersArr.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(
                                          value,
                                          style: TextStyles.textStyle100,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      setState(() {
                                        maxUsers = _;
                                      });
                                    },
                                  ))
                                ])),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    countrySpinner(),
                    SizedBox(
                      height: 20,
                    ),
                    new InkWell(
                      child: new Container(
                          height: 50.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(ColorInfo.APP_BLUE),
                          ),
                          child: new Center(
                            child: new Text(
                              "Register",
                              style: TextStyle(
                                  color: Color(ColorInfo.WHITE),
                                  fontSize: 18.0,
                                  fontFamily: Constants.LatoRegular),
                            ),
                          )),
                      onTap: _registerSubmit,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )))));
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  _registerSubmit() async {
    if (registerFormKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      registerFormKey.currentState.save();

      var connectivityResult = await NetworkCheck().check();
      if (connectivityResult) {
        CustomProgressLoader.showLoader(context);
        GlobalConfigRegRequest request = GlobalConfigRegRequest();
        request.country = country;
        request.countryCode = country;
        request.countryCodeValue =
            '${countryCodeDialCode.replaceFirst("+", "")}';
        request.mobileNo = '${phoneController.text}';
        request.userName = userNameController.text;
        request.emailId = emailController.text;
        request.noOfUsers = int.parse(maxUsers);
        request.password = passwordController.text;
        request.firstName = firstNameController.text;
        request.lastName = lastNameController.text;
        request.countryName = countryController.text;
        request.registerSource = "MOBILE";
        request.organisationName = organizationController.text;
        request.environmentCode = "SDX_PROD";

        GlobalConfigurationBloc _bloc = GlobalConfigurationBloc(context);
        _bloc.globalConfigurationsCreateRequest(request);
        // print('Request  ${request.toJson().toString()}');
        _bloc.createGlobalConfigurationFetcher.listen((value) {
          CustomProgressLoader.cancelLoader(context);
          if (value.superPromoCode != null && value.superPromoCode.isNotEmpty) {
            // print("user Token ${value.superPromoCode}");
            Fluttertoast.showToast(
                msg: "Registration successful",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);
            widget.simplifyLogDetailsCallBack(SimplifyLoginModel(
                username: userNameController.text,
                password: passwordController.text,
                userPromoCode: value.superPromoCode));
          } else {
            AlertUtils.showAlertDialog(context, value.message);
          }
        });
      } else {
        Utils.toasterMessage(Constants.NO_INTERNET_CONNECTION);
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  bool initCall = false;
  String initCountry = "IN";

  _builderMethod(code) {
    if (initCall) {
      countryController.text = code.name;
    }
    return Padding(
        padding: EdgeInsets.symmetric(/*vertical: 10,*/ horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Expanded(
              child: Text(!initCall ? "Select your country" : code.name,
                  style: !initCall
                      ? TextStyles.countryInitSpinnerStyle
                      : TextStyles.textStyle100)),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
          )
        ]));
  }

  _onChanged(CountryCode code) async {
    setState(() {
      initCall = true;
      country = code.code;
    });
  }

  Widget countrySpinner() {
    return Container(
        child: Stack(
//      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          child: TextFormField(
            readOnly: false,
            style: TextStyles.textStyle100,
            decoration: WidgetStyles.decoration("Country"),
            initialValue: " ",
            keyboardType: TextInputType.text,
            validator: (s) {
              if (country == null) {
                return "Please select your country";
              } else {
                return null;
              }
            },
          ),
        ),
        CountryCodePicker(
          onChanged: _onChanged,
          initialSelection: initCountry,
//                  onLoadShow: showOnload,
          showFlag: false,
          showCountryOnly: true,
          showFlagMain: true,
          showFlagDialog: true,
          builder: _builderMethod,
          //comparator: (a, b) => a.name.compareTo(b.name),
          onInit: (code) => print("${code.name} ${code.dialCode} ${code.code}"),
        ),
      ],
    ));
  }

  Widget phoneNo() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width / 7,
            child: Stack(/*alignment: Alignment.center,*/
                children: <Widget>[
              TextFormField(
                //initialValue: " ",
                readOnly: true,
                decoration: WidgetStyles.decoration("") ??
                    InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                validator: (arg) {
                  if (country == null || country == "") {
                    return " ";
                  }
                  return null;
                },
              ),
              Center(
                child: CountryCodePicker(
                  onChanged: (code) {
                    setState(() {
                      countryCodeDialCode = code.dialCode;
                      country = code.code;
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
                          padding:
                              EdgeInsets.only(top: 12, right: 10, left: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  "Select",
                                  textAlign: TextAlign.center,
                                  style: TextStyles.countryCodeStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                Icon(Icons.keyboard_arrow_down),
                                //SizedBox(width: 10)
                              ]));
                    } else {
                      countryCodeDialCode = code.dialCode;
                      country = code.code;
                      return Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  code.dialCode.toUpperCase(),
                                  //style: TextStyles.countryCodeStyle,
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
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                readOnly: false,
                controller: phoneController,
                maxLength: 10,
                textInputAction: TextInputAction.next,
                style: false ? TextStyle(color: Colors.grey) : TextStyle(),
                decoration: WidgetStyles.decoration("Enter Phone No") ??
                    InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                validator: ValidationUtils.mobileValidation,
              )),
        ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
