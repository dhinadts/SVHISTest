import 'package:Memberly/ui_utils/app_colors.dart';
import 'package:Memberly/utils/app_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UpperLogoWidget extends StatefulWidget {
  final bool showPoweredBy;
  final bool showVersion;
  final bool showTitle;
  final bool home;

  const UpperLogoWidget(
      {Key key,
      this.showPoweredBy = false,
      this.showVersion = false,
      this.showTitle = false,
      this.home = false})
      : super(key: key);

  @override
  _UpperLogoWidgetState createState() => _UpperLogoWidgetState();
}

class _UpperLogoWidgetState extends State<UpperLogoWidget> {
  String logoPath = "qrcodeLogo";
  String logoUrl;
  String clientName;

  @override
  void initState() {
    // debugPrint("widget.showPoweredBy ${widget.showPoweredBy}");
    initilizeLogoPath();
    super.initState();
  }

  initilizeLogoPath() async {
    String appLogo = await AppPreferences.getAppLogo();
    clientName = await AppPreferences.getClientName();
    print(appLogo);
    if (appLogo != null) {
      setState(() {
        logoUrl = appLogo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15),
                child: logoUrl != null
                    // ? Image.network(
                    //     logoUrl,
                    //     height: 120,
                    //     width: 250,
                    //   )
                    ? CachedNetworkImage(
                        imageUrl: logoUrl,
                        height: widget.home ? 80 : 120,
                        width: 250,
                      )
                    : Image.asset(
                        "assets/images/${logoPath}_logo.png",
                        width: 220,
                      ),
              ),
              widget.showTitle
                  ? Text(
                      clientName == null ? "" : "$clientName",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 0, 128, 1)),
                    )
                  : Container(),
              widget.showVersion
                  ? RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "V-${AppPreferences().version ?? "1.0.0"}",
                              style: TextStyle(
                                  fontSize: 15, color: AppColors.warmGrey)),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          // SizedBox(
          //   height: 30,
          // ),
          // Center(
          //     child: RichText(
          //   text: TextSpan(
          //     style: DefaultTextStyle.of(context).style,
          //         children: <TextSpan>[
          //           TextSpan(
          //               text: 'SDx',
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   color: Color(ColorInfo.APP_BLUE),
          //                   fontSize: 40.0)),
          //           TextSpan(
          //               text: 'Contact',
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   color: Color(ColorInfo.APP_GREEN),
          //                   fontSize: 40.0)),
          //         ],
          //       ),
          //     )),
          // Text(
          //   "V-${AppPreferences().version ?? "1.0.0"}",
          //   style: TextStyle(fontSize: 15, color: AppColors.warmGrey),
          // ),
          // SizedBox(
          //   height: 15,
          // ),
        ],
      ),
      if (widget.showPoweredBy)
        Positioned(
          right: 20,
          top: 15,
          child: Container(
            child: Column(
              children: <Widget>[
                Text("Powered By",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      // fontWeight: FontWeight.bold
                    )),
                Container(
                  child: Image.asset(
                    'assets/images/sivisoft_logo.png',
                    fit: BoxFit.fitWidth,
                    height: 40,
                  ),
                )
              ],
            ),
          ),
        )
    ]);
  }
}

class UpperLogoWidgetDATT extends StatelessWidget {
  final bool showPoweredBy;

  const UpperLogoWidgetDATT({Key key, this.showPoweredBy = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/images/datt_logo.png",
                width: 150,
                height: 120,
              ),
            ),
            if (showPoweredBy)
              Positioned(
                right: 20,
                top: 35,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text("Powered By",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      Container(
                        child: Image.asset(
                          'assets/images/sivisoft_logo.png',
                          fit: BoxFit.fitWidth,
                          height: 40,
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
        // Text(
        //   "V-${AppPreferences().version ?? "1.3.7"}",
        //   style: TextStyle(fontSize: 15, color: AppColors.warmGrey),
        // ),
        // SizedBox(
        //   height: 15,
        // ),
      ],
    );
  }
}
