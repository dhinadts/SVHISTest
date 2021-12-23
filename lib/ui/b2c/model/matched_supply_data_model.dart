import '../model/base_response.dart';

class MatchedSupplyDataModel extends BaseResponse {
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
  num providerId;
  dynamic providerItemInfo;
  String critical;
  String procure;
  num totalDistance;
  bool isSameItemName;
  List<dynamic> matchingTags;

  MatchedSupplyDataModel(
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
      this.providerId,
      this.providerItemInfo,
      this.critical,
      this.procure,
      this.totalDistance,
      this.isSameItemName,
      this.matchingTags});

  MatchedSupplyDataModel.fromJson(Map<String, dynamic> json) {
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
    providerId = json['provider_id'];
    providerItemInfo = json['provider_item_info'];
    critical = json['critical'];
    procure = json['procure'];
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
    data["provider_id"] = this.providerId;
    data["provider_item_info"] = this.providerItemInfo;
    data["critical"] = this.critical;
    data["procure"] = this.procure;
    data["total_distance"] = this.totalDistance;
    data["is_same_item_name"] = this.isSameItemName;
    data["matching_tags"] = this.matchingTags;

    return data;
  }
}
