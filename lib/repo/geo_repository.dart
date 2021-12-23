import 'dart:convert';

import '../model/geo_response.dart';
import 'package:http/http.dart' as http;

class GeoRepository {
  GeoRepository();

  Future<GoeResponseModel> fetchAddress(String lat, String long) async {
    GoeResponseModel model = GoeResponseModel();
    try {
      http.Response response = await http
          .get('https://geocode.xyz/' + lat + ',' + long + '?geoit=json');
      if (200 <= response.statusCode && response.statusCode <= 299) {
        var responseJson = json.decode(response.body);
        print("Body Geo address ${response.body.toString()}");
        model = GoeResponseModel.fromJson(responseJson);
      } else {
        print("Body Geo address ${response.body.toString()}");
        model?.status = "false";
      }
    } catch (_) {
      model?.status = "false";
    }

    return model;
  }
}
