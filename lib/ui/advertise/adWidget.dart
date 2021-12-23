import '../../utils/app_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

/// Written by Balvinder on 15 Apr 2021
void initializeAd() async {
  Admob.initialize();
  var adID = await getAppId();
  //print("=============================> Ad Id ====== $adID");
  FirebaseAdMob.instance.initialize(appId: adID);
}

Future<String> getAppId() async {
  var adId = await AppPreferences.getAdAppId();
  return adId;
}

Future<String> getAdBannerProp() async {
  var bannerData = await AppPreferences.getAdUnitBanner();
  var bannerId = bannerData.toString().split(',')[0];
  // print("========================> bannerId $bannerId");
  return bannerId;
}

Widget getSivisoftAdWidget() {
  return FutureBuilder(
    future: getAdBannerProp(),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.data == null) return Container();
      return AdmobBanner(
        adUnitId: snapshot.data,
        adSize: AdmobBannerSize.BANNER,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
      );
    },
  );
}

/// End here
