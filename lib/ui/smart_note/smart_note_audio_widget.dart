import '../../model/smart_notes_model.dart';
import 'package:location/location.dart';
import '../../utils/alert_utils.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'smart_note_audio_player.dart' as player;
import 'package:flutter/material.dart';
import '../../login/colors/color_info.dart';
import '../../utils/constants.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/services.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
// import 'dart:io' as io;
import '../common_views.dart';
import 'dart:io';

typedef VoidCallback = void Function(String filePath, String);

class AudioWidget extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  final VoidCallback callbackForAudioFilePath;
  final Function(String sType) callbackForViewMedia;

  final String audioFilePath;
  final String title;
  final SmartNotesModel smartNotesModel;
  AudioWidget({
    localFileSystem,
    @required this.callbackForAudioFilePath,
    @required this.callbackForViewMedia,
    this.audioFilePath,
    @required this.title,
    @required this.smartNotesModel,
  }) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  String _absolutePathOfAudio;
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  player.PlayerState _playerState = player.PlayerState.stopped;
  player.PlayingRouteState _playingRouteState =
      player.PlayingRouteState.speakers;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  // get _isPlaying => _playerState == PlayerState.playing;
  // get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  get _isPlayingThroughEarpiece =>
      _playingRouteState == player.PlayingRouteState.earpiece;
  final navigatorKey = GlobalKey<NavigatorState>();
  Recording _recording = new Recording();
  bool _isRecording = false;
  bool isRecordOptionTapped = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    if (widget.audioFilePath.length > 0) {
      _absolutePathOfAudio = widget.audioFilePath;
    }
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      audioPlayer.startHeadlessService();
    }
  }

  @override
  void dispose() {
    audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context, //navigatorKey.currentState.overlay.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Loading"),
              ),
            ],
          ),
        );
      },
    );
  }

  void dismissLoading() {
    // Navigator.pop(navigatorKey.currentState.overlay.context);
    Navigator.pop(context);
  }

  void _openFileExplorer() async {
    List<PlatformFile> _paths;

    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.audio,
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
    setState(() {
      if (_paths.length > 0) {
        PlatformFile audioFile = _paths[0];
        _absolutePathOfAudio = audioFile.path;
        debugPrint(audioFile.path);
        if (widget.smartNotesModel != null) {
          widget.smartNotesModel.isAudioRemoved = true;
        }
        widget.callbackForAudioFilePath(
          _absolutePathOfAudio,
          widget.title,
        );
      }
    });
  }

  Future _start() async {
    try {
      bool hasPermission = await AudioRecorder.hasPermissions;
      if (hasPermission) {
        print('Has permission');
        if (_absolutePathOfAudio != null && _absolutePathOfAudio != "") {
          String path = _absolutePathOfAudio;
          final appDocDirectory = await getApplicationDocumentsDirectory();
          print('Has absolute path of audio');
          if (!_absolutePathOfAudio.contains('/')) {
            path = appDocDirectory.path + '/' + _absolutePathOfAudio;
          }
          File file = LocalFileSystem().file(path);
          if (await file.exists()) {
            path = appDocDirectory.path + '/' + _absolutePathOfAudio;
          }
          // if (_doesFilexistsAtPath(path) != null) {
          //   print("Start recording: $path");
          // } else {
          //   path = appDocDirectory.path + '/' + _absolutePathOfAudio + "/" + "1" ;
          // }
          // await AudioRecorder.start(
          //     path: path, audioOutputFormat: AudioOutputFormat.AAC);
          await AudioRecorder.start(audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          print('Has no path');
          //await AudioRecorder.start(audioOutputFormat: AudioOutputFormat.WAV);

          Directory appDocDirectory =
              await getApplicationDocumentsDirectory().then((value) {
            String path = value.path +
                '/' +
                '${DateTime.now().microsecondsSinceEpoch}.aac';
            print('path inner: $value');
            AudioRecorder.start(path: path).then((value) {
              print('recording started inner');
              setState(() {
                _isRecording = true;
              });
            });
          });
          // String path = appDocDirectory.path + '/' + 'testfile.aac';
          // print('path: $path');
          // await AudioRecorder.start(path: path).then((value) {
          //   print('recording started');
          // }).catchError((onError) {
          //   print('RECORD ERROR: ${onError}');
          // }).whenComplete(() {
          //   print('record compltete');
          // });
        }

        bool isRecording = await AudioRecorder.isRecording;
        print('RRRR: $isRecording');
        setState(() {
          _isRecording = isRecording;
          _recording = new Recording(duration: new Duration(), path: "");
        });
      } else {
        showDialog(
            context: context, //navigatorKey.currentState.overlay.context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Microphone Permission'),
                content: Text('You must accept permissions for microphone'),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () async {
                      final permissionResult =
                          await permissions.PermissionHandler()
                              .requestPermissions([
                        permissions.PermissionGroup.microphone,
                        permissions.PermissionGroup.storage
                      ]);
                      if (permissionResult[
                                  permissions.PermissionGroup.microphone] ==
                              permissions.PermissionStatus.granted &&
                          permissionResult[
                                  permissions.PermissionGroup.storage] ==
                              permissions.PermissionStatus.granted) {
                        Navigator.pop(context);
                        _start();
                      }
                    },
                  ),
                ],
              );
            });
        // AlertUtils.showAlertDialog(
        //   context,
        //   "You must accept permissions for microphone",
        //   onChange: () async {
        //     final permissionResult = await permissions.PermissionHandler()
        //         .requestPermissions([
        //       permissions.PermissionGroup.microphone,
        //       permissions.PermissionGroup.storage
        //     ]);
        //     if (permissionResult[permissions.PermissionGroup.microphone] ==
        //             permissions.PermissionStatus.granted &&
        //         permissionResult[permissions.PermissionGroup.storage] ==
        //             permissions.PermissionStatus.granted) {
        //       _start();
        //     }
        //   },
        // );
      }
    } catch (e) {
      //print("ERRR: " + e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    // print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    // print("  File length: ${await file.length()}");
    _isRecording = isRecording;
    isRecordOptionTapped = false;
    setState(() {
      _recording = recording;
    });
    // _controller.text = recording.path;

    // var duration = await audioPlayer.setUrl(recording.path);
    //     print(duration);

    // if(duration is Duration){
    //   _duration = duration as Duration;
    // print(_duration.inMinutes);
    // print(_duration.inSeconds);

    // }else if (duration is double){
    // print(duration);

    // }
    _absolutePathOfAudio = recording.path;
    widget.callbackForAudioFilePath(_absolutePathOfAudio, widget.title);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.smartNotesModel != null &&
        widget.smartNotesModel.isAudioRemoved == false &&
        getMediaURL('audio').length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: CommonViews.getButtonView(
                200.0, "Replace Audio", ColorInfo.APP_RED, ColorInfo.APP_RED),
            onTap: () {
              showAudioSelectPopup(context);
            },
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Image.asset(
                  'assets/images/audio.png',
                  width: 200.0,
                  height: 200.0,
                ),
                CommonViews.getButtonView(200.0, "Play Audio",
                    ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
              ]),
              onTap: () {
                widget.callbackForViewMedia('audio');
              }),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/images/audio.png"),
        InkWell(
          child: CommonViews.getButtonView(
              200.0, "Add Audio", ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
          onTap: () {
            showAudioSelectPopup(context);
          },
        ),
        widget.audioFilePath.length > 0 && isRecordOptionTapped == false
            ? audioPlayerUI()
            : isRecordOptionTapped
                ? recordAudioUI()
                : _absolutePathOfAudio == null
                    ? Container()
                    : audioPlayerUI()
      ],
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

  Future<void> showAudioSelectPopup(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Select Audio From",
              style: TextStyle(
                  fontFamily: Constants.LatoRegular,
                  fontSize: 20.0,
                  color: Color(ColorInfo.APP_GRAY)),
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: CommonViews.getButtonView(200.0, "Record",
                        ColorInfo.APP_GREEN, ColorInfo.APP_GREEN),
                    onTap: () {
                      if (widget.smartNotesModel != null) {
                        widget.smartNotesModel.isAudioRemoved = true;
                      }
                      isRecordOptionTapped = true;
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  new SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: CommonViews.getButtonView(200.0, "Import",
                        ColorInfo.APP_GREEN, ColorInfo.APP_GREEN),
                    onTap: () {
                      isRecordOptionTapped = false;
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

  Widget recordAudioUI() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          RaisedButton(
            onPressed: () {
              if (_isRecording) {
              } else {
                _start();
              }
            },
            child: Text("Start"),
            color: _isRecording ? Colors.grey : Colors.blue,
          ),
          RaisedButton(
            onPressed: () {
              if (_isRecording) {
                _stop();
              }
            },
            child: Text("Stop"),
            color: _isRecording ? Colors.blue : Colors.grey,
          ),
        ])
      ],
    );
  }

  Widget progressBarWidget() {
    return Container(
      width: 120,
      height: 35,
      child: Slider(
        onChanged: (v) {
          final Position = v * _duration.inMilliseconds;
          audioPlayer.seek(Duration(milliseconds: Position.round()));
        },
        inactiveColor: Colors.grey,
        value: 0.1,
      ),
    );
  }

  void audioPlayerCompleted() {
    // print("audioPlayerCompleted");
  }

  Widget audioPlayerUI() {
    return Container(
      child: player.PlayerWidget(
        url: _absolutePathOfAudio,
        audioCompletedCallBack: audioPlayerCompleted,
      ),
    );
  }
}
