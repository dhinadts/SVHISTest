import '../model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserInfo extends BaseResponse {
  bool active;
  String addressLine1;
  String addressLine2;
  String addressLine3;
  String addressProof;
  String addressProofId;
  String addressProofPic;
  int age;
  bool sameAsPresentAddr;
  String androidUrl;
  String birthDate;
  String bloodGroup;
  String city;
  String cityName;
  String comments;
  String country;
  String countryCode;
  bool hasAdditionalInfo;
  String countryCodeValue;
  String countryName;
  String createdBy;
  String createdOn;
  String decryptedPassword;
  String departmentName;
  String district;
  String districtName;
  String downloadProfileURL;
  String downloadUrlMessage;
  String emailId;
  String employeeId;
  String errorMessage;
  String fees;
  String firstName;
  String gender;
  bool hasMembership;
  int invalidLoginCount;
  String iosUrl;
  bool isHomeLocation;
  bool isSethuAppInstalled;
  String lastName;
  String lastReportedDate;
  String latLongInfo;
  String location;
  String maritalStatus;
  String membershipStatus;
  String mobileNo;
  String modifiedBy;
  String modifiedOn;
  String registrationNumber;
  String oldDepartmentName;
  List<String> otherInterests;
  String otp;
  String otpId;
  String parentUserName;
  String password;
  String pregnant;
  String profileImage;
  String promoCode;
  String pwdChangeDate;
  bool pwdChangeFlag;
  String qualification;
  String tempUserSubType;
  String recentPic;
  String referredBy;
  String registeredNurseId;
  String registeredNursePic;
  String roleName;
  String scheduleId;
  String secondMobileNo;
  String secondaryAddressLine1;
  String secondaryAddressLine2;
  String secondaryAddressLine3;
  String secondaryCity;
  String secondaryCityName;
  String secondaryCountry;
  String secondaryCountryCode;
  String secondaryCountryCodeValue;
  String secondaryCountryName;
  String secondaryState;
  String secondaryStateName;
  String secondaryZipCode;
  String source;
  String state;
  String stateName;
  String symptomToken;
  String token;
  String tokenKey;
  String tokenKeyExpiryDate;
  String tokenUrl;
  String userCategory;
  String userFullName;
  String userName;
  String userRelation;
  String userStatus;
  String zipCode;
  String additionalQualificationMajor;
  String additionalQualificationStatus;

  String referredByValue;

  String additionalInfo;
  String membershipType;
  Map membershipEntitlements;

  UserInfo(
      {this.active,
      this.referredByValue,
      this.addressLine1,
      this.additionalInfo,
      this.addressLine2,
      this.addressLine3,
      this.addressProof,
      this.addressProofId,
      this.addressProofPic,
      this.additionalQualificationStatus,
      this.additionalQualificationMajor,
      this.age,
      this.androidUrl,
      this.birthDate,
      this.sameAsPresentAddr,
      this.bloodGroup,
      this.city,
      this.cityName,
      this.comments,
      this.country,
      this.countryCode,
      this.countryCodeValue,
      this.countryName,
      this.registrationNumber,
      this.createdBy,
      this.createdOn,
      this.hasAdditionalInfo: false,
      this.decryptedPassword,
      this.departmentName,
      this.district,
      this.districtName,
      this.downloadProfileURL,
      this.downloadUrlMessage,
      this.emailId,
      this.employeeId,
      this.errorMessage,
      this.fees,
      this.firstName,
      this.gender,
      this.hasMembership,
      this.invalidLoginCount,
      this.iosUrl,
      this.isHomeLocation,
      this.isSethuAppInstalled,
      this.lastName,
      this.lastReportedDate,
      this.latLongInfo,
      this.location,
      this.maritalStatus,
      this.membershipStatus,
      this.mobileNo,
      this.modifiedBy,
      this.modifiedOn,
      this.oldDepartmentName,
      this.otherInterests,
      this.otp,
      this.otpId,
      this.parentUserName,
      this.password,
      this.pregnant,
      this.profileImage,
      this.promoCode,
      this.pwdChangeDate,
      this.pwdChangeFlag,
      this.qualification,
      this.recentPic,
      this.referredBy,
      this.registeredNurseId,
      this.registeredNursePic,
      this.roleName,
      this.scheduleId,
      this.secondMobileNo,
      this.secondaryAddressLine1,
      this.secondaryAddressLine2,
      this.secondaryAddressLine3,
      this.secondaryCity,
      this.secondaryCityName,
      this.secondaryCountry,
      this.secondaryCountryCode,
      this.secondaryCountryCodeValue,
      this.secondaryCountryName,
      this.secondaryState,
      this.secondaryStateName,
      this.secondaryZipCode,
      this.source,
      this.state,
      this.stateName,
      this.symptomToken,
      this.tempUserSubType,
      this.token,
      this.tokenKey,
      this.tokenKeyExpiryDate,
      this.tokenUrl,
      this.userCategory,
      this.userFullName,
      this.userName,
      this.userRelation,
      this.userStatus,
      this.zipCode,
      this.membershipType,
      this.membershipEntitlements});

  UserInfo.fromJson(Map<String, dynamic> json) {
    active = json['active'] ?? false;
    addressLine1 = json['addressLine1'] ?? "";
    addressLine2 = json['addressLine2'] ?? "";
    addressLine3 = json['addressLine3'] ?? "";
    addressProof = json['addressProof'] ?? "";
    addressProofId = json['addressProofId'] ?? "";
    addressProofPic = json['addressProofPic'] ?? "";
    tempUserSubType = json['tempUserSubType'] ?? "";
    age = json['age'] ?? 0;
    sameAsPresentAddr = json['sameAsPresentAddr'] ?? false;
    additionalQualificationMajor = json['additionalQualificationMajor'] ?? "";
    additionalQualificationStatus = json['additionalQualificationStatus'] ?? "";
    androidUrl = json['androidUrl'] ?? "";
    registrationNumber = json['registrationNumber'] ?? "";
    birthDate = json['birthDate'] ?? "";
    bloodGroup = json['bloodGroup'] ?? "";
    city = json['city'] ?? "";
    state = json['state'] ?? "";
    additionalInfo = json['additionalInfo'] ?? "";
    cityName = json['cityName'] ?? "";
    comments = json['comments'] ?? "";
    country = json['country'] ?? "";
    countryCode = json['countryCode'] ?? "";
    countryCodeValue = json['countryCodeValue'] ?? "";
    countryName = json['countryName'] ?? "";
    createdBy = json['createdBy'] ?? "";
    referredByValue = json['referredByValue'] ?? "";
    hasAdditionalInfo = json['hasAdditionalInfo'] ?? false;
    createdOn = json['createdOn'] ?? "";
    decryptedPassword = json['decryptedPassword'] ?? "";
    departmentName = json['departmentName'] ?? "";
    district = json['district'] ?? "";
    districtName = json['districtName'] ?? "";
    downloadProfileURL = json['downloadProfileURL'] ?? "";
    downloadUrlMessage = json['downloadUrlMessage'] ?? "";
    emailId = json['emailId'] ?? "";
    employeeId = json['employeeId'] ?? "";
    errorMessage = json['errorMessage'] ?? "";
    fees = json['fees'] ?? "";
    firstName = json['firstName'] ?? "";
    gender = json['gender'] ?? "";
    hasMembership = json['hasMembership'] ?? false;
    invalidLoginCount = json['invalidLoginCount'] ?? 0;
    iosUrl = json['iosUrl'] ?? "";
    isHomeLocation = json['isHomeLocation'] ?? false;
    isSethuAppInstalled = json['isSethuAppInstalled'] ?? false;
    lastName = json['lastName'] ?? "";
    lastReportedDate = json['lastReportedDate'] ?? "";
    latLongInfo = json['latLongInfo'] ?? "";
    location = json['location'] ?? "";
    maritalStatus = json['maritalStatus'] ?? "";
    membershipStatus = json['membershipStatus'] ?? "";
    mobileNo = json['mobileNo'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    modifiedOn = json['modifiedOn'] ?? "";
    oldDepartmentName = json['oldDepartmentName'] ?? "";
    otherInterests = json['otherInterests'] == null
        ? []
        : json['otherInterests'].cast<String>();
    otp = json['otp'] ?? "";
    otpId = json['otpId'] ?? "";
    parentUserName = json['parentUserName'] ?? "";
    password = json['password'] ?? "";
    pregnant = json['pregnant'] ?? "";
    profileImage = json['profileImage'] ?? "";
    promoCode = json['promoCode'] ?? "";
    pwdChangeDate = json['pwdChangeDate'] ?? "";
    pwdChangeFlag = json['pwdChangeFlag'] ?? false;
    qualification = json['qualification'] ?? "";
    recentPic = json['recentPic'] ?? "";
    referredBy = json['referredBy'] ?? "";
    registeredNurseId = json['registeredNurseId'] ?? "";
    registeredNursePic = json['registeredNursePic'] ?? "";
    roleName = json['roleName'] ?? "";
    scheduleId = json['scheduleId'] ?? "";
    secondMobileNo = json['secondMobileNo'] ?? "";
    secondaryAddressLine1 = json['secondaryAddressLine1'] ?? "";
    secondaryAddressLine2 = json['secondaryAddressLine2'] ?? "";
    secondaryAddressLine3 = json['secondaryAddressLine3'] ?? "";
    secondaryCity = json['secondaryCity'] ?? "";
    secondaryCityName = json['secondaryCityName'] ?? "";
    secondaryCountry = json['secondaryCountry'] ?? "";
    secondaryCountryCode = json['secondaryCountryCode'] ?? "";
    secondaryCountryCodeValue = json['secondaryCountryCodeValue'] ?? "";
    secondaryCountryName = json['secondaryCountryName'] ?? "";
    secondaryState = json['secondaryState'] ?? "";
    secondaryStateName = json['secondaryStateName'] ?? "";
    secondaryZipCode = json['secondaryZipCode'] ?? "";
    source = json['source'] ?? "";

    stateName = json['stateName'] ?? "";
    symptomToken = json['symptomToken'] ?? "";
    token = json['token'] ?? "";
    tokenKey = json['tokenKey'] ?? "";
    tokenKeyExpiryDate = json['tokenKeyExpiryDate'] ?? "";
    tokenUrl = json['tokenUrl'] ?? "";
    userCategory = json['userCategory'] ?? "";
    userFullName = json['userFullName'] ?? "";
    userName = json['userName'] ?? "";
    userRelation = json['userRelation'] ?? "";
    userStatus = json['userStatus'] ?? "";
    zipCode = json['zipCode'] ?? "";
    membershipType = json['membershipType'] ?? "";
    membershipEntitlements = json['membershipEntitlements'] ?? {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['addressLine3'] = this.addressLine3;
    data['addressProof'] = this.addressProof;
    data['addressProofId'] = this.addressProofId;
    data['addressProofPic'] = this.addressProofPic;
    data['tempUserSubType'] = this.tempUserSubType;
    data['age'] = this.age;
    data['additionalQualificationMajor'] = this.additionalQualificationMajor;
    data['additionalQualificationStatus'] = this.additionalQualificationStatus;
    data['additionalInfo'] = this.additionalInfo;
    data['androidUrl'] = this.androidUrl;
    data['birthDate'] = this.birthDate;
    data['bloodGroup'] = this.bloodGroup;
    data['referredByValue'] = this.referredByValue;
    data['city'] = this.city;
    data['cityName'] = this.cityName;
    data['state'] = this.state;
    data['comments'] = this.comments;
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    data['countryCodeValue'] = this.countryCodeValue;
    data['registrationNumber'] = this.registrationNumber;
    data['countryName'] = this.countryName;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['decryptedPassword'] = this.decryptedPassword;
    data['departmentName'] = this.departmentName;
    data['district'] = this.district;
    data['districtName'] = this.districtName;
    data['downloadProfileURL'] = this.downloadProfileURL;
    data['downloadUrlMessage'] = this.downloadUrlMessage;
    data['emailId'] = this.emailId;
    data['employeeId'] = this.employeeId;
    data['errorMessage'] = this.errorMessage;
    data['sameAsPresentAddr'] = this.sameAsPresentAddr;
    data['fees'] = this.fees;
    data['firstName'] = this.firstName;
    data['gender'] = this.gender;
    data['hasMembership'] = this.hasMembership;
    data['invalidLoginCount'] = this.invalidLoginCount;
    data['iosUrl'] = this.iosUrl;
    data['isHomeLocation'] = this.isHomeLocation;
    data['isSethuAppInstalled'] = this.isSethuAppInstalled;
    data['lastName'] = this.lastName;
    data['lastReportedDate'] = this.lastReportedDate;
    data['latLongInfo'] = this.latLongInfo;
    data['location'] = this.location;
    data['maritalStatus'] = this.maritalStatus;
    data['membershipStatus'] = this.membershipStatus;
    data['mobileNo'] = this.mobileNo;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['oldDepartmentName'] = this.oldDepartmentName;
    data['otherInterests'] = this.otherInterests;
    data['otp'] = this.otp;
    data['otpId'] = this.otpId;
    data['parentUserName'] = this.parentUserName;
    data['password'] = this.password;
    data['pregnant'] = this.pregnant;
    data['profileImage'] = this.profileImage;
    data['promoCode'] = this.promoCode;
    data['pwdChangeDate'] = this.pwdChangeDate;
    data['pwdChangeFlag'] = this.pwdChangeFlag;
    data['hasAdditionalInfo'] = this.hasAdditionalInfo;
    data['qualification'] = this.qualification;
    data['recentPic'] = this.recentPic;
    data['referredBy'] = this.referredBy;
    data['registeredNurseId'] = this.registeredNurseId;
    data['registeredNursePic'] = this.registeredNursePic;
    data['roleName'] = this.roleName;
    data['scheduleId'] = this.scheduleId;
    data['secondMobileNo'] = this.secondMobileNo;
    data['secondaryAddressLine1'] = this.secondaryAddressLine1;
    data['secondaryAddressLine2'] = this.secondaryAddressLine2;
    data['secondaryAddressLine3'] = this.secondaryAddressLine3;
    data['secondaryCity'] = this.secondaryCity;
    data['secondaryCityName'] = this.secondaryCityName;
    data['secondaryCountry'] = this.secondaryCountry;
    data['secondaryCountryCode'] = this.secondaryCountryCode;
    data['secondaryCountryCodeValue'] = this.secondaryCountryCodeValue;
    data['secondaryCountryName'] = this.secondaryCountryName;
    data['secondaryState'] = this.secondaryState;
    data['secondaryStateName'] = this.secondaryStateName;
    data['secondaryZipCode'] = this.secondaryZipCode;
    data['source'] = this.source;

    data['stateName'] = this.stateName;
    data['symptomToken'] = this.symptomToken;
    data['token'] = this.token;
    data['tokenKey'] = this.tokenKey;
    data['tokenKeyExpiryDate'] = this.tokenKeyExpiryDate;
    data['tokenUrl'] = this.tokenUrl;
    data['userCategory'] = this.userCategory;
    data['userFullName'] = this.userFullName;
    data['userName'] = this.userName;
    data['userRelation'] = this.userRelation;
    data['userStatus'] = this.userStatus;
    data['zipCode'] = this.zipCode;
    data['membershipType'] = this.membershipType;
    data['membershipEntitlements'] = this.membershipEntitlements;
    return data;
  }
}
