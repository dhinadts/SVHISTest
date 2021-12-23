import 'dart:convert';

import 'base_response.dart';

class SupplierItemModel extends BaseResponse {
  num id;
  num supplier;
  String item;
  num quantity;
  String unit;
  String description;
  String capableSupplies;
  String materialToProduct;
  num arrangeQuantity;
  int arrangeDate;
  String comment;
  String allTags;
  String itemUpdated;

  SupplierItemModel({
    this.id,
    this.supplier,
    this.item,
    this.quantity,
    this.unit,
    this.description,
    this.capableSupplies,
    this.materialToProduct,
    this.arrangeQuantity,
    this.arrangeDate,
    this.comment,
    this.allTags,
    this.itemUpdated,
  });

  SupplierItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplier = json['supplier'];
    item = json['item'];
    quantity = json['quantity'];
    unit = json['unit'];
    description = json['description'];
    capableSupplies = json['capable_supplies'];
    materialToProduct = json['material_to_product'];
    arrangeQuantity = json['arrange_quantity'];
    comment = json['comment'];
    arrangeDate = json['arrange_date'];
    itemUpdated = json['item_updated'];
    allTags = json['tags'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["item_id"] = this.id;
    data["supplier"] = this.supplier;
    data["item"] = this.item;
    data["quantity"] = this.quantity;
    data["unit"] = this.unit;
    data["description"] = this.description;
    data["description"] = this.description;
    data["capable_supplies"] = this.capableSupplies;
    data["material_to_product"] = this.materialToProduct;
    data["arrange_quantity"] = this.arrangeQuantity;
    data["comment"] = this.comment;
    data["arrange_date"] = this.arrangeDate;
    data["item_updated"] = this.itemUpdated;
    data["tags"] = this.allTags;
    return data;
  }
}
