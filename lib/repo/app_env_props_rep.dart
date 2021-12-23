import 'dart:convert';

import '../model/app_env_props.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

import 'common_repository.dart';

class AppEnvPropRepo {
  static Future fetchEnvProps() async {
    String username = await AppPreferences.getUsername();
    String clientId = await AppPreferences.getClientId();
    String deparmentName = await AppPreferences.getDeptName();

    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    header.putIfAbsent(WebserviceConstants.clientId, () => clientId);

    // print(
    //     "${WebserviceConstants.baseAdminURL}${WebserviceConstants.environmentDataDynamic}?${WebserviceConstants.clientId}=${clientId}&${WebserviceConstants.departmentName}=${deparmentName}");
    http.Response response = await http.get(
      "${WebserviceConstants.baseAdminURL}${WebserviceConstants.environmentDataDynamic}?${WebserviceConstants.departmentName}=$deparmentName",
      headers: header,
    );
    List data = json.decode(response.body);
    List<AppEnvProps> envProps = [];
    data.forEach((e) {
      // debugPrint("Props ------------------> $e");
      envProps.add(AppEnvProps.fromJson(e));
    });
    for (var i = 0; i < envProps.length; i++) {
      switch (envProps[i].propertyName) {
        case "com.sdx.gui.noticeboard.filter.options":
          if (envProps[i].propertyValue != null &&
              envProps[i].propertyValue.isNotEmpty)
            await AppPreferences.setRecentActivityOptions(
                envProps[i].propertyValue.split(','));
          break;
        case "com.sdx.mobile.home.modernization.enabled":
          await AppPreferences.setLegacyFromEnvProps(
              (envProps[i].propertyValue == null ||
                      envProps[i].propertyValue == "false")
                  ? false
                  : true);
          break;
        case "com.sdx.mobile.module.newsfeed.enabled":
          await AppPreferences.setNewsFeedFromEnvProps(
              (envProps[i].propertyValue.isNotEmpty &&
                      envProps[i].propertyValue != null &&
                      envProps[i].propertyValue == "true")
                  ? true
                  : false);
          break;
        case "com.sdx.mobile.module.reminders.enabled":
          await AppPreferences.setRemaindersFromEnvProps(
              (envProps[i].propertyValue.isNotEmpty &&
                      envProps[i].propertyValue != null &&
                      envProps[i].propertyValue == "true")
                  ? true
                  : false);
          break;
        case "com.sdx.environment.adv.admob.adunits":
          AppPreferences.setAdunit(envProps[i].propertyValue);
          break;
        case "com.sdx.environment.adv.admob.appId":
          AppPreferences.setAdAppId(envProps[i].propertyValue);
          break;
// com.sdx.environment.memberly.host.gh.authorization
        case "com.sdx.mobile.adv.admob.adunit.banners":
          AppPreferences.setAdUnitBanner(envProps[i].propertyValue);
          break;
        case "com.sdx.environment.memberly.host.site.navigator":
          AppPreferences.setSiteNavigator(envProps[i].propertyValue);
          break;
        case "com.sdx.environment.memberly.host.url":
          AppPreferences.setHostUrl(envProps[i].propertyValue);
          break;
// com.sdx.environment.mobile.default.error.message
        case "com.sdx.environment.video.agora.appId":
          AppPreferences.setAgoraAppId(envProps[i].propertyValue);
          break;
        case "com.sdx.environment.video.agora.token":
          AppPreferences.setAgoraAppToken(envProps[i].propertyValue);
          break;
        case "com.sdx.mobile.donation.supportingdocs.declarationtext":
          AppPreferences.setDeclaration(envProps[i].propertyValue);
          break;
        case "com.sdx.mobile.meet.testconnection.enabled":
          AppPreferences.setAgoraConnectOption(envProps[i].propertyValue);
          break;
        case "com.sdx.mobile.donation.supportingdocs.urls":
          if (envProps[i].propertyValue != null &&
              envProps[i].propertyValue.isNotEmpty)
            AppPreferences.setSupportDocument(
                envProps[i].propertyValue.split(','));
          else
            AppPreferences.setSupportDocument(List<String>());
          break;
        case "com.sdx.mobile.memberly.gui.settings":
          AppPreferences.setGUISettings(json.encode(envProps[i].propertyValue));
          break;
        case "com.sdx.mobile.membership.benefits.content":
          AppPreferences.setMembershipBenefitsContent(
              envProps[i].propertyValue);
          break;

        case "com.sdx.mobile.membership.termsandconditions":
          AppPreferences.setMembershipTermsandConditions(
              envProps[i].propertyValue);
          break;
        case "com.sdx.mobile.signup.termsandconditions":
          AppPreferences.setSignupTermsandConditions(envProps[i].propertyValue);
          break;
        case "com.sdx.mobile.user.dailycheckin.enabled":
          AppPreferences.setUserDailyCheckinEnabled(
              (envProps[i].propertyValue != null &&
                      envProps[i].propertyValue == "true")
                  ? true
                  : false);
          break;
        case "com.sdx.mobile.user.dailycheckin.report.enabled":
          AppPreferences.setDailyCheckinReportEnabled(
              (envProps[i].propertyValue != null &&
                      envProps[i].propertyValue == "true")
                  ? true
                  : false);
          break;
        case "com.sdx.mobile.user.profile.history.enabled":
          AppPreferences.setProfileHistoryEnabled(
              (envProps[i].propertyValue != null &&
                      envProps[i].propertyValue == "true")
                  ? true
                  : false);
          break;
        case "sdx.environment.client.id":
          AppPreferences.setClientId(envProps[i].propertyValue);
          break;
        case "sdx.environment.default.currency":
          AppPreferences.setDefaultCurrency(envProps[i].propertyValue);
          break;
        case "sdx.environment.payment.gateway":
          AppPreferences.setDefaultPaymentGateway(envProps[i].propertyValue);
          break;
        case "sdx.environment.default.date.format":
          AppPreferences.setDefaultDateFormat(envProps[i].propertyValue);
          break;
        case "sdx.environment.default.timezone":
          AppPreferences.setDefaultTimeZone(envProps[i].propertyValue);
          break;
        case "sdx.environment.displaytext":
          AppPreferences.setDisplayText(envProps[i].propertyValue);
          break;
// sdx.environment.logo
        case "sdx.environment.membership.fees.required":
          AppPreferences.setMembershipFeeRequired(envProps[i].propertyValue);
          break;
        case "sdx.environment.membership.workflow.status":
          if (envProps[i].propertyValue != null &&
              envProps[i].propertyValue.isNotEmpty) {
            AppPreferences.setMembershipWorkFlow(
                envProps[i].propertyValue.split(','));
          } else {
            AppPreferences.setMembershipWorkFlow(List<String>());
          }
          break;
        case "sdx.environment.mobileapp.name":
          AppPreferences.setAppName(envProps[i].propertyValue);
          break;
        case "com.sdx.platform.payments.cash.enabled":
          AppPreferences.setCashPaymentEnable(envProps[i].propertyValue);
          break;
        case "com.sdx.platform.payments.cash.description":
          AppPreferences.setCashPaymentDesciption(envProps[i].propertyValue);
          break;
// sdx.environment.name
        case "sdx.environment.payments.enable":
          AppPreferences.setEnablePayments(envProps[i].propertyValue);
          break;
        case "sdx.environment.payments.paypal.secretid":
          AppPreferences.setPaypalSecretId(envProps[i].propertyValue);
          break;
        case "sdx.environment.payments.paypal.secretkey":
          AppPreferences.setPaypalSecretKey(envProps[i].propertyValue);
          break;
// sdx.environment.payments.platforms.available
        case "sdx.environment.payments.razorpay.merchantid":
          AppPreferences.setRazorPayMerchantKey(envProps[i].propertyValue);
          break;
// sdx.environment.payments.razorpay.secretid
// sdx.environment.payments.razorpay.secretkey
        case "sdx.environment.seed.data.bloodgroups":
          AppPreferences.setBloodGroup(envProps[i].propertyValue);
          break;
        /* case "com.sdx.mobile.module.newsfeed.enabled":
          debugPrint("Newsfeed enabled:");
          debugPrint(envProps[i].propertyValue);
          AppPreferences.setNewFeedEnabled(envProps[i].propertyValue);
          debugPrint("newsfeed enabled: app prefs");
          var dummy = AppPreferences.getNewFeedEnabled();
          debugPrint(dummy.toString());

          break;
        case "com.sdx.mobile.module.reminders.enabled":
          debugPrint("remainders enabled:");
          debugPrint(envProps[i].propertyValue);
          AppPreferences.setRemindersEnabled(envProps[i].propertyValue);
          debugPrint("remainders enabled: app prefs");
          var dummy = AppPreferences.getRemindersEnabled();
          debugPrint(dummy.toString());
          break;
        case "com.sdx.mobile.home.modernization.enabled":
          AppPreferences.setModernizeEnabled(envProps[i].propertyValue);
          break; */
        case "sdx.mobile.org.color.scheme":
          debugPrint(
              "sdx.mobile.org.color.scheme --> ${envProps[i].propertyValue}");
          AppColors.primaryColor = HexColor(envProps[i].propertyValue);
          AppPreferences.setAppColor(envProps[i].propertyValue);
          break;
        case "sdx.mobile.org.display.name":
          print("sdx.mobile.org.display.name");
          print(envProps[i].propertyValue);
          AppPreferences.setClientName(envProps[i].propertyValue);
          break;
        case "sdx.mobile.org.logo.url":
          print("sdx.mobile.org.logo.url");
          print(envProps[i].propertyValue);
          AppPreferences.setAppLogo(envProps[i].propertyValue);
          break;
        case "com.sdx.platform.address.preferences.address2.enabled":
          AppPreferences.setaddress2forDonataion(
              // envProps[i].propertyValue == "false" ||
              //         envProps[i].propertyValue == null
              //     ? false
              //     : true);
              /* envProps[i].propertyValue != null ||
                      envProps[i].propertyValue == "true"
                  ? true
                  : false); */
              envProps[i].propertyValue == "true" ? true : false);

          break;
        // com.sdx.platform.address.preferences.address2.enabled
        case "com.sdx.platform.address.preferences.county.enabled":
          AppPreferences.setCountyEnabledforDonataion(
              // envProps[i].propertyValue == "false" ||

              envProps[i].propertyValue == "true" ? true : false);
          //         envProps[i].propertyValue == null
          //     ? false
          //     : true);

          break;
        case "com.sdx.platform.address.preferences.county.label":
          AppPreferences.setCountyLabelforDonation(envProps[i].propertyValue);

          break;
        case "com.sdx.platform.address.preferences.zipcode.label":
          AppPreferences.setZipcodeLabelforDonation(envProps[i].propertyValue);

          break;
        case "com.sdx.platform.address.preferences.zipcode.length":
          AppPreferences.setZipcodeLengthforDonation(
              int.parse(envProps[i].propertyValue));

          break;
        case "com.sdx.platform.address.preferences.zipcode.validation":
          AppPreferences.setZipcodeValidationforDonation(
              envProps[i].propertyValue);
          AppPreferences.setZipcodeValidationAdditionalInfoforDonation(
              envProps[i].additionalInfo);
          break;
        case "com.sdx.platform.default.currency.symbol":
          if (envProps[i].propertyValue.toLowerCase() == "rs") {
            AppPreferences.setDefaultCurrencySymbol(Constants.RUPEE_SYMBOL);
          } else {
            AppPreferences.setDefaultCurrencySymbol(envProps[i].propertyValue);
          }
          break;
        case "com.sdx.platform.default.currency.suffix":
          AppPreferences.setDefaultCurrencySuffix(envProps[i].propertyValue);
          break;
        case "com.sdx.gui.formats.timeformat":
          print(
              "===================> Time Format ${envProps[i].propertyValue}");
          AppPreferences.setTimeFormat(
              envProps[i].propertyValue == "true" ? true : false);
          break;
        case "com.sdx.environment.support.category":
          AppPreferences.setSupportCategory(
              envProps[i].propertyValue.split(','));
          break;
        case "com.sdx.platform.schedule.expose.role.types":
          if (envProps[i].propertyValue != null &&
              envProps[i].propertyValue.isNotEmpty)
            await AppPreferences.setPlatformScheduleExposeRoleTypes(
                envProps[i].propertyValue.split(','));
          break;
        case "com.sdx.environment.mobile.default.error.message":
          if (envProps[i].propertyValue != null &&
              envProps[i].propertyValue.isNotEmpty)
            await AppPreferences.setApiErrorMessage(envProps[i].propertyValue);
          break;
        case "com.sdx.platform.rights.subdept.supervisor.usermod.access.enabled":
          // print(
          //     "com.sdx.platform.rights.subdept.supervisor.usermod.access.enabled");
          // print(envProps[i].propertyValue);

          if (envProps[i].propertyValue != null &&
              envProps[i].propertyValue.isNotEmpty)
            await AppPreferences.setSubdeptSupervisorUsermodAccessEnabled(
                envProps[i].propertyValue);
          break;
      }
    }
    await AppPreferences().init();
    DateUtils.init();
    //return envPropsList;
  }
}
