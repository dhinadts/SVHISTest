import '../model/globalConfigurationDecodeErrorResponse.dart';
import '../model/global_config_reg_request.dart';
import '../model/global_configuration_decode_response.dart';
import '../repo/global_configuration_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class GlobalConfigurationBloc extends Bloc {
  GlobalConfigurationDecodeResponse response;
  GlobalConfigurationDecodeErrorResponse responseError;
  GlobalConfigRegRequest reqAndResp;

  final _repository = GlobalConfigurationRepository();

  final globalConfigurationDecodeFetcher =
      PublishSubject<GlobalConfigurationDecodeResponse>();
  final globalConfigurationDecodeErrorFetcher =
      PublishSubject<GlobalConfigurationDecodeErrorResponse>();

  final createGlobalConfigurationFetcher =
      PublishSubject<GlobalConfigRegRequest>();

  GlobalConfigurationBloc(BuildContext context) : super(context);

  @override
  void init() {}

  decodeGlobalConfigurationsUsingToken(String token,
      {bool isPromoCode: false}) async {
    var response = await _repository.decodeGlobalConfigurationUsingToken(token,
        isPromoCode: isPromoCode);

    if (response.message == null) {
      globalConfigurationDecodeFetcher.sink.add(response);
    } else {
      globalConfigurationDecodeErrorFetcher.sink.add(response);
      // debugPrint(response.message);
    }
  }

  globalConfigurationsCreateRequest(GlobalConfigRegRequest request) async {
    reqAndResp = await _repository.createGlobalConfiguration(request);
    createGlobalConfigurationFetcher.sink.add(reqAndResp);
  }

  @override
  void dispose() {
    globalConfigurationDecodeFetcher.close();
    createGlobalConfigurationFetcher.close();
    globalConfigurationDecodeErrorFetcher.close();
  }
}
