import 'dart:convert';
import 'dart:io';
import '../../model/passing_arg.dart';
import '../../model/smart_notes_model.dart';
import '../../model/smart_notes_model.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import '../../login/colors/color_info.dart';
import '../../utils/constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'smart_note_audio_widget.dart';
import '../common_views.dart';
import 'smart_note_imageVideo_widget.dart';
import 'package:path/path.dart';
//https://stackoverflow.com/questions/49125191/how-to-upload-images-and-file-to-a-server-in-flutter
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

typedef VoidCallback = Function(String value, String fileName);

class SmartNotesMediaScreen extends StatefulWidget {
  final Function(String textTitle, String textComments, String fileName)
      callbackForVideoFilePath;
  final Function(String textTitle, String textComments, String fileName)
      callbackForAudioFilePath;
  final Function(String textTitle, String textComments, String fileName)
      callbackForImageFilePath;
  final Function(String textTitle, String textComments, String fileName)
      callbackForReminderTextValue;

  final Function(String smartNoteType) callbackForViewMedia;
  final TextEditingController tabIndex;
  final SmartNotesModel smartNotesModel;

  SmartNotesMediaScreen({
    @required this.callbackForVideoFilePath,
    @required this.callbackForAudioFilePath,
    @required this.callbackForImageFilePath,
    @required this.callbackForReminderTextValue,
    @required this.callbackForViewMedia,
    @required this.smartNotesModel,
    this.tabIndex,
  });

  @override
  SmartNotesMediaScreenState createState() => SmartNotesMediaScreenState();
}

class SmartNotesMediaScreenState extends State<SmartNotesMediaScreen> {
  File _userImageFile, globalFile;
  String videoFilePath = "";
  final textTitleController = TextEditingController();
  final textValueController = TextEditingController();
  final imageTitleTextController = TextEditingController();
  final audioTitleTextController = TextEditingController();
  String audioFilePath = "";
  String imageFilePath = "";
  String videoTitle = "";
  String audioTitle = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textTitleController.dispose();
    imageTitleTextController.dispose();
    audioTitleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: VerticalTabs(
                  disabledChangePageFromContentView: true,
                  tabsWidth: 50,
                  tabsElevation: 10,
                  tabs: <Tab>[
                    tabWidget("Title", Icons.edit),
                    tabWidget("Image", Icons.photo_library),
                    tabWidget("Video", Icons.music_video),
                    tabWidget("Audio", Icons.audiotrack),
                  ],
                  contents: <Widget>[
                    textContents(context),
                    imageContents(context),
                    videoContents(context),
                    audioContents(context),
                    // webEmailContents(),
                    // contactsContents()
                  ],
                  onSelect: (int tabValue) {
                    // print('tabValue = $tabValue');
                    widget.tabIndex.text = tabValue.toString();
                    if (tabValue == 2 && videoFilePath.length > 0) {
                      setState(() {});
                      videoContents(context);
                    } else if (tabValue == 3 && audioFilePath.length > 0) {
                      setState(() {});
                      audioContents(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabWidget(String title, IconData icon) {
    return Tab(
        child: Column(
      children: [
        SizedBox(height: 10),
        Icon(icon, color: Color(ColorInfo.APP_BLUE)),
        Text(
          title,
          style: TextStyle(fontSize: 11, color: Color(ColorInfo.APP_BLUE)),
        ),
        SizedBox(
          height: 10,
        )
      ],
    ));
  }

  Widget textContents(context) {
    if (widget.smartNotesModel != null) {
      textTitleController.text = widget.smartNotesModel.notesData.title;
      textValueController.text = widget.smartNotesModel.notesData.comments;
    }
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        padding: EdgeInsets.all(15),
        color: Colors.transparent,
        child: Column(
          children: [
            TextField(
              controller: textTitleController,
              decoration: InputDecoration(
                  hintText: widget.smartNotesModel != null
                      ? widget.smartNotesModel.notesData.title
                      : 'Please enter title'),
              keyboardType: TextInputType.multiline,
              //textInputAction: TextInputAction.done,
              maxLines: null,
              onChanged: (value) {
                if (widget.smartNotesModel != null) {
                  widget.smartNotesModel.notesData.title =
                      textTitleController.text;
                }
                widget.callbackForReminderTextValue(
                    textTitleController.text, textValueController.text, "");
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: textValueController,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                labelText: "Enter Text",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                if (widget.smartNotesModel != null) {
                  widget.smartNotesModel.notesData.comments =
                      textValueController.text;
                }
                widget.callbackForReminderTextValue(
                    textTitleController.text, textValueController.text, "");
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
            )
          ],
        ),
      ),
    );
  }

  checkAndFillTitleForMedia(fname, title) {
    if (title.isEmpty) {
      return fname;
    } else {
      return title;
    }
  }

  Widget imageContents(context) {
    // imageTitleTextController.text =  widget.smartNotesModel != null ? getMediaFileName("image") : "";

    if (widget.smartNotesModel != null) {
      imageTitleTextController.text = getMediaFileName("image");
    }
    return Container(
      // color: Colors.blueGrey,
      child: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            textAlign: TextAlign.center,
            controller: imageTitleTextController,
            decoration: InputDecoration(
                hintText: widget.smartNotesModel != null
                    ? getMediaFileName("image")
                    : 'Image Title'),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            onChanged: (value) {
              if (imageFilePath.length > 0) {
                widget.callbackForImageFilePath(
                    imageTitleTextController.text,
                    imageFilePath,
                    checkAndFillTitleForMedia(basename(imageFilePath),
                        imageTitleTextController.text));
              }
            },
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          ),
          widget.smartNotesModel != null &&
                  widget.smartNotesModel.isImageRemoved == false &&
                  getMediaURL('image').length > 0
              ? Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
                  child: Center(
                    child: Column(children: [
                      InkWell(
                          child: CommonViews.getButtonView(
                              200.0,
                              "Replace Image",
                              ColorInfo.APP_RED,
                              ColorInfo.APP_RED),
                          onTap: () {
                            openImagePicker(context);
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                          child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/placeholder.png',
                                  width: 200.0,
                                  height: 200.0,
                                ),
                                CommonViews.getButtonView(200.0, "View Image",
                                    ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
                              ]),
                          onTap: () {
                            widget.callbackForViewMedia('image');
                            //   Navigator.pushNamed(context, Routes.smartNoteFileShowScreen,
                            // arguments: Args(
                            //     smartNoteAttachment: getAttachmentFile('image'),
                            //     smartNoteFileType: widget.smartNotesModel.notesData.comments));
                          }),
                    ]),
                  ))
              : Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
                  child: Center(
                    child: InkWell(
                      child:
                          // widget.smartNotesModel != null && widget.smartNotesModel.isImageRemoved == true && _userImageFile == null
                          //     ? smartNoteEditImage()
                          //     :
                          _userImageFile != null
                              ? Image.file(
                                  _userImageFile,
                                  fit: BoxFit.fill,
                                )
                              : CommonViews.getButtonView(200.0, "Add Image",
                                  ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
                      onTap: () {
                        openImagePicker(context);
                      },
                    ),
                  ),
                )
        ],
      )),
    );
  }

  Widget smartNoteEditImage() {
    Uint8List _base64;
    (() async {
      http.Response response = await http.get(getMediaURL('image'));
      if (mounted) {
        setState(() {
          String profileImage = base64Encode(response.bodyBytes);
          _base64 = base64Decode(profileImage);

          return Image.memory(
            _base64,
            fit: BoxFit.fitWidth,
            // width: double.maxFinite,
            // height: double.maxFinite,
          );
        });
      }
    })();
    return Image.asset(
      "assets/images/placeholder.png",
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

  String getMediaFileName(String mediaType) {
    for (int i = 0; i < widget.smartNotesModel.notesData.files.length; i++) {
      FileDetails file = widget.smartNotesModel.notesData.files[i];
      if (file.fileType.toLowerCase() == mediaType) {
        return file.fileName.split('.').first;
      }
    }
    return "Image";
  }

  FileDetails getAttachmentFile(String mediaType) {
    for (int i = 0; i < widget.smartNotesModel.notesData.files.length; i++) {
      FileDetails file = widget.smartNotesModel.notesData.files[i];
      if (file.fileType.toLowerCase() == mediaType) {
        return file;
      }
    }
    return null;
  }

  Widget videoContents(BuildContext buildContext) {
    return VideoWidget(
      callbackForVideoFilePath:
          (String title, String filePath, String fileName) {
        videoFilePath = filePath;
        videoTitle = title;
        widget.callbackForVideoFilePath(
            title, filePath, checkAndFillTitleForMedia(fileName, title));
      },
      videoFilePath: videoFilePath,
      parentContext: buildContext,
      title: videoTitle,
      smartNotesModel: widget.smartNotesModel,
      callbackForViewMedia: (String sType) {
        widget.callbackForViewMedia(sType);
      },
    );
  }

  Widget audioContents(context) {
    audioTitleTextController.text =
        audioTitle.length > 0 ? audioTitle : audioTitleTextController.text;
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        TextField(
          textAlign: TextAlign.center,
          controller: audioTitleTextController,
          decoration: InputDecoration(
              hintText: widget.smartNotesModel != null
                  ? getMediaFileName("audio")
                  : 'Audio Title'),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 1,
          onChanged: (value) {
            if (audioFilePath.length > 0) {
              widget.callbackForAudioFilePath(
                  audioTitleTextController.text,
                  audioFilePath,
                  checkAndFillTitleForMedia(
                      basename(audioFilePath), audioTitleTextController.text));
            }
          },
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (audioTitleTextController.text.length > 0) {
              widget.callbackForAudioFilePath(
                  audioTitleTextController.text,
                  audioFilePath,
                  checkAndFillTitleForMedia(
                      basename(audioFilePath), audioTitleTextController.text));
            }
          },
        ),
        Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
            child: AudioWidget(
              audioFilePath: audioFilePath,
              callbackForAudioFilePath: (value, title) {
                audioFilePath = value;
                audioTitle = title;
                widget.callbackForAudioFilePath(
                    audioTitleTextController.text,
                    value,
                    checkAndFillTitleForMedia(basename(audioFilePath),
                        audioTitleTextController.text));
              },
              title: audioTitle,
              smartNotesModel: widget.smartNotesModel,
              callbackForViewMedia: (String sType) {
                widget.callbackForViewMedia(sType);
              },
            ))
      ])),
    );
  }

  Widget webEmailContents() {
    return Container(
      color: Colors.transparent,
    );
  }

  Widget contactsContents() {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: InkWell(
          child: CommonViews.getButtonView(
              200.0, "Add Contacts", ColorInfo.APP_GREEN, ColorInfo.APP_BLUE),
          onTap: () {},
        ),
      ),
    );
  }

//MARK: Image Media
  Future<void> openImagePicker(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              " Select Image From",
              style: TextStyle(
                  fontFamily: Constants.LatoRegular,
                  fontSize: 20.0,
                  color: Color(ColorInfo.APP_GRAY)),
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: CommonViews.getButtonView(200.0, "Camera",
                        ColorInfo.APP_GREEN, ColorInfo.APP_GREEN),
                    onTap: () {
                      openCamera();
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
                    child: CommonViews.getButtonView(200.0, "Gallery",
                        ColorInfo.APP_GREEN, ColorInfo.APP_GREEN),
                    onTap: () {
                      openGallery();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future openGallery() async {
    _userImageFile = null;
    globalFile = null;
    final pickedFile =
        (await ImagePicker().getImage(source: ImageSource.gallery));
    _userImageFile = File(pickedFile.path);
    Directory tempDir = await getTemporaryDirectory();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now);

    String tempPath = tempDir.path + "/" + formattedDate.toString() + ".jpeg";
    globalFile = await FlutterImageCompress.compressAndGetFile(
      _userImageFile.absolute.path, tempPath,
      quality: 75,
      //rotate: 180,
    );
    imageFilePath = tempPath;
    if (widget.smartNotesModel != null) {
      widget.smartNotesModel.isImageRemoved = true;
    }

    widget.callbackForImageFilePath(
        imageTitleTextController.text,
        tempPath,
        checkAndFillTitleForMedia(
            basename(tempPath), imageTitleTextController.text));
    setState(() {});
  }

  Future openCamera() async {
    _userImageFile = null;
    globalFile = null;
    final pickedFile =
        (await ImagePicker().getImage(source: ImageSource.camera));
    _userImageFile = File(pickedFile.path);

    Directory tempDir = await getTemporaryDirectory();
    var date = new DateTime.now();
    String tempPath = tempDir.path + "/" + date.toString() + ".jpeg";
    String f = tempPath.substring(1);
    String trimPathString = f.replaceAll(" ", "");

    globalFile = await FlutterImageCompress.compressAndGetFile(
      _userImageFile.absolute.path,
      trimPathString,
      quality: 75,
    );
    imageFilePath = trimPathString;
    if (widget.smartNotesModel != null) {
      widget.smartNotesModel.isImageRemoved = true;
    }

    widget.callbackForImageFilePath(
        imageTitleTextController.text,
        trimPathString,
        checkAndFillTitleForMedia(basename(trimPathString),
            imageTitleTextController.text)); // 'artlang'

    setState(() {});
  }
}
