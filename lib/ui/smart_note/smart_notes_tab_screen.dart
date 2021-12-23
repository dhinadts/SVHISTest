import 'dart:convert';
import 'dart:io';
import '../../model/smart_notes_model.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/smart_note/smart_note_file_list_screen.dart';
import '../../ui/smart_note/smart_note_file_show_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../login/colors/color_info.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../repo/common_repository.dart';
import '../../ui/smart_note/smart_note_media_screen.dart';
import '../../ui/user_list/smart_notes_users_check_list.dart';
import '../../ui_utils/icon_utils.dart';
import '../../utils/app_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:share/share.dart';

typedef VoidCallback = void Function(bool isNewNote);

class SmartNotesTabScreen extends StatefulWidget {
  final String currentUserDepartmentName;
  final String currentUserName;
  final VoidCallback callbackForNewNote;
  final SmartNotesModel smartNotesModel;
  SmartNotesTabScreen(
      {@required this.currentUserDepartmentName,
      @required this.callbackForNewNote,
      @required this.currentUserName,
      @required this.smartNotesModel});

  @override
  SmartNotesTabScreenState createState() => SmartNotesTabScreenState();
}

class SmartNotesTabScreenState extends State<SmartNotesTabScreen> {
  Color textColor = Colors.white;
  String imagePath = "", videoPath = "", audioPath = "", textValue = "";
  String imageFileName = "", videoFileName = "", audioFileName = "";
  String fileType;
  TextEditingController tabIndex = TextEditingController();
  String textComment = "";
  String textTitle = "";
  SmartNotesModel tempSmartNotesModel;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    if (widget.smartNotesModel != null) {
      tempSmartNotesModel = widget.smartNotesModel;
      textValue = tempSmartNotesModel.notesData.title;
      textComment = tempSmartNotesModel.notesData.comments;
      textTitle = tempSmartNotesModel.notesData.title;
    }
    super.initState();

    initializeAd();
  }

  Future<void> viewSmartNoteFile(String sType) async {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height - 70,
              // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: SmartNoteFileShowScreen(fileObj: getAttachmentFile(sType)),
            ),
          );
        });
  }

  String getTodayDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat(DateUtils.istDateAndTimeFormat1);
    String formattedDate = formatter.format(now);
    // print(formattedDate); // 2016-01-25
    return formattedDate;
  }

  String getTodayDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(now);
    // print(formattedDate); // 2016-01-25
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
          body: Column(
            children: [
              tempSmartNotesModel != null
                  ? Container(height: 35, color: AppColors.primaryColor)
                  : Container(),
              Container(
                height: 55,
                color: AppColors.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                              tempSmartNotesModel == null
                                  ? "New Smart Note"
                                  : "Edit Smart Note",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(getTodayDateTime(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (tempSmartNotesModel != null)
                          IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 15.0),
                                                child: const Text(
                                                    'Share Smart Note',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                              ),
                                            ),
                                            const Divider(
                                              height: 1,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    child: const Text(
                                                        'Internal Share'),
                                                    onPressed: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => UserCheckList(
                                                                noteId: widget
                                                                    .smartNotesModel
                                                                    .notesId,
                                                                entityName: widget
                                                                    .smartNotesModel
                                                                    .entityName,
                                                                userName: widget
                                                                    .smartNotesModel
                                                                    .userName,
                                                                departmentName: widget
                                                                    .smartNotesModel
                                                                    .departmentName)))),
                                                ElevatedButton(
                                                  child: const Text(
                                                      'External Share'),
                                                  onPressed: () async {
                                                    var fileDetails =
                                                        getAttachmentFile(
                                                            'image');

                                                    var imageURL =
                                                        fileDetails != null
                                                            ? fileDetails
                                                                .attachmentUrl
                                                            : null;
                                                    fileDetails =
                                                        getAttachmentFile(
                                                            'video');

                                                    var videoUrl =
                                                        fileDetails != null
                                                            ? fileDetails
                                                                .attachmentUrl
                                                            : null;

                                                    fileDetails =
                                                        getAttachmentFile(
                                                            'audio');

                                                    var audioURL =
                                                        fileDetails != null
                                                            ? fileDetails
                                                                .attachmentUrl
                                                            : null;
                                                    String shareText =
                                                        "$textTitle\n$textComment";
                                                    if (imageURL != null)
                                                      shareText +=
                                                          "\n\nImage\n$imageURL";
                                                    if (videoUrl != null)
                                                      shareText +=
                                                          "\n\nVideo\n$videoUrl";
                                                    if (audioURL != null)
                                                      shareText +=
                                                          "\n\nAudio\n$audioURL";

                                                    Share.share(shareText);
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              color: Colors.white),
                        IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SmartNotesMediaScreen(
                  callbackForAudioFilePath:
                      (String text, String value, String fileName) {
                    audioPath = value;
                    audioFileName = fileName;
                    // textValue = text;
                    // textTitle = text;
                    // print("=================> Text Title  $textValue");
                  },
                  callbackForReminderTextValue:
                      (String titleText, String textComments, String fileName) {
                    // print(tempSmartNotesModel.notesData.title);
                    // print("=================> Text Title  $textValue");
                    textTitle = titleText;
                    textComment = textComments;
                    textValue = titleText;
                  },
                  callbackForImageFilePath:
                      (String text, String value, String fileName) {
                    imagePath = value;
                    imageFileName = fileName;
                    // textValue = text;
                    // textTitle = text;
                    // print("=================> Text Title $text  $textValue");
                  },
                  callbackForVideoFilePath:
                      (String text, String value, String fileName) {
                    videoPath = value;
                    videoFileName = fileName;
                    // textValue = text;
                    // textTitle = text;
                    // textValue = text;
                    // print("=================> Text Title  $textValue");
                  },
                  tabIndex: tabIndex,
                  smartNotesModel: tempSmartNotesModel,
                  callbackForViewMedia: (String smartNoteType) {
                    viewSmartNoteFile(smartNoteType);
                  },
                ),
              ),
              getSivisoftAdWidget(),
              Container(
                height: 50,
                color: Colors.red,
              ),
            ],
          ),
          bottomSheet: Container(
            color: Colors.transparent,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                tempSmartNotesModel != null
                    ? bottomButton("Update")
                    : bottomButton("Save"),
              ],
            ),
          ),
        ));
  }

  void showToastForEmptyTitle(String message) {
    Fluttertoast.showToast(
        timeInSecForIosWeb: 5,
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP);
  }

  Widget bottomButton(String title) {
    return InkWell(
        onTap: () {
          print(textValue);
          switch (title) {
            case "Save":
              textValue.length == 0
                  ? showToastForEmptyTitle("Please add title")
                  : apiCallForSaveAction();
              break;
            case "Update":
              textValue.length == 0
                  ? showToastForEmptyTitle("Please add title")
                  : apiCallForUpdateAction();
              break;
            case "Close":
              break;
            case "Share":
              break;
            default:
          }
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                ),
                color: Color(ColorInfo.APP_BLUE)),
            width: 150,
            height: 45,
            //  color: Color(ColorInfo.APP_BLUE),

            child: Center(
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )))));
  }

  Future apiCallForSaveAction() async {
    CustomProgressLoader.showLoader(context);

    // Future uploadmultipleimage(String filename, String severUrl) async {
    NotesData notesData = NotesData(textComment, [], textTitle);
    if (tabIndex.text == '0') {
      fileType = 'title';
    } else if (tabIndex.text == '1') {
      fileType = 'image';
    } else if (tabIndex.text == '2') {
      fileType = 'video';
    } else if (tabIndex.text == '3') {
      fileType = 'audio';
    }
    Map<String, dynamic> map = {
      'comments': notesData.comments,
      'files': [],
      'title': notesData.title
    };
    String notesDataJson = jsonEncode(map);
    // print('notesData $notesDataJson');
    Notes notes = Notes(widget.currentUserDepartmentName,
        widget.currentUserName, "Report", "", "type", notesDataJson);

    Map<String, dynamic> notesMap = {
      'departmentName': notes.departmentName,
      'userName': notes.userName,
      'entityName': notes.entityName,
      'notesId': notes.notesId,
      'notesType': notes.notesType,
      'notesData': map
    };
    String notesJson = jsonEncode(notesMap);

    String url = WebserviceConstants.baseNotesURL +
        "/departments/${widget.currentUserDepartmentName}/notes";
    // print(url);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);
    request.fields['notes'] = notesJson;
    request.fields['reportDates'] = getTodayDate();
    request.fields['tenant'] = AppPreferences().tenant;
    request.fields['username'] = widget.currentUserName;
    List<String> filePaths = [];
    List<String> fileNames = [];

    if (imagePath.length > 0) {
      filePaths.add(imagePath);
      File fileObj = File(imagePath.toString());
      String fileExtension = fileObj.path.split('.').last;
      String imgFileName = imageFileName.length > 0
          ? imageFileName + "." + fileExtension
          : fileObj.path.split('/').last;

      fileNames.add(imgFileName);
    }
//
    if (videoPath.length > 0) {
      filePaths.add(videoPath);
      File fileObj = File(videoPath.toString());
      fileNames.add(videoFileName.length > 0
          ? videoFileName + "." + fileObj.path.split('.').last
          : fileObj.path.split('/').last);
    }

    if (audioPath.length > 0) {
      filePaths.add(audioPath);
      File fileObj = File(audioPath.toString());
      fileNames.add(audioFileName.length > 0
          ? audioFileName + "." + fileObj.path.split('.').last
          : fileObj.path.split('/').last);
    }

    if (filePaths.length > 0) {
      for (int i = 0; i < filePaths.length; i++) {
        File fileObj = File(filePaths[i].toString());
        String fileName = fileNames[i].replaceAll(" ", "");
        var multipartFile = new http.MultipartFile(
          'attachments',
          http.ByteStream(fileObj.openRead()).cast(),
          await fileObj.length(),
          filename: fileName,
        );
        request.files.add(multipartFile);
      }
    }

    http.StreamedResponse response;
    int statusCode;
    try {
      response = await request.send();
      debugPrint("$response");
      final responseString = await response.stream.bytesToString();
      CustomProgressLoader.cancelLoader(context);
      debugPrint("$responseString");
      debugPrint("status code - ${response.statusCode}");
      statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        widget.callbackForNewNote(true);
        Navigator.pop(context);
      }
    } catch (e) {
      CustomProgressLoader.cancelLoader(context);
      // showToastForEmptyTitle("Please try again after sometime");
    }
    return statusCode;
  }

  FileDetails getAttachmentFile(String mediaType) {
    print(widget.smartNotesModel.notesData.files.length);
    for (int i = 0; i < widget.smartNotesModel.notesData.files.length; i++) {
      FileDetails file = widget.smartNotesModel.notesData.files[i];
      print(file.fileType);
      print(mediaType);
      if (file.fileType.toLowerCase() == mediaType) {
        print(mediaType);
        return file;
      }
    }
    return null;
  }

  Future apiCallForUpdateAction() async {
    CustomProgressLoader.showLoader(context);

    // Future uploadmultipleimage(String filename, String severUrl) async {
    NotesData notesData = NotesData(textComment, [], textTitle);
    if (tabIndex.text == '0') {
      fileType = 'title';
    } else if (tabIndex.text == '1') {
      fileType = 'image';
    } else if (tabIndex.text == '2') {
      fileType = 'video';
    } else if (tabIndex.text == '3') {
      fileType = 'audio';
    }

    List<Map> attachmentObjs = [];
    if (tempSmartNotesModel.isImageRemoved == true) {
      FileDetails fileObj = getAttachmentFile('image');
      String fileObjString = jsonEncode(fileObj);
      Map<String, dynamic> map = jsonDecode(fileObjString);
      attachmentObjs.add(map);
    }

    if (tempSmartNotesModel.isVideoRemoved == true) {
      FileDetails fileObj = getAttachmentFile('video');
      String fileObjString = jsonEncode(fileObj);
      Map<String, dynamic> map = jsonDecode(fileObjString);
      attachmentObjs.add(map);
    }

    if (tempSmartNotesModel.isAudioRemoved == true) {
      FileDetails fileObj = getAttachmentFile('audio');
      String fileObjString = jsonEncode(fileObj);
      Map<String, dynamic> map = jsonDecode(fileObjString);
      attachmentObjs.add(map);
    }

    Map<String, dynamic> map = {
      'comments': notesData.comments,
      'files': attachmentObjs,
      'title': notesData.title
    };

    Map<String, dynamic> notesMap = {
      'departmentName': tempSmartNotesModel.departmentName,
      'userName': tempSmartNotesModel.userName,
      'entityName': tempSmartNotesModel.entityName,
      'notesId': tempSmartNotesModel.notesId,
      'notesType': tempSmartNotesModel.notesType,
      'notesData': map
    };
    String notesJson = jsonEncode(notesMap);
/*

https://qa.servicedx.com/notes/departments/GNAT/users/GNAT/entities/Report/notes/d09a6185-9ee7-4943-b14e-f0f2668228e5?notes=%7B%22departmentName%22%3A%22GNAT%22%2C%22userName%22%3A%22GNAT%22%2C%22entityName%22%3A%22Report%22%2C%22notesId%22%3A%22d09a6185-9ee7-4943-b14e-f0f2668228e5%22%2C%22notesType%22%3A%22type%22%2C%22notesData%22%3A%7B%22comments%22%3A%22%22%2C%22files%22%3A%5B%5D%2C%22title%22%3A%22%22%7D%7D
/departments/{department_name}/users/{user_name}/entities/{entity_name}/notes/{notes_id}

 */
    String entityName = tempSmartNotesModel.entityName;
    String notesId = tempSmartNotesModel.notesId;
    String url = WebserviceConstants.baseNotesURL +
        "/departments/${widget.currentUserDepartmentName}/users/${tempSmartNotesModel.userName}/entities/" +
        entityName +
        "/notes/" +
        notesId;
    print(url); //"https://qa.servicedx.com/notes/departments/GNAT/notes"
    debugPrint(url);
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.multipartForm);
    request.headers.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);
    request.fields['notes'] = notesJson;
    request.fields['reportDates'] = getTodayDate();
    request.fields['tenant'] = AppPreferences().tenant;
    request.fields['username'] = widget.currentUserName;
    List<String> filePaths = [];
    List<String> fileNames = [];

    if (imagePath.length > 0) {
      filePaths.add(imagePath);
      File fileObj = File(imagePath.toString());
      String fileExtension = fileObj.path.split('.').last;
      String imgFileName = imageFileName.length > 0
          ? imageFileName + "." + fileExtension
          : fileObj.path.split('/').last;

      fileNames.add(imgFileName);
    }
//
    if (videoPath.length > 0) {
      filePaths.add(videoPath);
      File fileObj = File(videoPath.toString());
      fileNames.add(videoFileName.length > 0
          ? videoFileName + "." + fileObj.path.split('.').last
          : fileObj.path.split('/').last);
    }

    if (audioPath.length > 0) {
      filePaths.add(audioPath);
      File fileObj = File(audioPath.toString());
      fileNames.add(audioFileName.length > 0
          ? audioFileName + "." + fileObj.path.split('.').last
          : fileObj.path.split('/').last);
    }

    if (filePaths.length > 0) {
      for (int i = 0; i < filePaths.length; i++) {
        File fileObj = File(filePaths[i].toString());
        String fileName = fileNames[i].replaceAll(" ", "");
        var multipartFile = new http.MultipartFile(
          'attachments',
          http.ByteStream(fileObj.openRead()).cast(),
          await fileObj.length(),
          filename: fileName,
        );
        request.files.add(multipartFile);
      }
    }

    http.StreamedResponse response;
    int statusCode;
    try {
      response = await request.send();
      debugPrint("$response");
      final responseString = await response.stream.bytesToString();
      CustomProgressLoader.cancelLoader(context);
      debugPrint("$responseString");
      debugPrint("status code - ${response.statusCode}");
      statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        widget.callbackForNewNote(true);
        Navigator.pop(context);
      }
    } catch (e) {
      CustomProgressLoader.cancelLoader(context);
      // showToastForEmptyTitle("Please try again after sometime");
    }
    return statusCode;
  }
}

class Notes {
  Notes(this.departmentName, this.userName, this.entityName, this.notesId,
      this.notesType, this.notesdata);
  final String departmentName;
  final String userName;
  final String entityName;
  final String notesId;
  final String notesType;
  final String notesdata;
}

class NotesData {
  NotesData(this.comments, this.files, this.title);
  final String comments;
  final List files;
  final String title;
}
