import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../utils/app_preferences.dart';
import '../../login/preferences/user_preference.dart';
import '../../repo/common_repository.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class APICalling {
  // Post Method

  static apiRequest(String url, Map jsonMap, String auth) async {
    final response = await http.post('$url',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
          "Authorization": auth,
        },
        body: json.encode(jsonMap));
    // print("--------> " + response.statusCode.toString());
    return response.body;
  }

  static apiPostWithHeaderRequest(String url, Map jsonMap) async {
    final response = await http.post('$url',
        headers: {
          "username": 'mobile',
          "tenant": WebserviceConstants.tenant,
          'content-type': 'application/json',
        },
        body: json.encode(jsonMap));

    // print("------------>" + response.body.toString());
    return response.statusCode;
  }

  Future<http.Response> apiPost(String url, jsonMap) async {
    Map<String, String> header = await WebserviceConstants.createHeader();
    final http.Response response =  await http.post('$url', headers: header, body: jsonMap);
    // print("------------>ss" + jsonMap);
    // print("------------>" + response.body.toString());
    return response;
  }

  static apiPut(String url, jsonMap) async {
    Map<String, String> header = await WebserviceConstants.createHeader();
    final response = await http.put('$url', headers: header, body: jsonMap);
    // print("------------>ss" + jsonMap);
    // print("------------>" + response.body.toString());
    return response.statusCode;
  }

  static apiDelete(String url) async {
    Map<String, String> header = await WebserviceConstants.createHeader();

    final response = await http.delete('$url', headers: header);
    // print("------------>" + response.body.toString());
    return response.statusCode;
  }

  static apiPostWithHeaderRequestFamilyTree(
      String url, String userName, Map jsonMap) async {
    Map<String, String> header = await WebserviceConstants.createHeader();

    final response =
        await http.post('$url', headers: header, body: json.encode(jsonMap));

    // print("------------>" + response.body.toString());
    return response;
  }

  static apiPutWithHeaderRequestFamilyTree(
      String url, String userName, Map jsonMap) async {
    Map<String, String> header = await WebserviceConstants.createHeader();
    final response = await http.put('$url',
        headers: header,
        body: json.encode(jsonMap));

    // print("------------>" + response.body.toString());
    return response;
  }

  static Future<String> getapiRequest(String url, String filename) async {
    HttpClient client = new HttpClient();
    var _downloadData = StringBuffer();
    var fileSave = new File(filename);
    client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.listen((d) => _downloadData.write(d), onDone: () {
        fileSave.writeAsString(_downloadData.toString());
      });
    });

    return "";
  }

  static Future<String> getapiRequestWithAccessToken(String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));

    request.headers.set('username', "mobile");
    request.headers.set('tenant', WebserviceConstants.tenant);
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply;
    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();
    } else {
      reply = "";
    }

    httpClient.close();
    return reply;
  }

  static Future<String> getapiRequestWithoutAccessToken(String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply;
    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();
    } else {
      reply = "";
    }
    httpClient.close();
    return reply;
  }

  static apiPostWithImageHeaderRequest(String url, File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    Map<String, String> headers = {
      "accesstoken": UserPreference.getAccessToken()
    };
    var length = await imageFile.length();
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('u_image', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    // print(respStr);
    return respStr;
  }
}
