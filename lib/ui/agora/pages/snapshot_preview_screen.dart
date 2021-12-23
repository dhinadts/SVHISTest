import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnapshotPreviewScreen extends StatelessWidget {
  final File imageFile;

  const SnapshotPreviewScreen({Key key, @required this.imageFile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: CupertinoPageScaffold(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Image.file(
              imageFile,
            )),
          ),
        ),
        bottomNavigationBar: bottomAppBar(context));
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, AppBar().preferredSize.height),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.8),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Snapshot Preview',
                            textAlign: TextAlign.center,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: CupertinoTheme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                    ],
                  ),
                ),
                Divider(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.delete_forever,
              size: 28,
              color: Colors.red,
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.upload_file,
                size: 28, color: CupertinoTheme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
