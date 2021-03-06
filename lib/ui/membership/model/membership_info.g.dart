// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipInfo _$MembershipInfoFromJson(Map<String, dynamic> json) {
  return MembershipInfo(
    active: json['active'] as bool,
    address: json['address'] as String,
    address1: json['address1'] as String,
    address2: json['address2'] as String,
    addressProof: json['addressProof'] as String,
    age: json['age'] as int,
    approvedDate: json['approvedDate'] as String,
    authroizedBy: json['authroizedBy'] as String,
    birthDate: json['birthDate'] as String,
    bloodGroup: json['bloodGroup'] as String,
    branch: json['branch'] as String,
    cardRenewal: json['cardRenewal'] as String,
    cellNumber: json['cellNumber'] as String,
    city: json['city'] as String,
    comments: json['comments'] as String,
    completedDate: json['completedDate'] as String,
    country: json['country'] as String,
    countryCodeCell: json['countryCodeCell'] as String,
    countryCodeHome: json['countryCodeHome'] as String,
    countryCodeValueCell: json['countryCodeValueCell'] as String,
    countryCodeValueHome: json['countryCodeValueHome'] as String,
    createdBy: json['createdBy'] as String,
    createdOn: json['createdOn'] as String,
    downloadProfileURL: json['downloadProfileURL'] as String,
    departmentName: json['departmentName'] as String,
    diabetes: json['diabetes'] as String,
    diabetesFamilyHistory: json['diabetesFamilyHistory'] as String,
    district: json['district'] as String,
    documentName: json['documentName'] as String,
    duration: json['duration'] as String,
    emailId: json['emailId'] as String,
    expiryDate: json['expiryDate'] as String,
    expiryDays: json['expiryDays'] as int,
    expiryDurationInMonths: json['expiryDurationInMonths'] as int,
    fees: json['fees'] as String,
    firstName: json['firstName'] as String,
    gender: json['gender'] as String,
    homeNumber: json['homeNumber'] as String,
    identifyProofBack: json['identifyProofBack'] as String,
    identifyProofFront: json['identifyProofFront'] as String,
    lastName: json['lastName'] as String,
    martialStatus: json['martialStatus'] as String,
    membershipId: json['membershipId'] as String,
    membershipStatus: json['membershipStatus'] as String,
    membershipType: json['membershipType'] as String,
    modifiedBy: json['modifiedBy'] as String,
    additionalQualificationMajor:
        json['additionalQualificationMajor'] as String,
    additionalQualificationStatus:
        json['additionalQualificationStatus'] as String,
    additionalInfo: json['additionalInfo'] as String,
    modifiedOn: json['modifiedOn'] as String,
    nationalId: json['nationalId'] as String,
    newMemberFees: json['newMemberFees'] as String,
    occupation: json['occupation'] as String,
    oldDepartmentName: json['oldDepartmentName'] as String,
    otherNames: json['otherNames'] as String,
    paymentMode: json['paymentMode'] as String,
    qualification: json['qualification'] as String,
    receiptNo: json['receiptNo'] as String,
    recommendedBy: json['recommendedBy'] as String,
    referredBy: json['referredBy'] as String,
    referredByValue: json['referredByValue'] as String,
    renewalFees: json['renewalFees'] as String,
    registeredNurse: json['registeredNurse'] as String,
    specialSkills:
        (json['specialSkills'] as List)?.map((e) => e as String)?.toList(),
    state: json['state'] as String,
    userFullName: json['userFullName'] as String,
    userName: json['userName'] as String,
    volunteer: json['volunteer'] as String,
    zipcode: json['zipcode'] as String,
    roleName: json['roleName'] as String,
    workLocation: json['workLocation'] as String,
    hasMembership: json['hasMembership'] as bool,
    otherInterests:
        (json['otherInterests'] as List)?.map((e) => e as String)?.toList(),
    registeredNurseDocument: json['registeredNurseDocument'] as String,
    recentPicture: json['recentPicture'] as String,
  );
}

Map<String, dynamic> _$MembershipInfoToJson(MembershipInfo instance) =>
    <String, dynamic>{
      'active': instance.active,
      'hasMembership': instance.hasMembership,
      'age': instance.age,
      'address': instance.address,
      'additionalInfo': instance.additionalInfo,
      'address1': instance.address1,
      'address2': instance.address2,
      'addressProof': instance.addressProof,
      'approvedDate': instance.approvedDate,
      'authroizedBy': instance.authroizedBy,
      'additionalQualificationMajor': instance.additionalQualificationMajor,
      'additionalQualificationStatus': instance.additionalQualificationStatus,
      'birthDate': instance.birthDate,
      'bloodGroup': instance.bloodGroup,
      'branch': instance.branch,
      'roleName': instance.roleName,
      'cardRenewal': instance.cardRenewal,
      'downloadProfileURL': instance.downloadProfileURL,
      'cellNumber': instance.cellNumber,
      'city': instance.city,
      'comments': instance.comments,
      'completedDate': instance.completedDate,
      'country': instance.country,
      'countryCodeCell': instance.countryCodeCell,
      'countryCodeHome': instance.countryCodeHome,
      'countryCodeValueCell': instance.countryCodeValueCell,
      'countryCodeValueHome': instance.countryCodeValueHome,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'departmentName': instance.departmentName,
      'diabetes': instance.diabetes,
      'diabetesFamilyHistory': instance.diabetesFamilyHistory,
      'district': instance.district,
      'documentName': instance.documentName,
      'duration': instance.duration,
      'emailId': instance.emailId,
      'expiryDate': instance.expiryDate,
      'expiryDays': instance.expiryDays,
      'expiryDurationInMonths': instance.expiryDurationInMonths,
      'fees': instance.fees,
      'firstName': instance.firstName,
      'gender': instance.gender,
      'homeNumber': instance.homeNumber,
      'identifyProofBack': instance.identifyProofBack,
      'identifyProofFront': instance.identifyProofFront,
      'lastName': instance.lastName,
      'martialStatus': instance.martialStatus,
      'membershipId': instance.membershipId,
      'membershipStatus': instance.membershipStatus,
      'membershipType': instance.membershipType,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'nationalId': instance.nationalId,
      'newMemberFees': instance.newMemberFees,
      'occupation': instance.occupation,
      'oldDepartmentName': instance.oldDepartmentName,
      'otherNames': instance.otherNames,
      'paymentMode': instance.paymentMode,
      'qualification': instance.qualification,
      'receiptNo': instance.receiptNo,
      'recommendedBy': instance.recommendedBy,
      'referredBy': instance.referredBy,
      'referredByValue': instance.referredByValue,
      'renewalFees': instance.renewalFees,
      'registeredNurse': instance.registeredNurse,
      'state': instance.state,
      'userFullName': instance.userFullName,
      'userName': instance.userName,
      'volunteer': instance.volunteer,
      'workLocation': instance.workLocation,
      'zipcode': instance.zipcode,
      'specialSkills': instance.specialSkills,
      'otherInterests': instance.otherInterests,
      'registeredNurseDocument': instance.registeredNurseDocument,
      'recentPicture': instance.recentPicture,
    };
