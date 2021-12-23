import '../../ui/advertise/webview_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/advertisement.dart';
import 'adwebview.dart';

class AdvertisementWidget extends StatefulWidget {
  final Advertisement advertisement;

  const AdvertisementWidget({Key key, this.advertisement}) : super(key: key);

  @override
  AdvertisementWidgetState createState() => AdvertisementWidgetState();
}

class AdvertisementWidgetState extends State<AdvertisementWidget> {
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
    switch (widget.advertisement.advertiseType) {
      case AD_TYPE_INTERSTITIAL:
        // showInterstitialDialog();
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
    return InkWell(
        onTap: () {
          if (widget.advertisement.childDirected.length > 0) {
            _showModalBottomSheet();
          }
        },
        child: Container(
          height:
              (widget.advertisement.mediaUrl != null) ? getBannerHeight() : 0,
          foregroundDecoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.advertisement.mediaUrl),
                fit: BoxFit.fitWidth),
          ),
        ));
  }

  double getBannerHeight() {
    switch (widget.advertisement.adSizeType) {
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

  void _showModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            )),
            onClosing: () {},
            builder: (context) {
              return new Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.amber,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: WebViewWidget(
                    url: widget.advertisement.childDirected,
                  ),
                ),
              );
            },
          );
        });
  }

  // //INTERSTITIAL ADs
  // Future<void> showInterstitialDialog() async {
  void showInterstitialDialog() {
    bool stateClosed = false;
    int adDuration = widget.advertisement.interstitialDuration.round() == 0
        ? 500
        : widget.advertisement.interstitialDuration.round();

    Future.delayed(Duration(milliseconds: adDuration), () {
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (context) {
            Future.delayed(Duration(seconds: 5), () {
              if (!stateClosed) Navigator.of(context).pop(true);
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewExample(
                                            widget.advertisement.childDirected,
                                            " ")));
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
                                            widget.advertisement.mediaUrl,
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
                                  stateClosed = true;
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.blue,
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
