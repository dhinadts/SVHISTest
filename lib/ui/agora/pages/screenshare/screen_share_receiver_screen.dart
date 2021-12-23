import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class ScreenShareReceiverScreen extends StatefulWidget {
  final int uid;
  final String remoteUserName;

  const ScreenShareReceiverScreen({Key key, this.uid, this.remoteUserName})
      : super(key: key);

  @override
  _ScreenShareReceiverScreenState createState() =>
      _ScreenShareReceiverScreenState();
}

class _ScreenShareReceiverScreenState extends State<ScreenShareReceiverScreen> {
  bool showScreenSharedUserName = true;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(
      //     leading: Container(), middle: Text('Shah\'s screen')),
      child: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () {
            setState(() {
              showScreenSharedUserName = !showScreenSharedUserName;
            });
          },
          child: Stack(
            children: [
              RtcRemoteView.SurfaceView(
                uid: widget.uid,
                renderMode: VideoRenderMode.Fit,
              ),
              if (showScreenSharedUserName)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: screenSharedUserName(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget screenSharedUserName() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.remoteUserName != null && widget.remoteUserName.isNotEmpty
                ? "${widget.remoteUserName}\'s screen"
                : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
