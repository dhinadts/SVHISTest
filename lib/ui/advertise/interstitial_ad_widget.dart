import '../../ui/advertise/webview_screen.dart';
import 'package:flutter/material.dart';

import '../../model/advertisement.dart';

class InterStitialAd extends StatelessWidget {
  final Advertisement advertisement;

  InterStitialAd(this.advertisement);

  static const String BANNER_TYPE_SMART = "Smart";
  static const String BANNER_TYPE_WIDTH_HEIGHT = "width_height";
  static const String MEDIUM_RECTANGLE_BANNER = "rectangleBanner";
  static const String FULL_BANNER = "fullBanner";
  static const String LARGE_BANNER = "largeBanner";
  static const String LEADER_BOARD_BANNER = "leaderboardBanner";
  static const String BANNER = "banner";
  static const String ANCHOR_TYPE_TOP = "TOP";
  static const String ANCHOR_TYPE_BOTTOM = "BOTTOM";
  static const String AD_TYPE_BANNER = "BANNER";
  static const String AD_TYPE_INTERSTITIAL = "INTERSTITIAL";
  static const String AD_TYPE_VIDEO = "VIDEO";
  static const double DEFAULT_BANNER_HEIGHT = 50;

  @override
  Widget build(BuildContext context) {
//Get the ad type
    switch (this.advertisement.advertiseType) {
      case AD_TYPE_INTERSTITIAL:
        // showInterstitialDialog(context);
        return Container(
          width: 0.0,
          height: 0.0,
        );
      case AD_TYPE_VIDEO:
        return Center(
          child: Text("reminder"),
        );
    }

    return getBannerTypeAd();
  }

//BANNER ADs
  Widget getBannerTypeAd() {
    return Container(
      color: Colors.cyan,
      height: (this.advertisement.mediaUrl != null) ? getBannerHeight() : 0,
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(this.advertisement.mediaUrl),
            fit: BoxFit.fitWidth),
      ),
    );
  }

  double getBannerHeight() {
    switch (this.advertisement.adSizeType) {
      case MEDIUM_RECTANGLE_BANNER:
        return 250;
      case FULL_BANNER:
        return 60;
      case LARGE_BANNER:
        return 100;
      case LEADER_BOARD_BANNER:
        return 90;
      case BANNER:
        return 50;
    }
    return DEFAULT_BANNER_HEIGHT;
  }

  // //INTERSTITIAL ADs
  // Future<void> showInterstitialDialog() async {
  static void showInterstitialDialog(BuildContext context, Advertisement ad) {
    // ad.childDirected = "https://www.sivisoft.com/";
    bool isAdTapped = false;
    int adDuration = ad.interstitialDuration.round() == 0
        ? 500
        : ad.interstitialDuration.round();
    Future.delayed(Duration(milliseconds: adDuration), () {
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (context) {
            Future.delayed(Duration(seconds: 5), () {
              if (context != null && isAdTapped == false) {
                Navigator.of(context).pop(true);
              }
            });
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                child: Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width * .8,
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                if (ad.childDirected.length > 0) {
                                  isAdTapped = true;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebViewExample(
                                              ad.childDirected, " ")));
                                }
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .5,
                                  width: MediaQuery.of(context).size.width * .8,
                                  color: Colors.grey[100],
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                            child: CircularProgressIndicator()),
                                        Center(
                                          child: Image.network(
                                            ad.mediaUrl,
                                            fit: BoxFit.fill,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            child: Align(
// These values are based on trial & error method
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  isAdTapped = true;
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
          });
    });
  }
}
