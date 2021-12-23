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

  static String _membershipWorkFlowKey = "membershipWorkFlowKey";
  static String _supportDocumentKey = "supportDocumentKey";
  static String _recentActivityOptionsKey = "recentActivityFields";

  static String _defaultTimeZoneKey = "defaultTimeZoneKey";
  static String _defaultDateFormatKey = "defaultDateFormatKey";
  static String _membershipFeeRequiredKey = "membershipFeeRequiredKey";
  static String _displayTextKey = "displayTextKey";
  static String _paypalSecretKey = "paypalSecretKey";
  static String _paypalSecretIdKey = "paypalSecretIdKey";
  static String _razorPaySecretKey = "razorPaySecretKey";
  static String _enablePaymentsKey = "enablePaymentsKey";
  static String _razorPayMerchantKey = "razorPayMerchantKey";
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

  static String setLegacyKey = "legacy_home_page";
  static String setNewsFeedKey = "newsfeed";
  static String setRemaindersKey = "remainders";

  String _setzipcodeLabelDonation;
  String _setzipcodeValidationDonation;
  String _zipcodeAdditionalInfoDonation;
  String _zipcodeLengthDonation;

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
  String _siteNavigator;
  BuildContext _context;
  String _userCategory;
  String _defaultPaymentGateway;
  bool _isAdditionalInformationAvl;
  bool _isCheckInAvl;
  String _appName;
  String _primaryColor;
  BluetoothDevice _selectedConnectedDevice;
  BluetoothConnection _connection;
  bool _isUserEligibleForBluetooth;
  String _defaultDateFormat;

  String get setzipAdditional => _zipcodeAdditionalInfoDonation;
  String get setzipcodeLabelDonation => _setzipcodeLabelDonation;
  String get setzipcodeValidationDonation => _setzipcodeValidationDonation;
  String get zipcodeLengthDonation => _zipcodeLengthDonation;
  String get countyLabelDonation => _countyLabelDonation;
  bool get setcountyEnabledforDonataion => _setcountyEnabledforDonataion;
  bool get setAddress2ForDonation => _setAddress2ForDonation;
  bool get setLegacy => _setLegacy;
  bool get setNewsFeed => _newsFeed;
  bool get setRemainders => _remainders;

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

  String get apiURL => _apiUrl;

  String get defaultCurrency => _currency;

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

  BluetoothConnection get connection => _connection;

  BuildContext get context => _context;

  BluetoothDevice get selectedConnectedDevice => _selectedConnectedDevice;

  bool get isUserEligibleForBluetooth => _isUserEligibleForBluetooth;

  init() async {
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
    _setAddress2ForDonation = await AppPreferences.getaddress2forDonataion();
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
  }

  static Future<void> setPasswordChanged(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _passwordStatus, value: loginStatus.toString()));
    await AppPreferences().init();
  }

  static Future<bool> isPasswordChanged() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _passwordStatus) == null ||
        storage.read(key: _passwordStatus).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setLegacyFromEnvProps(bool setLegacy) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: setLegacyKey, value: setLegacy.toString()));
    await AppPreferences().init();
  }

  static Future<bool> getLegacyFromEnvProps() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: setLegacyKey) == null ||
        storage.read(key: setLegacyKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setNewsFeedFromEnvProps(bool setLegacy) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: setNewsFeedKey, value: setLegacy.toString()));
    await AppPreferences().init();
  }

  static Future<bool> getNewsFeedFromEnvProps() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: setNewsFeedKey) == null ||
        storage.read(key: setNewsFeedKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setRemaindersFromEnvProps(bool setLegacy) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: setRemaindersKey, value: setLegacy.toString()));
    await AppPreferences().init();
  }

  static Future<bool> getRemaindersFromEnvProps() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: setRemaindersKey) == null ||
        storage.read(key: setRemaindersKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<bool> getUserEligibleForBluetooth() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _isUserEligibleForBluetoothKey) == null ||
        storage.read(key: _isUserEligibleForBluetoothKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setUserEligibleForBluetooth(bool isEligible) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _isUserEligibleForBluetoothKey, value: isEligible.toString()));
    await AppPreferences().init();
  }

  static Future<void> setNewFeedEnabled(dynamic showNewsFeed) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _newsFeedEnabledKey, value: showNewsFeed.toString()));
    await AppPreferences().init();
  }

  static Future<bool> getNewFeedEnabled() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _newsFeedEnabledKey) == null ||
        storage.read(key: _newsFeedEnabledKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setRemindersEnabled(dynamic reminderEnabled) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _remindersEnabledKey, value: reminderEnabled.toString()));
    await AppPreferences().init();
  }

  static Future<bool> getRemindersEnabled() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _remindersEnabledKey) == null ||
        storage.read(key: _remindersEnabledKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setModernizeEnabled(dynamic modernizeEnabled) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _modernizeEnabledKey, value: modernizeEnabled.toString()));
    await AppPreferences().init();
  }

  static Future<bool> getModernizeEnabled() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _modernizeEnabledKey) == null ||
        storage.read(key: _modernizeEnabledKey).toString() == "false")
      return false;
    else
      return true;
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

  static Future<void> setAgoraConnectOption(dynamic showConnectButton) async {
    showConnectButton = getBoolValueFromString(showConnectButton);
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _agoraConnectOptionKey, value: showConnectButton.toString()));

    await AppPreferences().init();
  }

  static Future<bool> getAgoraConnectOption() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _agoraConnectOptionKey) == null ||
        storage.read(key: _agoraConnectOptionKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<String> getHeight() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _heightKey) ?? null;
  }

  static Future<void> setHeight(String latLong) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _heightKey, value: latLong));
    await AppPreferences().init();
  }

  static Future<String> getWeight() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _weightKey) ?? null;
  }

  static Future<void> setAppName(String appName) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _appNameKey, value: appName));
    await AppPreferences().init();
  }

  static Future<String> getAppName() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _appNameKey) ?? null;
  }

  static Future<void> setWeight(String latLong) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _weightKey, value: latLong));
    await AppPreferences().init();
  }

  static Future<String> getLanguage() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _langKey) ?? "English";
  }

  static Future<void> setLanguage(String latLong) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _langKey, value: latLong));
    await AppPreferences().init();
  }

  static getMembershipBenefitsContent() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _memershipBenefitsContentKey);
  }

  static Future<String> getEnvironment() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _environmentCodeKey) ?? null;
  }

  static Future<void> setEnvironment(String latLong) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _environmentCodeKey, value: latLong));
    await AppPreferences().init();
  }

  setContext(BuildContext context) async {
    _context = context;
    AppPreferences().init();
  }

  static setUserDailyCheckinEnabled(bool dailycheckin) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _userDailyCheckinEnabledKey, value: dailycheckin.toString()));

    await AppPreferences().init();
  }

  static setMembershipTermsandConditions(String termsandconditions) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _membershipTermsandConditionsKey, value: termsandconditions));

    await AppPreferences().init();
  }

  static setSignupTermsandConditions(String termsandconditions) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _signupTermsandConditionsKey, value: termsandconditions));
    await AppPreferences().init();
  }

  static setMembershipBenefitsContent(String benefits) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _memershipBenefitsContentKey, value: benefits));

    await AppPreferences().init();
  }

  static setProfileHistoryEnabled(bool profileHistoryEnabled) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _userDailyCheckinReportEnabledKey,
        value: profileHistoryEnabled.toString()));
    await AppPreferences().init();
  }

  static setDailyCheckinReportEnabled(bool dailyCheckinReportEnabled) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _userProfileHistoryEnabledKey,
        value: dailyCheckinReportEnabled.toString()));
    await AppPreferences().init();
  }

  static Future<void> setGCPageIsShowing(bool viewed) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _gcPageShowing, value: viewed.toString()));
    await AppPreferences().init();
  }

  static Future<bool> isGCPageIsShowing() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _gcPageShowing) == null ||
        storage.read(key: _gcPageShowing).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setUserInfo(UserInfo userInfo) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _userInfoKey, value: json.encode(userInfo.toJson())));
    await AppPreferences().init();
  }

  static Future<UserInfo> getUserInfo() async {
    final storage = FlutterSecureStorage();
    String valueMap = await storage.read(key: _userInfoKey);
    Map<String, dynamic> userInfo =
        valueMap != null ? json.decode(valueMap) : Map();
    return UserInfo.fromJson(userInfo);

    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // String userinfo = localStorage.getString(_userInfoKey);

    // Map<String, dynamic> valueMap =
    //     userinfo != null ? json.decode(userinfo) : Map();

    // return UserInfo.fromJson(valueMap);
  }

  static Future<void> setIntroPageViewed(bool viewed) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _introPageViewed, value: viewed.toString()));
  }

  static Future<bool> isIntroPageViewed() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _introPageViewed) == null ||
        storage.read(key: _introPageViewed).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setTermsAcceptance(bool username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _termsKey, value: username.toString()));
  }

  static Future<bool> getTermsAcceptance() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _termsKey) == null ||
        storage.read(key: _termsKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setEmail(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _emailKey, value: username));
    await AppPreferences().init();
  }

  static Future<String> getEmail() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _emailKey);
  }

  static Future<void> setLatLang(String latLong) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _latLongKey, value: latLong));
    await AppPreferences().init();
  }

  static Future<String> getLatLang() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _latLongKey);
  }

  static Future<void> setDOB(String dob) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _dobKey, value: dob));
    await AppPreferences().init();
  }

  static Future<String> getDOB() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _dobKey);
  }

  static Future<void> setPageData(String pageData) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _noticeBoardPageDataKey, value: pageData));
    await AppPreferences().init();
  }

  static Future<String> getPageData() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _noticeBoardPageDataKey);
  }

  static Future<void> setCountry(String country) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _countryKey, value: country));
    await AppPreferences().init();
    WebserviceConstants.reloadEnv();
  }

  static Future<String> getCountry() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _countryKey) ?? "";
  }

  static Future<void> setBloodGroup(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _bloodKey, value: username));
    await AppPreferences().init();
  }

  static Future<void> setApiUrl(String apiUrl) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _apiUrlKey, value: apiUrl));
    await AppPreferences().init();
    WebserviceConstants.reloadEnv();
  }

  static Future<String> getApiUrl() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _apiUrlKey) ?? "";
  }

  static Future<String> getMenuItemsData() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _getMenuItemsKey) ?? null;
  }

  static Future<void> setMenuItemsData(String jsonData) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _getMenuItemsKey, value: jsonData));
    await AppPreferences().init();
  }

  static Future<void> setTenant(String tenant) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _tenantKey, value: tenant));

    await AppPreferences().init();
    WebserviceConstants.reloadEnv();
  }

  static Future<String> getTenant() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _tenantKey);
  }

  static Future<String> getBloodGroup() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _bloodKey);
  }

  static Future<void> setPhoneNo(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _phoneKey, value: username));
  }

  static Future<String> getPhone() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _phoneKey) ?? "";
  }

  static Future<void> setDeptName(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _deptKey, value: username));
  }

  static Future<String> getDeptName() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _deptKey) ?? "";
  }

  static Future<void> setDefaultCurrency(String currency) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _currencyKey, value: currency));
  }

  static Future<String> getDefaultCurrency() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _currencyKey) ?? "";
  }

  static Future<void> setDefaultPaymentGateway(
      String defaultPaymentGateway) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _defaultPaymentGatewayKey, value: defaultPaymentGateway));
  }

  static Future<String> getDefaultPaymentGateway() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _defaultPaymentGatewayKey) ?? "";
  }

  static Future<void> setVersion(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _versionKey, value: username));
    await AppPreferences().init();
  }

  static Future<String> getVersion() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _versionKey) ?? "";
  }

  static Future<void> setRole(String role) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _roleKey, value: role));
  }

  static Future<String> getRole() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _roleKey) ?? "";
  }

  static Future<void> setUsername(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _usernameKey, value: username));
  }

  static Future<String> getUsername() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _usernameKey) ?? "";
  }

  static Future<void> setPhysician(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _physicianKey, value: username));
  }

  static Future<String> getPhysician() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _physicianKey) ?? "";
  }

  static Future<void> setAddress(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _addressKey, value: username));
  }

  static Future<String> getAddress() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _addressKey) ?? "";
  }

  static Future<void> setFullName(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _fullNameKey, value: username));
  }

  static Future<String> getFullName() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _fullNameKey) ?? "";
  }

  static Future<void> setSecondFullName(String username) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _fullSecondNameKey, value: username));
  }

  static Future<String> getSecondFullName() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _fullSecondNameKey) ?? "";
  }

  static Future<void> setLoginStatus(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _loggedInStatus, value: loginStatus.toString()));
  }

  static Future<bool> getLoginStatus() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _loggedInStatus) == null ||
        storage.read(key: _loggedInStatus).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setProfileUpdate(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _globalStatus, value: loginStatus.toString()));
  }

  static Future<bool> getProfileUpdate() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _globalStatus) == null ||
        storage.read(key: _globalStatus).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setHistorySaved(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _historyStatus, value: loginStatus.toString()));
  }

  static Future<bool> isHistorySaved() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _historyStatus) == null ||
        storage.read(key: _historyStatus).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setCheckInSaved(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _checkInStatus, value: loginStatus.toString()));
  }

  static Future<bool> isCheckInSaved() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _checkInStatus) == null ||
        storage.read(key: _checkInStatus).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setPhysicianSaved(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _physicianStatus, value: loginStatus.toString()));
  }

  static Future<bool> isPhysicianSaved() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _physicianStatus) == null ||
        storage.read(key: _physicianStatus).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setSignUpStatus(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _singUpStatus, value: loginStatus.toString()));
  }

  static Future<bool> getSignUpStatus() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _singUpStatus) == null ||
        storage.read(key: _singUpStatus).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setaddress2forDonataion(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _address2forDonataionKey, value: loginStatus.toString()));
  }

  static Future<bool> getaddress2forDonataion() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _address2forDonataionKey) == null ||
        storage.read(key: _address2forDonataionKey).toString() == "false")
      return false;
    else
      return true;
  }

  static setCountyLabelforDonation(String defaultDateFormat) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _countyLabelDonationKey, value: defaultDateFormat));
    await AppPreferences().init();
  }

  static Future<String> getCountyLabelforDonation() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _countyLabelDonationKey) ?? null;
  }

  static setZipcodeLabelforDonation(String defaultDateFormat) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _zipcodeLabelDonationKey, value: defaultDateFormat));
    await AppPreferences().init();
  }

  static Future<String> getZipcodeLabelforDonation() async {
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

  static setZipcodeLengthforDonation(String defaultDateFormat) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _zipcodeLengthDonationKey, value: defaultDateFormat));
    await AppPreferences().init();
  }

  static Future<String> getZipcodeLengthforDonation() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _zipcodeLengthDonationKey) ?? null;
  }

  static Future<void> setCountyEnabledforDonataion(bool loginStatus) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _countyEnabledforDonataionKey, value: loginStatus.toString()));
  }

  static Future<bool> getCountyEnabledforDonataion() async {
    final storage = FlutterSecureStorage();
    if (storage.read(key: _countyEnabledforDonataionKey) == null ||
        storage.read(key: _countyEnabledforDonataionKey).toString() == "false")
      return false;
    else
      return true;
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
    final storage = FlutterSecureStorage();
    return storage.read(key: _clientIdKey) ?? null;
  }

  static Future<void> setClientId(String clientId) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _clientIdKey, value: clientId));

    await AppPreferences().init();
  }

  static Future<void> setConsideredDomain(String consideredDomain) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _consideredDomainKey, value: consideredDomain));

    await AppPreferences().init();
  }

  static Future<String> getConsideredDomain() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _consideredDomainKey) ?? null;
  }

  static Future<void> setSiteNavigator(String siteNavigator) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _siteNavigatorKey, value: siteNavigator));
    await AppPreferences().init();
  }

  static Future<String> getSiteNavigator() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _siteNavigatorKey) ?? null;
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
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _logoUrlKey, value: logoUrl));
    await AppPreferences().init();
  }

  static getAppLogo() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _logoUrlKey);
  }

  static setClientName(String clientName) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _clientNameKey, value: clientName));
    await AppPreferences().init();
  }

  static getClientName() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _clientNameKey);
  }

  static getUserDailyCheckinEnabled() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _userDailyCheckinEnabledKey) != null &&
        storage.read(key: _userDailyCheckinEnabledKey).toString() == "true")
      return true;
    else
      return false;
  }

  static getMembershipTermsandConditions() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _membershipTermsandConditionsKey);
  }

  static getSignupTermsandConditions() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _signupTermsandConditionsKey);
  }

  static getProfileHistoryEnabled() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _userDailyCheckinReportEnabledKey) == null ||
        storage.read(key: _userDailyCheckinReportEnabledKey).toString() ==
            "false")
      return false;
    else
      return true;
  }

  static getDailyCheckinReportEnabled() async {
    final storage = FlutterSecureStorage();

    if (storage.read(key: _userProfileHistoryEnabledKey) == null ||
        storage.read(key: _userProfileHistoryEnabledKey).toString() == "false")
      return false;
    else
      return true;
  }

  static Future<void> setAgoraAppId(String appid) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _appIdKey, value: appid));
    await AppPreferences().init();
  }

  static Future<String> getAgoraAppId() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _appIdKey) ?? null;
  }

  static Future<void> setAgoraAppToken(String appToken) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _appTokenKey, value: appToken));
    await AppPreferences().init();
  }

  static Future<String> getAgoraAppToken() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _appTokenKey) ?? null;
  }

  static setAdunit(String adunit) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _adunitKey, value: adunit));
    await AppPreferences().init();
  }

  static Future<String> getAdunit() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _adunitKey) ?? null;
  }

  static setAdAppId(String adunit) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _adAppIdKey, value: adunit));
    await AppPreferences().init();
  }

  static Future<String> getAdAppId() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _adAppIdKey) ?? null;
  }

  static setDeclaration(String declaration) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _declarationKey, value: declaration));
    await AppPreferences().init();
  }

  static Future<String> getDeclaration() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _declarationKey) ?? null;
  }

  static setRecentActivityOptions(List<String> supportDocument) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _recentActivityOptionsKey, value: supportDocument.join('@@')));
  }

  static Future<List<String>> getRecentActivityOptions() async {
    final storage = FlutterSecureStorage();
    var data = await storage.read(key: _recentActivityOptionsKey) ?? null;
    if (data != null) {
      return data.split('@@');
    } else {
      return null;
    }
  }

  static setSupportDocument(List<String> supportDocument) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _supportDocumentKey, value: supportDocument.join('@@')));
  }

  static Future<List<String>> getSupportDocument() async {
    final storage = FlutterSecureStorage();
    var data = await storage.read(key: _supportDocumentKey) ?? null;
    if (data != null) {
      return data.split('@@');
    } else {
      return null;
    }
  }

  static setMembershipWorkFlow(List<String> membershipWorkFlow) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _membershipWorkFlowKey, value: membershipWorkFlow.join('@@')));
  }

  static Future<List<String>> getMembershipWorkFlow() async {
    final storage = FlutterSecureStorage();
    var data = await storage.read(key: _membershipWorkFlowKey) ?? null;
    if (data != null) {
      return data.split('@@');
    } else {
      return null;
    }
  }

  static setDefaultDateFormat(String defaultDateFormat) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _defaultDateFormatKey, value: defaultDateFormat));
  }

  static Future<String> getDefaultDateFormat() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _defaultDateFormatKey) ?? null;
  }

  static setDefaultTimeZone(String defaultTimeZone) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _defaultTimeZoneKey, value: defaultTimeZone));
  }

  static Future<String> getDefaultTimeZone() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _defaultTimeZoneKey) ?? null;
  }

  static setAuthorization(String authorization) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _authorizationKey, value: authorization));
    await AppPreferences().init();
  }

  static Future<String> getAuthorization() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _authorizationKey) ?? null;
  }

  static setErrorMessage(String errorMessage) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _errorMessageKey, value: errorMessage));
    await AppPreferences().init();
  }

  static Future<String> getErrorMessage() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _errorMessageKey) ?? null;
  }

  static setHostUrl(String hostUrl) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _hostUrlKey, value: hostUrl));
    await AppPreferences().init();
  }

  static Future<String> getHostUrl() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _hostUrlKey) ?? null;
  }

  static setGUISettings(String guiSettings) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _guiSettingsKey, value: guiSettings));
    await AppPreferences().init();
  }

  static Future<String> getGUISettings() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _guiSettingsKey) ?? null;
  }

  static setDisplayText(String displayText) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _displayTextKey, value: displayText));
    await AppPreferences().init();
  }

  static Future<String> getDisplayText() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _displayTextKey) ?? null;
  }

  static setMembershipFeeRequired(String membershipFeeRequired) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(
        key: _membershipFeeRequiredKey, value: membershipFeeRequired));
    await AppPreferences().init();
  }

  static Future<String> getMembershipFeeRequired() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _membershipFeeRequiredKey) ?? null;
  }

  static setEnablePayments(String enablePayments) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _enablePaymentsKey, value: enablePayments));
    await AppPreferences().init();
  }

  static Future<String> getEnablePayments() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _enablePaymentsKey) ?? null;
  }

  static setPaypalSecretId(String paypalSecretId) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _paypalSecretIdKey, value: paypalSecretId));
    await AppPreferences().init();
  }

  static Future<String> getPaypalSecretId() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _paypalSecretIdKey) ?? null;
  }

  static setPaypalSecretKey(String paypalSecretKey) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _paypalSecretKey, value: paypalSecretKey));
    await AppPreferences().init();
  }

  static Future<String> getPaypalSecretKey() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _paypalSecretKey) ?? null;
  }

  static setRazorPaySecretKey(String razorPaySecretKey) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _razorPaySecretKey, value: razorPaySecretKey));
    await AppPreferences().init();
  }

  static Future<String> getRazorPaySecretKey() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _razorPaySecretKey) ?? null;
  }

  static setRazorPayMerchantKey(String razorPayMerchantKey) async {
    final storage = FlutterSecureStorage();
    unawaited(
        storage.write(key: _razorPayMerchantKey, value: razorPayMerchantKey));
    await AppPreferences().init();
  }

  static Future<String> getRazorPayMerchantKey() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _razorPayMerchantKey) ?? null;
  }

  static Future<void> logoutClearPreferences({bool isWipeCall: true}) async {
    showMenuGridScreen = false;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    AppColors.primaryColor = AppColors.primaryColorDark;
    final secureStorage = FlutterSecureStorage();

    if (isWipeCall) {
      await secureStorage.deleteAll();
      await secureStorage.delete(key: setLegacyKey);
      await secureStorage.delete(key: setNewsFeedKey);
      await secureStorage.delete(key: setRemaindersKey);
      await secureStorage.delete(key: _adunitKey);
      await secureStorage.delete(key: _adAppIdKey);
      await secureStorage.delete(key: _adUnitBannerKey);
      await secureStorage.delete(key: _adAppIdKey);
      await secureStorage.delete(key: _addressKey);
      await secureStorage.delete(key: _apiUrlKey);
      await secureStorage.delete(key: _appColorKey);
      await secureStorage.delete(key: _appIdKey);
      await secureStorage.delete(key: _appNameKey);
      await secureStorage.delete(key: _appTokenKey);
      await secureStorage.delete(key: _authorizationKey);
      await secureStorage.delete(key: _bloodKey);
      await secureStorage.delete(key: _checkInStatus);
      await secureStorage.delete(key: _clientIdKey);
      await secureStorage.delete(key: _consideredDomainKey);
      await secureStorage.delete(key: _clientNameKey);
      await secureStorage.delete(key: _countryKey);
      await secureStorage.delete(key: _currencyKey);
      await secureStorage.delete(key: _declarationKey);
      await secureStorage.delete(key: _defaultDateFormatKey);
      await secureStorage.delete(key: _defaultPaymentGatewayKey);
      await secureStorage.delete(key: _defaultTimeZoneKey);
      await secureStorage.delete(key: _deptKey);
      await secureStorage.delete(key: _displayTextKey);
      await secureStorage.delete(key: _enablePaymentsKey);
      await secureStorage.delete(key: _errorMessageKey);
      await secureStorage.delete(key: _guiSettingsKey);
      await secureStorage.delete(key: _hostUrlKey);
      await secureStorage.delete(key: _logoUrlKey);
      await secureStorage.delete(key: _membershipFeeRequiredKey);
      await secureStorage.delete(key: _membershipTermsandConditionsKey);
      await secureStorage.delete(key: _memershipBenefitsContentKey);
      await secureStorage.delete(key: _noticeBoardPageDataKey);
      await secureStorage.delete(key: _paypalSecretIdKey);
      await secureStorage.delete(key: _paypalSecretKey);
      await secureStorage.delete(key: _razorPayMerchantKey);
      await secureStorage.delete(key: _razorPaySecretKey);
      await secureStorage.delete(key: _signupTermsandConditionsKey);
      await secureStorage.delete(key: _supportDocumentKey);
      await secureStorage.delete(key: _recentActivityOptionsKey);

      await secureStorage.delete(key: _siteNavigatorKey);
      await secureStorage.delete(key: _tenantKey);
      await secureStorage.delete(key: _userDailyCheckinEnabledKey);
      await secureStorage.delete(key: _userDailyCheckinReportEnabledKey);
      await secureStorage.delete(key: _userProfileHistoryEnabledKey);
      await localStorage.clear();
      AppColors.primaryColor = Color(0xff000080);
      /*await secureStorage.delete(key:_logoUrlKey);
      await secureStorage.delete(key:_clientNameKey);
      await secureStorage.delete(key:_apiUrlKey);
      await secureStorage.delete(key:_deptKey);
      await secureStorage.delete(key:_clientIdKey);
      await secureStorage.delete(key:_consideredDomainKey);
      await secureStorage.delete(key:_currencyKey);*/
      bool isKeyPresent = await secureStorage.containsKey(key: _envPropsKey);
      if (isKeyPresent) {
        debugPrint("Key present...");
        await secureStorage.delete(key: _envPropsKey);
      } else {
        debugPrint("Key not present...");
      }
      await secureStorage.deleteAll();
    } else {
      await secureStorage.deleteAll();
      await secureStorage.delete(key: setLegacyKey);
      await secureStorage.delete(key: setNewsFeedKey);
      await secureStorage.delete(key: setRemaindersKey);
      await secureStorage.delete(key: _loggedInStatus);
      await secureStorage.delete(key: _usernameKey);
      await secureStorage.delete(key: _roleKey);
      await secureStorage.delete(key: _phoneKey);
      await secureStorage.delete(key: _fullNameKey);

      await secureStorage.delete(key: _addressKey);
      await secureStorage.delete(key: _termsKey);
      await secureStorage.delete(key: _physicianKey);
      await secureStorage.delete(key: _bloodKey);

      await secureStorage.delete(key: _physicianStatus);
      await secureStorage.delete(key: _checkInStatus);
      await secureStorage.delete(key: _historyStatus);
      await secureStorage.delete(key: _globalStatus);
      await secureStorage.delete(key: _countryKey);
      await secureStorage.delete(key: _heightKey);
      await secureStorage.delete(key: _weightKey);
      await secureStorage.delete(key: _passwordStatus);
      await secureStorage.delete(key: _isUserEligibleForBluetoothKey);

      await secureStorage.delete(key: _oauth2Token);
      AppColors.primaryColor = Color(0xff000080);
    }

    await AppPreferences().init();
  }

  static setAppColor(String appColor) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _appColorKey, value: appColor));
    await AppPreferences().init();
  }

  static Future<String> getAppColor() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _appColorKey) ?? null;
  }

  static Future<void> setUserCategory(String userCategory) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _userCategoryKey, value: userCategory));
    await AppPreferences().init();
  }

  static Future<String> getUserCategory() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _userCategoryKey) ?? null;
  }

  static setAdUnitBanner(String adUnitBanner) async {
    final storage = FlutterSecureStorage();
    unawaited(storage.write(key: _adUnitBannerKey, value: adUnitBanner));
    await AppPreferences().init();
  }

  static Future<String> getAdUnitBanner() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: _adUnitBannerKey) ?? null;
  }
}
