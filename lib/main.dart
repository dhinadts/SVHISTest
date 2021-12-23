import 'country_picker_util/country_localizations.dart';
import 'login/login_screen.dart';
import 'model/passing_arg.dart';
import 'ui/b2c/payment_screen.dart';
import 'ui/app_translations_delegate.dart';
import 'ui/application.dart';
import 'ui/b2c/service_registration.dart';
import 'ui/b2c/view/manager_dashboard_screen.dart';
import 'ui/b2c/view/matched_request_screen.dart';
import 'ui/b2c/view/profile_category_tab_screen.dart';
import 'ui/b2c/view/profile_info_screen.dart';
import 'ui/b2c/view/request_inProcess_screen.dart';
import 'ui/b2c/view/request_screen.dart';
import 'ui/b2c/view/requester_dashboard_screen.dart';
import 'ui/b2c/view/supplier_dashboard_screen.dart';
import 'ui/booking_appointment/appointment_confirmation_list_screen.dart';
import 'ui/booking_appointment/appointment_grid_dashboard.dart';
import 'ui/booking_appointment/appointment_history_screen.dart';
import 'ui/booking_appointment/book_Appointment_Home_Screen.dart';
import 'ui/booking_appointment/select_physician_screen.dart';
import 'ui/check_in_history_screen.dart';
import 'ui/check_in_screen.dart';
import 'ui/committees/commitees_list_screen.dart';
import 'ui/diabetes_risk_score/diabetes_risk_score_list_screen.dart';
import 'ui/doctor_schdule_screen.dart';
import 'ui/global_config/global_config_tabbed_screen.dart';
import 'ui/global_configuration_page.dart';
import 'ui/history_screen.dart';
import 'ui/log_reports/chart_state.dart';
import 'ui/payment/ui/transaction_history_details.dart';
import 'ui/people_list_page.dart';
import 'ui/recent_activity_list_screen.dart';
import 'ui/reset_password_screen.dart';
import 'ui/smart_note/smart_note_file_show_screen.dart';
import 'ui/smart_note/smart_note_text_show_screen.dart';
import 'ui/smart_note/smart_notes_tab_screen.dart';
import 'ui/splash_screen.dart';
import 'ui/subscription/subscription_screen.dart';
import 'ui/support_screen.dart';
import 'ui/tabs/AppLanguage.dart';
import 'ui/tabs/app_localizations.dart';
import 'ui/terms_and_conditions_screen.dart';
import 'ui/user_info_screen.dart';
import 'ui_utils/app_colors.dart';
import 'utils/app_preferences.dart';
import 'utils/constants.dart';
import 'utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/healthCare_device_screen.dart';
import 'ui/add_new_device.dart';
import 'ui/booking_appointment/campaign_feedback_list.dart';
import 'internationalize/transalations.dart';
import 'model/smart_note_edit_arg.dart';
import 'ui/b2c/view/supply_inProcess_screen.dart';
import 'ui/custom_drawer/navigation_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await FlutterDownloader.initialize(debug: true);

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(new MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;
  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
  };

  @override
  void initState() {
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    precacheImage(new AssetImage('assets/images/datt_logo.png'), context);
    application.onLocaleChanged = onLocaleChange;
    onLocaleChange(Locale(languagesMap[
        AppPreferences().language == null || AppPreferences().language == ""
            ? "English"
            : AppPreferences().language]));
    getVersion();
    resetInterstitalAdCount();
    super.initState();
  }

  Future<void> resetInterstitalAdCount() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt("interStitialAdCountKey", 0);
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    await AppPreferences.setVersion(version);
  }

  static final navigatorKey = new GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppPreferences().init();
    globalConfig();
    return MultiProvider(
        providers: [
          appLanguageProvider,
          ChangeNotifierProvider(create: (context) => BloodPressureData()),
          ChangeNotifierProvider(create: (context) => BMIData()),
          ChangeNotifierProvider(create: (context) => BloodSugarData()),
          ChangeNotifierProvider(create: (context) => Hba1cData()),
          ChangeNotifierProvider(create: (context) => DiastoleData()),
          ChangeNotifierProvider(create: (context) => SystoleData()),
        ],
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            locale: model.appLocal,
            supportedLocales: [
              Locale('en', ''),
            ],
            localizationsDelegates: [
              _newLocaleDelegate,
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              TranslationsDelegate(packages: ["1"]),
              CountryLocalizations.delegate,
            ],
            theme: ThemeData(
              primaryColor: AppColors.primaryColor,
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case Routes.login:
                  return MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  });

                case Routes.resetPasswordScreen:
                  return MaterialPageRoute(builder: (context) {
                    return ResetPassword();
                  });
                case Routes.subscriptionInfo:
                  return MaterialPageRoute(builder: (context) {
                    return SubscriptionScreen(settings.arguments);
                  });
                case Routes.globalConfigurationPage:
                  if (Constants.GC_REGISTRATION_ENABLED)
                    return MaterialPageRoute(builder: (context) {
                      Args arg = settings?.arguments ?? null;
                      return GlobalConfigTabbedScreen(
                        token: arg?.token,
                      );
                    });
                  return MaterialPageRoute(builder: (context) {
                    Args arg = settings?.arguments ?? null;
                    return GlobalConfigurationPage(
                      token: arg?.token,
                    );
                  });
                case Routes.checkInScreen:
                  return MaterialPageRoute(builder: (context) {
                    final Args args = settings.arguments;
                    return CheckInScreen(
                      args?.arg != null,
                      checkInDynamic: args?.checkInDynamic,
                      username: args?.username,
                      userFullName: args?.userFullName,
                      departmentName: args?.departmentName,
                    );
                  });

                case Routes.historyScreen:
                  return MaterialPageRoute(builder: (context) {
                    Args args = settings.arguments;
                    return HistoryScreen(
                      username: args?.username,
                      gender: args?.gender,
                    );
                  });
                case Routes.peopleListScreen:
                  return MaterialPageRoute(builder: (context) {
                    return PeopleListPage();
                  });
                case Routes.userInfoScreen:
                  return MaterialPageRoute(builder: (context) {
                    return UserInformationScreen();
                  });
                case Routes.noticeBoardScreen:
                  return MaterialPageRoute(builder: (context) {
                    return RecentActivityScreen();
                  });
                case Routes.termsAndConditionScreen:
                  return MaterialPageRoute(builder: (context) {
                    return TermsAndConditionScreen();
                  });
                case Routes.diabetesRiskScoreList:
                  return MaterialPageRoute(builder: (context) {
                    Args arg = settings.arguments;
                    return DiabetesRiskScoreListScreen(arg?.people);
                  });
                case Routes.checkInHistoryScreen:
                  return MaterialPageRoute(builder: (context) {
                    Args arg = settings.arguments;
                    return CheckInHistoryScreen(arg?.people, arg.userFullName);
                  });

                case Routes.smartNoteFileShowScreen:
                  return MaterialPageRoute(builder: (context) {
                    Args arg = settings.arguments;
                    return SmartNoteFileShowScreen(
                      fileObj: arg.smartNoteAttachment,
                    );
                  });
                case Routes.smartNoteTextShowScreen:
                  return MaterialPageRoute(builder: (context) {
                    SmartNoteTextArg arg = settings.arguments;
                    return SmartNoteTextShowScreen(
                      noteTitle: arg.noteTitle,
                      noteComment: arg.noteComments,
                    );
                  });
                case Routes.navigatorHomeScreen:
                  return MaterialPageRoute(builder: (context) {
                    return NavigationHomeScreen();
                  });

                case Routes.supportScreen:
                  return MaterialPageRoute(builder: (context) {
                    return SupportWidget();
                  });

                case Routes.transactionDetailsScreen:
                  return MaterialPageRoute(builder: (context) {
                    Args arg = settings.arguments;
                    return TransactionHistoryDetails(arg?.paymentDetail);
                  });

                case Routes.committeeListScreen:
                  return MaterialPageRoute(builder: (context) {
                    return CommitteesListScreen();
                  });
                case Routes.bookingAppointmentScreen:
                  return MaterialPageRoute(builder: (context) {
                    return AppointmentGridDashboard();
                  });
                case Routes.bookAppointmentHomeScreen:
                  return MaterialPageRoute(builder: (context) {
                    return BookAppointmentHomeScreen();
                  });
                case Routes.selectPhysicianScreen:
                  return MaterialPageRoute(builder: (context) {
                    final Args args = settings.arguments;
                    return SelectPhysicianScreen();
                  });
                case Routes.appointmentHistoryScreen:
                  return MaterialPageRoute(builder: (context) {
                    ScreenNameArg arg = ScreenNameArg("Appointment History");
                    return AppointmentHistoryScreen(pageName: arg?.title);
                  });
                case Routes.campignFeedbackList:
                  return MaterialPageRoute(builder: (context) {
                    // ScreenNameArg arg = ScreenNameArg("Appointment History");
                    return CampaignFeedbackList();
                  });
                case Routes.appointmentReminderScreen:
                  return MaterialPageRoute(builder: (context) {
                    ScreenNameArg arg = ScreenNameArg("Reminder");
                    return AppointmentHistoryScreen(pageName: arg?.title);
                  });
                // case Routes.doctorProfileScreen:
                //   return MaterialPageRoute(builder: (context) {
                //     return DoctorSchedulerScreen();
                //   });
                case Routes.appointmentConfirmationListScreen:
                  return MaterialPageRoute(builder: (context) {
                    return AppointmentConfirmationListScreen();
                  });

                case Routes.healthcareDevicesScreen:
                  return MaterialPageRoute(
                      builder: (context) => HealthCareDeviceScreen());
                case Routes.doctorSchduleScreen:
                  return MaterialPageRoute(
                      builder: (context) => DoctorSchedulerScreen());

                case Routes.addNewDeviceScreen:
                  return MaterialPageRoute(
                      builder: (context) =>
                          AddNewDevice(deviceName: "C19 Pro"));
                case Routes.smartNoteEditScreen:
                  return MaterialPageRoute(builder: (context) {
                    SmartNoteEditArg arg = settings.arguments;
                    return SmartNotesTabScreen(
                        currentUserDepartmentName:
                            arg.currentUserDepartmentName,
                        callbackForNewNote: arg.callbackForNewNote,
                        currentUserName: arg.currentUserDepartmentName,
                        smartNotesModel: arg.smartNotesModel);
                  });

                /// B2C module
                case Routes.requesterDashBoard:
                  final Args args = settings.arguments;
                  return MaterialPageRoute(builder: (context) {
                    return RequesterDashboardScreen(
                        // pageId: args?.pageIndex ?? Constants.PAGE_ID_REQUESTER_DASHBOARD,
                        );
                  });
                case Routes.supplierDashBoard:
                  return MaterialPageRoute(builder: (context) {
                    return SupplierDashboardScreen();
                  });
                case Routes.managerDashBoard:
                  return MaterialPageRoute(builder: (context) {
                    return ManagerDashboardScreen();
                  });
                case Routes.addRequest:
                  return MaterialPageRoute(builder: (context) {
                    return RequestScreen();
                  });
                case Routes.supplyInProcess:
                  return MaterialPageRoute(builder: (context) {
                    return SupplyInProcessScreen();
                  });
                case Routes.matchedRequest:
                  return MaterialPageRoute(builder: (context) {
                    return MatchedRequestScreen();
                  });
                case Routes.requestInProcess:
                  return MaterialPageRoute(builder: (context) {
                    return RequestInProcessScreen();
                  });
                case Routes.profileInfoScreen:
                  return MaterialPageRoute(builder: (context) {
                    return ProfileInfoScreen();
                  });
                case Routes.profileCategoryTabScreen:
                  return MaterialPageRoute(builder: (context) {
                    return ProfileCategoryTabScreen();
                  });

                case Routes.payments_screen:
                  return MaterialPageRoute(builder: (context) {
                    return PaymentsScreen();
                  });
                case Routes.service_registration:
                  return MaterialPageRoute(builder: (context) {
                    return ServiceRegistrationScreen();
                  });

                /// End here

                default:
                  return MaterialPageRoute(builder: (context) {
                    return SplashScreen();
                  });
              }
            },
          );
        }));
  }

  ChangeNotifierProvider get appLanguageProvider =>
      ChangeNotifierProvider<AppLanguage>(
        create: (context) => widget.appLanguage,
      );

  globalConfig() async {
    await GlobalConfiguration().loadFromAsset("app_global");
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
