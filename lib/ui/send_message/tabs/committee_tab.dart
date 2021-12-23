import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../ui_utils/ui_dimens.dart';
import '../../../widgets/loading_widget.dart';
import '../../tabs/app_localizations.dart';
import '../model/committee_info.dart';
import '../repository/send_message_api_client.dart';
import '../repository/send_message_repository.dart';

class CommitteeListTab extends StatefulWidget {
  final void Function(int) recordCountCallBack;
  final Function(CommitteeInfo, bool) committeeChangeCallBack;
  final List<CommitteeInfo> committee;

  const CommitteeListTab(
      {Key key,
      this.recordCountCallBack,
      this.committeeChangeCallBack,
      this.committee})
      : super(key: key);
  @override
  CommitteeListTabState createState() => CommitteeListTabState();
}

class CommitteeListTabState extends State<CommitteeListTab>
    with AutomaticKeepAliveClientMixin<CommitteeListTab> {
  final SendMessageRepository _sendMessageRepository =
      SendMessageRepository(SendMessageApiClient(httpClient: http.Client()));

  List<Recipient> committee = <Recipient>[];
  List<Recipient> committeeRecipientCopy = <Recipient>[];
  List<CommitteeInfo> committeeList = <CommitteeInfo>[];
  List<CommitteeInfo> committeeListCopy = <CommitteeInfo>[];
  bool isDataLoaded = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  bool init = false, searchableStringEntered = false;
  String searchQuery = "";
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCommitteeList();
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
                              labelText: "Search by Committee Name",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
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
                                fetchSearchCommitteeList(controller.text);
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
                    committee.length == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Container(child: Text("No data available")),
                          )
                        : ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.only(left: 5.0),
                                decoration: new BoxDecoration(
                                  color: committee[index].selected
                                      ? Colors.green[50]
                                      : null,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    //FocusScope.of(context).requestFocus(FocusNode());
                                    // print(
                                    //     "========================> Entered Here in the commiteeeeee selection");
                                    setState(() {
                                      committee[index].selected =
                                          !committee[index].selected;
                                    });

                                    CommitteeInfo contactInfo =
                                        findContactByContactName(
                                            committee[index].title);
                                    debugPrint(
                                        "contactInfo --> ${contactInfo.committeeName}");
                                    if (contactInfo != null) {
                                      debugPrint(
                                          "contactInfo --> ${contactInfo.committeeName}");
                                      widget.committeeChangeCallBack(
                                          contactInfo,
                                          committee[index].selected);
                                    }
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 8.0),
                                  dense: true,
                                  selected: committee[index].selected,
                                  leading: (committee[index].selected)
                                      ? Icon(Icons.check_box)
                                      : Icon(Icons.check_box_outline_blank),
                                  title: Text(
                                    committee[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(committee[index].subTitle,
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
                                        horizontal: 5),
                                    child: Divider(
                                        height: 3, color: Colors.grey[10])),
                            itemCount: committee.length,
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  fetchCommitteeList() async {
    committeeList.clear();
    committee.clear();
    committeeList = await _sendMessageRepository.getCommitteeList();
    if (committeeList.isNotEmpty) {
      for (var i = 0; i < committeeList.length; i++) {
        if (committeeList[i].committeeName != null &&
            committeeList[i].departmentName != null) {
          if (committeeList[i].active)
            committee.add(Recipient(committeeList[i].committeeName,
                committeeList[i].departmentName));
        }
      }
    }
    committeeRecipientCopy = List.from(committee);
    committeeListCopy = List.from(committeeList);
    // Select the previously selected data
    setSelectedContacts();
    setState(() {
      isDataLoaded = true;
    });
    widget.recordCountCallBack(committee.length);
  }

  fetchSearchCommitteeList(String searchStr) async {
    setState(() {
      isDataLoaded = false;
    });
    committeeList.clear();
    committee.clear();
    committeeList =
        await _sendMessageRepository.getSearchCommitteeList(searchStr);
    if (committeeList.isNotEmpty) {
      committeeList.forEach((v) {
        if (v.committeeName != null && v.departmentName != null) {
          if (v.active)
            committee.add(Recipient(v.committeeName, v.departmentName));
        }
      });
    }
    // Select the previously selected data
    setSelectedContacts();
    setState(() {
      isDataLoaded = true;
    });
    widget.recordCountCallBack(committee.length);
  }

  CommitteeInfo findContactByContactName(String committeeName) {
    CommitteeInfo contactInfo;

    if (committeeListCopy.isNotEmpty) {
      // print("entered into the committtee list loop");
      committeeListCopy.forEach((v) {
        if (v.committeeName != null &&
            v.departmentName != null &&
            v.committeeName == committeeName) {
          contactInfo = v;
        }
      });
    }
    return contactInfo;
  }

  setSelectedContacts() {
    widget.committee.forEach((element) {
      committee.forEach((v) {
        if (v.title == element.committeeName) {
          v.selected = true;
        }
      });
    });
  }

  resetSelectedContacts() {
    if (committee != null)
      committee.forEach((v) {
        if (v.selected) {
          v.selected = false;
        }
      });
    setState(() {});
  }

  // filterData(String searchString) {
  //   //FocusScope.of(context).requestFocus(FocusNode());
  //   List<Recipient> filteredList = <Recipient>[];
  //   for (final contact in contacts) {
  //     if (contact.title.toLowerCase().contains(searchString)) {
  //       filteredList.add(contact);
  //     }
  //   }
  //   setState(() {
  //     contacts = filteredList;
  //   });
  // }

  callSearchAPI() {
    debugPrint("callSearchAPI ...");
    _formKey.currentState.validate();
    if (searchableStringEntered && controller.text.length == 0) {
      setState(() {
        searchableStringEntered = false;
        isDataLoaded = false;
      });
      fetchCommitteeList();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class Recipient {
  final String title;
  final String subTitle;
  bool selected = false;

  Recipient(
    this.title,
    this.subTitle,
  );
}
