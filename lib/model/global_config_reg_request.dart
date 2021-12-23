class GlobalConfigRegRequest {
  String androidApkImageEncoded;
  String country;
  String countryCode;
  String countryCodeValue;
  String countryName;
  String createdBy;
  String createdOn;
  String emailId;
  String expiryDate;
  String firstName;
  int id;
  String initialApkDownloadLink;
  String initialMobileVersion;
  String iosApkImageEncoded;
  bool isActive;
  String lastName;
  String latLong;
  String mobileNo;
  String mobilePlatform;
  String modifiedBy;
  String modifiedOn;
  int noOfUsers;
  String organisationName;
  String registerSource;
  dynamic status;
  String supervisorToken;
  String superPromoCode;
  String tokenImageEncoded;
  String userName;
  String password;
  String userPromoCode;
  String userToken;
  int statusCode;
  String message;
  String environmentCode;

  GlobalConfigRegRequest(
      {this.androidApkImageEncoded,
      this.country,
      this.countryCode,
      this.countryCodeValue,
      this.countryName,
      this.createdBy,
      this.createdOn,
      this.emailId,
      this.expiryDate,
      this.firstName,
      this.id,
      this.initialApkDownloadLink,
      this.initialMobileVersion,
      this.iosApkImageEncoded,
      this.isActive,
      this.lastName,
      this.latLong,
      this.mobileNo,
      this.mobilePlatform,
      this.modifiedBy,
      this.modifiedOn,
      this.noOfUsers,
      this.organisationName,
      this.registerSource,
      this.status,
      this.supervisorToken,
      this.tokenImageEncoded,
      this.environmentCode,
      this.superPromoCode,
      this.userName,
      this.password,
      this.userPromoCode,
      this.userToken});

  GlobalConfigRegRequest.fromJson(Map<String, dynamic> json) {
    androidApkImageEncoded = json['androidApkImageEncoded'];
    country = json['country'];
    superPromoCode = json['superPromoCode'];
    password = json['password'];
    userPromoCode = json['userPromoCode'];
    environmentCode = json['environmentCode'];
    countryCode = json['countryCode'];
    countryCodeValue = json['countryCodeValue'];
    countryName = json['countryName'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    emailId = json['emailId'];
    expiryDate = json['expiryDate'];
    firstName = json['firstName'];
    id = json['id'];
    initialApkDownloadLink = json['initialApkDownloadLink'];
    initialMobileVersion = json['initialMobileVersion'];
    iosApkImageEncoded = json['iosApkImageEncoded'];
    isActive = json['isActive'];
    lastName = json['lastName'];
    latLong = json['latLong'];
    mobileNo = json['mobileNo'];
    mobilePlatform = json['mobilePlatform'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    noOfUsers = json['noOfUsers'];
    organisationName = json['organisationName'];
    registerSource = json['registerSource'];
    status = json['status'];
    supervisorToken = json['supervisorToken'];
    tokenImageEncoded = json['tokenImageEncoded'];
    userName = json['userName'];
    userToken = json['userToken'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['androidApkImageEncoded'] = this.androidApkImageEncoded;
    data['country'] = this.country;
    data['password'] = this.password;
    data['superPromoCode'] = this.superPromoCode;
    data['userPromoCode'] = this.userPromoCode;
    data['environmentCode'] = this.environmentCode;
    data['countryCode'] = this.countryCode;
    data['countryCodeValue'] = this.countryCodeValue;
    data['countryName'] = this.countryName;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['emailId'] = this.emailId;
    data['expiryDate'] = this.expiryDate;
    data['firstName'] = this.firstName;
    data['id'] = this.id;
    data['initialApkDownloadLink'] = this.initialApkDownloadLink;
    data['initialMobileVersion'] = this.initialMobileVersion;
    data['iosApkImageEncoded'] = this.iosApkImageEncoded;
    data['isActive'] = this.isActive;
    data['lastName'] = this.lastName;
    data['latLong'] = this.latLong;
    data['mobileNo'] = this.mobileNo;
    data['mobilePlatform'] = this.mobilePlatform;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['noOfUsers'] = this.noOfUsers;
    data['organisationName'] = this.organisationName;
    data['registerSource'] = this.registerSource;
    data['status'] = this.status;
    data['supervisorToken'] = this.supervisorToken;
    data['tokenImageEncoded'] = this.tokenImageEncoded;
    data['userName'] = this.userName;
    data['userToken'] = this.userToken;
    data['message'] = this.message;
    return data;
  }
}
