import 'dart:convert';

import 'base_response.dart';

class RequestedItemModel extends BaseResponse {
  num id;
  num provider;
  String item;
  num quantity;
  String description;
  String critical;
  String procure;
  String transport;
  int arrangeDate;
  String comment;
  String toCheck;
  String chamberBuying;
  bool toHide;
  String itemUpdated;
  String tags;

  RequestedItemModel(
      {this.id,
      this.provider,
      this.item,
      this.quantity,
      this.description,
      this.critical,
      this.procure,
      this.transport,
      this.arrangeDate,
      this.comment,
      this.toCheck,
      this.chamberBuying,
      this.toHide,
      this.itemUpdated,
      this.tags});

  RequestedItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provider = json['provider'];
    item = json['item'];
    quantity = json['quantity'];
    description = json['description'];
    critical = json['critical'];
    procure = json['procure'];
    transport = json['transport'];
    comment = json['comment'];
    chamberBuying = json['chamber_buying'];
    toCheck = json['to_check'];
    toHide = json['to_hide'];
    arrangeDate = json['arrange_date'];
    itemUpdated = json['item_updated'];
    tags = json['tags'];
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    var mapData = new Map();
//    mapData["item"] = newRequestData.item;
//    mapData["procure"] = newRequestData.procure;
//    mapData["critical"] = newRequestData.critical;
//    mapData["description"] = newRequestData.description;
//    mapData["quantity"] = newRequestData.quantity;
//    mapData["transport"] = newRequestData.transport;
//    mapData["arrange_date"] = newRequestData.arrangeDate;
//    mapData["comment"] = newRequestData.comment;
//    String json = jsonEncode(mapData);
//    print(json);
//    return json;
//  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["item_id"] = this.id;
    data["item_id_delete"] = this.id;
    data["item"] = this.item;
    data["procure"] = this.procure;
    data["critical"] = this.critical;
    data["description"] = this.description;
    data["quantity"] = this.quantity;
    data["transport"] = this.transport;
    data["arrange_date"] = this.arrangeDate;
    data["comment"] = this.comment;
    data["tags"] = this.tags;
    return data;
  }
}
