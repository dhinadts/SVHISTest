import 'dart:convert';

import '../model/base_response.dart';
import '../model/menu_item.dart';
import '../repo/common_repository.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

class MenuItemsRepository {
  MenuItemsRepository();

  WebserviceHelper helper = WebserviceHelper();

  Future<dynamic> getMenuItems() async {
    String url =
        '${WebserviceConstants.baseURL}/admin/menus?department_name=${AppPreferences().deptmentName}'; //Prod URL
    //String url = 'https://covidapp-e5d27.web.app/menu.json';  //Test URL
    // debugPrint("URL $url");
    final http.Response response = await http.get(
      url,
    );
    List<dynamic> jsonData;
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData.length > 0) {
        MenuItems menuItems = MenuItems.fromJson(jsonData[0]);
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        // debugPrint("Current App--$jsonData[0]");
        // debugPrint("Current App--$version");
        // debugPrint("Menu Version from server--${menuItems.appMinVersion}");
//        if (menuItems.appMinVersion == version) {
        double versionDouble = removeDotFromString(version);
        double appMinVersionDouble =
        removeDotFromString(menuItems.appMinVersion);
        double appMaxVersionDouble =
        removeDotFromString(menuItems.appMaxVersion);
        if (versionDouble <= appMaxVersionDouble &&
            versionDouble >= appMinVersionDouble) {
          // debugPrint(
          //     "Server version and current app version are same, Replacing menu items data");
          AppPreferences.setMenuItemsData(response.body);
        } else {
          // debugPrint("Server version and current app version are different");
        }
        return menuItems;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      jsonData = jsonDecode(response.body);
      return MenuItems.fromJson(jsonData[0]);
    }
  }

  double removeDotFromString(String ver) {
    double versionDouble = 0.0;
    if (ver.contains(".")) {
      String versionStr = ver.replaceAll(".", "");
      versionDouble = double.parse(versionStr.substring(0, 3));
    }

    return versionDouble;
  }

  BaseResponse onMultiTimeOut() {
    BaseResponse appBaseResponse = BaseResponse(status: 500);
    //BaseResponse response = BaseResponse(jsonEncode(appBaseResponse), 500);
    return appBaseResponse;
  }
}
