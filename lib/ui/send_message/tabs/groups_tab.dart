import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../ui_utils/ui_dimens.dart';
import '../../../widgets/loading_widget.dart';
import '../../tabs/app_localizations.dart';
import '../model/group_info.dart';
import '../repository/send_message_api_client.dart';
import '../repository/send_message_repository.dart';
import 'contacts_tab.dart';

class GroupsTab extends StatefulWidget {
  final void Function(int) recordCountCallBack;
  final void Function(GroupInfo, bool) groupChangeCallBack;
  final List<GroupInfo> selectedGroups;

  const GroupsTab(
      {Key key,
      this.recordCountCallBack,
      this.groupChangeCallBack,
      this.selectedGroups})
      : super(key: key);
  @override
  GroupsTabState createState() => GroupsTabState();
}

class GroupsTabState extends State<GroupsTab>
    with AutomaticKeepAliveClientMixin<GroupsTab> {
  final SendMessageRepository _sendMessageRepository =
      SendMessageRepository(SendMessageApiClient(httpClient: http.Client()));

  List<Recipient> groups = <Recipient>[];
  List<GroupInfo> groupList = <GroupInfo>[];
  bool isDataLoaded = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  bool init = false, searchableStringEntered = false;
  String searchQuery = "";
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGroupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isDataLoaded
          ? ListView(
              children: [
                SizedBox(height: 10),
                ListLoading(),
              ],
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: AppUIDimens.paddingXMedium),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppUIDimens.paddingSmall),
                          child: TextFormField(
                            focusNode: focusNode,
                            onChanged: (data) {
                              if (data.length == 0) {
                                callSearchAPI();
                              }
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              labelText: "Search by Group Name",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isNotEmpty) {
                                return value.length > 1
                                    ? null
                                    : "Search string must be 2 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.blueGrey,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.search),
                            color: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  controller.text.trim().length > 1) {
                                setState(() {
                                  searchableStringEntered = true;
                                });
                                fetchSearchGroupList(controller.text);
                              } else {
                                setState(() {
                                  if (controller.text.trim().length == 0) {
                                    Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)
                                            .translate("key_entersometext"),
                                        gravity: ToastGravity.TOP,
                                        toastLength: Toast.LENGTH_LONG);
                                    focusNode.requestFocus();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    groups.length == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Container(child: Text("No data available")),
                          )
                        : ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.only(left:5.0),
                                decoration: new BoxDecoration(
                                  color: groups[index].selected
                                      ? Colors.green[50]
                                      : null,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      groups[index].selected =
                                          !groups[index].selected;
                                    });
                                    GroupInfo groupInfo = findGroupByGroupName(
                                        groups[index].title);
                                    if (groupInfo != null)
                                      widget.groupChangeCallBack(
                                          groupInfo, groups[index].selected);
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16.0),
                                  dense: true,
                                  selected: groups[index].selected,
                                  leading: (groups[index].selected)
                                      ? Icon(Icons.check_box)
                                      : Icon(Icons.check_box_outline_blank),
                                  title: Text(
                                    groups[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(groups[index].subTitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      )),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Divider(
                                        height: 3, color: Colors.grey[10])),
                            itemCount: groups.length,
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  fetchGroupList() async {
    groupList.clear();
    groups.clear();
    groupList = await _sendMessageRepository.getGroupList();
    if (groupList.isNotEmpty) {
      groupList.forEach((v) {
        if (v.groupName != null && v.groupType != null)
          groups.add(Recipient(v.groupName, v.groupType));
      });
    }
    // Select the previously selected data
    setSelectedGroup();
    setState(() {
      isDataLoaded = true;
    });
    widget.recordCountCallBack(groups.length);
  }

  fetchSearchGroupList(String searchStr) async {
    setState(() {
      isDataLoaded = false;
    });
    groupList.clear();
    groups.clear();
    groupList = await _sendMessageRepository.getSearchGroupList(searchStr);
    if (groupList.isNotEmpty) {
      groupList.forEach((v) {
        if (v.groupName != null && v.groupType != null)
          groups.add(Recipient(v.groupName, v.groupType));
      });
    }
    // Select the previously selected data
    setSelectedGroup();
    setState(() {
      isDataLoaded = true;
    });
    widget.recordCountCallBack(groups.length);
  }

  GroupInfo findGroupByGroupName(String groupName) {
    GroupInfo groupInfo;
    if (groupList.isNotEmpty) {
      groupList.forEach((v) {
        if (v.groupName != null &&
            v.groupType != null &&
            v.groupName == groupName) {
          groupInfo = v;
        }
      });
    }
    return groupInfo;
  }

  setSelectedGroup() {
    widget.selectedGroups.forEach((element) {
      groups.forEach((v) {
        if (v.title == element.groupName) {
          v.selected = true;
        }
      });
    });
  }

  resetSelectedGroups() {
    if (groups != null)
      groups.forEach((v) {
        if (v.selected) {
          v.selected = false;
        }
      });
    setState(() {});
  }

  callSearchAPI() {
    debugPrint("callSearchAPI ...");
    _formKey.currentState.validate();
    if (searchableStringEntered && controller.text.length == 0) {
      setState(() {
        searchableStringEntered = false;
        isDataLoaded = false;
      });

      fetchGroupList();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
