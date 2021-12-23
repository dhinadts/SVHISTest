import '../../../repo/common_repository.dart';
import '../../../ui_utils/network_check.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "status")
  int status;

  @JsonKey(name: "timestamp")
  String timestamp;

  @JsonKey(name: "error")
  dynamic error;

  @JsonKey(name: "path")
  String path;

  BaseResponse(
      {this.message, this.status, this.error, this.timestamp, this.path});

  factory BaseResponse.fromJson(Map<String, dynamic> json,
      {BaseResponse response}) {
    if (response == null) {
      return _$BaseResponseFromJson(json);
    } else {
      BaseResponse baseRes = _$BaseResponseFromJson(json);
      baseRes._setValues(response, baseRes);
      return response;
    }
  }

  Future<void> markAsErrorResponse() async {
    bool isNetworkAvailable = await NetworkCheck().check();
    status = WebserviceHelper.WEB_ERROR_STATUS_CODE;
    if (!isNetworkAvailable) {
      message = "Network error";
    }
  }

  bool webErrorNotOccurred() {
    return status == WebserviceConstants.success;
  }

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);

  void _setValues(BaseResponse response, BaseResponse baseRes) {
    if (response != null && baseRes != null) {
      response.message = message;
      response.status = status;
      response.error = error;
    }
  }
}
