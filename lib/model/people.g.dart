// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

People _$PeopleFromJson(Map<String, dynamic> json) {
  return People()
    ..message = json['message'] as String
    ..status = json['status']
    ..timestamp = json['timestamp'] as String
    ..error = json['error'] as String
    ..path = json['path'] as String
    ..active = json['active'] as bool
    ..departmentName = json['departmentName'] as String
    ..location = json['location'] as String
    ..birthDate = json['birthDate'] as String
    ..bloodGroup = json['bloodGroup'] as String
    ..city = json['city'] as String
    ..cityName = json['cityName'] as String
    ..comments = json['comments'] as String
    ..country = json['country'] as String
    ..countryCode = json['countryCode'] as String
    ..countryCodeValue = json['countryCodeValue'] as String
    ..countryName = json['countryName'] as String
    ..emailId = json['emailId'] as String
    ..employeeId = json['employeeId'] as String
    ..firstName = json['firstName'] as String
    ..gender = json['gender'] as String
    ..invalidLoginCount = json['invalidLoginCount'] as int
    ..lastName = json['lastName'] as String
    ..userName = json['userName'] as String
    ..zipCode = json['zipCode'] as String
    ..tokenUrl = json['tokenUrl'] as String
    ..roleName = json['roleName'] as String
    ..stateName = json['stateName'] as String
    ..tokenKey = json['tokenKey'] as String
    ..addressLine1 = json['addressLine1'] as String
    ..addressLine2 = json['addressLine2'] as String
    ..addressLine3 = json['addressLine3'] as String
    ..userFullName = json['userFullName'] as String
    ..pregnant = json['pregnant'] as String
    ..age = json['age'] as int
    ..downloadProfileURL = json['downloadProfileURL'] as String
    ..userRelation = json['userRelation'] as String
    ..userStatus = json['userStatus'] as String
    ..userCategory = json['userCategory'] as String
    ..parentUserName = json['parentUserName'] as String
    ..latLongInfo = json['latLongInfo'] as String
    ..createdOn = json['createdOn'] as String
    ..isHomeLocation = json['isHomeLocation'] as bool
    ..mobileNo = json['mobileNo'] as String
    ..profileImage = json['profileImage'] as String
    ..profileImageBytes = json['profileImageBytes'] as String
    ..modifiedOn = json['modifiedOn'] as String
    ..source = json['source'] as String
    ..hasMembership = json['hasMembership'] as bool
    ..secondMobileNo = json['secondMobileNo'] as String
    ..lastReportedDate = json['lastReportedDate'] as String
    ..membershipEntitlements = json['membershipEntitlements']
    ..membershipStatus = json['membershipStatus']
    ..membershipType = json['membershipType'] as String;
}

Map<String, dynamic> _$PeopleToJson(People instance) => <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'active': instance.active,
      'departmentName': instance.departmentName,
      'location': instance.location,
      'birthDate': instance.birthDate,
      'bloodGroup': instance.bloodGroup,
      'city': instance.city,
      'cityName': instance.cityName,
      'comments': instance.comments,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'countryCodeValue': instance.countryCodeValue,
      'countryName': instance.countryName,
      'downloadProfileURL': instance.downloadProfileURL,
      'emailId': instance.emailId,
      'employeeId': instance.employeeId,
      'firstName': instance.firstName,
      'gender': instance.gender,
      'invalidLoginCount': instance.invalidLoginCount,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'zipCode': instance.zipCode,
      'tokenUrl': instance.tokenUrl,
      'roleName': instance.roleName,
      'stateName': instance.stateName,
      'tokenKey': instance.tokenKey,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'addressLine3': instance.addressLine3,
      'userFullName': instance.userFullName,
      'pregnant': instance.pregnant,
      'age': instance.age,
      'userRelation': instance.userRelation,
      'userStatus': instance.userStatus,
      'userCategory': instance.userCategory,
      'parentUserName': instance.parentUserName,
      'latLongInfo': instance.latLongInfo,
      'createdOn': instance.createdOn,
      'isHomeLocation': instance.isHomeLocation,
      'mobileNo': instance.mobileNo,
      'profileImage': instance.profileImage,
      'profileImageBytes': instance.profileImageBytes,
      'modifiedOn': instance.modifiedOn,
      'source': instance.source,
      'secondMobileNo': instance.secondMobileNo,
      'lastReportedDate': instance.lastReportedDate,
      'membershipType': instance.membershipType,
      'membershipEntitlements': instance.membershipEntitlements,
      'hasMembership': instance.hasMembership,
      'membershipStatus': instance.membershipStatus,
    };
