import 'dart:convert';
import 'dart:io';

import '../../bloc/auth_bloc.dart';
import '../../login/utils.dart';
import '../../model/user_info.dart';
import '../../repo/auth_repository.dart';
import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/membership/membership_card_screen.dart';
import '../../ui/membership/model/payment_info.dart';
import '../../ui/membership/widgets/docs_upload_single_widget.dart';
import '../../ui/membership/widgets/membership_list_item.dart';
import '../../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../country_picker_util/country_code_picker.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/people.dart';
import '../../model/user_info.dart';
import '../../repo/auth_repository.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';
import '../../ui_utils/text_styles.dart';
import '../../ui_utils/widget_styles.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/submit_button.dart';
import '../custom_drawer/navigation_home_screen.dart';
import '../custom_people_search.dart';
import '../diagnosis/bloc/people_search_bloc.dart';
import '../tabs/app_localizations.dart';
import 'api/membership_api_client.dart';
import 'membership_benefits.dart';
import 'model/membership_form_field_info.dart';
import 'model/membership_info.dart';
import 'model/payment_info.dart';
import 'repo/membership_repo.dart';
import 'widgets/dismissible_message_widget.dart';
import 'widgets/docs_upload_widget.dart';
import 'widgets/membership_list_item.dart';
import 'widgets/payment_cancel_dialog.dart';
import 'widgets/payments_widget.dart';

// const String oneYearNew = "1 Year - \$140";
// const String twoYearNew = "2 Years - \$190";
// const String threeYearNew = "3 Years - \$240";
// const String oneYearRenewal = "1 Year - \$100";
// const String twoYearRenewal = "2 Years - \$150";
// const String threeYearRenewal = "3 Years - \$200";

const String month = "1 Month - Rs.50";
const String quaterly = "3 Months - Rs.150";
const String halfYearly = "6 Months - Rs.300";
const String yearly = "1 Year - Rs.600";

// Special skills
const String medical = "Medical";
const String legal = "Legal";
const String marketing = "Marketing/communicaction";
const String graphicDesign = "IT/Graphic Design";
const String accounts = "Accounts";
const String fitness = "Fitness/Nutrition";

// Other interests
// const String otherInterestSports = "Sports";
// const String otherInterestBlogging = "Blogging";
// const String otherInterestTraveling = "Traveling";
// const String otherInterestArtDesign = "Art & Design";
// const String otherInterestMusic = "Music (Dancing & Singing)";
// const String otherInterestReading = "Reading";
// const String otherInterestVideoGaming = "Video Gaming";
// const String otherInterestYoga = "Yoga";

const String UNDER_REVIEW = "Under Review";
const String PENDING_PAYMENT = "Pending Payment";
const String PENDING_APPROVAL = "Pending Approval";
const String APPROVED = "Approved";
const String REJECTED = "Rejected";
const String EXPIRED = "Expired";

const String LIFE = "Life";
const String SUBSCRIPTION = "Subscription";

const String NEW_MEMBER = "New Member";
const String RENEWAL = "Renewal";

const String FN_FIRST_NAME = "firstName";
const String FN_LAST_NAME = "lastName";
const String FN_GENDER = "gender";
const String FN_AGE = "age";
const String FN_EMAIL_ADDRESS = "emailAddress";
const String FN_PHONE_NUMBER = "phoneNumber";
const String FN_SECONDARY_PHONE_NUMBER = "secondaryPhoneNumber";
const String FN_ADDRESSLINE_ONE = "addressLine1";
const String FN_ADDRESSLINE_TWO = "addressLine2";
const String FN_DISTRICT = "district";
const String FN_STATE = "state";
const String FN_CITY = "city";
const String FN_COUNTRY = "country";
const String FN_ZIPCODE = "zipcode";
const String FN_IDENTITY_PROOF = "identityProof";
const String FN_FEES = "fees";
const String FN_BIRTH_DATE = "birthDate";
const String FN_OTHER_NAMES = "otherNames";
const String FN_OCCUPATION = "occupation";
const String FN_NATIONAL_ID = "nationalId";
const String FN_DOCUMENT_UPLOAD = "documentUpload";
const String FN_DIABETES_QUESTIONNAIRE = "diabetesQuestionnaire";
const String FN_SPECIAL_SKILLS = "specialSkills";
const String FN_BRANCH = "branch";
const String FN_COMMENTS = "comments";
const String FN_APPROVAL = "approval";

const String FN_BLOOD_GROUP = "bloodGroup";
const String FN_EDUCATIONAL_QUALIFICATION = "educationalQualification";
const String FN_RN_NUMBER = "rnNumber";
const String FN_DOCUMENT_NAME = "documentName";
const String FN_WORK_LOCATION = "workLocation";
const String FN_REFERRED_BY = "referredBy";
const String FN_OTHER_INTERESTS = "otherInterests";
const String FN_TERMS_CONDITIONS = "terms&Conditions";
const String FN_HISTORY = "history";
const String FN_ADDRESS_PROOF_ID = "address_proof";
const String FN_ADDRESS_PROOF_DOCUMENT = "update_address_proof";
const String FN_RNRM_NUM_DOCUMENT = "rnrm_num";
const String FN_RECENT_PIC_DOCUMENT = "recent_pic";
const String KEY_REFERRED_BY_VALUE_SM = "REFERRED_BY_VALUE_SM";

/// Page reference key
const String KEY_QUALIFICATION = "QUALIFICATION";
const String KEY_GENDER = "GENDER";
const String KEY_BLOOD_GROUP = "BLOOD_GROUP";
const String KEY_OTHER_INTERESTS = "OTHER_INTERESTS";
const String KEY_DOCUMENTS = "DOCUMENTS";
const String KEY_REFERRED_BY = "REFERRED_BY";
const String KEY_FIELD_VALUE = "fieldValue";
const String KEY_FIELD_DISPLAY_VALUE = "fieldDisplayValue";

enum MembershipStatus {
  UnderReview,
  PendingPayment,
  PendingApproval,
  Approved,
  Rejected,
  Expired,
}

enum MembershipType {
  Life,
  Subscription,
}

final DateFormat gnatDobFormat = DateFormat("dd/MM/yyyy");
final DateFormat originalDobFormat = DateFormat("MM/dd/yyyy");

class MembershipScreen extends StatefulWidget {
  final String membershipId;
  final bool isCameHierarchyFrom;

  const MembershipScreen(
      {Key key, @required this.membershipId, this.isCameHierarchyFrom: false})
      : super(key: key);

  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _alertFormKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  double screenWidth;
  String _genderValue = "Male";
  String selectedBranch;
  var searchByUserNameController = TextEditingController();
  var otherNameController = TextEditingController();
  var dateOfBirthController = TextEditingController();
  var ageController = TextEditingController();
  var zipCodeController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var addressOneController = TextEditingController();
  var addressTwoController = TextEditingController();
  var districtController = TextEditingController();
  var areaController = TextEditingController();
  var firstController = TextEditingController();
  var lastController = TextEditingController();
  var emailController = TextEditingController();
  // var
  var occupationController = TextEditingController();
  var referedPersonNameContoller = TextEditingController();
  var nationalIdController = TextEditingController();
  var courseMajorController = TextEditingController();
  var courseCompletionStatusController = TextEditingController();
  var otherQualificationController = TextEditingController();
  var otherInterestController = TextEditingController();
  var additionalInfoController = TextEditingController();

  List<dynamic> preferredLocationsList = [];
  List<DropdownMenuItem<String>> preferredLocations = [];

  var phoneHomeController = TextEditingController();
  var phoneCellController = TextEditingController();

  var receiptNumberController = TextEditingController();
  var commentsController = TextEditingController();

  String countryCodeHome = "";
  String countryDialCodeHome = "";

  String addressProofPicURL = "";

  String countryCodeCell = "";
  String countryDialCodeCell = "";

  String membershipFeeRadioValue = NEW_MEMBER;

  //String newMemberFees = oneYearNew;
  String socialMedia;
  String newMemberFees = month;
  String renewelMemberFees = "";
  String receiptNumber = "";
  bool showEditReceiptNumber = false;
  List<String> specialSkills = [];
  List<DropdownMenuItem<PageReferenceData>> socialMediaDropDownList;
  List<dynamic> socialMediaList;
  bool isDiagnosedDiabetes = false;
  bool isFamilyHasDiabetes = false;
  bool isVolunteer = false;
  bool hasPaymentEnabled = false;

  bool paymentCheckbox = false;
  bool paymentStatus = false;
  MembershipStatus _membershipStatus = MembershipStatus.UnderReview;
  MembershipType _membershipType = MembershipType.Subscription;

  List<String> specialSkillsArray = [
    medical,
    legal,
    marketing,
    graphicDesign,
    accounts,
    fitness
  ];

  List<String> _selectedSpecialSkillsArray = [];
  List<String> _selectedOtherInterestsArray = [];

  MembershipRepository _membershipRepository;
  MembershipInfo _membershipInfo;
  AuthRepository _authRepository;

  PeopleBloc _peopleBloc;

  bool _isMembershipInfoLoaded = false;
  String _membershipUserName = "";
  String _departmentName = "";
  String _membershipDepartment = "";
  bool _isDiabetesReadOnly = false;
  bool _isFamilyDiabetesReadOnly = false;

  String _paymentMode = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController;

  File documentFrontImage, documentBackImage;
  File documentAddressProofImage, documentRnRmImage, documentRececentImage;

  String _userFullName = "";

  //double totalAmount = 140.0;
  double totalAmount = 50.0;
  double cardRenewal = 20.0;

  String recommendedBy = "";

  Color textFieldFillColor = Colors.grey.shade200;
  bool _isRestrictToEditFields = false;

  List<MembershipFormFieldInfo> _membershipFormFieldInfoList;
  List<String> _membershipFormFieldNameList;
  String _bloodGroup;
  String _educationalQualification;
  String _referredBy;
  var rnRmNumberController = TextEditingController();
  var workLocationController = TextEditingController();
  String _documentName;
  bool _isTermsAndConditionChecked = false;

  String clientId;
  bool membershipBenefitsOptionEnable = false;
  List<PageReferenceData> genderList;

  // = [
  //   PageReferenceData("Male", "Male"),
  //   PageReferenceData("Female", "Female")
  // ];
  //List<PageReferenceData> documentNameList;
  //List<PageReferenceData> referredByList;
  List<PageReferenceData> otherInterestsList;

  List<DropdownMenuItem<PageReferenceData>> _eduQualDropdownMenuItems;
  List<DropdownMenuItem<PageReferenceData>> _bloodGroupDropdownMenuItems;
  List<DropdownMenuItem<PageReferenceData>> _documentNameDropdownMenuItems;
  List<DropdownMenuItem<PageReferenceData>> _referredByDropdownMenuItems;

  List<String> _eduCompletionDropdownItems = [
    'Pursuing',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    documentFrontImage = null;
    documentBackImage = null;

    documentAddressProofImage = null;
    documentRnRmImage = null;
    documentRececentImage = null;

    /// To fetch the non-members
    _membershipRepository = MembershipRepository(
        membershipApiClient: MembershipApiClient(httpClient: http.Client()));
    _peopleBloc = PeopleBloc(
      diagnosisRepository: null,
      membershipRepository: _membershipRepository,
      fromRepo: FromRepo.Membership,
    );
    _authRepository = new AuthRepository();

    /// Fetch membership page reference data
    _fetchPageReferenceData();
    getMembershipBenefitsDataExits();
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    /// Initialize Admob
    initializeAd();
  }

  @override
  void deactivate() {
    _peopleBloc.close();
    super.deactivate();
  }

  getMembershipBenefitsDataExits() async {
    var membershipBenefitsData =
        await AppPreferences.getMembershipBenefitsContent();
    if (membershipBenefitsData.isNotEmpty) {
      membershipBenefitsOptionEnable = true;
    }
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

  Future<void> _fetchPageReferenceData() async {
    // debugPrint(
    //     "clientId from preference --> ${await AppPreferences.getClientId()}");
    clientId = await AppPreferences.getClientId();
    //clientId = "GNAT";
    //print("======================> Client ID $clientId");
    http.Response membershipPageReferenceData = await _membershipRepository
        .getMembershipPageReferenceData(clientId: clientId);
    if (membershipPageReferenceData.statusCode ==
        WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Map<String, dynamic> membershipPageReferenceJson =
          jsonDecode(membershipPageReferenceData.body);
      if (membershipPageReferenceJson.containsKey(KEY_QUALIFICATION)) {
        List<dynamic> qualificationList =
            membershipPageReferenceJson[KEY_QUALIFICATION];
        if (qualificationList != null) {
          List<PageReferenceData> educationalQualificationList = [];
          qualificationList.forEach((element) {
            educationalQualificationList.add(PageReferenceData(
                element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
            _eduQualDropdownMenuItems =
                buildDropDownMenuItems(educationalQualificationList);
          });
        }
      }

      List<PageReferenceData> socialMediaPageReferenceDataList =
          new List<PageReferenceData>();
      socialMediaList = membershipPageReferenceJson[KEY_REFERRED_BY_VALUE_SM];
      socialMediaList.forEach((element) {
        socialMediaPageReferenceDataList.add(PageReferenceData(
            element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
      });
      socialMediaDropDownList =
          buildDropDownMenuItems(socialMediaPageReferenceDataList);
      if (membershipPageReferenceJson.containsKey(KEY_BLOOD_GROUP)) {
        List<dynamic> bloodGroupListData =
            membershipPageReferenceJson[KEY_BLOOD_GROUP];
        if (bloodGroupListData != null) {
          List<PageReferenceData> bloodGroupList = [];
          bloodGroupListData.forEach((element) {
            bloodGroupList.add(PageReferenceData(
                element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
            _bloodGroupDropdownMenuItems =
                buildDropDownMenuItems(bloodGroupList);
          });
        }
      }

      if (membershipPageReferenceJson.containsKey(KEY_OTHER_INTERESTS)) {
        List<dynamic> otherInterestsListData =
            membershipPageReferenceJson[KEY_OTHER_INTERESTS];
        if (otherInterestsListData != null) {
          otherInterestsList = [];
          otherInterestsListData.forEach((element) {
            otherInterestsList.add(PageReferenceData(
                element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
          });
        }
      }

      if (membershipPageReferenceJson.containsKey(KEY_GENDER)) {
        List<dynamic> genderListData = membershipPageReferenceJson[KEY_GENDER];
        if (genderListData != null) {
          genderList = [];
          genderListData.forEach((element) {
            genderList.add(PageReferenceData(
                element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
          });
        }
      }

      if (membershipPageReferenceJson.containsKey(KEY_DOCUMENTS)) {
        List<dynamic> documentNameListData =
            membershipPageReferenceJson[KEY_DOCUMENTS];
        if (documentNameListData != null) {
          List<PageReferenceData> documentNameList = [];
          documentNameListData.forEach((element) {
            documentNameList.add(PageReferenceData(
                element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
            _documentNameDropdownMenuItems =
                buildDropDownMenuItems(documentNameList);
          });
        }
      }

      if (membershipPageReferenceJson.containsKey(KEY_REFERRED_BY)) {
        List<dynamic> referredByListData =
            membershipPageReferenceJson[KEY_REFERRED_BY];
        if (referredByListData != null) {
          List<PageReferenceData> referredByList = [];
          referredByListData.forEach((element) {
            referredByList.add(PageReferenceData(
                element[KEY_FIELD_VALUE], element[KEY_FIELD_DISPLAY_VALUE]));
            _referredByDropdownMenuItems =
                buildDropDownMenuItems(referredByList);
          });
        }
      }
    } else {
      String errorMsg =
          jsonDecode(membershipPageReferenceData.body)['message'] as String;

      AlertUtils.showAlertDialog(
          context,
          errorMsg != null && errorMsg.isNotEmpty
              ? errorMsg
              : AppPreferences().getApisErrorMessage);
    }

    /// Fetch membership form fields
    _fetchMembershipFormFields();
  }

  Future<void> _fetchMembershipFormFields() async {
    http.Response membershipFormResponse =
        await _membershipRepository.getMembershipFormFields(clientId: clientId);

    //debugPrint("membershipFormResponse --> ${membershipFormResponse.body}");
    if (membershipFormResponse.statusCode ==
        WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(membershipFormResponse.body);
      _membershipFormFieldInfoList =
          data.map((data) => MembershipFormFieldInfo.fromJson(data)).toList();
      if (_membershipFormFieldInfoList != null) {
        _membershipFormFieldNameList = [];
        _membershipFormFieldInfoList.forEach((element) {
          // debugPrint("fieldName --> ${element.fieldName}  ${element.toJson()}");
          _membershipFormFieldNameList.add(element.fieldName);
        });
      }

      if (_membershipFormFieldNameList != null &&
          _membershipFormFieldNameList.contains(FN_BRANCH)) {
        /// Fetch branch locations
        fetchPreferredLocations();
      } else {
        if (AppPreferences().role == Constants.supervisorRole) {
          if (widget.membershipId != null) {
            _fetchMembershipInfoById();
          } else {
            recommendedBy = "Supervisor";
            setState(() {
              _isMembershipInfoLoaded = true;
            });
          }
        } else {
          _fetchMembershipInfoByUserName();
        }
      }
    } else {
      String errorMsg =
          jsonDecode(membershipFormResponse.body)['message'] as String;

      AlertUtils.showAlertDialog(
          context,
          errorMsg != null && errorMsg.isNotEmpty
              ? errorMsg
              : AppPreferences().getApisErrorMessage);
    }
  }

  Future<void> _fetchMembershipInfoById() async {
    _membershipInfo =
        await _membershipRepository.getMembershipInfoById(widget.membershipId);
    _bindData();
  }

  Future<void> _fetchMembershipInfoByUserName() async {
    String userName = await AppPreferences.getUsername();
    String deptName = await AppPreferences.getDeptName();
    print(deptName);
    print(userName);
    _membershipUserName = userName;
    _membershipInfo =
        await _membershipRepository.getMembershipInfoByUserName(userName);

    if (_membershipInfo != null) {
      _isRestrictToEditFields = true;

      _bindData();
    } else {
      AuthBloc bloc = AuthBloc(context);
      await bloc.getUserInformation();
      _bindUserInfo();
    }
  }

  _bindUserInfo() {
    AppPreferences.getUserInfo()?.then((userInfo) {
      //print("user info = " + userInfo.toJson().toString());
      setState(() {
        firstController.text = userInfo.firstName;
        lastController.text = userInfo.lastName;
        _genderValue = ValidationUtils.isNullEmptyOrFalse(userInfo?.gender)
            ? "No"
            : userInfo?.gender;
        if (userInfo.birthDate != null && userInfo.birthDate.isNotEmpty)
          dateOfBirthController.text = _displayDobFormat(userInfo.birthDate);
        ageController.text = userInfo.age.toString();
        addressOneController.text = userInfo.addressLine1;
        addressTwoController.text = userInfo.addressLine2;
        cityController.text =
            (userInfo.city != null && userInfo.city.isNotEmpty)
                ? userInfo.city
                : userInfo.cityName;
        stateController.text =
            (userInfo.state != null && userInfo.state.isNotEmpty)
                ? userInfo.state
                : userInfo.stateName;
        countryController.text = userInfo.countryName;
        zipCodeController.text = userInfo.zipCode;
        emailController.text = userInfo.emailId;

        courseMajorController.text = userInfo.additionalQualificationMajor;
        courseCompletionStatusController.text =
            userInfo.additionalQualificationStatus;
        additionalInfoController.text = userInfo.additionalInfo;
        _documentName = userInfo.addressProof;
        nationalIdController.text = userInfo.addressProofId;
        _bloodGroup = userInfo.bloodGroup;
        _educationalQualification = userInfo.qualification;
        addressProofPicURL = userInfo.addressProofPic;
        //print("==================>${userInfo.addressProof}");
        countryCodeHome = userInfo?.countryCode ?? AppPreferences().country;

        countryDialCodeHome = userInfo.countryCodeValue;

        countryCodeCell =
            userInfo?.secondaryCountryCode ?? AppPreferences().country;
        countryDialCodeCell = userInfo.secondaryCountryCodeValue;

        if (countryDialCodeHome.isNotEmpty) {
          phoneHomeController.text =
              userInfo.mobileNo.substring(countryDialCodeHome.length);
        } else {
          phoneHomeController.text =
              userInfo.mobileNo.substring(userInfo.mobileNo.length - 10);
        }

        if (countryDialCodeCell != null &&
            countryDialCodeCell.isNotEmpty &&
            userInfo.secondMobileNo != null) {
          phoneCellController.text =
              userInfo.secondMobileNo.substring(countryDialCodeCell.length);
        } else {
          if (userInfo.secondMobileNo != null &&
              userInfo.secondaryCountryCode.isNotEmpty)
            phoneCellController.text = userInfo.secondMobileNo
                .substring(userInfo.secondMobileNo.length - 10);
          else {
            phoneCellController.text = userInfo.secondMobileNo;
          }
        }

        //phoneCellController.text = userInfo.secondMobileNo;
        _userFullName = userInfo.userFullName;

        recommendedBy = "User";

        //setState(() {
        _isMembershipInfoLoaded = true;
        //});
      });
    });
  }

  convertFeesToAmount(String memberFee) {
    List<String> strList = memberFee.split("-");
    if (strList.length > 1) {
      List<String> amountStrList = strList[1].split("Rs.");
      if (amountStrList.length > 1)
        totalAmount = double.parse(amountStrList[1]);
    }
  }

  _bindData() {
    if (_membershipInfo != null) {
      // debugPrint("_membershipInfo --> $_membershipInfo");
      // debugPrint("userName --> ${_membershipInfo.userName}");
      // debugPrint("departmentName --> ${_membershipInfo.departmentName}");
      // debugPrint("oldDepartmentName --> ${_membershipInfo.oldDepartmentName}");
      // debugPrint("branch --> ${_membershipInfo.branch}");
      // debugPrint("Proof Front : ${_membershipInfo.recentPicture}");
      // debugPrint("Proof Back : ${_membershipInfo.identifyProofBack}");
      debugPrint("renewal fees --> ${_membershipInfo.renewalFees}");
      // debugPrint(
      //     "countryDialCodeHome --> ${_membershipInfo.countryCodeValueCell}");
      setState(() {
        _membershipUserName = _membershipInfo.userName;
        _membershipDepartment = _membershipInfo.departmentName;
        firstController.text = _membershipInfo.firstName;
        lastController.text = _membershipInfo.lastName;
        otherNameController.text = _membershipInfo.otherNames;
        _genderValue = _membershipInfo.gender;
        if (_membershipInfo.birthDate != null &&
            _membershipInfo.birthDate.isNotEmpty) {
          dateOfBirthController.text =
              _displayDobFormat(_membershipInfo.birthDate);
        }

        if (_membershipInfo.age != 0)
          ageController.text = _membershipInfo.age.toString();
        nationalIdController.text = _membershipInfo.nationalId;
        addressOneController.text = _membershipInfo.address1;
        addressTwoController.text = _membershipInfo.address2;
        if (_membershipInfo.district != null &&
            _membershipInfo.district.isNotEmpty) {
          districtController.text = _membershipInfo.district;
        }
        // print(
        //     "=========================> AddressProofpic ${_membershipInfo.addressProof}");
        // print(
        //     "=========================> CourseMajor ${_membershipInfo.additionalQualificationMajor}");
        addressProofPicURL = _membershipInfo.addressProof;

        cityController.text = _membershipInfo.city;
        stateController.text = _membershipInfo.state;
        countryController.text = _membershipInfo.country;
        zipCodeController.text = _membershipInfo.zipcode;
        occupationController.text = _membershipInfo.occupation;
        emailController.text = _membershipInfo.emailId;
        countryCodeHome = _membershipInfo.countryCodeHome;
        countryDialCodeHome = _membershipInfo.countryCodeValueHome;
        countryCodeCell = _membershipInfo.countryCodeCell;
        countryDialCodeCell = _membershipInfo.countryCodeValueCell;
        phoneHomeController.text = _membershipInfo.homeNumber;
        phoneCellController.text = _membershipInfo.cellNumber;
        newMemberFees = _membershipInfo.newMemberFees;
        // print(
        //     "==============================> Social Media Value ${_membershipInfo.toJson()}");
        if (_membershipInfo.referredBy == "Person") {
          referedPersonNameContoller.text = _membershipInfo.referredByValue;
        } else {
          socialMedia = _membershipInfo.referredByValue;
        }

        debugPrint(
            "_membershipInfo.referredByValue --> ${_membershipInfo.referredByValue}");

        //print(_membershipInfo.additionalQualificationMajor);
        courseMajorController.text =
            _membershipInfo.additionalQualificationMajor;
        courseCompletionStatusController.text =
            _membershipInfo.additionalQualificationStatus;
        additionalInfoController.text = _membershipInfo.additionalInfo;
        _documentName = _membershipInfo.addressProof;

        if (newMemberFees.isNotEmpty) {
          convertFeesToAmount(newMemberFees);
        }
        _paymentMode = _membershipInfo.paymentMode;
        receiptNumber = _membershipInfo.receiptNo;
        if (_membershipInfo.comments != null)
          commentsController.text = _membershipInfo.comments;

        if (_membershipInfo.membershipStatus == APPROVED) {
          membershipFeeRadioValue = RENEWAL;
        }

        if (_membershipInfo.membershipType != null &&
            _membershipInfo.membershipType.isNotEmpty) {
          switch (_membershipInfo.membershipType) {
            case SUBSCRIPTION:
              _membershipType = MembershipType.Subscription;
              break;
            case LIFE:
              _membershipType = MembershipType.Life;
              break;
            default:
              _membershipType = MembershipType.Subscription;
              break;
          }
        }

        switch (_membershipInfo.membershipStatus) {
          case UNDER_REVIEW:
            // print(
            //     "===========================> Membership Status${_membershipInfo.membershipStatus}");
            _membershipStatus = MembershipStatus.UnderReview;
            break;
          case PENDING_PAYMENT:
            // print(
            //     "===========================> Membership Status${_membershipInfo.membershipStatus}");
            _membershipStatus = MembershipStatus.PendingPayment;
            break;
          case PENDING_APPROVAL:
            // print(
            //     "===========================> Membership Status${_membershipInfo.membershipStatus}");
            _membershipStatus = MembershipStatus.PendingApproval;
            break;
          case APPROVED:
            // print(
            // "===========================> Membership Status${_membershipInfo.membershipStatus}");
            if (isMembershipExpired(_membershipInfo)) {
              receiptNumber = "";
              paymentStatus = false;
              _paymentMode = "";
            }
            _membershipStatus = MembershipStatus.Approved;
            break;
          case REJECTED:
            _membershipStatus = MembershipStatus.Rejected;
            break;
          default:
            _membershipStatus = MembershipStatus.UnderReview;
        }

        if (_paymentMode != null &&
            _paymentMode.isNotEmpty &&
            receiptNumber != null &&
            receiptNumber.isNotEmpty) {
          paymentCheckbox = true;
          paymentStatus = true;
        }
        //print("inside $paymentStatus $paymentCheckbox");
        renewelMemberFees = _membershipInfo.renewalFees ?? '';
        if (renewelMemberFees.isNotEmpty) {
          convertFeesToAmount(renewelMemberFees);
          totalAmount += cardRenewal;
        }

        //("renewelMemberFees is --> $renewelMemberFees");
        if (_membershipInfo.diabetes == "Yes") {
          _isDiabetesReadOnly = true;
          isDiagnosedDiabetes = true;
        } else
          isDiagnosedDiabetes = false;

        if (_membershipInfo.diabetesFamilyHistory == "Yes") {
          _isFamilyDiabetesReadOnly = true;
          isFamilyHasDiabetes = true;
        } else
          isFamilyHasDiabetes = false;

        if (_membershipInfo.volunteer == "Yes")
          isVolunteer = true;
        else
          isVolunteer = false;
        if (preferredLocationsList.contains(_membershipInfo.branch)) {
          //debugPrint("preferredLocations contains");
          selectedBranch = _membershipInfo.branch;
          //print("IF Selected banch ${_membershipInfo.branch}");
        }
        // else {
        //   print("preferredLocations dosen,t contains");
        //   //selectedBranch = _membershipInfo.branch;
        //   print("ELSE Selected banch ${_membershipInfo.branch}");
        // }

        _membershipInfo.specialSkills?.asMap()?.forEach((key, value) {
          _selectedSpecialSkillsArray.add(value);
        });

        _userFullName = _membershipInfo.userFullName;

        if (_membershipInfo.recommendedBy != null &&
            _membershipInfo.recommendedBy.isNotEmpty) {
          recommendedBy = _membershipInfo.recommendedBy;
        }

        if (_membershipInfo.bloodGroup != null &&
            _membershipInfo.bloodGroup.isNotEmpty)
          _bloodGroup = _membershipInfo.bloodGroup;

        if (_membershipInfo.qualification != null &&
            _membershipInfo.qualification.isNotEmpty) {
          if (_eduQualDropdownMenuItems != null) {
            bool foundValue = false;
            _eduQualDropdownMenuItems.forEach((element) {
              if (element.value.fieldValue == _membershipInfo.qualification) {
                foundValue = true;
              }
            });
            if (foundValue)
              _educationalQualification = _membershipInfo.qualification;
            else {
              _educationalQualification = "Other";
              otherQualificationController.text = _membershipInfo.qualification;
            }
          }
        }

        if (_membershipInfo.registeredNurse != null &&
            _membershipInfo.registeredNurse.isNotEmpty)
          rnRmNumberController.text = _membershipInfo.registeredNurse;

        if (_membershipInfo.registeredNurse != null &&
            _membershipInfo.registeredNurse.isNotEmpty)
          rnRmNumberController.text = _membershipInfo.registeredNurse;

        if (_membershipInfo.documentName != null &&
            _membershipInfo.documentName.isNotEmpty)
          _documentName = _membershipInfo.documentName;

        if (_membershipInfo.workLocation != null &&
            _membershipInfo.workLocation.isNotEmpty)
          workLocationController.text = _membershipInfo.workLocation;

        // if (_membershipInfo.referredBy != null &&
        //     _membershipInfo.referredBy.isNotEmpty)
        //   _referredBy = _membershipInfo.referredBy;
        if (_membershipInfo.referredBy != null &&
            _membershipInfo.referredBy.isNotEmpty) {
          if (_referredByDropdownMenuItems != null) {
            bool foundValue = false;
            _referredByDropdownMenuItems.forEach((element) {
              if (element.value.fieldValue == _membershipInfo.referredBy) {
                foundValue = true;
              }
            });
            if (foundValue)
              _referredBy = _membershipInfo.referredBy;
            else {
              _referredBy = "Person";
              referedPersonNameContoller.text = _membershipInfo.referredBy;
            }
          }
        }

        _membershipInfo.otherInterests?.asMap()?.forEach((key, value) {
          _selectedOtherInterestsArray.add(value);
        });

        if (_selectedOtherInterestsArray.contains("Others")) {
          _selectedOtherInterestsArray.forEach((selectedInterest) {
            if (otherInterestsList != null) {
              if (!otherInterestsList.contains(selectedInterest)) {
                otherInterestController.text = selectedInterest;
              }
            }
          });
        }

        _isMembershipInfoLoaded = true;
        _isTermsAndConditionChecked = true;
      });
    }
  }

  String _displayDobFormat(String dob) {
    debugPrint("dob --> $dob");
    DateFormat inputDateFormat = DateFormat("MM/dd/yyyy");
    DateFormat outputDateFormat = DateFormat("dd/MM/yyyy");
    DateTime dateTime = inputDateFormat.parse(dob);
    return outputDateFormat.format(dateTime);
  }

  String _serverDobFormat(String dob) {
    debugPrint("dob --> $dob");
    DateFormat inputDateFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputDateFormat = DateFormat("MM/dd/yyyy");

    DateTime dateTime = inputDateFormat.parse(dob);
    return outputDateFormat.format(dateTime);
  }

  _setMembershipInfoFromPeople(People peopleInfo) async {
    _clearMembershipInfo();
    UserInfo people = await _authRepository.getUserInfo(peopleInfo.userName);

    //print("saass: " + people.addressProofPic ?? "");
    _membershipUserName = people.userName;
    _membershipDepartment = people.departmentName;
    print("$_membershipUserName $_membershipDepartment");
    firstController.text = people.firstName;
    lastController.text = people.lastName;
    _userFullName = people.userFullName;
    //debugPrint("_userFullName --> $_userFullName");
    _genderValue = people.gender;
    if (people.birthDate != null && people.birthDate.isNotEmpty) {
      dateOfBirthController.text = _displayDobFormat(people.birthDate);
    }

    ageController.text =
        people.age?.toString() == "0" ? "0" : people.age?.toString();
    addressOneController.text = people.addressLine1;
    addressTwoController.text = people.addressLine2;
    cityController.text = people.cityName;
    stateController.text = people.stateName;
    countryController.text = people.countryName;
    zipCodeController.text = people.zipCode;
    emailController.text = people.emailId;

    courseMajorController.text = people.additionalQualificationMajor;
    courseCompletionStatusController.text =
        people.additionalQualificationStatus;
    additionalInfoController.text = people.additionalInfo;
    _documentName = people.addressProof;
    nationalIdController.text = people.addressProofId;
    _bloodGroup = people.bloodGroup;
    _educationalQualification = people.qualification;
    addressProofPicURL = people.addressProofPic;

    if (people.mobileNo != null && people.mobileNo.isNotEmpty) {
      if (people.countryCodeValue != null &&
          people.countryCodeValue.isNotEmpty) {
        phoneHomeController.text =
            people.mobileNo.substring(people.countryCodeValue.length);
      } else {
        phoneHomeController.text =
            people.mobileNo.substring(people.mobileNo.length - 10);
      }
    }

    if (people.secondMobileNo != null && people.secondMobileNo.isNotEmpty) {
      if (people.countryCodeValue != null &&
          people.countryCodeValue.isNotEmpty) {
        phoneCellController.text =
            people.secondMobileNo.substring(people.countryCodeValue.length);
      } else {
        phoneCellController.text =
            people.secondMobileNo.substring(people.secondMobileNo.length - 10);
      }
    }

    if (people.countryCode != null && people.countryCode.isNotEmpty) {
      setState(() {
        countryCodeHome =
            people.countryCode != null && people.countryCode.isNotEmpty
                ? ValidationUtils.isName(people?.countryCode)
                    ? people?.countryCode
                    : '+${people?.countryCode}'
                : null;
      });
    }

    if (people.secondaryCountryCode != null &&
        people.secondaryCountryCode.isNotEmpty) {
      setState(() {
        countryCodeCell = people.secondaryCountryCode != null &&
                people.secondaryCountryCode.isNotEmpty
            ? ValidationUtils.isName(people?.secondaryCountryCode)
                ? people?.secondaryCountryCode
                : '+${people?.secondaryCountryCode}'
            : null;
      });
    }
  }

  _clearMembershipInfo() {
    searchByUserNameController.clear();
    firstController.clear();
    lastController.clear();
    _genderValue = "Male";
    dateOfBirthController.clear();
    ageController.clear();
    addressOneController.clear();
    addressTwoController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    zipCodeController.clear();
    emailController.clear();
    phoneHomeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setGlobalContext(context);
    screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => _peopleBloc,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: AppColors.primaryColor,
          title: Text('Membership Information',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: membershipBenefitsOptionEnable
              ? [
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (_) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MembershipBenefits(),
                      ),
                    ),
                    itemBuilder: (BuildContext context) {
                      return {'Membership Benefits'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ]
              : null,
        ),
        //: null,
        body: (!_isMembershipInfoLoaded)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (!hasPaymentEnabled)
                ? Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Container(
                            margin: new EdgeInsets.all(15.0),
                            child: Form(
                              key: _formKey,
                              autovalidate: _autoValidate,
                              child: formUI(),
                            ),
                          ),
                        ),
                      ),

                      /// Show Banner Ad
                      getSivisoftAdWidget(),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 380,
                        //height: 280,
                        child: Column(
                          children: [
                            Expanded(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Payment method",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                IconButton(
                                                    icon: Icon(Icons.clear),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              PaymentCancellationDialog(
                                                                onTap: () {
                                                                  setState(() {
                                                                    hasPaymentEnabled =
                                                                        false;
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                500),
                                                                        () {
                                                                      _scrollController.jumpTo(_scrollController
                                                                          .position
                                                                          .maxScrollExtent);
                                                                    });
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
                                            MediaQuery.of(context).size.height *
                                                1 /
                                                1.6,
                                        child: PaymentsWidget(
                                          repository: _membershipRepository,
                                          paymentDescription: membershipFeeRadioValue ==
                                                  NEW_MEMBER
                                              ? "Membership Fee for $_userFullName"
                                              : "Membership Renewal Fee for $_userFullName",
                                          totalAmount: totalAmount + 250,
                                          name: _membershipUserName,
                                          email: emailController.text,
                                          departmentName: _membershipDepartment,
                                          phoneNumber: phoneHomeController
                                                  .text.isNotEmpty
                                              ? phoneHomeController.text
                                              : phoneCellController.text,
                                          paymentStatus: (bool payStatus,
                                              String paymentMode,
                                              String requestId) async {
                                            if (paymentMode == "Cash") {
                                              debugPrint("Cash mode...");

                                              setState(() {
                                                hasPaymentEnabled = false;
                                                _paymentMode = paymentMode;
                                                paymentStatus = payStatus;
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  _scrollController.jumpTo(
                                                      _scrollController.position
                                                          .maxScrollExtent);
                                                });
                                              });
                                            } else if (paymentMode == "Card") {
                                              if (payStatus) {
                                                CustomProgressLoader.showLoader(
                                                    context);
                                                List<PaymentInfo>
                                                    paymentInfoList =
                                                    await _membershipRepository
                                                        .getMembershipTransactionDetails(
                                                            requestId:
                                                                requestId,
                                                            transactionType:
                                                                "MEMBERSHIP");

                                                PaymentInfo paymentInfo;
                                                if (paymentInfoList.length >
                                                    0) {
                                                  paymentInfoList
                                                      .forEach((element) {
                                                    debugPrint(
                                                        "element --> ${element.toJson()}");
                                                    paymentInfo = element;
                                                  });
                                                }
                                                CustomProgressLoader
                                                    .cancelLoader(context);
                                                if (paymentInfo != null &&
                                                    paymentInfo
                                                            .transactionStatus ==
                                                        "success") {
                                                  setState(() {
                                                    paymentStatus = true;
                                                    receiptNumber =
                                                        paymentInfoList[0]
                                                            .transactionId;
                                                    hasPaymentEnabled = false;
                                                    _paymentMode = paymentMode;
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 500),
                                                        () {
                                                      _scrollController.jumpTo(
                                                          _scrollController
                                                              .position
                                                              .maxScrollExtent);
                                                    });
                                                  });
                                                } else {
                                                  setState(() {
                                                    paymentStatus = false;
                                                    hasPaymentEnabled = false;
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 500),
                                                        () {
                                                      _scrollController.jumpTo(
                                                          _scrollController
                                                              .position
                                                              .maxScrollExtent);
                                                    });
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  hasPaymentEnabled = false;
                                                  paymentStatus = false;
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 500),
                                                      () {
                                                    _scrollController.jumpTo(
                                                        _scrollController
                                                            .position
                                                            .maxScrollExtent);
                                                  });
                                                });
                                              }
                                            }

                                            if (payStatus) {
                                              if (paymentMode == "Cash") {
                                                if (AppPreferences().role ==
                                                    Constants.USER_ROLE) {
                                                  showUserCashSuccessDialog(
                                                      context);
                                                } else {
                                                  receiptNoDialogue(context);
                                                }
                                              }

                                              if (_membershipStatus ==
                                                      MembershipStatus
                                                          .PendingPayment ||
                                                  _membershipStatus ==
                                                      MembershipStatus
                                                          .UnderReview) {
                                                if (receiptNumber != null &&
                                                    receiptNumber.isNotEmpty)
                                                  _membershipStatus =
                                                      MembershipStatus
                                                          .PendingApproval;
                                              }
                                            }
                                          },
                                          globalKey: _scaffoldKey,
                                          transactionType:
                                              TransactionType.MEMBERSHIP,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Show Banner Ad
                            getSivisoftAdWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        Column(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate("key_member_details"),
                  style: TextStyles.textStyle4,
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
        _membershipInfo != null
            ? Column(
                children: [
                  membershipDetailsContainerWidget(),
                  if (_membershipInfo != null &&
                      (_membershipInfo.membershipStatus == APPROVED ||
                          AppPreferences().role == Constants.USER_ROLE))
                    SizedBox(height: 20)
                ],
              )
            : Container(),
        if (AppPreferences().role == Constants.supervisorRole &&
            _membershipInfo == null)
          Column(
            children: [
              searchByNameTextField(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        if (AppPreferences().role == Constants.supervisorRole &&
            _membershipInfo != null &&
            (_membershipInfo.membershipStatus != APPROVED))
          Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Text(
                      'Membership Status',
                      style: TextStyles.mlDynamicTextStyle,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ChoiceChip(
                              avatar: _membershipStatus ==
                                      MembershipStatus.UnderReview
                                  ? Icon(Icons.check, color: Colors.white)
                                  : null,
                              label: Text(
                                UNDER_REVIEW,
                                style: TextStyle(
                                    color: _membershipStatus ==
                                            MembershipStatus.UnderReview
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              selected: _membershipStatus ==
                                      MembershipStatus.UnderReview
                                  ? true
                                  : false,
                              selectedColor: Colors.blue,
                              onSelected: (paymentStatus)
                                  ? null
                                  : (bool selected) {
                                      setState(() {
                                        _membershipStatus =
                                            MembershipStatus.UnderReview;
                                      });
                                    },
                            ),
                            SizedBox(width: 5),
                            ChoiceChip(
                              avatar: _membershipStatus ==
                                      MembershipStatus.PendingPayment
                                  ? Icon(Icons.check, color: Colors.white)
                                  : null,
                              label: Text(
                                PENDING_PAYMENT,
                                style: TextStyle(
                                    color: _membershipStatus ==
                                            MembershipStatus.PendingPayment
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              selected: _membershipStatus ==
                                      MembershipStatus.PendingPayment
                                  ? true
                                  : false,
                              selectedColor: AppColors.arrivedColor,
                              onSelected: (paymentStatus)
                                  ? null
                                  : (bool selected) {
                                      setState(() {
                                        _membershipStatus =
                                            MembershipStatus.PendingPayment;
                                      });
                                    },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ChoiceChip(
                              avatar: _membershipStatus ==
                                      MembershipStatus.PendingApproval
                                  ? Icon(Icons.check, color: Colors.white)
                                  : null,
                              label: Text(
                                PENDING_APPROVAL,
                                style: TextStyle(
                                    color: _membershipStatus ==
                                            MembershipStatus.PendingApproval
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              selected: _membershipStatus ==
                                      MembershipStatus.PendingApproval
                                  ? true
                                  : false,
                              selectedColor: Colors.orange,
                              onSelected: (!paymentStatus)
                                  ? null
                                  : (bool selected) {
                                      setState(() {
                                        _membershipStatus =
                                            MembershipStatus.PendingApproval;
                                      });
                                    },
                            ),
                            SizedBox(width: 5),
                            ChoiceChip(
                              avatar:
                                  _membershipStatus == MembershipStatus.Approved
                                      ? Icon(Icons.check, color: Colors.white)
                                      : null,
                              label: Text(
                                APPROVED,
                                style: TextStyle(
                                    color: _membershipStatus ==
                                            MembershipStatus.Approved
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              selected:
                                  _membershipStatus == MembershipStatus.Approved
                                      ? true
                                      : false,
                              selectedColor: Colors.green,
                              onSelected: (_membershipStatus ==
                                          MembershipStatus.PendingPayment ||
                                      _membershipStatus ==
                                          MembershipStatus.UnderReview)
                                  ? null
                                  : (bool selected) {
                                      setState(() {
                                        _membershipStatus =
                                            MembershipStatus.Approved;
                                      });
                                    },
                            ),
                            SizedBox(width: 5),
                            ChoiceChip(
                              avatar:
                                  _membershipStatus == MembershipStatus.Rejected
                                      ? Icon(Icons.check, color: Colors.white)
                                      : null,
                              label: Text(
                                REJECTED,
                                style: TextStyle(
                                    color: _membershipStatus ==
                                            MembershipStatus.Rejected
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              selected:
                                  _membershipStatus == MembershipStatus.Rejected
                                      ? true
                                      : false,
                              selectedColor: Colors.red,
                              onSelected: (bool selected) {
                                setState(() {
                                  _membershipStatus = MembershipStatus.Rejected;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),

        if (_membershipFormFieldNameList?.contains(FN_FIRST_NAME))
          TextFormField(
            style: TextStyles.grayedOutTextStyle,
            controller: firstController,
            readOnly: true,
            //enabled: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              border: OutlineInputBorder(),
              labelText: _membershipFormFieldInfoList[
                      _membershipFormFieldNameList.indexOf(FN_FIRST_NAME)]
                  .fieldDisplayName,
              filled: true,
              fillColor: textFieldFillColor,
            ),
            keyboardType: TextInputType.text,
            validator: (_membershipFormFieldNameList != null &&
                    _membershipFormFieldNameList.contains(FN_FIRST_NAME) &&
                    _membershipFormFieldInfoList[
                            _membershipFormFieldNameList.indexOf(FN_FIRST_NAME)]
                        .isMandatory)
                ? ValidationUtils.firstNameValidation
                : null,
          ),
        if (_membershipFormFieldNameList?.contains(FN_LAST_NAME))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              controller: lastController,
              readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_LAST_NAME)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              keyboardType: TextInputType.text,
              //validator: ValidationUtils.lastNameValidation,
              validator: (_membershipFormFieldNameList != null &&
                      _membershipFormFieldNameList.contains(FN_LAST_NAME) &&
                      _membershipFormFieldInfoList[_membershipFormFieldNameList
                              .indexOf(FN_LAST_NAME)]
                          .isMandatory)
                  ? ValidationUtils.lastNameValidation
                  : null,
            ),
          ),
        // SizedBox(
        //   height: 10,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_OTHER_NAMES))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              readOnly: _isRestrictToEditFields,
              controller: otherNameController,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  filled: _isRestrictToEditFields,
                  fillColor:
                      _isRestrictToEditFields ? textFieldFillColor : null,
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate("key_otherNames")),
              keyboardType: TextInputType.text,
            ),
          ),
        // SizedBox(
        //   height: 10,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_GENDER))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  // width: screenWidth / 3,
                  alignment: Alignment.topLeft,
                  child: Text(
                    _membershipFormFieldInfoList[
                            _membershipFormFieldNameList.indexOf(FN_GENDER)]
                        .fieldDisplayName,
                    style: TextStyles.mlDynamicTextStyle,
                    //maxLines: 2,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    runSpacing: -15.0,
                    children: [
                      for (PageReferenceData gender in genderList)
                        IntrinsicWidth(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: gender.fieldValue,
                                groupValue: _genderValue,
                                //onChanged: _genderRadioValueChanges,
                                onChanged: null,
                              ),
                              Text(
                                gender.fieldDisplayValue,
                                style: TextStyles.grayedOutTextStyle,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // SizedBox(
        //   height: 15,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_BIRTH_DATE))
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                  _membershipFormFieldInfoList[
                          _membershipFormFieldNameList.indexOf(FN_BIRTH_DATE)]
                      .fieldDisplayName,
                  style: TextStyles.mlDynamicTextStyle,
                )),
                Container(
                    width: screenWidth / 2.2,
                    padding: EdgeInsets.only(right: 0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        TextFormField(
                          style: TextStyles.grayedOutTextStyle,
                          focusNode: null,
                          //validator: validateDOB,
                          readOnly: true,
                          //enabled: false,
                          controller: dateOfBirthController,

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 16),
                            suffixIcon: Icon(Icons.calendar_today),
                            labelText: AppLocalizations.of(context)
                                .translate("key_date"),
                            filled: true,
                            fillColor: textFieldFillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        // SizedBox(
        //   height: 10,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_AGE))
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                  _membershipFormFieldInfoList[
                          _membershipFormFieldNameList.indexOf(FN_AGE)]
                      .fieldDisplayName,
                  style: TextStyles.mlDynamicTextStyle,
                )),
                Container(
                    width: screenWidth / 2.2,
                    padding: EdgeInsets.only(right: 0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        FocusScope(
                            node: null,
                            child: TextFormField(
                              style: TextStyles.grayedOutTextStyle,
                              controller: ageController,
                              readOnly: true,
                              //enabled: false,
                              enableInteractiveSelection: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 16),
                                labelText: _membershipFormFieldInfoList[
                                        _membershipFormFieldNameList
                                            .indexOf(FN_AGE)]
                                    .fieldDisplayName,
                                filled: true,
                                fillColor: textFieldFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            )),
                      ],
                    ))
              ],
            ),
          ),
        // SizedBox(
        //   height: 10,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_BLOOD_GROUP))
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    _membershipFormFieldInfoList[_membershipFormFieldNameList
                            .indexOf(FN_BLOOD_GROUP)]
                        .fieldDisplayName,
                    style: TextStyles.mlDynamicTextStyle),
                SizedBox(width: 30),
                Expanded(
                  child: DropdownButtonFormField<PageReferenceData>(
                    hint: Text(
                      _bloodGroup == null ? 'Select' : _bloodGroup,
                      style: _isRestrictToEditFields
                          ? TextStyles.grayedOutTextStyle
                          : TextStyles.mlDynamicTextStyle
                              .copyWith(color: Colors.black87),
                    ),
                    items: _bloodGroupDropdownMenuItems,
                    validator: (_membershipFormFieldNameList != null &&
                            _membershipFormFieldNameList
                                .contains(FN_BLOOD_GROUP) &&
                            _membershipFormFieldInfoList[
                                    _membershipFormFieldNameList
                                        .indexOf(FN_BLOOD_GROUP)]
                                .isMandatory)
                        ? (PageReferenceData pageReferenceData) {
                            if (_bloodGroup == null) {
                              return "Blood group is required";
                            } else {
                              return null;
                            }
                          }
                        : null,
                    onChanged: _isRestrictToEditFields
                        ? null
                        : (_) {
                            setState(
                              () {
                                _bloodGroup = _.fieldValue;
                              },
                            );
                          },
                  ),
                )
              ],
            ),
          ),
        if (_membershipFormFieldNameList
            ?.contains(FN_EDUCATIONAL_QUALIFICATION))
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    _membershipFormFieldInfoList[_membershipFormFieldNameList
                            .indexOf(FN_EDUCATIONAL_QUALIFICATION)]
                        .fieldDisplayName,
                    style: TextStyles.mlDynamicTextStyle),
                //Spacer(),
                SizedBox(width: 20),
                Expanded(
                    child: DropdownButtonFormField<PageReferenceData>(
                  hint: Text(
                    _educationalQualification == null
                        ? 'Select'
                        : _educationalQualification,
                    style: _isRestrictToEditFields
                        ? TextStyles.grayedOutTextStyle
                        : TextStyles.mlDynamicTextStyle
                            .copyWith(color: Colors.black87),
                  ),
                  items: _eduQualDropdownMenuItems,
                  validator: (_membershipFormFieldNameList != null &&
                          _membershipFormFieldNameList
                              .contains(FN_EDUCATIONAL_QUALIFICATION) &&
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_EDUCATIONAL_QUALIFICATION)]
                              .isMandatory)
                      ? (PageReferenceData pageReferenceData) {
                          if (_educationalQualification == null) {
                            return "Qualification is required";
                          } else {
                            return null;
                          }
                        }
                      : null,
                  onChanged: _isRestrictToEditFields
                      ? null
                      : (_) {
                          setState(() {
                            _educationalQualification = _.fieldValue;
                          });
                        },
                ))
              ],
            ),
          ),
        _educationalQualification == "Other"
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  style: _isRestrictToEditFields
                      ? TextStyles.grayedOutTextStyle
                      : TextStyles.mlDynamicTextStyle,
                  readOnly: _isRestrictToEditFields,
                  controller: otherQualificationController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    filled: _isRestrictToEditFields,
                    fillColor:
                        _isRestrictToEditFields ? textFieldFillColor : null,
                    border: OutlineInputBorder(),
                    labelText: "Other",
                  ),
                  keyboardType: TextInputType.text,
                  validator: (String value) {
                    if (value.isEmpty)
                      return "Other qualification cannot be blank";
                    else
                      return null;
                  },
                ),
              )
            : Container(),
        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              readOnly: _isRestrictToEditFields,
              controller: courseMajorController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
                border: OutlineInputBorder(),
                labelText: "Course Major",
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: PopupMenuButton<String>(
              child: TextFormField(
                style: _isRestrictToEditFields
                    ? TextStyles.grayedOutTextStyle
                    : TextStyles.mlDynamicTextStyle,
                readOnly: true,
                enabled: false,
                controller: courseCompletionStatusController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    filled: _isRestrictToEditFields,
                    fillColor:
                        _isRestrictToEditFields ? textFieldFillColor : null,
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    labelText: "Completion Status",
                    labelStyle: TextStyle(color: Colors.grey[600])),
                keyboardType: TextInputType.text,
              ),
              onSelected: _isRestrictToEditFields
                  ? null
                  : (String value) {
                      courseCompletionStatusController.text = value;
                    },
              enabled: !_isRestrictToEditFields,
              itemBuilder: (BuildContext context) {
                return _eduCompletionDropdownItems
                    .map<PopupMenuItem<String>>((String value) {
                  return new PopupMenuItem(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        child: Text(value),
                      ),
                      value: value);
                }).toList();
              },
            ),
          ),
        if (_educationalQualification != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              readOnly: _isRestrictToEditFields,
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              controller: additionalInfoController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: "Additional Details",
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
              ),
              keyboardType: TextInputType.text,
              // validator: (String value) {
              //   if (value.isEmpty)
              //     return "Completion status cannot be blank";
              //   else
              //     return null;
              // },
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_IDENTITY_PROOF))
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    _membershipFormFieldInfoList[_membershipFormFieldNameList
                            .indexOf(FN_IDENTITY_PROOF)]
                        .fieldDisplayName,
                    style: TextStyles.mlDynamicTextStyle),
                //Spacer(),
                SizedBox(width: 20),
                Expanded(
                    child: DropdownButtonFormField<PageReferenceData>(
                  hint: Text(
                    _documentName == null ? 'Select' : _documentName,
                    style: _isRestrictToEditFields
                        ? TextStyles.grayedOutTextStyle
                        : TextStyles.mlDynamicTextStyle
                            .copyWith(color: Colors.black87),
                  ),
                  items: _documentNameDropdownMenuItems,
                  validator: (_membershipFormFieldNameList != null &&
                          _membershipFormFieldNameList
                              .contains(FN_IDENTITY_PROOF) &&
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_IDENTITY_PROOF)]
                              .isMandatory)
                      ? (PageReferenceData pageReferenceData) {
                          if (_documentName == null) {
                            return "Address Proof is required";
                          } else {
                            return null;
                          }
                        }
                      : null,
                  onChanged: _isRestrictToEditFields
                      ? null
                      : (_) {
                          setState(() {
                            _documentName = _.fieldValue;
                          });
                        },
                ))
              ],
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_DOCUMENT_NAME))
          Padding(
            padding: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    _membershipFormFieldInfoList[_membershipFormFieldNameList
                            .indexOf(FN_DOCUMENT_NAME)]
                        .fieldDisplayName,
                    style: TextStyles.mlDynamicTextStyle),
                //Spacer(),
                SizedBox(width: 20),
                Expanded(
                    child: DropdownButtonFormField<PageReferenceData>(
                  hint: Text(
                    _documentName == null ? 'Select' : _documentName,
                    style: TextStyles.mlDynamicTextStyle,
                  ),
                  items: _documentNameDropdownMenuItems,
                  validator: (_membershipFormFieldNameList != null &&
                          _membershipFormFieldNameList
                              .contains(FN_DOCUMENT_NAME) &&
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_DOCUMENT_NAME)]
                              .isMandatory)
                      ? (PageReferenceData pageReferenceData) {
                          if (_documentName == null) {
                            return "Document name is required";
                          } else {
                            return null;
                          }
                        }
                      : null,
                  onChanged: (_) {
                    setState(() {
                      _documentName = _.fieldValue;
                    });
                  },
                ))
              ],
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_NATIONAL_ID))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              readOnly: _isRestrictToEditFields,
              controller: nationalIdController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
                border: OutlineInputBorder(),
                labelText:
                    AppLocalizations.of(context).translate("key_tt_national"),
              ),
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty)
                  return "Address proof id cannot be blank";
                else
                  return null;
              },
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_ADDRESS_PROOF_ID))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              readOnly: _isRestrictToEditFields,
              controller: nationalIdController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList
                            .indexOf(FN_ADDRESS_PROOF_ID)]
                    .fieldDisplayName,
              ),
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty)
                  return "Address Proof ID cannot be blank";
                else
                  return null;
              },
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_ADDRESS_PROOF_DOCUMENT))
          Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Text(
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_ADDRESS_PROOF_DOCUMENT)]
                              .fieldDisplayName,
                          style: TextStyles.mlDynamicTextStyle),
                    ],
                  )),
              // SizedBox(
              //   height: 10,
              // ),
              (_membershipInfo != null &&
                      ((_membershipInfo.addressProof == null ||
                          _membershipInfo.addressProof.isEmpty)) &&
                      _autoValidate)
                  ? DismissibleMessageWidget(
                      msg: "Please select address proof picture",
                      color: Colors.red[400],
                    )
                  : (_membershipInfo == null &&
                          _autoValidate &&
                          (addressProofPicURL == null &&
                              documentAddressProofImage == null))
                      ? DismissibleMessageWidget(
                          msg: "Please select address proof picture",
                          color: Colors.red[400],
                        )
                      : Container(),
              SizedBox(
                height: 5.0,
              ),
              DocsUploadSingleWidget(
                isRestrictToEditFields: _isRestrictToEditFields,
                documentImageCallback: (File addressProofImage) {
                  setState(() {
                    documentAddressProofImage = addressProofImage;
                  });
                },
                documentImageUrl: _membershipInfo != null &&
                        _membershipInfo.addressProof != null &&
                        _membershipInfo.addressProof.isNotEmpty
                    ? _membershipInfo.addressProof
                    : addressProofPicURL != null &&
                            addressProofPicURL.isNotEmpty
                        ? addressProofPicURL
                        : null,
              ),
            ],
          ),
        if (_membershipFormFieldNameList?.contains(FN_DOCUMENT_UPLOAD))
          Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Text(
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_DOCUMENT_UPLOAD)]
                              .fieldDisplayName,
                          style: TextStyles.mlDynamicTextStyle),
                    ],
                  )),
              // SizedBox(
              //   height: 10,
              // ),
              (_membershipInfo != null &&
                      ((_membershipInfo.identifyProofFront == null ||
                              _membershipInfo.identifyProofFront.isEmpty) ||
                          (_membershipInfo.identifyProofBack == null &&
                              _membershipInfo.identifyProofBack.isEmpty)) &&
                      _autoValidate)
                  ? DismissibleMessageWidget(
                      msg: "Please select document",
                      color: Colors.red[400],
                    )
                  : (_membershipInfo == null &&
                          _autoValidate &&
                          (documentFrontImage == null ||
                              documentBackImage == null))
                      ? DismissibleMessageWidget(
                          msg: "Please select document",
                          color: Colors.red[400],
                        )
                      : Container(),
              SizedBox(
                height: 5.0,
              ),
              DocsUploadWidget(
                isRestrictToEditFields: _isRestrictToEditFields,
                documentFrontImageCallback: (File frontImage) {
                  setState(() {
                    //documentFrontImageBytes = frontImage;
                    documentFrontImage = frontImage;
                  });
                },
                documentBackImageCallback: (File backImage) {
                  setState(() {
                    //documentBackImageBytes = backImage;
                    documentBackImage = backImage;
                  });
                },
                documentFrontImageUrl: _membershipInfo != null &&
                        _membershipInfo.identifyProofFront != null &&
                        _membershipInfo.identifyProofFront.isNotEmpty
                    ? _membershipInfo.identifyProofFront
                    : null,
                documentBackImageUrl: _membershipInfo != null &&
                        _membershipInfo.identifyProofBack != null &&
                        _membershipInfo.identifyProofBack.isNotEmpty
                    ? _membershipInfo.identifyProofBack
                    : null,
                //documentFrontImageBytes: documentFrontImageBytes,
                //documentBackImageBytes: documentBackImageBytes,
              ),
            ],
          ),

        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_RN_NUMBER))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              controller: rnRmNumberController,
              readOnly: _isRestrictToEditFields,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_RN_NUMBER)]
                    .fieldDisplayName,
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (_membershipFormFieldNameList != null &&
                      _membershipFormFieldNameList.contains(FN_RN_NUMBER) &&
                      _membershipFormFieldInfoList[_membershipFormFieldNameList
                              .indexOf(FN_RN_NUMBER)]
                          .isMandatory)
                  ? (value) {
                      if (value.isEmpty) {
                        return "RN/RM Number cannot be blank";
                      } else {
                        return null;
                      }
                    }
                  : null,
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_RNRM_NUM_DOCUMENT))
          Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Text(
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_RNRM_NUM_DOCUMENT)]
                              .fieldDisplayName,
                          style: TextStyles.mlDynamicTextStyle),
                    ],
                  )),
              // SizedBox(
              //   height: 10,
              // ),
              (_membershipInfo != null &&
                      ((_membershipInfo.registeredNurseDocument == null ||
                          _membershipInfo.registeredNurseDocument.isEmpty)) &&
                      _autoValidate)
                  ? DismissibleMessageWidget(
                      msg: "Please select RN/RM Number picture",
                      color: Colors.red[400],
                    )
                  : (_membershipInfo == null &&
                          _autoValidate &&
                          (documentRnRmImage == null))
                      ? DismissibleMessageWidget(
                          msg: "Please select RN/RM Number picture",
                          color: Colors.red[400],
                        )
                      : Container(),
              SizedBox(
                height: 5.0,
              ),
              DocsUploadSingleWidget(
                isRestrictToEditFields: _isRestrictToEditFields,
                documentImageCallback: (File rnRmImage) {
                  setState(() {
                    //documentFrontImage = frontImage;
                    documentRnRmImage = rnRmImage;
                  });
                },
                documentImageUrl: _membershipInfo != null &&
                        _membershipInfo.registeredNurseDocument != null &&
                        _membershipInfo.registeredNurseDocument.isNotEmpty
                    ? _membershipInfo.registeredNurseDocument
                    : null,
              ),
            ],
          ),
        if (_membershipFormFieldNameList?.contains(FN_RECENT_PIC_DOCUMENT))
          Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Text(
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_RECENT_PIC_DOCUMENT)]
                              .fieldDisplayName,
                          style: TextStyles.mlDynamicTextStyle),
                    ],
                  )),
              // SizedBox(
              //   height: 10,
              // ),
              (_membershipInfo != null &&
                      ((_membershipInfo.recentPicture == null ||
                          _membershipInfo.recentPicture.isEmpty)) &&
                      _autoValidate)
                  ? DismissibleMessageWidget(
                      msg: "Please select Recent Picture",
                      color: Colors.red[400],
                    )
                  : (_membershipInfo == null &&
                          _autoValidate &&
                          (documentRececentImage == null))
                      ? DismissibleMessageWidget(
                          msg: "Please select Recent Picture",
                          color: Colors.red[400],
                        )
                      : Container(),
              SizedBox(
                height: 5.0,
              ),
              DocsUploadSingleWidget(
                isRestrictToEditFields: _isRestrictToEditFields,
                documentImageCallback: (File recentImage) {
                  setState(() {
                    documentRececentImage = recentImage;
                  });
                },
                documentImageUrl: _membershipInfo != null &&
                        _membershipInfo.recentPicture != null &&
                        _membershipInfo.recentPicture.isNotEmpty
                    ? _membershipInfo.recentPicture
                    : null,
              ),
            ],
          ),

        if (_membershipFormFieldNameList?.contains(FN_REFERRED_BY))
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    _membershipFormFieldInfoList[_membershipFormFieldNameList
                            .indexOf(FN_REFERRED_BY)]
                        .fieldDisplayName,
                    style: TextStyles.mlDynamicTextStyle),
                //Spacer(),
                SizedBox(width: 20),
                Expanded(
                    child: DropdownButtonFormField<PageReferenceData>(
                  hint: Text(
                    _referredBy == null ? 'Select' : _referredBy,
                    style: _isRestrictToEditFields
                        ? TextStyles.grayedOutTextStyle
                        : TextStyles.mlDynamicTextStyle
                            .copyWith(color: Colors.black87),
                  ),
                  items: _referredByDropdownMenuItems,
                  validator: (_membershipFormFieldNameList != null &&
                          _membershipFormFieldNameList
                              .contains(FN_REFERRED_BY) &&
                          _membershipFormFieldInfoList[
                                  _membershipFormFieldNameList
                                      .indexOf(FN_REFERRED_BY)]
                              .isMandatory)
                      ? (PageReferenceData pageReferenceData) {
                          if (_referredBy == null) {
                            return "Referred by is required";
                          } else {
                            return null;
                          }
                        }
                      : null,
                  onChanged: _isRestrictToEditFields
                      ? null
                      : (_) {
                          setState(() {
                            _referredBy = _.fieldValue;
                          });
                        },
                )),
              ],
            ),
          ),
        if (_referredBy == "Person")
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              readOnly: _isRestrictToEditFields,
              controller: referedPersonNameContoller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
                border: OutlineInputBorder(),
                labelText: "Person Name",
              ),
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty)
                  return "Person name cannot be blank";
                else
                  return null;
              },
            ),
          ),
        if (_referredBy == "Social Media")
          DropdownButtonFormField(
            hint: Text(
              socialMedia == null ? 'Select' : socialMedia,
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle
                      .copyWith(color: Colors.black87),
            ),
            items: socialMediaDropDownList,
            validator: (value) {
              if (socialMedia == null) {
                return "One of the social media to be selected";
              } else {
                return null;
              }
            },
            onChanged: _isRestrictToEditFields
                ? null
                : (_) {
                    setState(() {
                      socialMedia = _.fieldValue;
                    });
                  },
          ),
        if (_membershipFormFieldNameList?.contains(FN_ADDRESSLINE_ONE))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              controller: addressOneController,
              readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList
                            .indexOf(FN_ADDRESSLINE_ONE)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty)
                  return "Address1 cannot be blank";
                else
                  return null;
              },
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_ADDRESSLINE_TWO))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              controller: addressTwoController,
              readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList
                            .indexOf(FN_ADDRESSLINE_TWO)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_DISTRICT))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              controller: districtController,
              //readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_DISTRICT)]
                    .fieldDisplayName,
                //filled: true,
                //fillColor: textFieldFillColor,
              ),
              keyboardType: TextInputType.text,
              validator: (_membershipFormFieldNameList != null &&
                      _membershipFormFieldNameList.contains(FN_DISTRICT) &&
                      _membershipFormFieldInfoList[
                              _membershipFormFieldNameList.indexOf(FN_DISTRICT)]
                          .isMandatory)
                  ? (String value) {
                      if (value.isEmpty) {
                        return "Native district cannot be blank";
                      } else {
                        return null;
                      }
                    }
                  : null,
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_WORK_LOCATION))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              controller: workLocationController,
              //readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_WORK_LOCATION)]
                    .fieldDisplayName,
                //filled: true,
                //fillColor: textFieldFillColor,
              ),
              keyboardType: TextInputType.text,
              validator: (_membershipFormFieldNameList != null &&
                      _membershipFormFieldNameList.contains(FN_WORK_LOCATION) &&
                      _membershipFormFieldInfoList[_membershipFormFieldNameList
                              .indexOf(FN_WORK_LOCATION)]
                          .isMandatory)
                  ? (value) {
                      if (value.isEmpty) {
                        return "Work location cannot be blank";
                      } else {
                        return null;
                      }
                    }
                  : null,
            ),
          ),
        if (_membershipFormFieldNameList?.contains(FN_CITY))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                errorMaxLines: 2,
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_CITY)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              controller: cityController,
              keyboardType: TextInputType.text,
              // validator: ValidationUtils.cityValidation,
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_STATE))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                errorMaxLines: 3,
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_STATE)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              controller: stateController,
              keyboardType: TextInputType.text,
              //validator: ValidationUtils.stateValidation,
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_COUNTRY))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              readOnly: true,
              //enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                errorMaxLines: 2,
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_COUNTRY)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              controller: countryController,
              keyboardType: TextInputType.text,
              validator: ValidationUtils.countryValidation,
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_ZIPCODE))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              controller: zipCodeController,
              readOnly: true,
              //enabled: false,
              //maxLength: 13,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_ZIPCODE)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              keyboardType: TextInputType.text,
              //validator: validateZip,
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_OCCUPATION))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              readOnly: _isRestrictToEditFields,
              controller: occupationController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
                border: OutlineInputBorder(),
                labelText:
                    AppLocalizations.of(context).translate("key_occupation"),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_EMAIL_ADDRESS))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: TextStyles.grayedOutTextStyle,
              readOnly: true,
              //enabled: false,
              controller: emailController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: _membershipFormFieldInfoList[
                        _membershipFormFieldNameList.indexOf(FN_EMAIL_ADDRESS)]
                    .fieldDisplayName,
                filled: true,
                fillColor: textFieldFillColor,
              ),
              validator: ValidationUtils.emailValidation,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_PHONE_NUMBER))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                  width: MediaQuery.of(context).size.width / 7,
                  child: Stack(children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: textFieldFillColor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 1),
                      child: Center(
                        child: CountryCodePicker(
                            textStyle: TextStyles.grayedOutTextStyle,
                            enabled: false,
                            onChanged: _onCountryCodeHomeChanged,
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: (countryCodeHome != null &&
                                    countryCodeHome.isNotEmpty)
                                ? countryCodeHome
                                : AppPreferences().country,
                            showFlag: true,
                            showFlagDialog: true,
                            onInit: (code) {
                              countryCodeHome = code.code;
                              countryDialCodeHome = code.dialCode;
                              //print("countryDialCodeHome $countryDialCodeHome");
                            }),
                      ),
                    )
                  ]),
                )),
                SizedBox(
                  width: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: TextFormField(
                    readOnly: true,
                    //     enabled: false,
                    style: TextStyles.grayedOutTextStyle,
                    controller: phoneHomeController,
                    maxLength: 10,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                      border: OutlineInputBorder(),
                      labelText: _membershipFormFieldInfoList[
                              _membershipFormFieldNameList
                                  .indexOf(FN_PHONE_NUMBER)]
                          .fieldDisplayName,
                      filled: true,
                      fillColor: textFieldFillColor,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
          ),
        // SizedBox(
        //   height: 20,
        // ),
        if (_membershipFormFieldNameList?.contains(FN_SECONDARY_PHONE_NUMBER))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                  width: MediaQuery.of(context).size.width / 7,
                  child: Stack(children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        border: OutlineInputBorder(),
                        filled: _isRestrictToEditFields,
                        fillColor:
                            _isRestrictToEditFields ? textFieldFillColor : null,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 1),
                      child: Center(
                        child: CountryCodePicker(
                            enabled: !_isRestrictToEditFields,
                            onChanged: _onCountryCodeCellChanged,
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: (countryCodeCell != null &&
                                    countryCodeCell.isNotEmpty)
                                ? countryCodeCell
                                : AppPreferences().country,
                            showFlag: true,
                            showFlagDialog: true,
                            onInit: (code) {
                              countryCodeCell = code.code;
                              countryDialCodeCell = code.dialCode;
                            }),
                      ),
                    )
                  ]),
                )),
                SizedBox(
                  width: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: new TextFormField(
                    style: _isRestrictToEditFields
                        ? TextStyles.grayedOutTextStyle
                        : TextStyles.mlDynamicTextStyle,
                    readOnly: _isRestrictToEditFields,
                    maxLength: 10,
                    controller: phoneCellController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                      border: OutlineInputBorder(),
                      labelText: _membershipFormFieldInfoList[
                              _membershipFormFieldNameList
                                  .indexOf(FN_SECONDARY_PHONE_NUMBER)]
                          .fieldDisplayName,
                      filled: _isRestrictToEditFields,
                      fillColor:
                          _isRestrictToEditFields ? textFieldFillColor : null,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    validator: ValidationUtils.secondMobileValidation,
                  ),
                ),
              ],
            ),
          ),
        // SizedBox(
        //   height: 10,
        // ),

        if (_membershipType == MembershipType.Life &&
            _membershipFormFieldNameList != null &&
            _membershipFormFieldNameList.contains(FN_FEES))
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "Membership Type : Life",
                    style: TextStyles.textStyle4,
                  ),
                ],
              ),
              SizedBox(height: 10)
            ],
          ),
        if (_membershipType == MembershipType.Subscription &&
            _membershipFormFieldNameList != null &&
            _membershipFormFieldNameList.contains(FN_FEES))
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      // width: screenWidth / 3,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context).translate("key_fees"),
                        style: TextStyles.textStyle4,
                      )),
                  if (false)
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Radio(
                          value: NEW_MEMBER,
                          groupValue: membershipFeeRadioValue,
                          onChanged: (value) {
                            setState(() {
                              membershipFeeRadioValue = NEW_MEMBER;
                            });
                          },
                        ),
                        Text(
                          NEW_MEMBER,
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                        Radio(
                          value: RENEWAL,
                          groupValue: membershipFeeRadioValue,
                          onChanged: (value) {
                            setState(() {
                              membershipFeeRadioValue = RENEWAL;
                            });
                          },
                        ),
                        Text(
                          RENEWAL,
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                      ],
                    ))
                ],
              ),
              Card(
                child: Column(
                  children: [
                    //(membershipFeeRadioValue == NEW_MEMBER)
                    //?
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: (newMemberFees == month) ? true : false,
                              onChanged: (_membershipInfo == null)
                                  ? (newValue) {
                                      _newMemberCheckBoxValueChanges(month);
                                    }
                                  : null,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("key_one_month_rs"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Checkbox(
                              value: (newMemberFees == quaterly) ? true : false,
                              onChanged: (_membershipInfo == null)
                                  ? (newValue) {
                                      _newMemberCheckBoxValueChanges(quaterly);
                                    }
                                  : null,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("key_two_quaterly_rs"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value:
                                  (newMemberFees == halfYearly) ? true : false,
                              onChanged: (_membershipInfo == null)
                                  ? (newValue) {
                                      _newMemberCheckBoxValueChanges(
                                          halfYearly);
                                    }
                                  : null,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("key_three_6_months_rs"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                            Checkbox(
                              value: (newMemberFees == yearly) ? true : false,
                              onChanged: (_membershipInfo == null)
                                  ? (newValue) {
                                      _newMemberCheckBoxValueChanges(yearly);
                                    }
                                  : null,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("key_three_yearly_rs"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    //: Container(),
                    // (membershipFeeRadioValue == RENEWAL)
                    //     ? Column(
                    //         children: [
                    //           SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             children: [
                    //               Checkbox(
                    //                   value:
                    //                       (renewelMemberFees == oneYearRenewal)
                    //                           ? true
                    //                           : false,
                    //                   onChanged: (_membershipInfo == null)
                    //                       ? null
                    //                       : (newValue) {
                    //                           _renewalMemberCheckBoxValueChanges(
                    //                               oneYearRenewal);
                    //                         }),
                    //               Text(
                    //                 AppLocalizations.of(context)
                    //                     .translate("key_one_year_renewal"),
                    //                 style: TextStyles.mlDynamicTextStyle,
                    //               ),
                    //               SizedBox(
                    //                 width: 20.0,
                    //               ),
                    //               Checkbox(
                    //                   value:
                    //                       (renewelMemberFees == twoYearRenewal)
                    //                           ? true
                    //                           : false,
                    //                   onChanged: (_membershipInfo == null)
                    //                       ? null
                    //                       : (newValue) {
                    //                           _renewalMemberCheckBoxValueChanges(
                    //                               twoYearRenewal);
                    //                         }),
                    //               Text(
                    //                 AppLocalizations.of(context)
                    //                     .translate("key_two_year_renewal"),
                    //                 style: TextStyles.mlDynamicTextStyle,
                    //               ),
                    //             ],
                    //           ),
                    //           Row(
                    //             children: [
                    //               Checkbox(
                    //                   value: (renewelMemberFees ==
                    //                           threeYearRenewal)
                    //                       ? true
                    //                       : false,
                    //                   onChanged: (_membershipInfo == null)
                    //                       ? null
                    //                       : (newValue) {
                    //                           _renewalMemberCheckBoxValueChanges(
                    //                               threeYearRenewal);
                    //                         }),
                    //               Text(
                    //                 AppLocalizations.of(context)
                    //                     .translate("key_three_year_renewal"),
                    //                 style: TextStyles.mlDynamicTextStyle,
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       )
                    //     : Container(),
                    // membershipFeeRadioValue == RENEWAL
                    //     ? Column(
                    //         children: [
                    //           SizedBox(
                    //             height: 10.0,
                    //           ),
                    //           Row(
                    //             children: [
                    //               SizedBox(
                    //                 width: 10.0,
                    //               ),
                    //               Text(
                    //                 AppLocalizations.of(context)
                    //                     .translate("key_card_renewal"),
                    //                 style: TextStyles.mlDynamicTextStyle,
                    //               ),
                    //             ],
                    //           ),
                    //           SizedBox(
                    //             height: 10.0,
                    //           ),
                    //         ],
                    //       )
                    //     : Container(),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Color(0xFF1E8449), width: 2)),
            padding: EdgeInsets.all(15.0),
            child: RichText(
              text: new TextSpan(
                text: "* One time registration fee of ",
                style: TextStyle(color: Color(0xFF1E8449)),
                children: <TextSpan>[
                  new TextSpan(
                      text: '₹250', style: new TextStyle(color: Colors.red)),
                  new TextSpan(
                      text:
                          "\n\n* Additionally you can choose any of the membership subscription option (monthly, quartly, half yearly, annually)."),
                  new TextSpan(
                      text:
                          "\n\nFor eg: If you choose monthly subscription option, you will pay registration fee "),
                  new TextSpan(
                      text: "₹250 ", style: TextStyle(color: Colors.red)),
                  new TextSpan(
                      text:
                          "+ ₹${totalAmount.toInt()}(monthly membership fee) total ₹${(totalAmount.toInt() + 250).toString()}."),
                ],
              ),
            )),
        SizedBox(height: 10),
        // Column(
        //   children: [
        //     Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>[
        //         Container(
        //             // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        //             // width: screenWidth / 3,
        //             alignment: Alignment.centerLeft,
        //             child: Text(
        //               _membershipFormFieldInfoList[
        //                       _membershipFormFieldNameList.indexOf(FN_FEES)]
        //                   .fieldDisplayName,
        //               style: TextStyles.textStyle4,
        //             )),
        //         Expanded(
        //             child: Row(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: <Widget>[
        //             Radio(
        //               value: NEW_MEMBER,
        //               groupValue: membershipFeeRadioValue,
        //               onChanged: (value) {
        //                 setState(() {
        //                   membershipFeeRadioValue = NEW_MEMBER;
        //                 });
        //               },
        //             ),
        //             Text(
        //               NEW_MEMBER,
        //               style: TextStyles.mlDynamicTextStyle,
        //             ),
        //             Radio(
        //               value: RENEWAL,
        //               groupValue: membershipFeeRadioValue,
        //               onChanged: (value) {
        //                 setState(() {
        //                   membershipFeeRadioValue = RENEWAL;
        //                 });
        //               },
        //             ),
        //             Text(
        //               RENEWAL,
        //               style: TextStyles.mlDynamicTextStyle,
        //             ),
        //           ],
        //         ))
        //       ],
        //     ),
        //     // SizedBox(
        //     //   height: 10,
        //     // ),
        //     Card(
        //       child: Column(
        //         children: [
        //           (membershipFeeRadioValue == NEW_MEMBER)
        //               ? Column(
        //                   children: [
        //                     // SizedBox(
        //                     //   height: 10,
        //                     // ),
        //                     Row(
        //                       children: [
        //                         Checkbox(
        //                           value: (newMemberFees == oneYearNew)
        //                               ? true
        //                               : false,
        //                           onChanged: (_membershipInfo == null)
        //                               ? (newValue) {
        //                                   _newMemberCheckBoxValueChanges(
        //                                       oneYearNew);
        //                                 }
        //                               : null,
        //                         ),
        //                         Text(
        //                           AppLocalizations.of(context)
        //                               .translate("key_one_year"),
        //                           style: TextStyles.mlDynamicTextStyle,
        //                         ),
        //                         SizedBox(
        //                           width: 20.0,
        //                         ),
        //                         Checkbox(
        //                           value: (newMemberFees == twoYearNew)
        //                               ? true
        //                               : false,
        //                           onChanged: (_membershipInfo == null)
        //                               ? (newValue) {
        //                                   _newMemberCheckBoxValueChanges(
        //                                       twoYearNew);
        //                                 }
        //                               : null,
        //                         ),
        //                         Text(
        //                           AppLocalizations.of(context)
        //                               .translate("key_two_year"),
        //                           style: TextStyles.mlDynamicTextStyle,
        //                         ),
        //                       ],
        //                     ),
        //                     Row(
        //                       children: [
        //                         Checkbox(
        //                           value: (newMemberFees == threeYearNew)
        //                               ? true
        //                               : false,
        //                           onChanged: (_membershipInfo == null)
        //                               ? (newValue) {
        //                                   _newMemberCheckBoxValueChanges(
        //                                       threeYearNew);
        //                                 }
        //                               : null,
        //                         ),
        //                         Text(
        //                           AppLocalizations.of(context)
        //                               .translate("key_three_year"),
        //                           style: TextStyles.mlDynamicTextStyle,
        //                         ),
        //                       ],
        //                     ),
        //                   ],
        //                 )
        //               : Container(),
        //           (membershipFeeRadioValue == RENEWAL)
        //               ? Column(
        //                   children: [
        //                     // SizedBox(
        //                     //   height: 10,
        //                     // ),
        //                     Row(
        //                       children: [
        //                         Checkbox(
        //                             value:
        //                                 (renewelMemberFees == oneYearRenewal)
        //                                     ? true
        //                                     : false,
        //                             onChanged: (_membershipInfo == null)
        //                                 ? null
        //                                 : (newValue) {
        //                                     _renewalMemberCheckBoxValueChanges(
        //                                         oneYearRenewal);
        //                                   }),
        //                         Text(
        //                           AppLocalizations.of(context)
        //                               .translate("key_one_year_renewal"),
        //                           style: TextStyles.mlDynamicTextStyle,
        //                         ),
        //                         SizedBox(
        //                           width: 20.0,
        //                         ),
        //                         Checkbox(
        //                             value:
        //                                 (renewelMemberFees == twoYearRenewal)
        //                                     ? true
        //                                     : false,
        //                             onChanged: (_membershipInfo == null)
        //                                 ? null
        //                                 : (newValue) {
        //                                     _renewalMemberCheckBoxValueChanges(
        //                                         twoYearRenewal);
        //                                   }),
        //                         Text(
        //                           AppLocalizations.of(context)
        //                               .translate("key_two_year_renewal"),
        //                           style: TextStyles.mlDynamicTextStyle,
        //                         ),
        //                       ],
        //                     ),
        //                     Row(
        //                       children: [
        //                         Checkbox(
        //                             value: (renewelMemberFees ==
        //                                     threeYearRenewal)
        //                                 ? true
        //                                 : false,
        //                             onChanged: (_membershipInfo == null)
        //                                 ? null
        //                                 : (newValue) {
        //                                     _renewalMemberCheckBoxValueChanges(
        //                                         threeYearRenewal);
        //                                   }),
        //                         Text(
        //                           AppLocalizations.of(context)
        //                               .translate("key_three_year_renewal"),
        //                           style: TextStyles.mlDynamicTextStyle,
        //                         ),
        //                       ],
        //                     ),
        //                   ],
        //                 )
        //               : Container(),
        //           membershipFeeRadioValue == RENEWAL
        //               ? Column(
        //                   children: [
        //                     // SizedBox(
        //                     //   height: 10.0,
        //                     // ),
        //                     Row(
        //                       children: [
        //                         SizedBox(
        //                           width: 10.0,
        //                         ),
        //                         Text(
        //                           AppLocalizations.of(context)
        //                               .translate("key_card_renewal"),
        //                           style: TextStyles.mlDynamicTextStyle,
        //                         ),
        //                       ],
        //                     ),
        //                     SizedBox(
        //                       height: 10.0,
        //                     ),
        //                   ],
        //                 )
        //               : Container(),
        //           // SizedBox(
        //           //   height: 10.0,
        //           // ),
        //         ],
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //   ],
        // ),
        if (_membershipFormFieldNameList?.contains(FN_DIABETES_QUESTIONNAIRE))
          Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate("key_other_information"),
                    style: TextStyles.textStyle4,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppPreferences().role == Constants.USER_ROLE
                                  ? AppLocalizations.of(context)
                                      .translate("key_diabetes")
                                  : AppLocalizations.of(context)
                                      .translate("key_diabetes_supervisor"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ),
                          Switch(
                            value: isDiagnosedDiabetes,
                            onChanged: (_isDiabetesReadOnly)
                                ? null
                                : (bool value) {
                                    setState(() {
                                      isDiagnosedDiabetes = value;
                                    });
                                  },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppPreferences().role == Constants.USER_ROLE
                                  ? AppLocalizations.of(context)
                                      .translate("key_diabetes_family")
                                  : AppLocalizations.of(context).translate(
                                      "key_diabetes_family_supervisor"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ),
                          Switch(
                            value: isFamilyHasDiabetes,
                            onChanged: (_isFamilyDiabetesReadOnly)
                                ? null
                                : (bool value) {
                                    setState(() {
                                      isFamilyHasDiabetes = value;
                                    });
                                  },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppPreferences().role == Constants.USER_ROLE
                                  ? AppLocalizations.of(context)
                                      .translate("key_diabetes_volunteer")
                                  : AppLocalizations.of(context).translate(
                                      "key_diabetes_volunteer_supervisor"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ),
                          Switch(
                            value: isVolunteer,
                            onChanged: (bool value) {
                              setState(() {
                                isVolunteer = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        if (_membershipFormFieldNameList?.contains(FN_OTHER_INTERESTS))
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    _membershipFormFieldInfoList[_membershipFormFieldNameList
                            .indexOf(FN_OTHER_INTERESTS)]
                        .fieldDisplayName,
                    style: TextStyles.textStyle4,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 2.0,
                  children: [
                    for (PageReferenceData otherInterest in otherInterestsList)
                      FilterChip(
                        label: Text(
                          otherInterest.fieldDisplayValue,
                          style: _isRestrictToEditFields
                              ? TextStyles.mlDynamicTextStyle
                                  .copyWith(color: Colors.black87)
                              : TextStyles.mlDynamicTextStyle,
                        ),
                        backgroundColor: Colors.grey[300],
                        selectedColor: Colors.grey[300],
                        selected: _selectedOtherInterestsArray
                                .contains(otherInterest.fieldValue)
                            ? true
                            : false,
                        disabledColor: Colors.grey[300],
                        onSelected: _isRestrictToEditFields
                            ? null
                            : (bool value) {
                                _otherInterestsCheckBoxValueChanges(
                                    value, otherInterest.fieldValue);
                              },
                      ),
                  ],
                ),
              ),
            ],
          ),

        if (_selectedOtherInterestsArray.contains("Others"))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              style: _isRestrictToEditFields
                  ? TextStyles.grayedOutTextStyle
                  : TextStyles.mlDynamicTextStyle,
              controller: otherInterestController,
              readOnly: _isRestrictToEditFields,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                filled: _isRestrictToEditFields,
                fillColor: _isRestrictToEditFields ? textFieldFillColor : null,
                border: OutlineInputBorder(),
                labelText: "Others",
              ),
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty)
                  return "Others cannot be blank";
                else
                  return null;
              },
            ),
          ),

        if (_membershipFormFieldNameList?.contains(FN_SPECIAL_SKILLS))
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate("key_special_skills"),
                    style: TextStyles.textStyle4,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _selectedSpecialSkillsArray.contains(medical)
                              ? true
                              : false,
                          onChanged: (newValue) {
                            _specialSkillsCheckBoxValueChanges(
                                newValue, medical);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context).translate("key_medical"),
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Checkbox(
                          value: _selectedSpecialSkillsArray.contains(legal)
                              ? true
                              : false,
                          onChanged: (newValue) {
                            _specialSkillsCheckBoxValueChanges(newValue, legal);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context).translate("key_legal"),
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _selectedSpecialSkillsArray
                                  .contains(graphicDesign)
                              ? true
                              : false,
                          onChanged: (newValue) {
                            _specialSkillsCheckBoxValueChanges(
                                newValue, graphicDesign);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("key_graphic_design"),
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Checkbox(
                          value: _selectedSpecialSkillsArray.contains(accounts)
                              ? true
                              : false,
                          onChanged: (newValue) {
                            _specialSkillsCheckBoxValueChanges(
                                newValue, accounts);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("key_accounts"),
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _selectedSpecialSkillsArray.contains(marketing)
                              ? true
                              : false,
                          onChanged: (newValue) {
                            _specialSkillsCheckBoxValueChanges(
                                newValue, marketing);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("key_marketing"),
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _selectedSpecialSkillsArray.contains(fitness)
                              ? true
                              : false,
                          onChanged: (newValue) {
                            _specialSkillsCheckBoxValueChanges(
                                newValue, fitness);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context).translate("key_fitness"),
                          style: TextStyles.mlDynamicTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

        if ((_membershipFormFieldNameList != null &&
                _membershipFormFieldNameList.contains(FN_BRANCH)) &&
            (AppPreferences().role == Constants.supervisorRole ||
                (AppPreferences().role == Constants.USER_ROLE &&
                    _membershipInfo != null &&
                    _membershipInfo.branch != null &&
                    _membershipInfo.branch.isNotEmpty)))
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("key_preferred_branch"),
                      style: TextStyles.mlDynamicTextStyle,
                    ),
                  ),
                  Flexible(
                    child: DropdownButtonFormField<String>(
                      items: preferredLocations ?? [],
                      value: selectedBranch,
                      hint: Text(
                        selectedBranch != null &&
                                selectedBranch.trim().length > 0
                            ? selectedBranch
                            : 'Select Branch',
                      ),
                      onChanged: (AppPreferences().role == Constants.USER_ROLE)
                          ? null
                          : (selectedValue) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                selectedBranch = selectedValue;
                              });
                            },
                      validator: (String value) {
                        if (selectedBranch == null || selectedBranch.isEmpty)
                          return "Branch is required";
                        else
                          return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        if ((_membershipFormFieldNameList != null &&
                _membershipFormFieldNameList.contains(FN_COMMENTS)) &&
            ((AppPreferences().role == Constants.supervisorRole) ||
                ((AppPreferences().role == Constants.USER_ROLE) &&
                    _membershipInfo != null &&
                    _membershipInfo.comments != null &&
                    _membershipInfo.comments.isNotEmpty)))
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  minLines: 3,
                  maxLines: null,
                  //readOnly: readOnly,
                  controller: commentsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Comments",
                  )
                  //onChanged: (value) => {others = value},
                  ),
            ],
          ),

        // SizedBox(
        //   height: 10,
        // ),

        // if ((_membershipInfo != null &&
        //         AppPreferences().role == Constants.USER_ROLE &&
        //         (PaymentCancellationDialog() != null &&
        //             receiptNumber.isNotEmpty)) ||
        //     (AppPreferences().role == Constants.supervisorRole))

        /// For supervisor, i) if the payment is already done - show the payment details ii) If the membershipStatus is changed as Rejected and the payment is not done - hide the payment option
        if ((_membershipFormFieldNameList != null &&
                _membershipFormFieldNameList.contains(FN_FEES)) &&
            ((_membershipType == MembershipType.Subscription &&
                    AppPreferences().role == Constants.supervisorRole &&
                    (_membershipStatus != MembershipStatus.Rejected ||
                        paymentStatus)) ||
                (_membershipType == MembershipType.Subscription &&
                    AppPreferences().role == Constants.USER_ROLE &&
                    _membershipInfo != null &&
                    (_membershipInfo.membershipStatus != UNDER_REVIEW) &&
                    (_membershipStatus != MembershipStatus.Rejected ||
                        paymentStatus))))
          Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: paymentCheckbox ? true : false,
                    onChanged: paymentStatus
                        ? null
                        : (newValue) {
                            // if (AppPreferences().role ==
                            //     Constants.USER_ROLE) {
                            // showPaymentDialog(
                            //     "\"Please contact our head office at 672-0864 to make your payment\" \nor \nVisit us at 10-12 Success St, to make your payment",
                            //     "NB: Your membership will only be approved once the payment has been made",
                            //     270);
                            //} else {
                            //debugPrint(
                            // "isexpired --> ${isMembershipExpired(_membershipInfo)}");
                            if (_membershipInfo != null &&
                                _membershipInfo.approvedDate != null &&
                                isMembershipExpired(_membershipInfo) &&
                                renewelMemberFees.isEmpty) {
                              showPaymentDialog(
                                  "Please select Membership Renewal and continue payment",
                                  "",
                                  140);
                            } else {
                              setState(() {
                                paymentCheckbox = newValue;
                              });
                            }
                            //}
                          },
                  ),
                  Text(
                    "Payment",
                    style: TextStyles.textStyle4,
                  ),
                  if (paymentStatus &&
                      receiptNumber != null &&
                      receiptNumber.isNotEmpty)
                    Row(children: [
                      Text(
                        " :",
                        style: TextStyles.textStyle4,
                      ),
                      SizedBox(width: 15),
                      Text("Success",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )),
                    ]),
                ],
              ),

              //if (paymentStatus || (_paymentMode != null && _paymentMode.isNotEmpty))
              if (paymentStatus)
                Column(
                  children: [
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: [
                          Text("Payment mode : "),
                          SizedBox(width: 10),
                          Text(
                            _paymentMode,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              if (receiptNumber != null && receiptNumber.isNotEmpty)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: [
                          Text(
                            _paymentMode == "Cash"
                                ? "Receipt Number : "
                                : "Transaction\nNumber : ",
                            maxLines: null,
                          ),
                          SizedBox(width: 10),
                          Text(
                            receiptNumber,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (showEditReceiptNumber)
                            Row(
                              children: [
                                SizedBox(width: 10),
                                RaisedButton(
                                  onPressed: () {
                                    receiptNumberController.text =
                                        receiptNumber;
                                    receiptNoDialogue(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  textColor: Colors.white,
                                  color: AppColors.arrivedColor,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          // onTap: () {
                          //   receiptNoDialogue(context);
                          // },
                          // child: Row(
                          //   children: [
                          //     SizedBox(width: 10),
                          //     Text('Edit'),
                          //     Icon(Icons.edit),
                          //   ],
                          // ),
                          //),
                        ],
                      ),
                    ),
                    //SizedBox(height: 10),
                  ],
                ),
            ],
          ),
        if (_membershipFormFieldNameList != null &&
            _membershipFormFieldNameList.contains(FN_TERMS_CONDITIONS))
          Row(
            children: <Widget>[
              Checkbox(
                value: _isTermsAndConditionChecked,
                onChanged:
                    (_membershipInfo != null && _isTermsAndConditionChecked)
                        ? null
                        : (isClicked) async {
                            String termsandconditions = await AppPreferences
                                .getMembershipTermsandConditions();
                            AlertUtils.showTermsAndConditionDialog(
                                context,
                                termsandconditions == null
                                    ? AppLocalizations.of(context)
                                        .translate("key_terms_gnat")
                                    : termsandconditions, (value) {
                              setState(() {
                                _isTermsAndConditionChecked = value;
                              });

                              Navigator.pop(context);
                            }, MediaQuery.of(context).size.width);
                          },
              ),
              Text(
                _membershipFormFieldInfoList[_membershipFormFieldNameList
                        .indexOf(FN_TERMS_CONDITIONS)]
                    .fieldDisplayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.textStyle4,
              ),
            ],
          ),

        SizedBox(height: 10),
        SubmitButton(
          color: _membershipInfo != null
              ? _membershipInfo.martialStatus == UNDER_REVIEW
                  ? Colors.grey[400]
                  : null
              : AppColors.arrivedColor,
          text: _membershipInfo != null
              ? paymentCheckbox && paymentStatus
                  ? "Update"
                  : paymentCheckbox
                      ? "Pay Now"
                      : "Update"
              : paymentCheckbox && paymentStatus
                  ? "Submit"
                  : paymentCheckbox
                      ? "Pay Now"
                      : "Submit",
          onPress: (AppPreferences().role == Constants.USER_ROLE &&
                  _membershipInfo != null &&
                  (_membershipInfo.membershipStatus == REJECTED ||
                      _membershipInfo.membershipStatus == UNDER_REVIEW))
              ? null
              : () async {
                  _validateInputs();
                },
        ),
      ],
    );
  }

  Widget searchByNameTextField() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: TextField(
              controller: searchByUserNameController,
              onTap: () {},
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(),
                labelText: 'Search by Name',
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ),
        SizedBox(width: 10),
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.blueGrey,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              People people = await showSearch<People>(
                context: context,
                delegate: PeopleSearch(
                    peopleBloc: _peopleBloc,
                    searchText: searchByUserNameController.text),
              );
              if (people != null) {
                //debugPrint("Selected people is --> ${people.toJson()}");
                _setMembershipInfoFromPeople(people);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget membershipDetailsContainerWidget() {
    return GestureDetector(
      onTap: _membershipInfo.membershipStatus == APPROVED
          ? () async {
              debugPrint("OnTap called...");
              FocusScope.of(context).requestFocus(FocusNode());
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MembershipCardScreen(membershipInfo: _membershipInfo),
                ),
              );
            }
          : null,
      child: Container(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.arrivedColor,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              )),
          child: SizedBox(
              child: Column(
            children: [
              if (_membershipInfo.membershipStatus == APPROVED)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 7,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: Text(
                          'Membership ID',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 5, right: 3),
                      child: Text(
                        _membershipInfo.membershipId,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 5),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                  ],
                ),
              if (AppPreferences().role == Constants.USER_ROLE &&
                  _membershipInfo != null &&
                  _membershipInfo.membershipStatus.toLowerCase() != "approved")
                // ||
                //     (AppPreferences().role == Constants.supervisorRole &&
                //         _membershipInfo != null &&
                //         _membershipInfo.membershipStatus.toLowerCase() ==
                //             "approved"))
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: Text(
                          'Membership Status',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                      child: Container(
                        decoration: new BoxDecoration(
                            color: getMembershipStatusColor(
                                _membershipInfo.membershipStatus == APPROVED
                                    ? (isMembershipExpired(_membershipInfo)
                                        ? EXPIRED
                                        : APPROVED)
                                    : _membershipInfo.membershipStatus),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10.0))),
                        child: Center(
                          child: Text(
                            _membershipInfo.membershipStatus == APPROVED
                                ? (isMembershipExpired(_membershipInfo)
                                    ? "  Expired - Pending Payment  "
                                    : "  ${getMembershipRemainingDays(_membershipInfo)}  ")
                                : "  ${_membershipInfo.membershipStatus}  ",
                            style: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                  ],
                ),
              // if (_membershipInfo != null &&
              //     _membershipInfo.approvedDate != null &&
              //     _membershipInfo.approvedDate.isNotEmpty)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Expanded(
              //         child: Padding(
              //           padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
              //           child: Text(
              //             'Approved Date',
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
              //         child: Text(
              //           DateUtils.convertUTCToLocalTimeApprovedDate(
              //               _membershipInfo.approvedDate),
              //           overflow: TextOverflow.ellipsis,
              //           style: TextStyle(
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 7,
              //       ),
              //     ],
              //   ),
            ],
          )),
        ),
      ),
    );
  }

  showPaymentDialog(String title1, String title2, double dialogHeight) {
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
                                Text(
                                  title1,
                                  style: TextStyle(
                                    fontSize: 14,
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

  void _genderRadioValueChanges(String value) {
    setState(() {
      _genderValue = value;
      debugPrint("_genderValue --> $value");
    });
  }

  void _newMemberCheckBoxValueChanges(String value) {
    setState(() {
      newMemberFees = value;
      debugPrint("_newMemberCheckBoxValueChanges --> $value");
      convertFeesToAmount(newMemberFees);
    });
  }

  void _renewalMemberCheckBoxValueChanges(String value) {
    setState(() {
      renewelMemberFees = value;
      debugPrint("_renewalMemberCheckBoxValueChanges --> $value");
      convertFeesToAmount(renewelMemberFees);
      totalAmount += cardRenewal;
    });
  }

  void _specialSkillsCheckBoxValueChanges(bool newValue, String skill) {
    setState(() {
      if (newValue) {
        if (!_selectedSpecialSkillsArray.contains(skill)) {
          _selectedSpecialSkillsArray.add(skill);
        }
      } else {
        if (_selectedSpecialSkillsArray.contains(skill)) {
          _selectedSpecialSkillsArray.remove(skill);
        }
      }
    });
  }

  void _otherInterestsCheckBoxValueChanges(bool newValue, String interest) {
    setState(() {
      if (newValue) {
        if (!_selectedOtherInterestsArray.contains(interest)) {
          _selectedOtherInterestsArray.add(interest);
        }
      } else {
        if (_selectedOtherInterestsArray.contains(interest)) {
          _selectedOtherInterestsArray.remove(interest);
        }
      }
    });
  }

  openDateSelector() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now(),
        minTime: DateTime.now().subtract(Duration(days: 43830)),
        theme: WidgetStyles.datePickerTheme, onChanged: (date) {
      //print('change $date in time zone ' +
      //date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      //print('confirm $date');

      setState(() {
        dateOfBirthController.text = _displayDobFormat(
            DateFormat(DateUtils.defaultDateFormat).format(date.toLocal()));
        ageController.text = getUserAge(date).toString();
      });
    },
        currentTime: DateTime.now(),
        // locale:
        //     AppPreferences().isLanguageTamil() ? LocaleType.ta : LocaleType.en);
        locale: LocaleType.en);
  }

  String validateDOB(String value) {
    if (value.trim().length == 0)
      return "DOB cannot be blank";
    else
      return null;
  }

  String validateZip(String value) {
    if (value.length < 1)
      return AppLocalizations.of(context).translate("key_pincodeerror");
    else if (value.length > 14)
      return "Must be below 14 digits";
    else
      return null;
  }

  getUserAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  bool formAutoValidate = false;

  showUserCashSuccessDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      //barrierDismissible: false,
      child: Dialog(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.cancel,
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF1E8449), width: 2),
                ),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Congratulations!! GNAT(Graduate Nurses Association of Tamil Nadu) family heartily welcomes you. You have successfully registered as a members in GNAT* Please note that you have 30 days from today to pay the membership fee in order to ger your ID card and complete your registration. You are not a member unless you pay the fee.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E8449),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  receiptNoDialogue(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Receipt Number"),
            if (showEditReceiptNumber)
              GestureDetector(
                child: Icon(
                  Icons.cancel,
                  size: 30.0,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
          ],
        ),
        //contentPadding: const EdgeInsets.all(16.0),
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
                    onChanged: (str) {
                      // setState(() {
                      //   receiptNumber = str;
                      // });
                    },
                  )),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Confirm'),
              onPressed: () {
                if (_alertFormKey.currentState.validate()) {
                  setState(() {
                    //receiptNumber = str;
                    receiptNumber = receiptNumberController.text;
                  });
                  Navigator.pop(context);
                } else {
                  setState(() {
                    formAutoValidate = true;
                  });
                }
              })
        ],
      ),
    );
  }

  void _validateInputs() async {
    debugPrint("_validateInput");
    //debugPrint("${documentAddressProofImage}");
    FocusScope.of(context).requestFocus(FocusNode());
    if ((_formKey.currentState.validate() &&
        (_membershipInfo != null &&
            _membershipInfo.addressProof != null &&
            _membershipInfo.addressProof.isNotEmpty &&
            _membershipInfo.registeredNurseDocument != null &&
            _membershipInfo.registeredNurseDocument.isNotEmpty &&
            _membershipInfo.recentPicture != null &&
            _membershipInfo.recentPicture.isNotEmpty))) {
      debugPrint("_validateInput 1");
      _checkTermsAndConditions();
    } else if (_formKey.currentState.validate() &&
        _membershipInfo == null &&
        ((addressProofPicURL != null || documentAddressProofImage != null)) &&
        documentRnRmImage != null &&
        documentRececentImage != null) {
      debugPrint("_validateInputs 2");
      _checkTermsAndConditions();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  // void _validateInputs() async {
  //   FocusScope.of(context).requestFocus(FocusNode());
  //   if ((_formKey.currentState.validate() &&
  //       (_membershipInfo != null &&
  //           _membershipInfo.identifyProofFront != null &&
  //           _membershipInfo.identifyProofFront.isNotEmpty &&
  //           _membershipInfo.identifyProofBack != null &&
  //           _membershipInfo.identifyProofBack.isNotEmpty))) {
  //     _checkTermsAndConditions();
  //   } else if (_formKey.currentState.validate() &&
  //       _membershipInfo == null &&
  //       (documentFrontImage != null && documentBackImage != null)) {
  //     _checkTermsAndConditions();
  //   } else {
  //     setState(() {
  //       _autoValidate = true;
  //     });
  //   }
  // }

  _checkTermsAndConditions() {
    if (_membershipFormFieldNameList.contains(FN_TERMS_CONDITIONS)) {
      if (_isTermsAndConditionChecked) {
        _sendDataToServer();
      } else {
        Utils.toasterMessage(Constants.TERMS_AND_CONDITION_WARNING);
      }
    } else {
      _sendDataToServer();
    }
  }

  _sendDataToServer() async {
    debugPrint("_sendDataToServer called...");
    _formKey.currentState.save();
    if (paymentCheckbox && paymentStatus || !paymentCheckbox) {
      CustomProgressLoader.showLoader(context);
      MembershipInfo info = new MembershipInfo();

      info.active = true;
      //if (_referredBy != "Person")
      info.referredBy = _referredBy;
      // else
      //   info.referredBy = referedPersonNameContoller.text.length != 0
      //       ? referedPersonNameContoller.text
      //       : socialMedia;
      if (_referredBy == "Person") {
        info.referredByValue = referedPersonNameContoller.text;
      } else {
        info.referredByValue = socialMedia;
      }

      info.address1 = addressOneController.text;
      info.address2 = addressTwoController.text.isNotEmpty
          ? addressTwoController.text
          : null;
      info.age =
          ageController.text.isNotEmpty ? int.parse(ageController.text) : "0";
      info.birthDate = dateOfBirthController.text.isNotEmpty
          ? _serverDobFormat(dateOfBirthController.text)
          : null;
      info.branch = selectedBranch;
      info.cellNumber =
          phoneCellController.text.isNotEmpty ? phoneCellController.text : null;
      info.city = cityController.text;
      info.country = countryController.text;

      info.countryCodeCell = countryCodeCell;
      info.countryCodeHome = countryCodeHome;
      info.additionalQualificationMajor = courseMajorController.text;
      info.additionalQualificationStatus =
          courseCompletionStatusController.text;
      info.additionalInfo = additionalInfoController.text;
      info.countryCodeValueCell =
          countryDialCodeCell?.replaceAll("+", "") ?? null;
      info.countryCodeValueHome =
          countryDialCodeHome?.replaceAll("+", "") ?? null;
      if ((_membershipFormFieldNameList != null &&
          _membershipFormFieldNameList.contains(FN_BRANCH))) {
        if (AppPreferences().role == Constants.USER_ROLE) {
          if (_membershipInfo != null) {
            info.departmentName = _membershipInfo.departmentName;
            info.oldDepartmentName = "";
          } else {
            info.departmentName = await AppPreferences.getDeptName();
            info.oldDepartmentName = "";
          }
        } else {
          String deparmentNameFromPreference =
              await AppPreferences.getDeptName();

          /// When the headoffice supervisor updates the branch value, that time departmentName should be the updated branch value and olddepartment value should be the previous department value.
          if (_membershipInfo != null &&
              _membershipInfo.branch != null &&
              _membershipInfo.branch != selectedBranch) {
            debugPrint("1...");
            info.departmentName = selectedBranch;
            info.oldDepartmentName = _membershipInfo.departmentName;
          }

          /// When the user user submits the membeship form, branch value will be null.
          /// If the supervisor selects different branch while updating, then we need to update department name and old department name.
          else if (_membershipInfo != null &&
              _membershipInfo.branch == null &&
              selectedBranch != deparmentNameFromPreference) {
            debugPrint("2...");
            info.departmentName = selectedBranch;
            info.oldDepartmentName = _membershipInfo.departmentName;
          }

          /// When the user user submits the membeship form, branch value will be null
          /// If ths supervisor selects same branch name, then we no need to update the dapartment and old department value will be empty.
          else if (_membershipInfo != null &&
              _membershipInfo.branch == null &&
              selectedBranch == deparmentNameFromPreference) {
            debugPrint("3...");
            info.departmentName = deparmentNameFromPreference;
            info.oldDepartmentName = "";
          }

          /// When the supervisor enrolls membership for the user.
          /// If ths supervisor selects different branch name, then we need to update department name and old department name.
          else if (_membershipInfo == null &&
              selectedBranch != deparmentNameFromPreference) {
            debugPrint("4...");
            info.departmentName = selectedBranch;
            info.oldDepartmentName = deparmentNameFromPreference;
          }

          /// When the supervisor enrolls membership for the user.
          /// If ths supervisor selects same branch name, then we no need to update the dapartment and old department value will be empty.
          else if (_membershipInfo == null &&
              selectedBranch == deparmentNameFromPreference) {
            debugPrint("5...");
            info.departmentName = deparmentNameFromPreference;
            info.oldDepartmentName = "";
          } else {
            debugPrint("6...");
            info.departmentName = deparmentNameFromPreference;
            info.oldDepartmentName = "";
          }

          if (widget.isCameHierarchyFrom) {
            if (_membershipInfo != null) {
              //debugPrint("isCameHierarchyFrom _membershipInfo != null");
              if (_membershipInfo.departmentName != selectedBranch) {
                debugPrint("7...");
                //debugPrint("isCameHierarchyFrom _membershipInfo != null if");
                info.oldDepartmentName = _membershipInfo.departmentName;
                info.departmentName = selectedBranch;
              } else {
                debugPrint("8...");
                //debugPrint("isCameHierarchyFrom _membershipInfo != null else");
                info.oldDepartmentName = "";
                info.departmentName = _membershipInfo.departmentName;
              }
            } else {
              debugPrint("9...");
              info.departmentName = selectedBranch;
              if (selectedBranch == _membershipDepartment) {
                //debugPrint("9... If");
                info.oldDepartmentName = "";
              } else {
                //debugPrint("9... Else");
                info.oldDepartmentName = _membershipDepartment;
              }
            }
          }
        }
      } else {
        if (_membershipInfo != null) {
          info.departmentName = _membershipInfo.departmentName;
          info.oldDepartmentName = "";
        } else {
          if (AppPreferences().role == Constants.USER_ROLE) {
            info.departmentName = await AppPreferences.getDeptName();
            info.oldDepartmentName = "";
          } else {
            info.departmentName = _membershipDepartment;
            info.oldDepartmentName = "";
          }
        }
      }

      info.diabetes = (isDiagnosedDiabetes) ? "Yes" : "No";
      info.diabetesFamilyHistory = isFamilyHasDiabetes ? "Yes" : "No";

      info.receiptNo = receiptNumber;

      info.paymentMode = _paymentMode;
      switch (_membershipStatus) {
        case MembershipStatus.UnderReview:
          info.membershipStatus = UNDER_REVIEW;
          break;
        case MembershipStatus.PendingPayment:
          info.membershipStatus = PENDING_PAYMENT;
          break;
        case MembershipStatus.PendingApproval:
          info.membershipStatus = PENDING_APPROVAL;
          break;
        case MembershipStatus.Approved:
          info.membershipStatus = APPROVED;
          if (_membershipInfo != null &&
              _membershipInfo.approvedDate != null &&
              isMembershipExpired(_membershipInfo) &&
              receiptNumber != null &&
              receiptNumber.isNotEmpty &&
              paymentStatus) {
            var now = DateTime.now();
            var approvedDateTime =
                DateTime(now.year, now.month, now.day, now.hour, now.minute)
                    .toUtc()
                    .toString();
            var approvedDateTimeArray = approvedDateTime.split(" ");
            var approvedDateTimeInUTC =
                approvedDateTimeArray[0] + "T" + approvedDateTimeArray[1];
            info.approvedDate = approvedDateTimeInUTC;
            info.authroizedBy = await AppPreferences.getUsername();
          } else {
            if (_membershipInfo != null &&
                _membershipInfo.approvedDate != null) {
              info.approvedDate = _membershipInfo.approvedDate;
              info.authroizedBy = _membershipInfo.authroizedBy;
            } else {
              var now = DateTime.now();
              var approvedDateTime =
                  DateTime(now.year, now.month, now.day, now.hour, now.minute)
                      .toUtc()
                      .toString();
              var approvedDateTimeArray = approvedDateTime.split(" ");
              var approvedDateTimeInUTC =
                  approvedDateTimeArray[0] + "T" + approvedDateTimeArray[1];
              info.approvedDate = approvedDateTimeInUTC;
              info.authroizedBy = await AppPreferences.getUsername();
            }
          }
          break;
        case MembershipStatus.Rejected:
          info.membershipStatus = REJECTED;
          break;
        default:
          info.membershipStatus = UNDER_REVIEW;
      }

      info.emailId = emailController.text;
      info.firstName = firstController.text;
      info.gender = _genderValue;
      info.homeNumber = phoneHomeController.text;
      info.lastName = lastController.text;

      info.nationalId = nationalIdController.text;

      info.newMemberFees = newMemberFees;
      info.occupation = occupationController.text.isNotEmpty
          ? occupationController.text
          : null;
      info.otherNames =
          otherNameController.text.isNotEmpty ? otherNameController.text : null;
      info.renewalFees = renewelMemberFees;

      info.specialSkills = _selectedSpecialSkillsArray.isNotEmpty
          ? _selectedSpecialSkillsArray
          : null;
      info.state = stateController.text;
      if (AppPreferences().role == Constants.supervisorRole) {
        info.userName = _membershipUserName;
      } else {
        info.userName = await AppPreferences.getUsername();
      }
      if (_userFullName != null && _userFullName.isNotEmpty)
        info.userFullName = _userFullName;
      //info.approvedDate = "2019-08-26T14:00:00";
      //info.renewalFees = "";
      info.volunteer = isVolunteer ? "Yes" : "No";
      info.zipcode = zipCodeController.text;
      if (commentsController.text.isNotEmpty) {
        info.comments = commentsController.text;
      }
      if (recommendedBy.isNotEmpty) {
        info.recommendedBy = recommendedBy;
      } else {
        if (AppPreferences().role == Constants.supervisorRole) {
          info.recommendedBy = "Supervisor";
        } else {
          info.recommendedBy = "User";
        }
      }

      info.district = districtController.text;
      info.bloodGroup = _bloodGroup;
      if (_educationalQualification != "Other")
        info.qualification = _educationalQualification;
      else
        info.qualification = otherQualificationController.text;
      info.documentName = _documentName;
      info.workLocation = workLocationController.text;
      // if (_referredBy != "Person")
      //   info.referredBy = _referredBy;
      // else
      //   info.referredBy = referedPersonNameContoller.text.length != 0
      //       ? referedPersonNameContoller.text
      //       : socialMedia;

      if (_selectedOtherInterestsArray.contains("Others")) {
        _selectedOtherInterestsArray.add(otherInterestController.text);
      }
      info.otherInterests = _selectedOtherInterestsArray.isNotEmpty
          ? _selectedOtherInterestsArray
          : null;
      info.registeredNurse = rnRmNumberController.text;

      //if (socialMedia != null) info.referredByValue = socialMedia;
      // debugPrint("Info referredByValue ${info.referredByValue}");
      // debugPrint("Info referredBy ${info.referredBy}");
      debugPrint("Info ${info.toJson()}");

      String toastMsg = "";
      http.Response response;
      if (_membershipInfo != null) {
        if (_membershipInfo.identifyProofFront != null &&
            _membershipInfo.identifyProofFront.isNotEmpty) {
          info.identifyProofFront = _membershipInfo.identifyProofFront;
        }
        if (_membershipInfo.identifyProofBack != null &&
            _membershipInfo.identifyProofBack.isNotEmpty) {
          info.identifyProofBack = _membershipInfo.identifyProofBack;
        }

        if (_membershipInfo.addressProof != null &&
            _membershipInfo.addressProof.isNotEmpty) {
          info.addressProof = _membershipInfo.addressProof;
        }
        if (_membershipInfo.registeredNurseDocument != null &&
            _membershipInfo.registeredNurseDocument.isNotEmpty) {
          info.registeredNurseDocument =
              _membershipInfo.registeredNurseDocument;
        }
        if (_membershipInfo.recentPicture != null &&
            _membershipInfo.recentPicture.isNotEmpty) {
          info.recentPicture = _membershipInfo.recentPicture;
        }

        toastMsg = "Membership updated successfully";
        response = await _membershipRepository.updateMembership(
          membershipData: info.toJson(),
          membershipId: _membershipInfo.membershipId,
          frontImageFile: documentFrontImage,
          backImageFile: documentBackImage,
          addressProofImageFile: documentAddressProofImage,
          rnRmImageFile: documentRnRmImage,
          recentImageFile: documentRececentImage,
        );
        // print("updation payment");
      } else {
        toastMsg = "Membership added successfully";
        response = await _membershipRepository.createMembership(
          membershipData: info.toJson(),
          frontImageFile: documentFrontImage,
          backImageFile: documentBackImage,
          addressProofImageFile: documentAddressProofImage,
          rnRmImageFile: documentRnRmImage,
          recentImageFile: documentRececentImage,
        );
        // print("created membership payment");
      }
      debugPrint("Response body --> ${response.body}");
      debugPrint("Response code --> ${response.statusCode}");

      // To update the Profile information
      if (AppPreferences().role == Constants.USER_ROLE) {
        AuthBloc bloc = AuthBloc(context);
        await bloc.getUserInformation();
      }

      CustomProgressLoader.cancelLoader(context);
      if (response.statusCode == 201 || response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: toastMsg,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            gravity: ToastGravity.TOP);

        if (AppPreferences().role == Constants.supervisorRole) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
              ModalRoute.withName(Routes.navigatorHomeScreen));
        }
      } else {
        debugPrint("response --> ${response.body}");
        String errorMsg = jsonDecode(response.body)['message'] as String;
        if (errorMsg != null &&
            errorMsg.isNotEmpty &&
            errorMsg == "Receipt No Already Exists") {
          showEditReceiptNumber = true;
        }
        AlertUtils.showAlertDialog(
            context,
            errorMsg != null && errorMsg.isNotEmpty
                ? errorMsg
                : AppPreferences().getApisErrorMessage);
      }
    } else {
      setState(() {
        hasPaymentEnabled = true;
      });
    }
  }

  Future<void> fetchPreferredLocations() async {
    preferredLocationsList =
        await _membershipRepository.getMembershipFormBranches();

    int count = 0;
    //print("Prefered locations $preferredLocationsList ");
    preferredLocationsList.forEach((v) {
      //debugPrint("branch --> $v");
      if (count == preferredLocations.length - 1) {
        setState(() {
          preferredLocations.add(DropdownMenuItem(
            child: Text(v),
            value: v,
          ));
        });
      } else {
        preferredLocations.add(DropdownMenuItem(
          child: Text(v),
          value: v,
        ));
      }
      count = count + 1;
    });

    //setState(() {});
    if (AppPreferences().role == Constants.supervisorRole) {
      if (widget.membershipId != null) {
        _fetchMembershipInfoById();
      } else {
        recommendedBy = "Supervisor";
        setState(() {
          _isMembershipInfoLoaded = true;
        });
      }
    } else {
      _fetchMembershipInfoByUserName();
    }
  }

  _onCountryCodeHomeChanged(CountryCode country) async {
    countryCodeHome = country.code;
    countryDialCodeHome = country.dialCode;
  }

  _onCountryCodeCellChanged(CountryCode country) async {
    countryCodeCell = country.code;
    countryDialCodeCell = country.dialCode;
  }
}

bool isMembershipExpired(MembershipInfo membershipInfo) {
  int numOfRenewalYears = 0;
  int numOfYears = 0;
  if (membershipInfo.renewalFees != null &&
      membershipInfo.renewalFees.isNotEmpty) {
    //debugPrint("renewalFees is --> ${membershipInfo.renewalFees}");

    // switch (membershipInfo.renewalFees) {
    //   case oneYearRenewal:
    //     numOfRenewalYears = 1;
    //     break;
    //   case twoYearRenewal:
    //     numOfRenewalYears = 2;
    //     break;
    //   case threeYearRenewal:
    //     numOfRenewalYears = 3;
    //     break;
    //   default:
    // }
    //debugPrint("numOfRenewalYears --> $numOfRenewalYears");
  } else if (membershipInfo.newMemberFees != null &&
      membershipInfo.newMemberFees.isNotEmpty) {
    //debugPrint("newMemberFees is --> ${membershipInfo.newMemberFees}");

    switch (membershipInfo.newMemberFees) {
      // case oneYearNew:
      //   numOfYears = 1;
      //   break;
      // case twoYearNew:
      //   numOfYears = 2;
      //   break;
      // case threeYearNew:
      //   numOfYears = 3;
      //   break;
      // default:

      case month:
        numOfYears = 1;
        break;
      case quaterly:
        numOfYears = 2;
        break;
      case halfYearly:
        numOfYears = 3;
        break;

      case yearly:
        numOfYears = 3;
        break;
      default:
    }
    //debugPrint("numOfYears --> $numOfYears");
  }
  final currentDate = DateTime.now();
  var dateTimeArray = membershipInfo?.approvedDate?.split("T");
  if (dateTimeArray != null && dateTimeArray.length > 1) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm")
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();

    final difference = currentDate.difference(dateLocal).inDays;
    //debugPrint("difference is --> $difference");
    if (numOfRenewalYears != 0 && (difference > numOfRenewalYears * 365)) {
      return true;
    } else if (numOfYears != 0 && (difference > numOfYears * 365)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

String getMembershipRemainingDays(MembershipInfo membershipInfo) {
  int numOfRenewalYears = 0;
  int numOfYears = 0;
  if (membershipInfo.renewalFees != null &&
      membershipInfo.renewalFees.isNotEmpty) {
    //debugPrint("renewalFees is --> ${membershipInfo.renewalFees}");

    // switch (membershipInfo.renewalFees) {
    //   case oneYearRenewal:
    //     numOfRenewalYears = 1;
    //     break;
    //   case twoYearRenewal:
    //     numOfRenewalYears = 2;
    //     break;
    //   case threeYearRenewal:
    //     numOfRenewalYears = 3;
    //     break;
    //   default:
    // }
    //debugPrint("numOfRenewalYears --> $numOfRenewalYears");
  } else if (membershipInfo.newMemberFees != null &&
      membershipInfo.newMemberFees.isNotEmpty) {
    //debugPrint("newMemberFees is --> ${membershipInfo.newMemberFees}");

    switch (membershipInfo.newMemberFees) {
      // case oneYearNew:
      //   numOfYears = 1;
      //   break;
      // case twoYearNew:
      //   numOfYears = 2;
      //   break;
      // case threeYearNew:
      //   numOfYears = 3;
      //   break;
      // default:
    }
    //debugPrint("numOfYears --> $numOfYears");
  }
  final currentDate = DateTime.now();
  var dateTimeArray = membershipInfo?.approvedDate?.split("T");
  if (dateTimeArray != null && dateTimeArray.length > 1) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm")
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();

    final difference = currentDate.difference(dateLocal).inDays;
    //debugPrint("difference is --> $difference");

    if (numOfRenewalYears != 0 && (difference <= numOfRenewalYears * 365)) {
      int remainingDays = (numOfRenewalYears * 365) - difference;
      return getDaysString(remainingDays);
    } else if (numOfYears != 0 && (difference <= numOfYears * 365)) {
      int remainingDays = (numOfYears * 365) - difference;
      return getDaysString(remainingDays);
    } else {
      return APPROVED;
    }
  } else {
    return APPROVED;
  }
}

String getDaysString(int days) {
  if (days == 0) {
    return "Expires Today";
  } else if (days == 1) {
    return "Expires in 1 Day";
  } else if (days <= 30) {
    return "Expires in $days Days";
  } else {
    return APPROVED;
  }
}

class PageReferenceData {
  final String fieldValue;
  final String fieldDisplayValue;

  const PageReferenceData(this.fieldValue, this.fieldDisplayValue);
}
