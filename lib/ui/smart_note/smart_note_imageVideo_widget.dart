import 'dart:async';
import 'dart:io';
import 'dart:math';
// import 'dart:html';
// import 'dart:io';

import '../../login/colors/color_info.dart';
import '../../model/smart_notes_model.dart';
import '../../ui_utils/text_styles.dart';
import '../../utils/alert_utils.dart';
import '../../utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';
import '../common_views.dart';

typedef VoidCallback = void Function(String filePath, String fileName);

class VideoWidget extends StatefulWidget {
  final Function(String textTitle, String textComments, String fileName)
      callbackForVideoFilePath;
  final Function(String sType) callbackForViewMedia;
  final String videoFilePath;
  final String title;
  final SmartNotesModel smartNotesModel;

  final BuildContext parentContext;
  const VideoWidget(
      {Key key,
      @required this.videoFilePath,
      @required this.callbackForVideoFilePath,
      @required this.callbackForViewMedia,
      @required this.parentContext,
      @required this.title,
      @required this.smartNotesModel})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  String _retrieveDataError;
  bool initialized = false;

  //https://pub.dev/packages/flutter_video_compress/example
  // final _flutterVideoCompress = FlutterVideoCompress();
  final videoTitleTextController = TextEditingController();
  String vFilePath = "";
  final ImagePicker _picker = ImagePicker();

  Future<void> _playVideo(String filePath) async {
    if (filePath != null && mounted) {
      await _disposeVideoController();
      if (kIsWeb) {
        _controller = VideoPlayerController.network(filePath);
      } else {
        _controller = VideoPlayerController.file(File(filePath));
      }

      await _controller.setVolume(1.0);
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    if (_controller != null) {
      await _controller.setVolume(0.0);
    }
    final PickedFile file = await _picker.getVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    if (file != null) {
      vFilePath = file.path;
      if (widget.smartNotesModel != null) {
        widget.smartNotesModel.isVideoRemoved = true;
      }
      widget.callbackForVideoFilePath(
          videoTitleTextController.text, file.path, basename(file.path));
      await _playVideo(file.path);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    videoTitleTextController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_controller != null) {
      await _controller.dispose();
      _controller = null;
    }
  }

  Widget _previewVideo() {
    videoTitleTextController.text =
        widget.title.length > 0 ? widget.title : videoTitleTextController.text;
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      if (widget.videoFilePath.length > 0) {
        _playVideo(widget.videoFilePath);
      } else {
        return emptyStateWidget();
      }
    }
    if (_controller != null) _controller.addListener(_onVideoControllerUpdate);
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          color: Colors.white,
          child: playVieoWidget(),
        ));
  }

  Widget playVieoWidget() {
    if (initialized) {
      return Column(
        children: [
          Text(
            'Max size allowed is 10MB',
            style: TextStyle(color: Colors.red, fontSize: 15.0),
          ),
          videoFileTextFieldWidget(context),
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            ),
          )
        ],
      );
    } else {
      return Container(
        child: CircularProgressIndicator(),
      );
    }
    ;
  }

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != _controller.value.initialized) {
      initialized = _controller.value.initialized;
      setState(() {});
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        await _playVideo(response.file.path);
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: widget.videoFilePath.length > 0 && widget.title.length > 0
              ? _previewVideo()
              : !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                  ? FutureBuilder<void>(
                      future: retrieveLostData(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return emptyStateWidget();
                          case ConnectionState.done:
                            return _previewVideo();
                          default:
                            if (snapshot.hasError) {
                              return emptyStateWidget();
                            } else {
                              return emptyStateWidget();
                            }
                        }
                      },
                    )
                  : (widget.videoFilePath.length > 0
                      ? _previewVideo()
                      : emptyStateWidget())),
    );
  }

  String getMediaFileName(String mediaType) {
    for (int i = 0; i < widget.smartNotesModel.notesData.files.length; i++) {
      FileDetails file = widget.smartNotesModel.notesData.files[i];
      if (file.fileType.toLowerCase() == mediaType) {
        return file.fileName.split('.').first;
      }
    }
    return "Video";
  }

  Widget videoFileTextFieldWidget(context) {
    videoTitleTextController.text =
        widget.title.length > 0 ? widget.title : videoTitleTextController.text;
    return TextField(
      textAlign: TextAlign.center,
      controller: videoTitleTextController,
      decoration: InputDecoration(
          hintText: widget.smartNotesModel != null
              ? getMediaFileName('video')
              : 'Video Title'),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      onChanged: (value) {
        if (vFilePath.length > 0) {
          widget.callbackForVideoFilePath(
              videoTitleTextController.text, vFilePath, basename(vFilePath));
        }
      },
      onEditingComplete: () {
        widget.callbackForVideoFilePath(
            videoTitleTextController.text, vFilePath, basename(vFilePath));

        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  String getMediaURL(String mediaType) {
    for (int i = 0; i < widget.smartNotesModel.notesData.files.length; i++) {
      FileDetails file = widget.smartNotesModel.notesData.files[i];
      if (file.fileType.toLowerCase() == mediaType) {
        return file.attachmentUrl;
      }
    }
    return "";
  }

  Widget emptyStateWidget() {
    if (widget.smartNotesModel != null &&
        widget.smartNotesModel.isVideoRemoved == false &&
        getMediaURL('video').length > 0) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '*Max size allowed is 10MB',
              style: TextStyle(color: Colors.red, fontSize: 15.0),
            ),
            videoFileTextFieldWidget(context),

            SizedBox(height: 20),
            InkWell(
              child: CommonViews.getButtonView(
                  200.0, "Replace Video", ColorInfo.APP_RED, ColorInfo.APP_RED),
              onTap: () {
                openImageVideoPicker(widget.parentContext);
              },
            ),

            SizedBox(
              height: 30,
            ),
            InkWell(
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Image.asset(
                    'assets/images/video.png',
                    width: 200.0,
                    height: 200.0,
                  ),
                  CommonViews.getButtonView(200.0, "Play Video",
                      ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
                ]),
                onTap: () {
                  widget.callbackForViewMedia('video');
                }),

            // Image.asset(
            //   "assets/images/placeholder.png",
            // )
          ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '*Max size allowed is 10MB',
          style: TextStyle(color: Colors.red, fontSize: 15.0),
        ),
        videoFileTextFieldWidget(context),
        SizedBox(height: 20),
        InkWell(
          child: CommonViews.getButtonView(
              200.0, "Add Video", ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
          onTap: () {
            openImageVideoPicker(widget.parentContext);
          },
        ),
        SizedBox(height: 20),
        Image.asset(
          "assets/images/video.png",
          height: 150,
          width: 150,
        ),
      ],
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> openImageVideoPicker(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Select Video From",
              style: TextStyle(
                  fontFamily: Constants.LatoRegular,
                  fontSize: 20.0,
                  color: Color(ColorInfo.APP_GRAY)),
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  // GestureDetector(
                  //   child: CommonViews.getButtonView(200.0, "Camera",
                  //       ColorInfo.APP_GREEN, ColorInfo.APP_GREEN),
                  //   onTap: () {
                  //     _onImageButtonPressed(ImageSource.camera,
                  //         context: context);
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  new SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: CommonViews.getButtonView(200.0, "Gallery",
                        ColorInfo.APP_GREEN, ColorInfo.APP_GREEN),
                    onTap: () {
                      // _onImageButtonPressed(ImageSource.gallery,
                      // context: context);
                      _openFileExplorer();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openFileExplorer() async {
    List<PlatformFile> _paths;

    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        allowedExtensions: null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      // print("Unsupported operation" + e.toString());
    } catch (ex) {
      // print(ex);
    }
    if (!mounted) return;
    // setState(() async {
    if (_paths != null && _paths.length > 0) {
      PlatformFile videoFile = _paths[0];
      debugPrint(videoFile.path);
      vFilePath = videoFile.path;

      //CHeck if file size is greater than 10mb, show popup else upload
// String fileSize = getFileSize(vFilePath, 1);
// String fileSizeNum = fileSize.split(" ").first;
// String fileSizeBytes = fileSize.split(" ").last;
      int fileSize = await _getFileSizeInBytes(vFilePath);
      int tenMB = 10000000;
      if (fileSize < tenMB) {
        if (widget.smartNotesModel != null) {
          widget.smartNotesModel.isVideoRemoved = true;
        }
        setState(() {
          widget.callbackForVideoFilePath(
              videoTitleTextController.text, vFilePath, basename(vFilePath));
          if (videoFile.path != null) {
            _playVideo(videoFile.path);
          }
        });
      } else {
        AlertUtils.showAlertDialog(
            widget.parentContext, "Please select file size less than 10MB");
      }
    }
    // });
  }

  Future<int> _getFileSizeInBytes(String filepath) async {
    var file = File(filepath);
    int bytes = await file.length();
    //1MB = 10000000 bytes

    return bytes;
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
} //end of class

// class AspectRatioVideo extends StatefulWidget {
//   final VoidCallback addVideoCallBack;
//   final VideoPlayerController controller;
//   final String fileName;
//   final OnTitleChangeCallback titleChangeCallback;

//   const AspectRatioVideo({
//     Key key,
//     @required this.fileName,
//     @required this.controller,
//     @required this.addVideoCallBack,
//     @required this.titleChangeCallback,
//   }) : super(key: key);

//   @override
//   AspectRatioVideoState createState() =>
//       AspectRatioVideoState(this.addVideoCallBack);
// }

// class AspectRatioVideoState extends State<AspectRatioVideo> {
//   VideoPlayerController get controller => widget.controller;

//   final VoidCallback addVideoCallBack;

//   AspectRatioVideoState(this.addVideoCallBack);

//   final videoTitleEditTextController = TextEditingController();

//   bool initialized = false;

//   void _onVideoControllerUpdate() {
//     if (!mounted) {
//       return;
//     }
//     if (initialized != controller.value.initialized) {
//       initialized = controller.value.initialized;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     controller.addListener(_onVideoControllerUpdate);
//     videoTitleEditTextController.text = widget.fileName;
//   }

//   @override
//   void dispose() {
//     controller.removeListener(_onVideoControllerUpdate);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (initialized) {
//       return Column(
//         children: [
//           TextField(
//             controller: videoTitleEditTextController,
//             decoration: InputDecoration(hintText: "Change Title"),
//             onChanged: widget.titleChangeCallback,
//           ),
//           InkWell(
//             child: CommonViews.getButtonView(
//                 200.0, "Change Video", ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
//             onTap: () {
//               widget.addVideoCallBack("", "");
//             },
//           ),
//           Stack(
//             children: <Widget>[
//               // Positioned(
//               //   top: 0,
//               //   height: 44,
//               //   left: 20,
//               //   child:
//               // ),
//               Positioned(
//                   top: 100,
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   child:

//                       // FutureBuilder(
//                       //   future: _initializeVideoPlayerFuture,
//                       //   builder: (context, snapshot) {
//                       //     if (snapshot.connectionState == ConnectionState.done) {
//                       // If the VideoPlayerController has finished initialization, use
//                       // the data it provides to limit the aspect ratio of the video.
//                       AspectRatio(
//                     aspectRatio: controller.value.aspectRatio,
//                     // Use the VideoPlayer widget to display the video.
//                     child: VideoPlayer(controller),
//                   )
//                   //     } else {
//                   //       // If the VideoPlayerController is still initializing, show a
//                   //       // loading spinner.
//                   //       return Center(child: CircularProgressIndicator());
//                   //     }
//                   //   },
//                   // )
//                   ),
//               Center(
//                   child: ButtonTheme(
//                       height: 40.0,
//                       minWidth: 40.0,
//                       child: RaisedButton(
//                         padding: EdgeInsets.all(60.0),
//                         color: Colors.transparent,
//                         textColor: Colors.white,
//                         onPressed: () {
//                           // Wrap the play or pause in a call to `setState`. This ensures the
//                           // correct icon is shown.
//                           setState(() {
//                             // If the video is playing, pause it.
//                             if (controller.value.isPlaying) {
//                               controller.pause();
//                             } else {
//                               // If the video is paused, play it.
//                               controller.play();
//                             }
//                           });
//                         },
//                         child: Icon(
//                           controller.value.isPlaying
//                               ? Icons.pause
//                               : Icons.play_arrow,
//                           size: 60.0,
//                         ),
//                       )))
//             ],
//           ),
//         ],
//       );

//       // Center(
//       //   child: AspectRatio(
//       //     aspectRatio: controller.value?.aspectRatio,
//       //     child: VideoPlayer(controller),
//       //   ),
//       // );
//     } else {
//       return Container(
//         child: CircularProgressIndicator(),
//       );
//     }
//   }
// }
