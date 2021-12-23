import 'base_response.dart';

class ProvidersAndSuppliersActiveStatusModel extends BaseResponse {
  int activeProvider;
  int notActiveProvider;
  int activeSupplier;
  int notActiveSupplier;

  ProvidersAndSuppliersActiveStatusModel({
    this.activeProvider,
    this.notActiveProvider,
    this.activeSupplier,
    this.notActiveSupplier,
  });

  ProvidersAndSuppliersActiveStatusModel.fromJson(Map<String, dynamic> json) {
    activeProvider = json['active_provider'];
    notActiveProvider = json['not_active_provider'];
    activeSupplier = json['active_supplier'];
    notActiveSupplier = json['not_active_supplier'];
  }
}
