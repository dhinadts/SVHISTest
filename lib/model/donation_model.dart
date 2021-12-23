import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DonationModel {
  String address;
  String address2;
  String county;
  String city;
  String comments;
  String country;
  String countryCode;
  String countryCodeValue;
  String createdBy;
  String createdOn;
  String donatedTo;
  String donationAmount;
  String donationCurrency;
  String donationDescription;
  String donationStatus;
  String donationType;
  String emailId;
  String firstName;
  String lastName;
  String mobileNumber;
  String modifiedBy;
  String modifiedOn;
  String paymentId;
  String reminder;
  String state;
  String transactionId;
  bool active;
  String zipcode;

  DonationModel(
      {this.active,
      this.comments,
      this.city,
      this.address2,
      this.county,
      this.country,
      this.state,
      this.firstName,
      this.lastName,
      this.emailId,
      this.countryCode,
      this.countryCodeValue,
      this.address,
      this.createdBy,
      this.createdOn,
      this.donatedTo,
      this.donationAmount,
      this.donationCurrency,
      this.donationDescription,
      this.donationStatus,
      this.donationType,
      this.mobileNumber,
      this.modifiedBy,
      this.modifiedOn,
      this.paymentId,
      this.reminder,
      this.transactionId,
      this.zipcode});

  DonationModel.fromJson(Map<String, dynamic> json) {
    active = json['active'] ?? false;
    comments = json['comments'] ?? "";
    countryCode = json['countryCode'] ?? "";
    countryCodeValue = json['countryCodeValue'] ?? "";
    address = json['address'] ?? "";
    address2 = json['address2'] ?? "";
    county = json['county'] ?? "";
    city = json['city'] ?? "";
    country = json['country'] ?? "";
    state = json['state'] ?? "";
    firstName = json['firstName'] ?? "";
    lastName = json['lastName'] ?? "";
    emailId = json['emailId'] ?? "";
    mobileNumber = json['mobileNumber'] ?? "";
    createdBy = json['createdBy'] ?? "";
    createdOn = json['createdOn'] ?? "";
    donatedTo = json['donatedTo'] ?? "";
    donationAmount = json['donationAmount'] ?? "";
    donationCurrency = json['donationCurrency'] ?? "";
    donationDescription = json['donationDescription'] ?? "";
    donationStatus = json['donationStatus'] ?? "";
    donationType = json['donationType'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    modifiedOn = json['modifiedOn'] ?? "";
    paymentId = json['paymentId'] ?? "";
    reminder = json['reminder'] ?? "";
    transactionId = json['transactionId'] ?? "";
    zipcode = json['zipcode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['active'] = this.active;
    data['comments'] = this.comments;
    data['countryCode'] = this.countryCode;
    data['countryCodeValue'] = this.countryCodeValue;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['county'] = this.county;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['donatedTo'] = this.donatedTo;
    data['donationAmount'] = this.donationAmount;
    data['donationCurrency'] = this.donationCurrency;
    data['donationDescription'] = this.donationDescription;
    data['donationStatus'] = this.donationStatus;
    data['donationType'] = this.donationType;
    data['mobileNumber'] = this.mobileNumber;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['paymentId'] = this.paymentId;
    data['reminder'] = this.reminder;
    data['transactionId'] = this.transactionId;
    data['zipcode'] = this.zipcode;

    return data;
  }
}
