import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../../model/smart_notes_model.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class SmartNoteFileShowScreen extends StatefulWidget {
  final FileDetails fileObj;
  final String noteComments;

  SmartNoteFileShowScreen({
    @required this.fileObj,
    this.noteComments,
  });

  @override
  _SmartNoteFileShowScreenState createState() =>
      _SmartNoteFileShowScreenState();
}

class _SmartNoteFileShowScreenState extends State<SmartNoteFileShowScreen> {
  VideoPlayerController _controller;
  Uint8List _base64;
  String _base64Str;
  Future<void> _initializeVideoPlayerFuture;
  bool showFullView = false;

  @override
  void initState() {
    super.initState();
    if (widget.fileObj.fileType.toLowerCase() == "image") {
      // _base64 = base64Decode(widget.filePath);

      (() async {
        http.Response response = await http.get(
          widget.fileObj.attachmentUrl,
        );
        if (mounted) {
          setState(() {
            String profileImage = base64Encode(response.bodyBytes);
            _base64 = base64Decode(profileImage);
          });
        }
      })();
    } else {
      _controller = VideoPlayerController.network(
        // 'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'
        widget.fileObj.attachmentUrl,
      );
      _initializeVideoPlayerFuture = _controller.initialize();

      _controller.setLooping(true);
    }

    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileObj.fileType.toLowerCase() == "audio" ||
        widget.fileObj.fileType.toLowerCase() == "file")
      return loadAudioPlayer();
    else if (widget.fileObj.fileType.toLowerCase() == "video")
      return loadVideo();
    else
      return loadImage();
  }

  Scaffold loadVideo() {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.fileObj.fileName.length == 0
              ? "Video"
              : widget.fileObj.fileName,
          pageId: Constants.PAGE_ID_SMART_NOTE),
      body: Stack(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.fullscreen,
                    //    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (showFullView) {
                        showFullView = false;
                      } else {
                        showFullView = true;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: Center(
                    child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the video.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: Container(
                          height: 40,
                          width: 120,
                          color: Colors.white,
                          child: VideoPlayer(_controller),
                        ),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )),
              ),

              /// Show Banner Ad
              getSivisoftAdWidget(),
            ],
          ),
          showFullView ? fullScreenVideoView() : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: RotatedBox(
          quarterTurns: showFullView ? 1 : 0,
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  Scaffold loadAudioPlayer() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: widget.fileObj.fileName.length == 0
              ? "Audio"
              : widget.fileObj.fileName,
          pageId: Constants.PAGE_ID_SMART_NOTE),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                Center(
                    child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the video.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )),
                Center(
                  child: Container(
                    height: 450.0,
                    width: double.infinity,
                    color: Colors.white,
                    child: _controller.value.isPlaying
                        ? Icon(
                            Icons.stream,
                            color: Colors.blue,
                            size: 200.0,
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: Colors.blue,
                            size: 200.0,
                          ),
                  ),

                  // Image.asset(
                  //   _controller.value.isPlaying
                  //       ? "assets/audio_player_gif.gif"
                  //       : "assets/audio_player_stop.png",
                  //   fit: BoxFit.fitWidth,
                  // ),
                )
              ],
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  Widget loadImage() {
    return Scaffold(
        appBar: CustomAppBar(
            title: widget.fileObj.fileName.length == 0
                ? "Image"
                : widget.fileObj.fileName,
            pageId: Constants.PAGE_ID_SMART_NOTE),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.blue,
                  child: _base64 != null && _base64.length > 0
                      ? Image.memory(
                          _base64,
                          fit: BoxFit.fitWidth,
                          // width: double.maxFinite,
                          // height: double.maxFinite,
                        )
                      : Image.asset(
                          "assets/images/placeholder.png",
                        ),
                ),
                // Image.memory(_base64)
              ),
            ),

            /// Show Banner Ad
            getSivisoftAdWidget(),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) _controller.dispose();
  }

  /// Full Screen chart view
  Widget fullScreenVideoView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColors.transparentBg,
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
            ),
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Center(
                child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: Container(
                      height: 40,
                      width: 120,
                      color: Colors.white,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            )),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                //   color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (showFullView) {
                    showFullView = false;
                  } else {
                    showFullView = true;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
