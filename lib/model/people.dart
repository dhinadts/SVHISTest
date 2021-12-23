import '../model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'people.g.dart';

@JsonSerializable()
class People extends BaseResponse {
  @JsonKey(name: "active")
  bool active;

  @JsonKey(name: "departmentName")
  String departmentName;

  @JsonKey(name: "location")
  String location;

  @JsonKey(name: "birthDate")
  String birthDate;
  @JsonKey(name: "bloodGroup")
  String bloodGroup;
  @JsonKey(name: "city")
  String city;
  @JsonKey(name: "cityName")
  String cityName;
  @JsonKey(name: "comments")
  String comments;
  @JsonKey(name: "country")
  String country;
  @JsonKey(name: "countryCode")
  String countryCode;
  @JsonKey(name: "countryCodeValue")
  String countryCodeValue;
  @JsonKey(name: "countryName")
  String countryName;
  @JsonKey(name: "emailId")
  String emailId;
  @JsonKey(name: "employeeId")
  String employeeId;
  @JsonKey(name: "firstName")
  String firstName;
  @JsonKey(name: "gender")
  String gender;
  @JsonKey(name: "invalidLoginCount")
  int invalidLoginCount;
  @JsonKey(name: "lastName")
  String lastName;

  @JsonKey(name: "userName")
  String userName;

  @JsonKey(name: "zipCode")
  String zipCode;

  @JsonKey(name: "tokenUrl")
  String tokenUrl;

  @JsonKey(name: "roleName")
  String roleName;

  @JsonKey(name: "stateName")
  String stateName;

  @JsonKey(name: "tokenKey")
  String tokenKey;

  // Remaining Fields
  @JsonKey(name: "addressLine1")
  String addressLine1;

  @JsonKey(name: "addressLine2")
  String addressLine2;

  @JsonKey(name: "addressLine3")
  String addressLine3;

  @JsonKey(name: "userFullName")
  String userFullName;

  @JsonKey(name: "pregnant")
  String pregnant;

  @JsonKey(name: "age")
  int age;

  @JsonKey(name: "userRelation")
  String userRelation;

  @JsonKey(name: "userStatus")
  String userStatus;

  @JsonKey(name: "userCategory")
  String userCategory;

  @JsonKey(name: "downloadProfileURL")
  String downloadProfileURL;

  @JsonKey(name: "parentUserName")
  String parentUserName;

  @JsonKey(name: "latLongInfo")
  String latLongInfo;

  @JsonKey(name: "createdOn")
  String createdOn;

  @JsonKey(name: "isHomeLocation")
  bool isHomeLocation;

  @JsonKey(name: "mobileNo")
  String mobileNo;

  @JsonKey(name: "profileImage")
  String profileImage;

  @JsonKey(name: "profileImageBytes")
  String profileImageBytes;

  @JsonKey(name: "modifiedOn")
  String modifiedOn;

  @JsonKey(name: "source")
  String source;

  @JsonKey(name: "secondMobileNo")
  String secondMobileNo;

  @JsonKey(name: "lastReportedDate")
  String lastReportedDate;

  @JsonKey(name: "membershipType")
  String membershipType;

  @JsonKey(name: "membershipStatus")
  String membershipStatus;

  @JsonKey(name: "hasMembership")
  bool hasMembership;

  @JsonKey(name:'membershipEntitlements')
  Map<String,dynamic> membershipEntitlements;

  People();

  factory People.fromJson(Map<String, dynamic> json) => _$PeopleFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleToJson(this);
}

// @JsonSerializable()
// class MembershipEntitlements{
//   @JsonKey(name: 'membershipId')
//   String membershipId;

//   @JsonKey(name: "membershipStatus")
//   String membershipStatus;

//   @JsonKey(name: "membershipType")
//   String membershipType;

//   @JsonKey(name: "approvedDate")
//   String approvedDate;

//   @JsonKey(name: "expiryDate")
//   String expiryDate;

//   MembershipEntitlements();

//   factory MembershipEntitlements.fromJson(Map<String, dynamic> json) =>
//       _$MembershipEntitlementsFromJson(json);

//   Map<String, dynamic> toJson() => _$MembershipEntitlementsToJson(this);
// }
