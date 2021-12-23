import 'dart:convert';

import 'base_response.dart';

class MatchedRequestDataModel extends BaseResponse {
  String item;
  num quantity;
  num arrangeDate;
  num arrangeQuantity;
  String description;
  num id;
  String organizationName;
  String address;
  String firstName;
  String lastName;
  String jobTitle;
  String city;
  String state;
  String zipCode;
  num supplierId;
  dynamic providerItemInfo;
  String capableSupplies;
  num totalDistance;
  bool isSameItemName;
  List<dynamic> matchingTags;

  MatchedRequestDataModel(
      {this.item,
      this.quantity,
      this.arrangeDate,
      this.arrangeQuantity,
      this.description,
      this.id,
      this.organizationName,
      this.address,
      this.firstName,
      this.lastName,
      this.jobTitle,
      this.city,
      this.state,
      this.zipCode,
      this.supplierId,
      this.providerItemInfo,
      this.capableSupplies,
      this.totalDistance,
      this.isSameItemName,
      this.matchingTags});

  MatchedRequestDataModel.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    quantity = json['quantity'];
    arrangeDate = json['arrange_date'];
    arrangeQuantity = json['arrange_quantity'];
    description = json['description'];
    id = json['id'];
    organizationName = json['organization_name'];
    address = json['address'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    jobTitle = json['job_title'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipcode'];
    supplierId = json['supplier_id'];
    providerItemInfo = json['provider_item_info'];
    capableSupplies = json['capable_supplies'];
    totalDistance = json['total_distance'];
    isSameItemName = json['is_same_item_name'];
    matchingTags = json['matching_tags'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["item"] = this.item;
    data["quantity"] = this.quantity;
    data["arrange_date"] = this.arrangeDate;
    data["arrange_quantity"] = this.arrangeQuantity;
    data["id"] = this.id;
    data["organization_name"] = this.organizationName;
    data["address"] = this.address;
    data["firstname"] = this.firstName;
    data["lastname"] = this.lastName;
    data["job_title"] = this.jobTitle;
    data["city"] = this.city;
    data["state"] = this.state;
    data["zipcode"] = this.zipCode;
    data["supplier_id"] = this.supplierId;
    data["provider_item_info"] = this.providerItemInfo;
    data["capable_supplies"] = this.capableSupplies;
    data["total_distance"] = this.totalDistance;
    data["is_same_item_name"] = this.isSameItemName;
    data["matching_tags"] = this.matchingTags;

    return data;
  }
}
