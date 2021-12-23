import 'dart:convert';

import '../model/env_props.dart';
import '../model/user_info.dart';
import '../repo/common_repository.dart';
import '../ui_utils/app_colors.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class AppPreferences {
  static AppPreferences _instance = AppPreferences._internal();

  AppPreferences._internal();

  factory AppPreferences() => _instance;
  static String _zipcodeLabelDonationKey = "zipcode_label_donation";
  static String _zipcodeValidationDonationKey = "zipcode_validation_donation";
  static String _zipcodeAdditionalInfoDonationKey = "zipcode_Additional_INfo";
  static String _zipcodeLengthDonationKey = "county_length_donation";
  static String _timeFormatKey = "timeFormatKey";
  static String _countyLabelDonationKey = "county_label_donation";
  static String _address2forDonataionKey = "address2_donation";
  static String _countyEnabledforDonataionKey = "county_enabled_for_Donataion";
  static const _introPageViewed = "intro_page_viewed";
  static const _oauth2Token = "oauth2_token";
  static const _loggedInStatus = "oauth2_token";
  static const _globalStatus = "global_token";
  static const _historyStatus = "history_status_token";
  static const _checkInStatus = "check_in_status_token";
  static const _passwordStatus = "password_status_token";
  static const _physicianStatus = "physician_status_token";
  static const _singUpStatus = "signup_token";
  static const _usernameKey = "username";
  static const _addressKey = "address";
  static const _fullNameKey = "fullname";
  static const _fullSecondNameKey = "fullsecondname";
  static const _roleKey = "role_key";
  static const _deptKey = "dept_key";
  static const _versionKey = "version_key";
  static const _phoneKey = "phone_key";
  static const _emailKey = "email_key";

  /// B2C
  static const _tokenKey = "token_key";
  static const _userGroupKey = "user_group";
  static const _firstNameKey = "first_name";

  /// End here

  static const _dobKey = "dob_key";
  static const _countryKey = "country_key";
  static const _bloodKey = "blood_key";
  static const _apiUrlKey = "url_key";
  static const _getMenuItemsKey = "menu_items_key";
  static const _tenantKey = "tenant_key";
  static const _latLongKey = "lar_long_key";
  static const _termsKey = "terms_key";
  static const _physicianKey = "physician_key";
  static const _userInfoKey = "user_info_key";
  static const _logoUrlKey = "logo_url";
  static const _clientNameKey = "client_name";
  static const _gcPageShowing = "gc_page_is_showing";
  static const _noticeBoardPageDataKey = "notice_board_page_key";
  static const _environmentCodeKey = "environment_code_key";
  static const _heightKey = "height_key";
  static const _weightKey = "weight_key";
  static const _clientIdKey = "client_id_key";
  static const _consideredDomainKey = "considered_domain_key";
  static const _envPropsKey = "environment_properties";
  static const _currencyKey = "client_currency";
  static const _envShortCodeKey = "environment_short_code";
  static const _userDailyCheckinEnabledKey = "userDailyCheckinEnabled";
  static const _userDailyCheckinReportEnabledKey =
      "userDailyCheckinReportEnabled";
  static const _userProfileHistoryEnabledKey = "userProfileHistoryEnabled";
  static const _signupTermsandConditionsKey = "signupTermsandConditions";
  static const _membershipTermsandConditionsKey =
      "membershipTermsandConditions";
  static const _memershipBenefitsContentKey = "memershipBenefitsContent";
  static const _appIdKey = "appID";
  static const _appTokenKey = "appToken";
  static const _adunitKey = "adunit";
  static const _adAppIdKey = "adAppId";
  static const _declarationKey = "declaration";
  static const _userCategoryKey = "userCategory";
  static String _cashPaymentDesciptionKey = "cashPaymentDesciption";
  static String _cashPaymentEnableKey = "cashPaymentEnable";

  static String _membershipWorkFlowKey = "membershipWorkFlowKey";
  static String _supportDocumentKey = "supportDocumentKey";
  static String _recentActivityOptionsKey = "recentActivityFields";
  static String _setRoleTypesKey = "platformScheduleExposeRoleTypes";
  static String _jwtTokenKey = "jwtToken";
  static String _defaultTimeZoneKey = "defaultTimeZoneKey";
  static String _defaultDateFormatKey = "defaultDateFormatKey";
  static String _membershipFeeRequiredKey = "membershipFeeRequiredKey";
  static String _displayTextKey = "displayTextKey";
  static String _paypalSecretKey = "paypalSecretKey";
  static String _paypalSecretIdKey = "paypalSecretIdKey";
  static String _razorPaySecretKey = "razorPaySecretKey";
  static String _enablePaymentsKey = "enablePaymentsKey";
  static String _razorPayMerchantKey = "razorPayMerchantKey";
  static String _supportCategoryKey = "supportCategoryKey";
  static String _appNameKey = "appName";
  static String _authorizationKey = "authorization";
  static String _hostUrlKey = "hostUrl";
  static String _guiSettingsKey = "guiSettings";
  static String _errorMessageKey = "errorMessage";
  static String _siteNavigatorKey = "siteNavigator";
  static String _defaultPaymentGatewayKey = "defaultPaymentGatwayKey";
  static String _appColorKey = "appColorKey";
  static String _adUnitBannerKey = "adUnitBanner";
  static const _isUserEligibleForBluetoothKey =
      "is_user_eligible_for_bluetooth_key";
  static const String promoDeparmentNameKey = "promoDeparmentName";
  static String setLegacyKey = "legacy_home_page";
  static String setNewsFeedKey = "newsfeed";
  static String setRemaindersKey = "remainders";
  static String _apiErrorMessageKey = "_apiErrorMessageKey";
  static const _currencySymbolKey = "client_currency_symbol";

  static const _currencySuffixKey = "client_currency_suffix";
  static const _userMemberShipTypeKey = "userMembershipType";
  static const subdeptSupervisorUsermodAccessEnabledKey =
      "subdeptSupervisorUsermodAccessEnabled";

  static String _menuStyleKey = "menu_style";

  String _setzipcodeLabelDonation;
  String _setzipcodeValidationDonation;
  String _zipcodeAdditionalInfoDonation;
  String _zipcodeLengthDonation;
  String _promoDepartmentName;
  String _countyLabelDonation;
  bool _setAddress2ForDonation;
  bool _setcountyEnabledforDonataion;
  bool _setLegacy;
  bool _newsFeed;
  bool _remainders;
  static String _agoraConnectOptionKey = "agoraConnectOption";
  static String _newsFeedEnabledKey = "newsFeedEnabled";
  static String _modernizeEnabledKey = "modernizeEnabled";
  static String _remindersEnabledKey = "remindersEnabled";
  static String _isMembershipApplicableKey = "membershipApplicable";
  bool _loginStatus;
  bool _historySaved;
  bool _checkInSaved;
  bool _physicianSaved;
  String _username;
  String _deptmentName;
  String _role;
  String _fullName;
  String _fullName2;
  String setterCountry;
  UserInfo _userInfo;
  bool _terms;
  bool _signUp;
  bool _gcPageIsShowing;
  String _email;

  /// B2C
  String _token;
  String _userGroup;
  String _firstName;

  /// End Here
  String _phoneNo;
  String _apiUrl;
  String _menuItemsData;
  String _tenant;
  String _latAndLang;
  bool _profileUpdate;
  bool userDailyCheckinEnabled;
  bool _passwordChanged;
  bool _isDailyCheckInEnabled;
  static const _langKey = "landguage_key";
  String _language;
  String _version;
  String _environmentCode;
  String _height;
  String _weight;
  String _clientId;
  String _consideredDomain;
  String _currency;
  String _hostUrl;
  List<String> _supportCategory;
  String _siteNavigator;
  BuildContext _context;
  String _userCategory;
  bool timeformat;
  String _defaultPaymentGateway;
  bool _isAdditionalInformationAvl;
  bool _isCheckInAvl;
  String _appName;
  String _primaryColor;
  BluetoothDevice _selectedConnectedDevice;
  BluetoothConnection _connection;
  bool _isUserEligibleForBluetooth;
  String _defaultDateFormat;
  String _currencySymbol;
  String _currencySuffix;
  String _userMemberShipType;
  String _environmentShortCode;
  String _subdeptSupervisorUsermodAccessEnabled;
  String _menuStyle;
  String _guiSettings;
  String _apiErrorMessage;

  bool _isMembershipApplicable;

  String get setzipAdditional => _zipcodeAdditionalInfoDonation;

  String get setzipcodeLabelDonation => _setzipcodeLabelDonation;

  String get setzipcodeValidationDonation => _setzipcodeValidationDonation;

  String get zipcodeLengthDonation => _zipcodeLengthDonation;

  String get countyLabelDonation => _countyLabelDonation;

  bool get setcountyEnabledforDonataion => _setcountyEnabledforDonataion;

  bool get setAddress2ForDonation => _setAddress2ForDonation;

  bool get setLegacy => _setLegacy;

  bool get setTimFormat => _setLegacy;

  bool get setNewsFeed => _newsFeed;

  bool get setRemainders => _remainders;

  List<String> get getSupportCategoryList => _supportCategory;

  String get defaultDateFormat => _defaultDateFormat;

  String get primaryColor => _primaryColor;

  String get defaultPaymentGateway => _defaultPaymentGateway;

  String get hostUrl => _hostUrl;

  String get siteNavigator => _siteNavigator;

  bool get isAdditionalInformationAvl => _isAdditionalInformationAvl;

  bool get isCheckInAvl => _isCheckInAvl;

  String get version => _version;

  String get language => _language;

  BuildContext _setContext;

  BuildContext get mContext => _setContext;

  String get environmentCode => _environmentCode;

  String get phoneNo => _phoneNo;

  String get latAndLang => _latAndLang;

  bool get isDailyCheckInEnabled => _isDailyCheckInEnabled;

  bool get profileUpdate => _profileUpdate;

  bool get passwordChanged => _passwordChanged;

  bool get historySaved => _historySaved;

  bool get checkInSaved => _checkInSaved;

  bool get physicianSaved => _physicianSaved;

  bool get loginStatus => _loginStatus;

  String get username => _username;

  String get userCategory => _userCategory;

  String get country => setterCountry;

  String get deptmentName => _deptmentName;

  String get role => _role;

  String get fullName => _fullName;

  String get fullName2 => _fullName2;

  UserInfo get userInfo => _userInfo;

  String get email => _email;

  /// B2C
  String get token => _token;
  String get userGroup => _userGroup;
  String get firstName => _firstName;

  /// End here

  String get apiURL => _apiUrl;

  String get defaultCurrency => _currency;

  String get defaultCurrencySymbol => _currencySymbol;

  String get defaultCurrencySuffix => _currencySuffix;

  String get menuItemsData => _menuItemsData;

  String get tenant => _tenant;

  String get weight => _weight;

  String get height => _height;

  bool get terms => _terms;

  bool get signUp => _signUp;

  bool get gcPageIsShowing => _gcPageIsShowing;

  String get clientId => _clientId;

  String get appName => _appName;

  String get consideredDomain => _consideredDomain;

  String get promoDeparmentName => _promoDepartmentName;

  bool get isMembershipApplicable => _isMembershipApplicable;

  BluetoothConnection get connection => _connection;

  BuildContext get context => _context;

  String get getApisErrorMessage => _apiErrorMessageKey;

  BluetoothDevice get selectedConnectedDevice => _selectedConnectedDevice;

  bool get isUserEligibleForBluetooth => _isUserEligibleForBluetooth;

  String get userMemberShipType => _userMemberShipType;
  String get environmentShortCode => _environmentShortCode;
  String get subdeptSupervisorUsermodAccessEnabled =>
      _subdeptSupervisorUsermodAccessEnabled;

  String get menuStyle => _menuStyle;

  String get guiSettings => _guiSettings;

  init() async {
    // _apiUrl = await AppPreferences.getApiUrl();
    _subdeptSupervisorUsermodAccessEnabled =
        await AppPreferences.getSubdeptSupervisorUsermodAccessEnabled();
    _promoDepartmentName = await AppPreferences.getPromoDepartmentName();
    _setLegacy = await AppPreferences.getLegacyFromEnvProps();
    _newsFeed = await AppPreferences.getNewsFeedFromEnvProps();
    _remainders = await AppPreferences.getRemaindersFromEnvProps();
    _defaultDateFormat = await AppPreferences.getDefaultDateFormat();
    _version = await AppPreferences.getVersion();
    _gcPageIsShowing = await AppPreferences.isGCPageIsShowing();
    _language = await AppPreferences.getLanguage();
    _loginStatus = await AppPreferences.getLoginStatus();
    _username = await AppPreferences.getUsername();
    _userCategory = await AppPreferences.getUserCategory();
    _deptmentName = await AppPreferences.getDeptName();
    _role = await AppPreferences.getRole();
    _fullName = await AppPreferences.getFullName();
    _fullName2 = await AppPreferences.getSecondFullName();
    _email = await AppPreferences.getEmail();
    _supportCategory = await AppPreferences.getSupportCategory();

    /// B2C
    _token = await AppPreferences.getToken();
    _userGroup = await AppPreferences.getUserGroup();
    _firstName = await AppPreferences.getFirstName();
    _apiErrorMessage = await AppPreferences.getApiErrorMessage();

    /// End here
    timeformat = await AppPreferences.getTimeFormat();
    _terms = await AppPreferences.getTermsAcceptance();
    _historySaved = await AppPreferences.isHistorySaved();
    _checkInSaved = await AppPreferences.isCheckInSaved();
    _physicianSaved = await AppPreferences.isPhysicianSaved();
    _latAndLang = await AppPreferences.getLatLang();
    _signUp = await AppPreferences.getSignUpStatus();
    setterCountry = await AppPreferences.getCountry();
    _phoneNo = await AppPreferences.getPhone();
    _apiUrl = await AppPreferences.getApiUrl();
    _menuItemsData = await AppPreferences.getMenuItemsData();
    _tenant = await AppPreferences.getTenant();
    _profileUpdate = await AppPreferences.getProfileUpdate();
    _environmentCode = await AppPreferences.getEnvironment();
    _passwordChanged = await AppPreferences.isPasswordChanged();
    _height = await AppPreferences.getHeight();
    _weight = await AppPreferences.getWeight();
    _clientId = await AppPreferences.getClientId();
    _appName = await AppPreferences.getAppName();
    _consideredDomain = await AppPreferences.getConsideredDomain();
    _userInfo = await AppPreferences.getUserInfo();
    _currency = await AppPreferences.getDefaultCurrency();
    _currencySuffix = await AppPreferences.getDefaultCurrencySuffix();
    _currencySymbol = await AppPreferences.getDefaultCurrencySymbol();
    _isDailyCheckInEnabled =
        await AppPreferences.getDailyCheckinReportEnabled();
    _isAdditionalInformationAvl =
        await AppPreferences.getProfileHistoryEnabled();
    _isCheckInAvl = await AppPreferences.getUserDailyCheckinEnabled();
    _hostUrl = await AppPreferences.getHostUrl();
    _siteNavigator = await AppPreferences.getSiteNavigator();
    _defaultPaymentGateway = await AppPreferences.getDefaultPaymentGateway();
    _primaryColor = await AppPreferences.getAppColor();
    _isUserEligibleForBluetooth =
        await AppPreferences.getUserEligibleForBluetooth();
    _zipcodeAdditionalInfoDonation =
        await AppPreferences.getZipcodeValidationAdditionalInfoforDonation();
    _setzipcodeLabelDonation =
        await AppPreferences.getZipcodeLabelforDonation();
    _setzipcodeValidationDonation =
        await AppPreferences.getZipcodeValidationforDonation();

    _zipcodeLengthDonation = await AppPreferences.getZipcodeLengthforDonation();

    _countyLabelDonation = await AppPreferences.getCountyLabelforDonation();
    _setcountyEnabledforDonataion =
        await AppPreferences.getCountyEnabledforDonataion();
    _environmentShortCode = await AppPreferences.getEnvironmentShortCode();
    _setAddress2ForDonation = await AppPreferences.getaddress2forDonataion();
    _userMemberShipType = await AppPreferences.getUserMembershipType();
    _isMembershipApplicable = await AppPreferences.getIsMembershipApplicable();

    _menuStyle = await AppPreferences.getMenuStyle();

    _guiSettings = await AppPreferences.getGUISettings();

//    await GlobalConfiguration().loadFromAsset("app_global.json");
  }

  /* static Future<void> setSubdeptSupervisorUsermodAccessEnabled(
      bool setLegacy) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(
        subdeptSupervisorUsermodAccessEnabledKey, setLegacy));
    await AppPreferences().init();
  }

  static Future<bool> getSubdeptSupervisorUsermodAccessEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool setLegacy =
        localStorage.getBool(subdeptSupervisorUsermodAccessEnabledKey);
    return setLegacy;
  } */
  static setSubdeptSupervisorUsermodAccessEnabled(
      String supportDocument) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(
        subdeptSupervisorUsermodAccessEnabledKey, supportDocument);
    await AppPreferences().init();
  }

  static Future<String> getSubdeptSupervisorUsermodAccessEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String supportDocuments =
        localStorage.getString(subdeptSupervisorUsermodAccessEnabledKey);
    return supportDocuments ?? null;
  }

  static Future<void> setaddress2forDonataion(bool setLegacy) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_address2forDonataionKey, setLegacy));
    await AppPreferences().init();
  }

  static Future<bool> getaddress2forDonataion() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool setLegacy = localStorage.getBool(_address2forDonataionKey);
    return setLegacy;
  }

  static Future<void> setCashPaymentEnable(dynamic cashPaymentEnable) async {
    cashPaymentEnable = getBoolValueFromString(cashPaymentEnable);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_cashPaymentEnableKey, cashPaymentEnable));
    await AppPreferences().init();
  }

  static Future<bool> getCashPaymentEnable() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool setLegacy = localStorage.getBool(_cashPaymentEnableKey);
    return setLegacy;
  }

  /* static Future<void> setaddress2forDonataion(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _address2forDonataionKey, value: loginStatus.toString()));
  }

  static Future<bool> getaddress2forDonataion() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _address2forDonataionKey) == null &&
        storage.read(key: _address2forDonataionKey).toString() == "false")
      return false;
    else
      return true;
  }
 */
  static setCountyLabelforDonation(String defaultDateFormat) async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // await localStorage.setString(_defaultDateFormatKey, defaultDateFormat);
    // await AppPreferences().init();
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _countyLabelDonationKey, value: defaultDateFormat));
    await AppPreferences().init();
    // print(await getDefaultDateFormat());
  }

  static Future<String> getCountyLabelforDonation() async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // String consideredDomain = localStorage.getString(_defaultDateFormatKey);
    // return consideredDomain ?? null;
    final storage = FlutterSecureStorage();
    return storage.read(key: _countyLabelDonationKey) ?? null;
  }

  static setZipcodeLabelforDonation(String defaultDateFormat) async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // await localStorage.setString(_defaultDateFormatKey, defaultDateFormat);
    // await AppPreferences().init();
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _zipcodeLabelDonationKey, value: defaultDateFormat));
    await AppPreferences().init();
    // print(await getDefaultDateFormat());
  }

  static Future<String> getZipcodeLabelforDonation() async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // String consideredDomain = localStorage.getString(_defaultDateFormatKey);
    // return consideredDomain ?? null;
    final storage = FlutterSecureStorage();
    return storage.read(key: _zipcodeLabelDonationKey) ?? null;
  }

  static setZipcodeValidationforDonation(String defaultDateFormat) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _zipcodeValidationDonationKey, value: defaultDateFormat));
    await AppPreferences().init();
  }

  static Future<String> getZipcodeValidationforDonation() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _zipcodeValidationDonationKey) ?? null;
  }

  static setZipcodeValidationAdditionalInfoforDonation(
      String defaultDateFormat) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _zipcodeAdditionalInfoDonationKey, value: defaultDateFormat));
    await AppPreferences().init();
  }

  static Future<String> getZipcodeValidationAdditionalInfoforDonation() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _zipcodeAdditionalInfoDonationKey) ?? null;
  }

  static setZipcodeLengthforDonation(int defaultDateFormat) async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // await localStorage.setString(_defaultDateFormatKey, defaultDateFormat);
    // await AppPreferences().init();
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _zipcodeLengthDonationKey, value: defaultDateFormat.toString()));
    await AppPreferences().init();
    // print(await getDefaultDateFormat());
  }

  static Future<String> getZipcodeLengthforDonation() async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // String consideredDomain = localStorage.getString(_defaultDateFormatKey);
    // return consideredDomain ?? null;
    final storage = FlutterSecureStorage();
    return storage.read(key: _zipcodeLengthDonationKey) ?? null;
  }

  static Future<void> setCountyEnabledforDonataion(bool setLegacy) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_countyEnabledforDonataionKey, setLegacy));
    await AppPreferences().init();
  }

  static Future<bool> getCountyEnabledforDonataion() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool setLegacy = localStorage.getBool(_countyEnabledforDonataionKey);
    return setLegacy;
  }

  /* static Future<void> setCountyEnabledforDonataion(bool loginStatus) async {
    print("County -- > $loginStatus");
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _countyEnabledforDonataionKey, value: loginStatus.toString()));
    print("County");
    print(await getCountyEnabledforDonataion());
  }

  static Future<bool> getCountyEnabledforDonataion() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _countyEnabledforDonataionKey) == null ||
        storage.read(key: _countyEnabledforDonataionKey).toString() == "false")
      return false;
    else
      return true;
  } */

  static Future<void> setLegacyFromEnvProps(bool setLegacy) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(setLegacyKey, setLegacy));
    await AppPreferences().init();
  }

  static Future<bool> getLegacyFromEnvProps() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool setLegacy = localStorage.getBool(setLegacyKey);
    return setLegacy;
  }

  static Future<void> setPromoDepartmentName(String promoDepartmentName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(
        localStorage.setString(promoDeparmentNameKey, promoDepartmentName));
    await AppPreferences().init();
  }

  static Future<String> getPromoDepartmentName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String promoDepartmentName = localStorage.getString(promoDeparmentNameKey);
    return promoDepartmentName;
  }

  static Future<void> setNewsFeedFromEnvProps(bool setLegacy) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(setNewsFeedKey, setLegacy));
    await AppPreferences().init();
  }

  static Future<bool> getNewsFeedFromEnvProps() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool setLegacy = localStorage.getBool(setNewsFeedKey);
    return setLegacy;
  }

  static Future<void> setRemaindersFromEnvProps(bool setLegacy) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(setRemaindersKey, setLegacy));
    await AppPreferences().init();
  }

  static Future<bool> getRemaindersFromEnvProps() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool setLegacy = localStorage.getBool(setRemaindersKey);
    return setLegacy;
  }

  static Future<bool> getUserEligibleForBluetooth() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool isEligible = localStorage.getBool(_isUserEligibleForBluetoothKey);
    return isEligible ?? false;
  }

  static Future<void> setUserEligibleForBluetooth(bool isEligible) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_isUserEligibleForBluetoothKey, isEligible));
    await AppPreferences().init();
  }

  setBluetoothConnection(BluetoothConnection connection) {
    debugPrint("<<<setBluetoothConnection>>>");
    this._connection = connection;
  }

  setSelectedConnectedDevice(BluetoothDevice device) {
    _selectedConnectedDevice = device;
    debugPrint(
        "AppPrefer >>  setSelectedConnectedDevice ${_selectedConnectedDevice.name}");
  }

  setGlobalContext(BuildContext context) {
    _setContext = context;
  }

  bool isLanguageTamil() {
    return language == "Tamil";
  }

  bool isTTDEnvironment() {
    debugPrint(
        "ENV setup :$environmentCode Env ${Constants.TT_ENV_CODE}  ${environmentCode == Constants.TT_ENV_CODE}");
    return environmentCode == Constants.TT_ENV_CODE && language == "English";
  }

  static bool getBoolValueFromString(String value) {
    if (value.toLowerCase() == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> setPasswordChanged(bool loginStatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_passwordStatus, loginStatus));
    await AppPreferences().init();
  }

  static Future<bool> isPasswordChanged() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_passwordStatus);
    return loginStatus ?? false;
  }

  static Future<void> setAgoraConnectOption(dynamic showConnectButton) async {
    showConnectButton = getBoolValueFromString(showConnectButton);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_agoraConnectOptionKey, showConnectButton));
    await AppPreferences().init();
  }

  static Future<bool> getAgoraConnectOption() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_agoraConnectOptionKey);
    return loginStatus ?? false;
  }

  static Future<void> setNewFeedEnabled(dynamic showNewsFeed) async {
    showNewsFeed = getBoolValueFromString(showNewsFeed);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_newsFeedEnabledKey, showNewsFeed));
    await AppPreferences().init();
  }

  static Future<bool> getNewFeedEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_newsFeedEnabledKey);
    return loginStatus ?? false;
  }

  static Future<void> setRemindersEnabled(dynamic reminderEnabled) async {
    reminderEnabled = getBoolValueFromString(reminderEnabled);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_remindersEnabledKey, reminderEnabled));
    await AppPreferences().init();
  }

  static Future<bool> getRemindersEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_remindersEnabledKey);
    return loginStatus ?? false;
  }

  static Future<void> setModernizeEnabled(dynamic modernizeEnabled) async {
    modernizeEnabled = getBoolValueFromString(modernizeEnabled);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_modernizeEnabledKey, modernizeEnabled));
    await AppPreferences().init();
  }

  static Future<bool> getModernizeEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_modernizeEnabledKey);
    return loginStatus ?? false;
  }

  static Future<String> getHeight() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_heightKey);
    return latLong ?? null;
  }

  static Future<void> setHeight(String latLong) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_heightKey, latLong);
    await AppPreferences().init();
  }

  static Future<String> getWeight() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_weightKey);
    return latLong ?? null;
  }

  static Future<void> setAppName(String appName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_appNameKey, appName);
    await AppPreferences().init();
  }

  static Future<String> getAppName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_appNameKey);
    return latLong ?? null;
  }

  static Future<void> setCashPaymentDesciption(
      String cashPaymentDesciption) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(
        _cashPaymentDesciptionKey, cashPaymentDesciption);
    await AppPreferences().init();
  }

  static Future<String> getCashPaymentDesciption() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_cashPaymentDesciptionKey);
    return latLong ?? null;
  }

  static Future<void> setWeight(String latLong) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_weightKey, latLong);
    await AppPreferences().init();
  }

  static Future<String> getLanguage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_langKey);
    return latLong ?? "English";
  }

  static Future<void> setLanguage(String latLong) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_langKey, latLong);
    await AppPreferences().init();
  }

  static getMembershipBenefitsContent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(_memershipBenefitsContentKey);
  }

  static Future<String> getEnvironment() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_environmentCodeKey);
    return latLong ?? null;
  }

  static Future<void> setEnvironment(String latLong) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_environmentCodeKey, latLong);
    await AppPreferences().init();
  }

  setContext(BuildContext context) async {
    _context = context;
    AppPreferences().init();
  }

  static setUserDailyCheckinEnabled(bool dailycheckin) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_userDailyCheckinEnabledKey, dailycheckin));
    await AppPreferences().init();
  }

  static setMembershipTermsandConditions(String termsandconditions) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(
        _membershipTermsandConditionsKey, termsandconditions));
    await AppPreferences().init();
  }

  static setSignupTermsandConditions(String termsandconditions) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(
        _signupTermsandConditionsKey, termsandconditions));
    await AppPreferences().init();
  }

  static setMembershipBenefitsContent(String benefits) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_memershipBenefitsContentKey, benefits));
    await AppPreferences().init();
  }

  static setProfileHistoryEnabled(bool profileHistoryEnabled) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(
        _userDailyCheckinReportEnabledKey, profileHistoryEnabled));
    await AppPreferences().init();
  }

  static setDailyCheckinReportEnabled(bool dailyCheckinReportEnabled) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(
        _userProfileHistoryEnabledKey, dailyCheckinReportEnabled));
    await AppPreferences().init();
  }

  static Future<void> setGCPageIsShowing(bool viewed) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_gcPageShowing, viewed));
    await AppPreferences().init();
  }

  static Future<bool> isGCPageIsShowing() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool viewedStatus = localStorage.getBool(_gcPageShowing);
    return viewedStatus ?? false;
  }

  static Future<void> setUserInfo(UserInfo userInfo) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // print(
    //     'From SetUser Info....................${userInfo.stateName} and ${userInfo.state}');
    String userString = json.encode(userInfo.toJson());
    unawaited(localStorage.setString(_userInfoKey, userString));
  }

  static Future<UserInfo> getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String userinfo = localStorage.getString(_userInfoKey);
    // print('From GetUserInfo...............$userinfo');
    // print(
    //     'From SetUserInfo.......${utf8.encode(userinfo).reduce((value, element) => value + element)}');
    Map<String, dynamic> valueMap =
        userinfo != null ? json.decode(userinfo) : Map();
    //print('From GetUserInfo.............. value map $valueMap');
    return UserInfo.fromJson(valueMap);
  }

  static Future<void> setIntroPageViewed(bool viewed) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_introPageViewed, viewed));
  }

  static Future<bool> isIntroPageViewed() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool viewedStatus = localStorage.getBool(_introPageViewed);
    return viewedStatus ?? false;
  }

  static Future<void> setTermsAcceptance(bool username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_termsKey, username));
  }

  static Future<bool> getTermsAcceptance() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_termsKey);
    return loginStatus ?? false;
  }

  static Future<void> setEmail(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_emailKey, username));
  }

  static Future<String> getEmail() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_emailKey);
    return loginStatus ?? "";
  }

  static Future<void> setLatLang(String latLong) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_latLongKey, latLong);
    await AppPreferences().init();
  }

  static Future<String> getLatLang() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_latLongKey);
    return latLong ?? "";
  }

  static Future<void> setDOB(String dob) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_dobKey, dob));
  }

  static Future<String> getDOB() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_dobKey);
    return loginStatus ?? "";
  }

  static Future<void> setPageData(String pageData) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_noticeBoardPageDataKey, pageData));
  }

  static Future<String> getPageData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String pageData = localStorage.getString(_noticeBoardPageDataKey);
    return "$pageData" ?? "";
  }

  static Future<void> setCountry(String country) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_countryKey, country);
    await AppPreferences().init();
    WebserviceConstants.reloadEnv();
    // print("setCountry $country");
  }

  static Future<String> getCountry() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String country = localStorage.getString(_countryKey);
    return country ?? "";
  }

  static Future<void> setBloodGroup(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_bloodKey, username));
  }

  static Future<void> setApiUrl(String apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_apiUrlKey, apiUrl));
    await AppPreferences().init();
    WebserviceConstants.reloadEnv();
  }

  static Future<String> getApiUrl() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String apiUrl = localStorage.getString(_apiUrlKey);
    return apiUrl ?? "";
  }

  static Future<String> getMenuItemsData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String menuItemsUrl = localStorage.getString(_getMenuItemsKey);
    return menuItemsUrl ?? null;
  }

  static Future<void> setMenuItemsData(String jsonData) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_getMenuItemsKey, jsonData));
  }

  static Future<void> setTenant(String tenant) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_tenantKey, tenant));
    await AppPreferences().init();
    WebserviceConstants.reloadEnv();
  }

  static Future<String> getTenant() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String tenant = localStorage.getString(_tenantKey);
    return tenant ?? "";
  }

  static Future<String> getBloodGroup() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_bloodKey);
    return loginStatus ?? "";
  }

  static Future<void> setPhoneNo(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_phoneKey, username));
  }

  static Future<String> getPhone() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_phoneKey);
    return loginStatus ?? "";
  }

  static Future<void> setDeptName(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_deptKey, username));
  }

  static Future<String> getDeptName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_deptKey);
    return loginStatus ?? "";
  }

  static Future<void> setDefaultCurrency(String currency) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_currencyKey, currency));
  }

  static Future<String> getDefaultCurrency() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String defaultCurrency = localStorage.getString(_currencyKey);
    return defaultCurrency ?? "";
  }

  static Future<void> setDefaultCurrencySymbol(String currencySymbol) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_currencySymbolKey, currencySymbol));
  }

  static Future<String> getDefaultCurrencySymbol() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String defaultCurrencySymbol = localStorage.getString(_currencySymbolKey);
    return defaultCurrencySymbol ?? "";
  }

  static Future<void> setDefaultCurrencySuffix(String currencySuffix) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_currencySuffixKey, currencySuffix));
  }

  static Future<String> getDefaultCurrencySuffix() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String defaultCurrencySuffix = localStorage.getString(_currencySuffixKey);
    return defaultCurrencySuffix ?? "";
  }

  static Future<void> setDefaultPaymentGateway(
      String defaultPaymentGateway) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(
        _defaultPaymentGatewayKey, defaultPaymentGateway));
  }

  static Future<String> getDefaultPaymentGateway() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String defaultPaymentGateway =
        localStorage.getString(_defaultPaymentGatewayKey);
    return defaultPaymentGateway ?? "";
  }

  static Future<void> setVersion(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_versionKey, username));
    await AppPreferences().init();
  }

  static Future<String> getVersion() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String versionNumber = localStorage.getString(_versionKey);
    return versionNumber ?? "";
  }

  static Future<void> setRole(String role) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_roleKey, role));
  }

  static Future<String> getRole() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_roleKey);
    return loginStatus ?? "";
  }

  static Future<void> setUsername(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_usernameKey, username));
  }

  static Future<String> getUsername() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_usernameKey);
    return loginStatus ?? "";
  }

  static Future<void> setPhysician(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_physicianKey, username));
  }

  static Future<String> getPhysician() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_physicianKey);
    return loginStatus ?? "";
  }

  static Future<void> setAddress(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_addressKey, username));
  }

  static Future<String> getAddress() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_addressKey);
    return loginStatus ?? "";
  }

  static Future<void> setFullName(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_fullNameKey, username));
  }

  static Future<String> getFullName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_fullNameKey);
    return loginStatus ?? "";
  }

  static Future<void> setSecondFullName(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_fullSecondNameKey, username));
  }

  static Future<String> getSecondFullName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_fullSecondNameKey);
    return loginStatus ?? "";
  }

  static Future<void> setLoginStatus(bool loginStatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_loggedInStatus, loginStatus));
  }

  static Future<bool> getLoginStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_loggedInStatus);
    return loginStatus ?? false;
  }

  static Future<void> setProfileUpdate(bool loginStatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_globalStatus, loginStatus));
  }

  static Future<bool> getProfileUpdate() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_globalStatus);
    return loginStatus ?? false;
  }

  static Future<void> setHistorySaved(bool loginStatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_historyStatus, loginStatus));
  }

  static Future<bool> isHistorySaved() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_historyStatus);
    return loginStatus ?? false;
  }

  static Future<void> setCheckInSaved(bool loginStatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_checkInStatus, loginStatus));
  }

  static Future<bool> isCheckInSaved() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_checkInStatus);
    return loginStatus ?? false;
  }

  static Future<void> setPhysicianSaved(bool loginStatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_physicianStatus, loginStatus));
  }

  static Future<bool> isPhysicianSaved() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_physicianStatus);
    return loginStatus ?? false;
  }

  static Future<void> setSignUpStatus(bool loginStatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_singUpStatus, loginStatus));
  }

  static Future<bool> getSignUpStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool loginStatus = localStorage.getBool(_singUpStatus);
    return loginStatus ?? false;
  }

  static Future<void> setOAuth2Token(String oAuth2Token) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _oauth2Token, value: oAuth2Token));
  }

  static Future<String> getOAuth2Token() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _oauth2Token);
  }

  static Future<String> getClientId() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_clientIdKey);
    return latLong ?? null;
  }

  static Future<void> setClientId(String clientId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_clientIdKey, clientId);
    await AppPreferences().init();
  }

  static Future<String> getJWTToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String latLong = localStorage.getString(_jwtTokenKey);
    return latLong ?? null;
  }

  static Future<void> setJWTToken(String accessToken) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_jwtTokenKey, accessToken);
    await AppPreferences().init();
  }

  static Future<void> setConsideredDomain(String consideredDomain) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_consideredDomainKey, consideredDomain);
    await AppPreferences().init();
  }

  static Future<String> getConsideredDomain() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_consideredDomainKey);
    return consideredDomain ?? null;
  }

  static Future<void> setSiteNavigator(String siteNavigator) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_siteNavigatorKey, siteNavigator);
    await AppPreferences().init();
  }

  static Future<String> getSiteNavigator() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String siteNavigator = localStorage.getString(_siteNavigatorKey);
    return siteNavigator ?? null;
  }

  static Future<void> setEnvProps(EnvProps envProps) async {
    final storage = FlutterSecureStorage();
    return storage.write(
        key: _envPropsKey, value: jsonEncode(envProps.toJson()));
  }

  static Future<EnvProps> getEnvProps() async {
    final storage = FlutterSecureStorage();
    return EnvProps.fromJson(jsonDecode(await storage.read(key: _envPropsKey)));
  }

  static setAppLogo(String logoUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(_logoUrlKey, logoUrl);
  }

  static getAppLogo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(_logoUrlKey);
  }

  static setClientName(String clientName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(_clientNameKey, clientName);
  }

  static getClientName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(_clientNameKey);
  }

  static getUserDailyCheckinEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getBool(_userDailyCheckinEnabledKey);
  }

  static getMembershipTermsandConditions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(_membershipTermsandConditionsKey);
  }

  static getSignupTermsandConditions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(_signupTermsandConditionsKey);
  }

  static getProfileHistoryEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getBool(_userDailyCheckinReportEnabledKey) ?? false;
  }

  static getDailyCheckinReportEnabled() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return (localStorage.getBool(_userProfileHistoryEnabledKey)) ?? false;
  }

  static Future<void> setAgoraAppId(String appid) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_appIdKey, appid);
    await AppPreferences().init();
  }

  static Future<String> getAgoraAppId() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_appIdKey);
    return consideredDomain ?? null;
  }

  static Future<void> setAgoraAppToken(String appToken) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_appTokenKey, appToken);
    await AppPreferences().init();
  }

  static Future<String> getAgoraAppToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_appTokenKey);
    return consideredDomain ?? null;
  }

  static setAdunit(String adunit) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_adunitKey, adunit);
    await AppPreferences().init();
  }

  static Future<String> getAdunit() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_adunitKey);
    return consideredDomain ?? null;
  }

  static setAdAppId(String adunit) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_adAppIdKey, adunit);
    await AppPreferences().init();
  }

  static Future<String> getAdAppId() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_adAppIdKey);
    return consideredDomain ?? null;
  }

  static Future<void> setIsMembershipApplicable(dynamic isMem_Appl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setBool(_isMembershipApplicableKey, isMem_Appl));
    await AppPreferences().init();
  }

  static Future<bool> getIsMembershipApplicable() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool isApplicable = localStorage.getBool(_isMembershipApplicableKey);
    return isApplicable ?? false;
  }

  static setDeclaration(String declaration) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_declarationKey, declaration);
    await AppPreferences().init();
  }

  static Future<String> getDeclaration() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_declarationKey);
    return consideredDomain ?? null;
  }

  static setRecentActivityOptions(List<String> supportDocument) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setStringList(
        _recentActivityOptionsKey, supportDocument);
    await AppPreferences().init();
  }

  static Future<List<String>> getRecentActivityOptions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List<String> supportDocuments =
        localStorage.getStringList(_recentActivityOptionsKey);
    return supportDocuments ?? null;
  }

  static setSupportDocument(List<String> supportDocument) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setStringList(_supportDocumentKey, supportDocument);
    await AppPreferences().init();
  }

  static Future<List<String>> getSupportDocument() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List<String> supportDocuments =
        localStorage.getStringList(_supportDocumentKey);
    return supportDocuments ?? null;
  }

  static setMembershipWorkFlow(List<String> membershipWorkFlow) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setStringList(
        _membershipWorkFlowKey, membershipWorkFlow);
    await AppPreferences().init();
  }

  static Future<List<String>> getMembershipWorkFlow() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List<String> membershipWorkFlow =
        localStorage.getStringList(_membershipWorkFlowKey);
    return membershipWorkFlow ?? null;
  }

  static setDefaultDateFormat(String defaultDateFormat) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_defaultDateFormatKey, defaultDateFormat);
    await AppPreferences().init();
  }

  static Future<String> getDefaultDateFormat() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_defaultDateFormatKey);
    return consideredDomain ?? null;
  }

  static setDefaultTimeZone(String defaultTimeZone) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_defaultTimeZoneKey, defaultTimeZone);
    await AppPreferences().init();
  }

  static Future<String> getDefaultTimeZone() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_defaultTimeZoneKey);
    return consideredDomain ?? null;
  }

  static setAuthorization(String authorization) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_authorizationKey, authorization);
    await AppPreferences().init();
  }

  static Future<String> getAuthorization() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_authorizationKey);
    return consideredDomain ?? null;
  }

  static setErrorMessage(String errorMessage) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_errorMessageKey, errorMessage);
    await AppPreferences().init();
  }

  static Future<String> getErrorMessage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_errorMessageKey);
    return consideredDomain ?? null;
  }

  static setHostUrl(String hostUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_hostUrlKey, hostUrl);
    await AppPreferences().init();
  }

  static Future<String> getHostUrl() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String hostUrl = localStorage.getString(_hostUrlKey);
    return hostUrl ?? null;
  }

  static setGUISettings(String guiSettings) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_guiSettingsKey, guiSettings);
    await AppPreferences().init();
  }

  static Future<String> getGUISettings() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_guiSettingsKey);
    return consideredDomain ?? null;
  }

  static setDisplayText(String displayText) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_displayTextKey, displayText);
    await AppPreferences().init();
  }

  static Future<String> getDisplayText() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_displayTextKey);
    return consideredDomain ?? null;
  }

  static setMembershipFeeRequired(String membershipFeeRequired) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(
        _membershipFeeRequiredKey, membershipFeeRequired);
    await AppPreferences().init();
  }

  static Future<String> getMembershipFeeRequired() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_membershipFeeRequiredKey);
    return consideredDomain ?? null;
  }

  static setEnablePayments(String enablePayments) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_enablePaymentsKey, enablePayments);
    await AppPreferences().init();
  }

  static Future<String> getEnablePayments() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_enablePaymentsKey);
    return consideredDomain ?? null;
  }

  static setPaypalSecretId(String paypalSecretId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_paypalSecretIdKey, paypalSecretId);
    await AppPreferences().init();
  }

  static Future<String> getPaypalSecretId() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_paypalSecretIdKey);
    return consideredDomain ?? null;
  }

  static setPaypalSecretKey(String paypalSecretKey) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_paypalSecretKey, paypalSecretKey);
    await AppPreferences().init();
  }

  static Future<String> getPaypalSecretKey() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain;
    consideredDomain = localStorage.getString(_paypalSecretKey);
    return consideredDomain ?? null;
  }

  static setPlatformScheduleExposeRoleTypes(
      List<String> supportDocument) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setStringList(_setRoleTypesKey, supportDocument);
    await AppPreferences().init();
  }

  static Future<List<String>> getPlatformScheduleExposeRoleTypes() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List<String> supportDocuments =
        localStorage.getStringList(_setRoleTypesKey);
    return supportDocuments ?? null;
  }

  static setRazorPaySecretKey(String razorPaySecretKey) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_razorPaySecretKey, razorPaySecretKey);
    await AppPreferences().init();
  }

  static Future<String> getRazorPaySecretKey() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_razorPaySecretKey);
    return consideredDomain ?? null;
  }

  static setRazorPayMerchantKey(String razorPayMerchantKey) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_razorPayMerchantKey, razorPayMerchantKey);
    await AppPreferences().init();
  }

  static Future<String> getRazorPayMerchantKey() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_razorPayMerchantKey);
    return consideredDomain ?? null;
  }

  static setMenuStyle(String menuStyle) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_menuStyleKey, menuStyle);
    await AppPreferences().init();
  }

  static Future<String> getMenuStyle() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain =
        localStorage.getString(_menuStyleKey) ?? "Default";
    return consideredDomain ?? null;
  }

  static Future<void> logoutClearPreferences({bool isWipeCall: true}) async {
    showMenuGridScreen = false;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    AppColors.primaryColor = AppColors.primaryColorDark;
    final secureStorage = FlutterSecureStorage();

    if (isWipeCall) {
      await localStorage.remove(setLegacyKey);
      await localStorage.remove(setNewsFeedKey);
      await localStorage.remove(setRemaindersKey);
      await localStorage.remove(_adunitKey);
      await localStorage.remove(_adAppIdKey);
      await localStorage.remove(_adUnitBannerKey);
      await localStorage.remove(_adAppIdKey);
      await localStorage.remove(_addressKey);
      await localStorage.remove(_apiUrlKey);
      await localStorage.remove(_appColorKey);
      await localStorage.remove(_appIdKey);
      await localStorage.remove(_appNameKey);
      await localStorage.remove(_appTokenKey);
      await localStorage.remove(_authorizationKey);
      await localStorage.remove(_bloodKey);
      await localStorage.remove(_checkInStatus);
      await localStorage.remove(_clientIdKey);
      await localStorage.remove(_consideredDomainKey);
      await localStorage.remove(_clientNameKey);
      await localStorage.remove(_countryKey);
      await localStorage.remove(_currencyKey);
      await localStorage.remove(_declarationKey);
      await localStorage.remove(_defaultDateFormatKey);
      await localStorage.remove(_defaultPaymentGatewayKey);
      await localStorage.remove(_defaultTimeZoneKey);
      await localStorage.remove(_deptKey);
      await localStorage.remove(_displayTextKey);
      await localStorage.remove(_enablePaymentsKey);
      await localStorage.remove(_errorMessageKey);
      await localStorage.remove(_guiSettingsKey);
      await localStorage.remove(_hostUrlKey);
      await localStorage.remove(_logoUrlKey);
      await localStorage.remove(_membershipFeeRequiredKey);
      await localStorage.remove(_membershipTermsandConditionsKey);
      await localStorage.remove(_memershipBenefitsContentKey);
      await localStorage.remove(_noticeBoardPageDataKey);
      await localStorage.remove(_paypalSecretIdKey);
      await localStorage.remove(_paypalSecretKey);
      await localStorage.remove(_razorPayMerchantKey);
      await localStorage.remove(_razorPaySecretKey);
      await localStorage.remove(_signupTermsandConditionsKey);
      await localStorage.remove(_supportDocumentKey);
      await localStorage.remove(_recentActivityOptionsKey);

      await localStorage.remove(_siteNavigatorKey);
      await localStorage.remove(_tenantKey);
      await localStorage.remove(_userDailyCheckinEnabledKey);
      await localStorage.remove(_userDailyCheckinReportEnabledKey);
      await localStorage.remove(_userProfileHistoryEnabledKey);
      await localStorage.clear();
      AppColors.primaryColor = Color(0xff000080);
      /*await localStorage.remove(_logoUrlKey);
      await localStorage.remove(_clientNameKey);
      await localStorage.remove(_apiUrlKey);
      await localStorage.remove(_deptKey);
      await localStorage.remove(_clientIdKey);
      await localStorage.remove(_consideredDomainKey);
      await localStorage.remove(_currencyKey);*/
      bool isKeyPresent = await secureStorage.containsKey(key: _envPropsKey);
      if (isKeyPresent) {
        debugPrint("Key present...");
        await secureStorage.delete(key: _envPropsKey);
      } else {
        debugPrint("Key not present...");
      }
      await secureStorage.deleteAll();
    } else {
      await localStorage.remove(setLegacyKey);
      await localStorage.remove(setNewsFeedKey);
      await localStorage.remove(setRemaindersKey);
      await localStorage.remove(_loggedInStatus);
      await localStorage.remove(_usernameKey);
      await localStorage.remove(_roleKey);
      await localStorage.remove(_phoneKey);
      await localStorage.remove(_fullNameKey);
      //await localStorage.remove(_dobKey);
      await localStorage.remove(_addressKey);
      await localStorage.remove(_termsKey);
      await localStorage.remove(_physicianKey);
      await localStorage.remove(_bloodKey);
      //await localStorage.remove(_ailmentStatus);
      await localStorage.remove(_physicianStatus);
      await localStorage.remove(_checkInStatus);
      await localStorage.remove(_historyStatus);
      await localStorage.remove(_globalStatus);
      await localStorage.remove(_countryKey);
      await localStorage.remove(_heightKey);
      await localStorage.remove(_weightKey);
      await localStorage.remove(_passwordStatus);
      await localStorage.remove(_isUserEligibleForBluetoothKey);

      await secureStorage.delete(key: _oauth2Token);
      AppColors.primaryColor = Color(0xff000080);
    }
    await localStorage.remove(_userMemberShipTypeKey);

    await AppPreferences().init();
  }

  static setAppColor(String appColor) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_appColorKey, appColor);
    await AppPreferences().init();
  }

  static Future<String> getAppColor() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String consideredDomain = localStorage.getString(_appColorKey);
    return consideredDomain ?? null;
  }

  static Future<void> setUserCategory(String userCategory) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_userCategoryKey, userCategory));
  }

  static Future<String> getUserCategory() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_userCategoryKey);
    return loginStatus ?? "";
  }

  static setAdUnitBanner(String adUnitBanner) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(localStorage.setString(_adUnitBannerKey, adUnitBanner));
  }

  static Future<String> getAdUnitBanner() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_adUnitBannerKey);
    return loginStatus ?? "";
  }

  static Future<void> setUserMembershipType(String userMemberShipType) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    unawaited(
        localStorage.setString(_userMemberShipTypeKey, userMemberShipType));
  }

  static Future<String> getUserMembershipType() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String userMemberShipType = localStorage.getString(_userMemberShipTypeKey);
    return userMemberShipType ?? "";
  }

  static setEnvironmentShortCode(String envShortCode) async {
    final storage = FlutterSecureStorage();
    return storage.write(key: _envShortCodeKey, value: envShortCode);
  }

  static getEnvironmentShortCode() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: _envShortCodeKey);
  }

  /// B2C
  static Future<void> setToken(String token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(_tokenKey, token);
  }

  static Future<String> getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String loginStatus = localStorage.getString(_tokenKey);
    return loginStatus ?? "";
  }

  static Future<void> setUserGroup(String userGroup) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(_userGroupKey, userGroup);
  }

  static Future<String> getUserGroup() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String userGroup = localStorage.getString(_userGroupKey);
    return userGroup ?? "";
  }

  static Future<void> setFirstName(String firstName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(_firstNameKey, firstName);
  }

  static Future<String> getFirstName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String firstName = localStorage.getString(_firstNameKey);
    return firstName ?? "";
  }

  static void setTimeFormat(bool timeFormat) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setBool(_timeFormatKey, timeFormat);
  }

  static Future<bool> getTimeFormat() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool timeformat = localStorage.getBool(_timeFormatKey);
    return timeformat;
  }

  static void setSupportCategory(List<String> supportCategory) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setStringList(_supportCategoryKey, supportCategory);
  }

  static Future<List<String>> getSupportCategory() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return await localStorage.getStringList(_supportCategoryKey);
  }

  static setApiErrorMessage(String propertyValue) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(_firstNameKey, _apiErrorMessageKey);
  }

  static Future<String> getApiErrorMessage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(_apiErrorMessageKey);
  }
}
