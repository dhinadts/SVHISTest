import 'base_response.dart';

class RequestCompleteVsIncompleteModel extends BaseResponse {
  int complete;
  int incomplete;

  RequestCompleteVsIncompleteModel({
    this.complete,
    this.incomplete,
  });

  RequestCompleteVsIncompleteModel.fromJson(Map<String, dynamic> json) {
    complete = json['complete'];
    incomplete = json['incomplete'];
  }
}
