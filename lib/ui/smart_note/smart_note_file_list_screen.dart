import 'dart:convert';

import '../../login/utils/custom_progress_dialog.dart';
import '../../model/passing_arg.dart';
import '../../model/smart_note_edit_arg.dart';
import '../../model/smart_notes_model.dart';
import '../custom_drawer/navigation_home_screen.dart';
import 'smart_notes_tab_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';
import '../../ui_utils/widget_styles.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/widgets/stack.dart' as pdf;
import '../../ui_utils/app_colors.dart';
import '../../repo/common_repository.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../utils/constants.dart';
import '../../widgets/loading_widget.dart';
import '../custom_drawer/custom_app_bar.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmartNoteFileListScreen extends StatefulWidget {
  final String title;
  const SmartNoteFileListScreen({Key key, this.title = "Smart Notes"})
      : super(key: key);
  @override
  SmartNoteFileListScreenState createState() => SmartNoteFileListScreenState();
}

List<SmartNotesModel> modifiedorderG = [];

class SmartNoteFileListScreenState extends State<SmartNoteFileListScreen> {
  List<SmartNotesModel> smartNotesFileList = List();
  List<SmartNotesModel> localBackup = List();
  List<SmartNotesModel> localBackup1 = List();
  List<NotesAttachment> notesAttachments = List();

  bool isDataLoaded = false;
  WebserviceHelper helper = WebserviceHelper();
  FocusNode focusNode = FocusNode();
  var controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey(); // backing data
  int removeIndex = -1;
  double popupMenuItemHeight = 40;
  int selectedSearchOption = 0;
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var dummylist;
  List dummy = [];
  bool pinThis = false;
  int itemToBePinned;
  int pinnedCount = 0;
  bool setLoader = false;
  bool changeIcon = false;
  ScrollController _scrollController;
  String service = "";
  var searchLabel = "Search by Title";
  // var searchLabel = "Search by Title/Date";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: AppColors.borderShadow,
        /* appBar: CustomAppBar(
            title: widget.title, pageId: Constants.PAGE_ID_SMART_NOTE), */
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          actions: [
            pinThis
                ? IconButton(
                    onPressed: () {
                      doPin(itemToBePinned);
                    },
                    icon:
                        /* changeIcon
                        ? Icon(Icons.push_pin_outlined, size: 20,)
                        :  */
                        FaIcon(FontAwesomeIcons.thumbtack, size: 18),
                  )
                : SizedBox.shrink(),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen(
                              drawerIndex: Constants.PAGE_ID_HOME,
                            )),
                    ModalRoute.withName(Routes.navigatorHomeScreen));
              },
            )
          ],
        ),
        body: Container(
            //decoration: BoxDecoration(boxShadow: WidgetStyles.cardBoxShadow),
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            //DATE and NAME related search
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUIDimens.paddingSmall),
                            child: TextFormField(
                              focusNode: focusNode,
                              validator: (value) {
                                if (value.length > 0 && value.length < 2) {
                                  return "Search string must be 2 characters";
                                } else if (value.length == 0) {
                                  Fluttertoast.showToast(
                                      msg: "Please enter text",
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 5,
                                      gravity: ToastGravity.TOP);
                                }
                              },
                              onChanged: (data) {
                                if (data.length == 0) {
                                  // setState(() {
                                  //   smartNotesFileList = localBackup1;
                                  // });
                                  print("9876543210.0123456789");
                                  smartNotesFileList.clear();
                                  // searchLabel = "Search by Title";
                                  fetchUserSmartNoteFiles();
                                  // _filter(data);
                                }
                              },
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: searchLabel,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.blueGrey,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              // setState(() {
                              //   localBackup = smartNotesFileList;
                              // });
                              // localBackup = smartNotesFileList;
                              _filter(controller.text);
                            }
                          },
                        ),
                      ),
                    ),
                    getSearchPopup(),
                  ],
                ),
              ),
            ),
            Text(""),
            if (!(isDataLoaded && smartNotesFileList.length == 0))
              userTitleText(),
            Expanded(
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: smartNotesFileList.length > 0 // && setLoader
                        ? animatedListViewBuilderItem()
                        : Padding(
                            padding:
                                EdgeInsets.only(top: AppUIDimens.paddingMedium),
                            child: (isDataLoaded &&
                                    smartNotesFileList.length == 0 &&
                                    service == "")
                                ? Text("No data available")
                                : service != ""
                                    ? Text("Service Temporarily Unavailable")
                                    : ListLoading(
                                        avoidPadding: true,
                                      )))),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openSmartNoteScreen(null);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
        ));
  }

  Future<void> openSmartNoteScreen(SmartNotesModel smartNotesModel) async {
    String userName = await AppPreferences.getUsername();

    String deptName = await AppPreferences.getDeptName();

    if (smartNotesModel != null) {
      //Make all bool value false
      smartNotesModel.isVideoRemoved = false;
      smartNotesModel.isImageRemoved = false;
      smartNotesModel.isAudioRemoved = false;
    }

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
              child: SmartNotesTabScreen(
                currentUserDepartmentName: deptName,
                callbackForNewNote: (bool isNewNote) {
                  if (isNewNote) {
                    fetchUserSmartNoteFiles();
                    if (smartNotesModel == null) {
                      if (smartNotesFileList.length > 0) {
                        _listKey.currentState
                            .insertItem(smartNotesFileList.length);
                      }
                    }
                  }
                },
                currentUserName: userName,
                smartNotesModel: smartNotesModel,
              ),
            ),
          );
        });
  }

  Future<void> navigateToSmartNoteEdit(SmartNotesModel smartNotesModel) async {
    String userName = await AppPreferences.getUsername();

    String deptName = await AppPreferences.getDeptName();

    if (smartNotesModel != null) {
      //Make all bool value false
      smartNotesModel.isVideoRemoved = false;
      smartNotesModel.isImageRemoved = false;
      smartNotesModel.isAudioRemoved = false;
    }

    Navigator.pushNamed(context, Routes.smartNoteEditScreen,
        arguments: SmartNoteEditArg(
            currentUserDepartmentName: deptName,
            currentUserName: userName,
            smartNotesModel: smartNotesModel,
            callbackForNewNote: (bool isNewNote) {
              if (isNewNote) {
                fetchUserSmartNoteFiles();
              }
            }));
  }

  Future<void> navigateToEditSmartNoteScreen(
      SmartNotesModel smartNotesModel) async {
    String userName = await AppPreferences.getUsername();

    String deptName = await AppPreferences.getDeptName();

    SmartNotesTabScreen(
      currentUserDepartmentName: deptName,
      callbackForNewNote: (bool isNewNote) {
        if (isNewNote) {
          fetchUserSmartNoteFiles();
        }
      },
      currentUserName: userName,
      smartNotesModel: smartNotesModel,
    );
  }

  void showDeleteAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are you sure you want to delete?",
            style: TextStyle(fontSize: 15.0, fontFamily: "customRegular"),
          ),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
                  style: new TextStyle(fontFamily: "customRegular")),
              onPressed: () {
                print("removeIndex");
                print(removeIndex);
                Navigator.of(context).pop(true);
                deleteNoteAPICall(smartNotesFileList[removeIndex]);
                // smartNotesFileList.removeAt(removeIndex);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: new TextStyle(fontFamily: "customRegular"),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void showFileDeleteAlert(
      SmartNotesModel smartNotesModel, FileDetails fileDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are you sure you want to delete the attachment?",
            style: TextStyle(fontSize: 15.0, fontFamily: "customRegular"),
          ),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
                  style: new TextStyle(fontFamily: "customRegular")),
              onPressed: () {
                Navigator.of(context).pop(true);

                // Future.delayed(Duration(seconds: 2), () async {
                deleteNoteFileAPICall(smartNotesModel, fileDetails);
                // });
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: new TextStyle(fontFamily: "customRegular"),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _removeSingleItems() {
    if (removeIndex > -1) {
      smartNotesFileList.removeAt(removeIndex);

      localBackup1 = smartNotesFileList;
      print("testing deletion");
      print(removeIndex);

      // This builder is just so that the animation has something
      // to work with before it disappears from view since the
      // original has already been deleted.
      // AnimatedListRemovedItemBuilder builder = (context, animation) {
      //   // A method to build the Card widget.
      //   return buildItem(removeIndex);
      // };
      // _listKey.currentState.removeItem(removeIndex, builder,
      //     duration: Duration(milliseconds: 100));
      setState(() {});
    }
  }

  Future<void> doPin(int i) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Smartnotes')
        .document(AppPreferences().username)
        .collection("userName")
        .getDocuments();
    var dummylist = querySnapshot.documents.map((doc) => doc.data).toList();
    // if (dummylist.length < 4) {

    setState(() {
      // if (pinnedCount < 3) {
      smartNotesFileList[i].pinned = !smartNotesFileList[i].pinned;
      pinThis = !pinThis;

      if (smartNotesFileList[i].pinned) {
        if (dummylist.length < 3) {
          final CollectionReference smartNotesCollection = Firestore.instance
              .collection('Smartnotes')
              .document(AppPreferences().username)
              .collection("userName");

          smartNotesCollection.add({
            'notesID': smartNotesFileList[i].notesId,
          });

          pinnedCount = pinnedCount + 1;
        } else {
          smartNotesFileList[i].pinned = false;
          showDialog(
              context: context,
              child: AlertDialog(
                title: Text("You can pin up only 3 notes"),
              ));
        }
      } else {
        Firestore.instance
            .collection('Smartnotes')
            .document(AppPreferences().username)
            .collection("userName")
            .where("notesID", isEqualTo: smartNotesFileList[i].notesId)
            .getDocuments()
            .then((value) {
          value.documents.forEach((element) {
            Firestore.instance
                .collection("Smartnotes")
                .document(AppPreferences().username)
                .collection("userName")
                .document(element.documentID)
                .delete()
                .then((value) {
              print("Success!");
            });
          });
        });
      }
    });
  }

  Widget buildItem(int i) {
    return InkWell(
      onLongPress: () {
        /* setState(() {
          changeIcon = false;
        });
        Firestore.instance
            .collection("Smartnotes")
            .where("notesID", isEqualTo: smartNotesFileList[i].notesId)
            .getDocuments()
            .then((value) {
          value.documents.forEach((element) {
            setState(() {
              changeIcon = true;
            });
          });
        }); */
        //  longpress enable line below only
        setState(() {
          pinThis = !pinThis;
          itemToBePinned = i;
          // smartNotesFileList[i].pinned = !smartNotesFileList[i].pinned;
        });
      },
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child:
                /*ExpansionPanelList(
                  elevation: 1,
                  // dividerColor: Colors.grey[100],
                  expandedHeaderPadding: EdgeInsets.only(top: 10, bottom: 0),
                  expansionCallback: (index, isexpanded) {
                    setState(() {
                      smartNotesFileList[i].isExpanded =
                          !smartNotesFileList[i].isExpanded;
                    });
                  },
                  children: expansionPanelList(i))*/
                ExpansionTile(
              title: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smartNotesFileList[i].notesData.title.length > 0
                          ? Row(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.pink,
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      smartNotesFileList[i]
                                                  .notesData
                                                  .title
                                                  .length >
                                              15
                                          ? smartNotesFileList[i]
                                                  .notesData
                                                  .title
                                                  .substring(0, 15) +
                                              "..."
                                          : smartNotesFileList[i]
                                              .notesData
                                              .title,
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                SizedBox(width: 15.0),
                                smartNotesFileList[i].pinned
                                    ? Transform(
                                        transform: new Matrix4.identity()
                                          ..rotateZ(45 * 3.1415927 / 180),
                                        child: FaIcon(
                                            FontAwesomeIcons.thumbtack,
                                            color: Colors.red,
                                            size: 15),
                                      )
                                    // Icon(Icons.pin_drop, size: 15.0)
                                    : SizedBox.shrink(),
                              ],
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "Created on " +
                              DateUtils.convertUTCToLocalTime(
                                  smartNotesFileList[i].createdOn),
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700],
                              fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      //Call delete API and remove the cell from listview
                      removeIndex = i;
                      navigateToSmartNoteEdit(smartNotesFileList[i]);
                    }),
                IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      //Call delete API and remove the cell from listview
                      removeIndex = i;
                      showDeleteAlert();
                    }),
              ]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: _buildExpandableContent(
                    smartNotesModel: smartNotesFileList[i],
                    noteComments: smartNotesFileList[i].notesData.comments,
                    noteTitle: smartNotesFileList[i].notesData.title,
                  )),
                ),
              ],
              trailing: smartNotesFileList[i].notesData.files.isEmpty
                  ? SizedBox(
                      width: 24,
                    )
                  : null,
            ),
          ),
          // Positioned(
          //   left: 5.0,
          //   top: 5.0,
          //   child: smartNotesFileList[i].pinned
          //       ? FaIcon(FontAwesomeIcons.thumbtack, size: 15)
          //       // Icon(Icons.pin_drop, size: 15.0)
          //       : SizedBox.shrink(),
          // ),
        ],
      ),
    );
  }

  List<ExpansionPanel> expansionPanelList(i) {
    List<ExpansionPanel> expansionPanelWidgetList = [];

    expansionPanelWidgetList.add(ExpansionPanel(
        headerBuilder: (context, isexpanded) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                // color: Colors.green,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          smartNotesFileList[i].notesData.title.length > 0
                              ? Row(
                                  children: [
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        // color: Colors.pink,
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          smartNotesFileList[i].notesData.title,
                                          maxLines: 3,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16),
                                        )),
                                    SizedBox(width: 15.0),
                                    smartNotesFileList[i].pinned
                                        ? Transform(
                                            transform: new Matrix4.identity()
                                              ..rotateZ(45 * 3.1415927 / 180),
                                            child: FaIcon(
                                                FontAwesomeIcons.thumbtack,
                                                size: 15),
                                          )
                                        // Icon(Icons.pin_drop, size: 15.0)
                                        : SizedBox.shrink(),
                                  ],
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Created on " +
                                  DateUtils.convertUTCToLocalTime(
                                      smartNotesFileList[i].createdOn),
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[700],
                                  fontSize: 11.5),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                //Call delete API and remove the cell from listview
                                removeIndex = i;
                                navigateToSmartNoteEdit(smartNotesFileList[i]);
                              }),
                          IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                //Call delete API and remove the cell from listview

                                setState(() {
                                  removeIndex = i;
                                });
                                showDeleteAlert();
                              }),
                        ],
                      ),
                    ]),
              ),
            ],
          );
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: _buildExpandableContent(
            smartNotesModel: smartNotesFileList[i],
            noteComments: smartNotesFileList[i].notesData.comments,
            noteTitle: smartNotesFileList[i].notesData.title,
          )),
        ),
        isExpanded: smartNotesFileList[i].isExpanded));
    return expansionPanelWidgetList;
  }

  firebaseCollections() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Smartnotes')
        .document(AppPreferences().username)
        .collection("userName")
        .getDocuments();
    // print("Firesbased Shina");
    // setState(() {
    dummylist = querySnapshot.documents.map((doc) => doc.data).toList();
    // });
    // print(dummylist);
    dummy.clear();
    if (dummylist.length > 0) {
      for (var i = 0; i < dummylist.length; i++) {
        // setState(() {
        dummy.add(dummylist[i]["notesID"]);
        // });
      }
    }
    // print("dummy ");
    // debugPrint(dummy.toString());
    setLoader = true;
    // setState(() {});
  }

  bool loader = true;
  Widget animatedListViewBuilderItem() {
    List<SmartNotesModel> modifiedorder = [];
    firebaseCollections();
    if (dummylist == null || dummylist.length == 0) {
      // print("EEEEMPTY");
      setState(() {
        loader = false;
        // modifiedorder = smartNotesFileList;
        for (var i = 0; i < smartNotesFileList.length; i++) {
          smartNotesFileList[i].pinned = false;
          modifiedorder.add(smartNotesFileList[i]);
        }
      });
    } else {
      for (var i = 0; i < smartNotesFileList.length; i++) {
        if ( //smartNotesFileList[i].pinned ||
            dummy.contains(smartNotesFileList[i].notesId)) {
          smartNotesFileList[i].pinned = true;
          modifiedorder.add(smartNotesFileList[i]);
        }
      }
      for (var i = 0; i < smartNotesFileList.length; i++) {
        if ( // !smartNotesFileList[i].pinned ||
            !dummy.contains(smartNotesFileList[i].notesId)) {
          smartNotesFileList[i].pinned = false;
          modifiedorder.add(smartNotesFileList[i]);
        }
      }
      setState(() {
        loader = false;
        smartNotesFileList = modifiedorder;
        // modifiedorderG = modifiedorder;
      });
    }

    return /* ReorderableListView(
      children: <Widget>[
        for (var i = 0; i < smartNotesFileList.length; i++)
          Container(
              color: Colors.white,
              key: ValueKey(smartNotesFileList[i]),
              child: ExpansionPanelList(
                  elevation: 1,
                  dividerColor: Colors.grey[100],
                  expandedHeaderPadding: EdgeInsets.only(top: 10, bottom: 0),
                  expansionCallback: (index, isexpanded) {
                    setState(() {
                      smartNotesFileList[i].isExpanded =
                          !smartNotesFileList[i].isExpanded;
                    });
                  },
                  children: expansionPanelList(i))),
      ],
      onReorder: reorderData,
    ); */
        // (dummylist == null || dummylist.length == 0) &&
        ListView.builder(
            controller: _scrollController,
            itemCount: smartNotesFileList.length,
            itemBuilder: (context, i) {
              return buildItem(i);
            });

    // AnimatedList(
    //     key: _listKey,
    //     initialItemCount: smartNotesFileList.length,
    //     itemBuilder: (context, i, animation) {
    //       if (i < smartNotesFileList.length) {
    //         // sorting();
    //         return buildItem(i, animation);
    //       }
    //       return Container(height: 0, width: 0);
    //     });
  }

  void sorting() {}

  /* void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = smartNotesFileList.removeAt(oldindex);
      smartNotesFileList.insert(newindex, items);
    });
  } */

  Widget listViewBuilderItem() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: smartNotesFileList.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    new InkWell(
                        onTap: () {
                          debugPrint(
                              'SmartNotes Model ${smartNotesFileList[i]}');
                          smartNotesFileList[i].isExpanded == true
                              ? smartNotesFileList[i].isExpanded = false
                              : smartNotesFileList[i].isExpanded = true;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Container(
                              // color: Colors.green,
                              width: MediaQuery.of(context).size.width - 90,
                              child: Row(children: [
                                Text(
                                  DateUtils.convertUTCToLocalTime(
                                      smartNotesFileList[i].createdOn),
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                    color: Colors.black,
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
//Call delete API and remove the cell from listview
                                    }),
                              ]),
                            ),
                            smartNotesFileList[i].notesData.title.length > 0
                                ? Container(
                                    // color: Colors.pink,
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    child: Text(
                                      smartNotesFileList[i].notesData.title,
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      style: new TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ))
                                : Container(),
                          ],
                        ))
                  ],
                ),
                SizedBox(height: 10),
                Column(children: [
                  Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 1,
                    color: smartNotesFileList[i].isExpanded
                        ? AppColors.borderShadow
                        : Colors.black,
                  ),
                  Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 5,
                    color: smartNotesFileList[i].isExpanded
                        ? Colors.white
                        : AppColors.borderShadow,
                  )
                ]),
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: smartNotesFileList[i].isExpanded
                        ? Column(
                            children: _buildExpandableContent(
                            smartNotesModel: smartNotesFileList[i],
                            noteComments:
                                smartNotesFileList[i].notesData.comments,
                            noteTitle: smartNotesFileList[i].notesData.title,
                          ))
                        : Container()),
                smartNotesFileList[i].isExpanded
                    ? separatorWidget()
                    : Container(),
              ],
            ),
          );
        });
  }

  Widget separatorWidget() {
    return Column(children: [
      Container(
        // margin: EdgeInsets.symmetric(horizontal: 10),
        height: 1,
        color: Colors.black,
      ),
      Container(
        // margin: EdgeInsets.symmetric(horizontal: 10),
        height: 5,
        color: AppColors.borderShadow,
      )
    ]);
  }

  Widget userTitleText() {
    return Container(
      height: 55,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          color: AppColors.arrivedColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          )),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Notes History",
            style: AppPreferences().isLanguageTamil()
                ? TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)
                : TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandableContent(
      {SmartNotesModel smartNotesModel,
      String noteComments,
      String noteTitle}) {
    List<FileDetails> files = smartNotesModel.notesData.files;
    List<Widget> columnContent = [];
    if (noteComments.isNotEmpty) {
      columnContent.add(
        Card(
          elevation: 2,
          child: new ListTile(
              title: Column(
                children: [
                  Row(
                    children: [
                      getIconWidget('text'),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text(
                            noteTitle,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              onTap: () {
                //call API for getting the path and then pass the File Path
                Navigator.pushNamed(context, Routes.smartNoteTextShowScreen,
                    arguments: SmartNoteTextArg(
                      noteTitle: noteTitle,
                      noteComments: noteComments,
                    ));
              }),
        ),
      );
    }
    for (FileDetails content in files)
      columnContent.add(
        Card(
          elevation: 2,
          child: new ListTile(
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      getIconWidget(content.fileType.toLowerCase()),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          // width: MediaQuery.of(context).size.width - 150,
                          child: Text(
                        content.fileName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      )),
                      Spacer(),
                      IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            //Call delete API and remove the cell from listview
                            showFileDeleteAlert(smartNotesModel, content);
                          })
                    ],
                  ),
                ],
              ),
              onTap: () {
                //call API for getting the path and then pass the File Path
                Navigator.pushNamed(context, Routes.smartNoteFileShowScreen,
                    arguments: Args(
                        smartNoteAttachment: content,
                        smartNoteFileType: noteComments));
              }),
        ),
      );

    return columnContent;
  }

  Icon getIconWidget(String type) {
    switch (type) {
      case "video":
        return Icon(
          Icons.video_call,
          color: Colors.blue,
        );
        break;
      case "audio":
        return Icon(
          Icons.music_video,
          color: Colors.blue,
        );
        break;
      case "text":
        return Icon(
          Icons.text_fields,
          color: Colors.blue,
        );
      case "file":
        return Icon(
          Icons.music_video,
          color: Colors.blue,
        );
        break;
      default:
    }
    return Icon(
      Icons.image,
      color: Colors.blue,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dummylist.clear();
    // dummy.dispose();
  }

  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        pinThis = false;
      });
    });
    super.initState();
    // delete11();
    getDOc();
    firebaseCollections();

    fetchUserSmartNoteFiles();

    // pinned();
  }

  /* delete11() async {
    final collectionRef = Firestore.instance.collection('you_Collection_Path');
    final futureQuery = collectionRef.getDocuments();
    await futureQuery.then((value) => value.documents.forEach((element) {
          element.reference.delete();
          print("deleted");
        }));
    print("deleted");
  } */

  getDOc() async {
    QuerySnapshot querySnapshot1 =
        await Firestore.instance.collection('Smartnotes').getDocuments();
    final allData1 = querySnapshot1.documents.map((doc) => doc.data).toList();
    // print("USERNAMES");
    // print(allData1);
    dummy.clear();
    if (allData1.length > 0) {
      for (var i = 0; i < allData1.length; i++) {
        // setState(() {
        dummy.add(allData1[i]["userName"]);
        // });
      }
    }
    // print("DUMMY----");
    // print(dummy);

    if (allData1.isEmpty || !dummy.contains(AppPreferences().username)) {
      Firestore.instance.collection("Smartnotes").add({
        "userName": AppPreferences()
            .username //your data which will be added to the collection and collection will be created after this
      }).then((_) {
        print("${AppPreferences().username} created");
      }).catchError((_) {
        print("an error occured");
      });
    } else {
      print("Already available");
    }

    // final allData = querySnapshot.documents.map((doc) => doc.data).toList();
    // print("Firesbased Shina");
    // QuerySnapshot querySnapshot = await Firestore.instance
    //     .collection('Smartnotes')
    //     .document(AppPreferences().username)
    //     .collection("userName")
    //     .getDocuments();
    // final allData = querySnapshot.documents.map((doc) => doc.data).toList();
    // print(
    // "Firesbased Shina -- ${Firestore.instance.collection('Smartnotes').document(AppPreferences().username).path}");
    // print(allData);

    // print(allData);
    // var docRef =
    //     await Firestore.instance.collection("Smartnotes").getDocuments();
    // docRef.documents.forEach((result) {
    //   print(result.documentID);
    // });
  }

  Future<List<SmartNotesModel>> fetchUserSmartNoteFiles() async {
    // CustomProgressLoader.showLoader(context);
    String departmentName = await AppPreferences.getDeptName();
    String entityName = "Report"; //TODO: For now hardcoded as per API team
    String userName = await AppPreferences.getUsername();
    String loggedInUserName = await AppPreferences.getUsername();
    Map<String, String> header = {};
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
    header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
    debugPrint(WebserviceConstants.baseNotesURL +
        "/departments/$departmentName/users/$userName/entities/$entityName/notes");
    final response = await helper.get(
        WebserviceConstants.baseNotesURL +
            "/departments/$departmentName/users/$userName/entities/$entityName/notes",
        headers: header,
        isOAuthTokenNeeded: false);
    // CustomProgressLoader.cancelLoader(context);

    debugPrint("response - ${response.statusCode}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      Map<String, dynamic> jsonMapData = new Map();
      List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("smartNoteList", () => jsonData);
      } catch (_) {
        print("rrrrrrrrrrr" + _);
        // jsonData = jsonDecode(response.body);
        jsonMapData.putIfAbsent("smartNoteList", () => null);
      }

      if (jsonData != null) {
        smartNotesFileList = jsonMapData["smartNoteList"]
            .map<SmartNotesModel>((x) => SmartNotesModel.fromJson(x))
            .toList();
        localBackup = smartNotesFileList;
        localBackup1 = smartNotesFileList;
        isDataLoaded = true;
        service = "";
        //if (smartNotesFileList.length > 0) {
        setState(() {});
        //}

        // for loop for getting pinned items at first

        return smartNotesFileList;
      }
    } else {
      debugPrint("response errror - ${response.body}");
      isDataLoaded = true;
      if (response.statusCode > 500 && response.statusCode < 505) {
        service = "Service tempora";
      }
      smartNotesFileList = [];
      setState(() {});
    }
    return smartNotesFileList;
  }

//   Future<List<NotesAttachment>> fetchFileDetailsFromAttachmentID(
//       FileDetails fileDetails) async {
//     String attachmentID = fileDetails.attachmentId;
//     String loggedInUserName = await AppPreferences.getUsername();
//     Map<String, String> header = {};
//     header.putIfAbsent(WebserviceConstants.contentType,
//         () => WebserviceConstants.applicationJson);
//     header.putIfAbsent(WebserviceConstants.username, () => loggedInUserName);
//     header.putIfAbsent("tenant", () => WebserviceConstants.tenant);
//     String urlString = WebserviceConstants.baseNotesURL +
//         "/attachments/list?attachment_id=$attachmentID";
//     final response =
//         await helper.get(urlString, headers: header, isOAuthTokenNeeded: false);
// //https://qa.servicedx.com/notes/attachments/list?attachment_id=2de440e1-bfa6-48b9-b1b0-71b14ed09f57

//     debugPrint("response - ${response.statusCode}");
//     debugPrint(urlString);
//     if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
//       Map<String, dynamic> jsonMapData = new Map();
//       List<dynamic> jsonData;
//       try {
//         jsonData = jsonDecode(response.body);
//         jsonMapData.putIfAbsent("notesAttachments", () => jsonData);
//         debugPrint("notesAttachments - ${jsonData.toString()}");
//       } catch (_) {
//         print("" + _);
//       }

//       if (jsonData != null) {
//         notesAttachments = jsonMapData["notesAttachments"]
//             .map<NotesAttachment>((x) => NotesAttachment.fromJson(x))
//             .toList();
//         if (notesAttachments.length > 0) {
//           NotesAttachment attachment = notesAttachments[0];
//           //Navigate to

//           print("----*****----");
//           print(attachment.fileLocation);
//           Navigator.pushNamed(context, Routes.smartNoteFileShowScreen,
//               arguments: Args(smartNoteAttachment: attachment));
//         } else {
//           Fluttertoast.showToast(
//               timeInSecForIosWeb: 5,
//               msg: "Data not available",
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.TOP);
//         }
//         return notesAttachments;
//       }
//     }
//     return notesAttachments;
//   }

  Future<void> deleteNoteFileAPICall(
      SmartNotesModel modelObj, FileDetails fileDetails) async {
    String userName = modelObj.userName;
    String deptName = modelObj.departmentName;
    String entity = modelObj.entityName;
    String noteID = modelObj.notesId;
    String attachmentId = fileDetails.attachmentId;
    CustomProgressLoader.showLoader(context);

    Map<String, String> header = {"accept": " */*"};
    String url = WebserviceConstants.baseNotesURL +
        "/departments/$deptName/users/$userName/entities/$entity/notes/$noteID/attachment/$attachmentId";
    // String urlStr = url.replaceAll(" ", "");
    /*
    https://qa.servicedx.com/notes/departments/test26/users/user26/entities/report26/notes/b1a6dc9d-6916-479c-93a0-20611a30fce8/attachment/66d5ab08-c315-494a-b732-b66ddb8d68aa
     */
    debugPrint(url);
    final http.Response response = await http.delete(
      url,
      headers: header,
      //accept: */*
    );
    debugPrint("status code - ${response.statusCode}");
    CustomProgressLoader.cancelLoader(context);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      //remove item from array and animate UI
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: "Attachment deleted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
      modelObj.notesData.files.remove(fileDetails);
      setState(() {});
      //TODO: Remove file from expanded list
    } else {
      //error in deleteing
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: "Error in deleting the attachment.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  Future<void> deleteNoteAPICall(SmartNotesModel modelObj) async {
    String userName = modelObj.userName;
    String deptName = modelObj.departmentName;
    String entity = modelObj.entityName;
    String noteID = modelObj.notesId;
    CustomProgressLoader.showLoader(context);

    Map<String, String> header = {"accept": " */*"};
    String url = WebserviceConstants.baseNotesURL +
        "/departments/$deptName/users/$userName/entities/$entity/notes/$noteID";
    // String urlStr = url.replaceAll(" ", "");
    debugPrint(url);
    final http.Response response = await http.delete(
      url,
      headers: header,
      //accept: */*
    );
    debugPrint("status code - ${response.statusCode}");
    CustomProgressLoader.cancelLoader(context);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      //remove item from array and animate UI
      _removeSingleItems();

      Firestore.instance
          .collection('Smartnotes')
          .document(AppPreferences().username)
          .collection("userName")
          .where("notesID", isEqualTo: noteID)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          Firestore.instance
              .collection("Smartnotes")
              .document(AppPreferences().username)
              .collection("userName")
              .document(element.documentID)
              .delete()
              .then((value) {
            print("Success!");
          });
        });
      });

      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: "Note deleted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    } else {
      //error in deleteing
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: "Error in deleting the note.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  void audioPlayerCompleted() {
    // print("audioPlayerCompleted");
  }

  String getFileType(String filePath) {
    String fileType = filePath.split(".").last;

    if (fileType == "png" || fileType == "jpg" || fileType == "jpeg") {
      return "image";
    } else if (fileType == "mp4") {
      return "video";
    }
    return "audio";
  }

  _filter(String searchPeople) {
    print("Search date is --> $searchPeople");

    smartNotesFileList = localBackup1;
    localBackup = smartNotesFileList;
    if (searchPeople.length > 0) {
      List<SmartNotesModel> filteredList = new List();
      for (final people in localBackup) {
        //TODO: Need to clarify search option by username or first and last name?
        if (people.notesData.title
                .toLowerCase()
                .contains(searchPeople.toLowerCase()) ||
            DateUtils.convertUTCToLocalTime(people.createdOn)
                .toLowerCase()
                .contains(searchPeople.toLowerCase())) {
          filteredList.add(people);
        }
      }

      setState(() {
        smartNotesFileList = filteredList;
      });
    }
    setState(() {});
  }

  openDateSelector() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now(),
        minTime: DateTime.now().subtract(Duration(days: 43830)),
        theme: WidgetStyles.datePickerTheme, onChanged: (date) {
      // print('change $date in time zone ' +
      // date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      // print('confirm $date');

      setState(() {
        controller.text =
            DateFormat(DateUtils.defaultDateFormat).format(date.toLocal());
      });
      _filter(DateFormat(DateUtils.defaultDateFormat).format(date.toLocal()));
    },
        currentTime: DateTime.now(),
        locale:
            /*AppPreferences().isLanguageTamil() ? LocaleType.ta :*/ LocaleType
                .en);
  }

  Widget getSearchPopup() {
    return PopupMenuButton(
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
            height: popupMenuItemHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Search By",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.cancel,
                  size: 30.0,
                ),
              ],
            ),
            value: -1,
          ),
        );

        list.add(
          PopupMenuItem(
            height: popupMenuItemHeight,
            child: Row(
              children: [
                Icon(
                  Icons.done,
                  color: selectedSearchOption == 0
                      ? Colors.green
                      : Colors.transparent,
                ),
                SizedBox(width: 10),
                Text('Title'),
              ],
            ),
            value: 0,
          ),
        );
        list.add(
          PopupMenuItem(
            height: popupMenuItemHeight,
            child: Row(
              children: [
                Icon(
                  Icons.done,
                  color: selectedSearchOption == 1
                      ? Colors.green
                      : Colors.transparent,
                ),
                SizedBox(width: 10),
                Text('Date'),
              ],
            ),
            value: 1,
          ),
        );
        list.add(
          PopupMenuItem(
            height: popupMenuItemHeight,
            child: Row(
              children: [
                Icon(
                  Icons.done,
                  color: selectedSearchOption == 2
                      ? Colors.green
                      : Colors.transparent,
                ),
                SizedBox(width: 10),
                Text('Clear'),
              ],
            ),
            value: 2,
          ),
        );
        return list;
      },
      onCanceled: () {},
      onSelected: (value) {
        setState(() {
          if (value != -1) {
            selectedSearchOption = value;
            debugPrint("selectedSearchOption --> $selectedSearchOption");
            if (selectedSearchOption == 0) {
              controller.clear();
              searchLabel = "Search by Title";
              FocusScope.of(context).requestFocus(FocusNode());
            } else if (selectedSearchOption == 1) {
              controller.clear();
              searchLabel = "Search by Date";
              openDateSelector();
            } else if (selectedSearchOption == 2) {
              controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              selectedSearchOption = 0;
              // print("localBackuplocalBackuplocalBackuplocalBackuplocalBackup");
              // print(localBackup);
              smartNotesFileList.clear();
              searchLabel = "Search by Title";
              fetchUserSmartNoteFiles();
              // setState(() {
              //   smartNotesFileList.addAll(localBackup);
              // });
            }
          }
        });
      },
      offset: Offset(0, 50),
      child: Container(
        width: 48,
        height: 48,
        decoration: const ShapeDecoration(
          color: Colors.blueGrey,
          shape: CircleBorder(),
        ),
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
      ),
    );
  }
}
