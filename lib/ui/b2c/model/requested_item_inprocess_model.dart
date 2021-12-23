import 'base_response.dart';

class RequestedItemInProcessDataModel extends BaseResponse {
  String orderItem;
  num orderId;
  num orderQuantity;
  String orderTo;
  String orderCreated;
  String orderStatus;
  String commentSupplier;
  String emailSupplier;
  dynamic biSupplier;

  RequestedItemInProcessDataModel({
    this.orderItem,
    this.orderId,
    this.orderQuantity,
    this.orderTo,
    this.orderCreated,
    this.orderStatus,
    this.biSupplier,
    this.commentSupplier,
    this.emailSupplier,
  });

  RequestedItemInProcessDataModel.fromJson(Map<String, dynamic> json) {
    orderItem = json['order_item'];
    orderId = json['order_id'];
    orderQuantity = json['order_quantity'];
    orderTo = json['order_to'];
    orderCreated = json['order_created'];
    orderStatus = json['order_status'];
    biSupplier = json['bi_supplier'];
    commentSupplier = json['comment_supplier'];
    emailSupplier = json['email_supplier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["order_item"] = this.orderItem;
    data["order_id"] = this.orderId;
    data["order_quantity"] = this.orderQuantity;
    data["order_to"] = this.orderTo;
    data["order_created"] = this.orderCreated;
    data["order_status"] = this.orderStatus;
    data["bi_supplier"] = this.biSupplier;
    data["comment_supplier"] = this.commentSupplier;
    data["email_supplier"] = this.emailSupplier;
    return data;
  }
}
