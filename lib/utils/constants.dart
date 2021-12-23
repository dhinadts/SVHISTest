import 'package:flutter/widgets.dart';
import 'app_preferences.dart';

class Constants {
  static String bookAppointmentDashboard = 'BookAppointmentDashboard';
  static String supervisorRole = 'Supervisor';
  static String adminRole = 'Admin';
  static const String USER_ROLE = 'User';
  static const String LatoBold = 'LatoBold';
  static const String LatoSemiBold = 'LatoSemiBold';
  static const String LatoRegular = 'LatoRegular';
  static const String LatoThin = 'LatoThin';
  static const String LatoLight = 'LatoLight';
  static const String TT_ENV_CODE = "SDX_TRINIDAD";
  static const String QA_ENV_CODE = "SDX_QA";
  static const String UNDER_REVIEW = "Under Review";

  static const String CLIENT_ID = "Memberly";
  static const String APP_SCOPE = "Memberly";
  static const String CLIENT_CHANNEL = "Mobile";
  static const int hiderecording = 30;
  static const int PAGE_ID_HOME = 100;
  static const int PAGE_ID_ADD_A_PERSON = 101;
  static const int PAGE_ID_ADD_FAMILY = 102;
  static const int PAGE_ID_PEOPLE_LIST = 103;
  static const int PAGE_ID_SEARCH_PEOPLE = 104;
  static const int PAGE_ID_RECENT_ACTIVITY = 105;
  static const int PAGE_ID_PREVENTION = 106;
  static const int PAGE_ID_SUPPORT = 107;

  static const int PAGE_PERSONAL_INFORMATION = 108;
  static const int PAGE_ID_DAILY_CHECK_IN = 109;
  static const int PAGE_ID_EVENT_LIST = 110;
  static const int PAGE_ID_RESET_PASSWORD = 112;
  static const int PAGE_ID_RESERVED_USERS = 113;
  static const int PAGE_ID_SETTINGS = 114;
  static const int PAGE_ID_PORT_MONITORING = 115;
  static const int PAGE_ID_LOGOUT = 118;
  static const int PAGE_ID_SMART_NOTE = 119;
  static const int PAGE_ID_COPING = 120;

  static const int PAGE_ID_ADD_USER_FAMILY = 121;
  static const int PAGE_ID_SUBSCRIPTION_LIST = 122;
  static const int PAGE_ID_WIPE_DATA = 123;
  static const int PAGE_ID_MEMBERSHIP = 124;
  static const int PAGE_ID_DIABETES = 125;
  static const int PAGE_ID_DIAGNOSIS = 126;
  static const int PAGE_ID_EVENTS_LIST = 127;
  static const int PAGE_ID_DIABETES_RISK_SCORE_TAB = 128;

  static const int PAGE_ID_SEND_MESSAGE = 129;

  static const int PAGE_ID_TRANSACTION_HISTORY = 130;

  static const int PAGE_ID_DONATION = 131;
  static const int PAGE_ID_COMMITTEES = 132;
  static const int PAGE_ID_FAQ = 133;
  static const int PAGE_ID_HIERARCHICAL = 134;
  static const int PAGE_ID_EVENT_DETAILS = 135;
  static const int PAGE_ID_EVENT_REG = 136;
  static const int PAGE_ID_INAPP_WEBVIEW = 139;
  static const int PAGE_ID_BOOK_APPOINTMENT = 141;
  static const int PAGE_ID_CAMPAIGN_LIST = 142;
  static const int PAGE_ID_REFRESH_ENVIRINMENT = 143;
  static const int PAGE_ID_ADD_NEW_DEVICE = 124;
  static const int PAGE_ID_USER_PROFILE = 140;
  static const int FLASHCARDS_MIN_VAL = 5;

  static const int PAGE_ID_Doctor_Schedule = 500;
  static const int PAGE_ID_Appointment_Confirmation = 501;
  static const int PAGE_ID_Appointment_History = 502;
  static const int PAGE_ID_Book_Appointments = 503;
  static const int PAGE_ID_Administration = 504;
  static const int PAGE_ID_Doctor_List = 505;
  static const int PAGE_ID_Patient_Assessment = 506;
  static const int PAGE_ID_ELECTION_POLL = 507;
  static const int PAGE_ID_Attendance = 508;

  static const int PAGE_ID_Home_Nusrsing_Service = 509;
  static const int PAGE_ID_NEWSFEED = 510;
  static const int PAGE_ID_TOBEMEMBER = 211;
  static const int PAGE_ID_CALLUS = 212;

  static const int PAGE_ID_QRCODE = 511;

  static const bool LOGODOUBLETOUCH = true;
  static const bool VIDEO_CALLING_MODERN =
      true; //If true, agora video will have modernUI.
  // static const bool LEGACY_HOMEPAGE = true;

  static const String SUCCESS = "success";

  //---------------------- Validation Message --------------------------
  static const String VALIDATION_BLANK_EMAIL = "Email cannot be blank";
  static const String VALIDATION_CONFIRM_EMAIL_MATCH =
      "The Confirmation Email must match your Email Address";
  static const String VALIDATION_BLANK_PHONE_NO =
      "Phone number cannot be blank";
  static const String VALIDATION_BLANK_USERNAME = "Username cannot be blank";
  static const String VALIDATION_VALID_USERNAME = "Enter valid username";

  static const String VALIDATION_VALID_PHONE_NO = "Enter valid phone number";

  static const String VALIDATION_VALID_EMAIL = "Enter valid email address";
  static const String VALIDATION_ALREADY_EXIST_EMAIL = "Email already exist";
  static const String VALIDATION_BLANK_PASSWORD = "Password cannot be blank";
  static const String VALIDATION_BLANK_OLD_PASSWORD =
      "Old password cannot be blank";
  static const String VALIDATION_BLANK_NEW_PASSWORD =
      "New password cannot be blank";
  static const String VALIDATION_BLANK_CONF_PASSWORD =
      "Confirm password cannot be blank";
  static const String VALIDATION_VALID_PASSWORD =
      "Password must have at least 8 characters with at least one letter and one number";
  static const String VALIDATION_VALID_PASSWORD_LOGIN =
      "Please enter the correct password";

  static const String VALIDATION_BLANK_NAME = "Name cannot be blank";
  static const String VALIDATION_BLANK_FIRSTNAME = "First name cannot be blank";
  static const String VALIDATION_BLANK_LASTNAME = "Last name cannot be blank";
  static const String VALIDATION_BLANK_ADDRESS = "Address cannot be blank";
  static const String VALIDATION_VALID_FIRSTNAME = "Enter valid first name";
  static const String VALIDATION_VALID_NAME_RESERVED_USERS = "Enter valid name";

  static const String VALIDATION_BLANK_PHYSICIAN =
      "Physician name cannot be blank";
  static const String VALIDATION_VALID_PHYSICIAN = "Enter valid physician name";

  static const String VALIDATION_VALID_LASTNAME = "Enter valid last name";
  static const String VALIDATION_VALID_ADDRESS = "Enter address";

  static const String VALIDATION_BLANK_CITY = "City cannot be blank";
  static const String VALIDATION_VALID_NAME =
      "Name must contain only alphabets";
  static const String VALIDATION_VALID_CITY = "Enter valid city";

  static const String VALIDATION_VALID_COUNTRY = "Enter valid Country";

  static const String VALIDATION_BLANK_STATE = "State cannot be blank";
  static const String VALIDATION_VALID_STATE = "Enter valid parish";

  static const String VALIDATION_BLANK_COUNTRY = "Country cannot be blank";
  static const String VALIDATION_BLANK_DESIGNATION = "Enter designation";

  static const String VALIDATION_BLANK_CONFIRM_PASSWORD =
      "Enter confirm password";
  static const String VALIDATION_MATH_CONFIRM_PASSWORD =
      "Mismatch password and confirm password";

  static const String VALIDATION_VALID_ZIP = "Please enter valid ZIP code";

  //-------------------- ERROR Message-----------------------------------------
  static String SOMETHING_WENT_WRONG = AppPreferences().getApisErrorMessage;
  static const String NO_INTERNET_CONNECTION =
      "Please check your internet connection or try again later";
  static const String TERMS_AND_CONDITION_WARNING =
      "Please accept the Terms and Conditions";

  //------------------------No Record Found -----------------------------------
  static const String NO_RECORD_FOUND = "No record found";

  static String appName = "DATT";
  static const String RUPEE_SYMBOL = "\u20B9";
  static const String DOLLAR_SYMBOL = "\u0024";
  static BuildContext context = null;
  static const String HINDI_KEY = "Hindi";
  static const String TAMIL_KEY = "Tamil";
  static const String ENGLISH_KEY = "English";

  static const String HINDI_VALUE_KEY = "हिन्दी";
  static const String TAMIL_VALUE_KEY = "தமிழ்";
  static const String ENGLISH_VALUE_KEY = "English";
  static const String TELUGU_KEY = "Telugu";

  static const SETTINGS_ENABLED = true;
  static const LANGUAGE_ENABLED = false;
  static const GC_REGISTRATION_ENABLED = true;
  static const JAMAICA_CODE = "1";
  static const INDIA_CODE = "91";
  static const LIKE_OPERATOR = "LIKE";
  static const EQUAL_OPERATOR = "EQUAL";
  static const PRIMARY_KEY = "PRIMARY";
  static const SECONDARY_KEY = "SECONDARY";
  static const BMI = "BMI";
  static const PRE_PRANDIABLE = "PRE_PRANDIABLE";
  static const POST_PRANDIABLE = "POST_PRANDIABLE";
  static const DOMAIN_DATT = "DATTApp";
  static const DOMAIN_WORK_FORCE = "WorkForce";
  static const GNAT_KEY = "GNAT";

  // UNITS identifications
  static const CENTIMETERS = "CMS";
  static const INCHES = "Inches";
  static const KGS = "KGS";
  static const POUNDS = "Pounds";

  static const MEMBERSHIPTYPE = "Life";

  ///
  /// B2C module
  ///
  static const String VALIDATION_BLANK_CATEGORY_TYPE =
      "Category type cannot be blank";
  static const String VALIDATION_BLANK_SUBCATEGORY_TYPE =
      "Subcategory type cannot be blank";
  static const String VALIDATION_DAYS = "Days should be in range 0 and 31";
  static const String VALIDATION_BLANK_ORGANISATION_NAME =
      "Organisation name cannot be blank";
  static const String VALIDATION_BLANK_JOB_TITLE = "Job title cannot be blank";
  static const String VALIDATION_BLANK_COUNTY = "County cannot be blank";
  static const String VALIDATION_BLANK_ZIP_CODE = "Zip code cannot be blank";
  static const String VALIDATION_VALID_ZIP_CODE = "Enter 5 digit Zip code";

  //-------------------- ERROR Message-----------------------------------------
  static const String VALIDATION_BLANK_QUANTITY =
      "Quantity cannot be blank or 0";
  static const String VALIDATION_QUANTITY =
      "Quantity should be in range 1 and 10000";
  static const String VALIDATION_SUPPLY_QUANTITY =
      "Quantity should be in range 1 and 100000";
  static const String checkYourInternetConnection =
      "check_your_internet_connection";
  static const String ok = "ok";
  static const String all = "all";

  static const int PAGE_ID_REQUESTER_DASHBOARD = 100;
  static const int PAGE_ID_DAILY_SYMPTOMS = 109;
  static const int PAGE_ID_DAILY_QUARANTINE = 110;
  static const int PAGE_ID_CONTACT_TRACING = 111;
  static const int PAGE_ID_CONTACT_LIST = 116;
  static const int PAGE_ID_QUARANTINE_LIST = 117;

  static const String VALIDATION_BLANK_NO_OF_EMPLOYEES =
      "No of Employees cannot be 0 or blank";
}
