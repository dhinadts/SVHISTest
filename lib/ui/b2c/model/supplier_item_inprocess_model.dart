import 'base_response.dart';

class SupplierItemInProcessDataModel extends BaseResponse {
  num id;
  String orderItem;
  num orderQuantity;
  String orderBy;
  String chamberBuying;
  String orderCreated;
  String orderStatus;
  bool confirm;
  String emailRequester;
  dynamic biRequester;

  SupplierItemInProcessDataModel(
      {this.id,
      this.orderItem,
      this.orderQuantity,
      this.orderBy,
      this.chamberBuying,
      this.orderCreated,
      this.orderStatus,
      this.confirm,
      this.emailRequester,
      this.biRequester});

  SupplierItemInProcessDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderItem = json['order_item'];
    orderQuantity = json['order_quantity'];
    orderBy = json['order_by'];
    chamberBuying = json['chamber_buying'];
    orderCreated = json['order_created'];
    orderStatus = json['order_status'];
    confirm = json['confirm'];
    emailRequester = json['email_requester'];
    biRequester = json['bi_requester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["order_item"] = this.orderItem;
    data["order_quantity"] = this.orderQuantity;
    data["order_by"] = this.orderBy;
    data["chamber_buying"] = this.chamberBuying;
    data["order_created"] = this.orderCreated;
    data["order_status"] = this.orderStatus;
    data["confirm"] = this.confirm;
    data["email_requester"] = this.emailRequester;
    data["bi_requester"] = this.biRequester;
    return data;
  }
}
