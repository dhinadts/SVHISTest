import '../../utils/app_preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../login/utils/custom_progress_dialog.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/text_styles.dart';
import '../../utils/validation_utils.dart';
import 'add_edit_committee_screen.dart';
import 'bloc/committees_bloc.dart';

class CommitteeRoleScreen extends StatefulWidget {
  final String teamOrGroup;
  final List<CommitteeMembers> selectedCommitteeMembersList;
  final void Function(List<CommitteeMembers>)
      updateSelectedCommitteeMembersList;

  final List memberTypes;

  const CommitteeRoleScreen(
      {Key key,
      @required this.selectedCommitteeMembersList,
      @required this.teamOrGroup,
      @required this.updateSelectedCommitteeMembersList,
      @required this.memberTypes})
      : super(key: key);

  @override
  _CommitteeRoleScreenState createState() => _CommitteeRoleScreenState();
}

class _CommitteeRoleScreenState extends State<CommitteeRoleScreen> {
  bool formAutoValidate = false;
  final GlobalKey<FormState> _alertFormKey = GlobalKey<FormState>();
  TextEditingController committeeNameDialogController = TextEditingController();
  TextEditingController committeeTitleDialogController =
      TextEditingController();
  List<CommitteeMembers> committeeMembersList = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    committeeNameDialogController.text = widget.teamOrGroup;
    getRoleDefinitionList();
  }

  getRoleDefinitionList() async {
    // debugPrint(
    // "selectedCommitteeMembersList length --> ${widget.selectedCommitteeMembersList.length}");
    CommitteesBloc committeesBloc = CommitteesBloc(context);
    committeesBloc.getCommitteeRoleDefinitionList();
    committeesBloc.committeeMembersListFetcher.listen((value) {
      if (value != null) {
        committeeMembersList.clear();
        value.forEach((v) {
          bool found = false;
          widget.selectedCommitteeMembersList.forEach((element) {
            if (element.title == v) {
              // debugPrint("element title --> ${element.title}");
              // debugPrint("v --> $v");
              found = true;
            }
          });
          if (found) {
            CommitteeMembers committeeMember = CommitteeMembers(v);
            committeeMember.selected = true;
            committeeMembersList.add(committeeMember);
          } else {
            CommitteeMembers committeeMember = CommitteeMembers(v);
            committeeMember.selected = false;
            committeeMembersList.add(committeeMember);
          }
        });
      }
      setState(() {
        isDataLoaded = true;
        waiting = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Role Definition"),
        centerTitle: true,
      ),
      body: isDataLoaded
          ? Card(
              shadowColor: Colors.black,
              elevation: 6,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: DottedBorder(
                borderType: BorderType.Rect,
                color: AppColors.kImageBorderColor,
                dashPattern: [4, 4],
                child: Stack(
                  children: [
                    ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          //padding: const EdgeInsets.all(5.0),

                          child: ListTile(
                            onTap: () {
                              if (widget.memberTypes.contains(
                                  committeeMembersList[index].title)) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Already ${committeeMembersList[index].title}'s are in group",
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 5,
                                    gravity: ToastGravity.TOP);
                              } else {
                                setState(() {
                                  committeeMembersList[index].selected =
                                      !committeeMembersList[index].selected;
                                  List<CommitteeMembers> updatedList = [];

                                  committeeMembersList.forEach((element) {
                                    if (element.selected) {
                                      updatedList.add(element);
                                    }
                                  });
                                  widget.updateSelectedCommitteeMembersList(
                                      updatedList);
                                });
                              }
                            },
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16.0),
                            dense: true,
                            selected: committeeMembersList[index].selected,
                            leading: (committeeMembersList[index].selected)
                                ? /* committeeMembersList[index].title == "Member"
                                    ? Icon(
                                        Icons.check_box,
                                        color: Colors.grey,
                                      )
                                    : */
                                Icon(
                                    Icons.check_box,
                                    color: Colors.blue,
                                  )
                                : Icon(Icons.check_box_outline_blank),
                            title: Text(
                              committeeMembersList[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child:
                                  Divider(height: 3, color: Colors.grey[10])),
                      itemCount: committeeMembersList.length,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          backgroundColor: AppColors.arrivedColor,
          onPressed: () async {
            // committeeNameDialogController.text =
            //     jointTeamController.text;
            addCommitteeTitleDialogue(context);
          },
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  addCommitteeTitleDialogue(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        title: Row(
          children: [
            Text("Add Title"),
            Spacer(),
            GestureDetector(
              child: Icon(
                Icons.cancel,
                size: 30.0,
              ),
              onTap: () {
                //committeeTitleDialogController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        //contentPadding: const EdgeInsets.all(16.0),
        content: SingleChildScrollView(
          child: Form(
            key: _alertFormKey,
            autovalidate: formAutoValidate,
            child: Column(
              children: [
                TextFormField(
                  controller: committeeNameDialogController,
                  readOnly: true,
                  style: TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Team/Group",
                      errorMaxLines: 2),
                  keyboardType: TextInputType.text,
                  onChanged: (str) {},
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: committeeTitleDialogController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z ]")),
                  ],
                  style: TextStyles.mlDynamicTextStyle,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title",
                      errorMaxLines: 2),
                  keyboardType: TextInputType.text,
                  validator: ValidationUtils.committeeTitleValidation,
                  onChanged: (str) {},
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          new RaisedButton(
              color: AppColors.arrivedColor,
              child: const Text('Add'),
              onPressed: () async {
                if (_alertFormKey.currentState.validate()) {
                  String departmentName = await AppPreferences.getDeptName();
                  CustomProgressLoader.showLoader(context);
                  // setState(() {});
                  CommitteesBloc _bloc = new CommitteesBloc(context);
                  Map<String, dynamic> titleData = {};
                  titleData["comments"] = "";
                  titleData["fieldName"] = "COMMITTEE_MEMBER_TYPE";
                  titleData["fieldValue"] = committeeTitleDialogController.text;
                  titleData["fieldDisplayValue"] =
                      committeeTitleDialogController.text;
                  titleData["departmentName"] = departmentName;
                  titleData["active"] = true;

                  _bloc.addCommitteeTitle(titleData);
                  _bloc.addCommitteeTitleFetcher.listen((response) async {
                    CustomProgressLoader.cancelLoader(context);
                    if (response.status == 201) {
                      Navigator.pop(context);
                      committeeTitleDialogController.clear();
                      Fluttertoast.showToast(
                          timeInSecForIosWeb: 5,
                          msg: "New role added Successfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP);
                      setState(() {
                        isDataLoaded = false;
                        waiting = true;
                      });
                      getRoleDefinitionList();
                    }
                  });
                } else {
                  setState(() {
                    formAutoValidate = true;
                  });
                }
              })
        ],
      ),
    );
  }
}
