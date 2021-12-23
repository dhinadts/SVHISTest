import 'dart:convert';

import '../../ui/membership/widgets/docs_upload_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

import '../../login/colors/color_info.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import '../custom_drawer/navigation_home_screen.dart';
import '../tabs/app_localizations.dart';
import 'model/committee_info.dart';
import 'model/contact_info.dart';
import 'model/group_info.dart';
import 'repository/send_message_api_client.dart';
import 'repository/send_message_repository.dart';
import 'tabs/recipients_tab.dart';
import 'dart:io';

class SendMessageScreen extends StatefulWidget {
  final String title;
  const SendMessageScreen({Key key, this.title}) : super(key: key);
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SendMessageRepository _sendMessageRepository =
      SendMessageRepository(SendMessageApiClient(httpClient: http.Client()));
  final toController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  List<ContactInfo> selectedContacts = [];
  List<GroupInfo> selectedGroups = [];
  List<CommitteeInfo> selectedCommittee = [];

  List<MessageRecipient> messageRecipientList = [];

  List<PlatformFile> attachments = [];

  int selectedCount = 0;

  //bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  MessageRecipient findMessageRecipientByName(String name) {
    MessageRecipient messageRecipient;
    if (messageRecipientList.isNotEmpty) {
      messageRecipientList.forEach((v) {
        if (v.name == name) {
          messageRecipient = v;
        }
      });
    }
    return messageRecipient;
  }

  ContactInfo findContactByContactName(String contactName) {
    ContactInfo contactInfo;
    if (selectedContacts.isNotEmpty) {
      selectedContacts.forEach((v) {
        if (v.contactName != null && v.contactName == contactName) {
          contactInfo = v;
        }
      });
    }
    return contactInfo;
  }

  CommitteeInfo findCommitteeByCommitteeName(String committeeName) {
    CommitteeInfo committeeInfo;
    if (selectedCommittee.isNotEmpty) {
      selectedCommittee.forEach((v) {
        if (v.departmentName != null && v.committeeName == committeeName) {
          committeeInfo = v;
        }
      });
    }
    return committeeInfo;
  }

  GroupInfo findGroupByGroupName(String groupName) {
    GroupInfo groupInfo;
    if (selectedGroups.isNotEmpty) {
      selectedGroups.forEach((v) {
        if (v.groupName != null &&
            v.groupType != null &&
            v.groupName == groupName) {
          groupInfo = v;
        }
      });
    }
    return groupInfo;
  }

  _selectReceipents() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => RecipientsTabScreen(
          contacts: selectedContacts,
          groups: selectedGroups,
          committees: selectedCommittee,
          selectedRecipientsCallback: (List<ContactInfo> contacts,
              List<GroupInfo> groups, List<CommitteeInfo> committee) {
            selectedContacts = contacts;
            selectedGroups = groups;
            selectedCommittee = committee;
            setState(() {
              selectedCount =
                  contacts.length + groups.length + committee.length;
            });
          },
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      title: Text(
        widget.title,
        style: AppPreferences().isLanguageTamil()
            ? TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
            : TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              //replaceHome();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            })
      ],
    );
  }

  attachFiles() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        attachments.addAll(result.files);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("To"),
                        ),
                      ],
                    ),
                    selectedCount == 0
                        ? TextFormField(
                            controller: toController,
                            onTap: () {
                              _selectReceipents();
                            },
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            validator: (String arg) {
                              return selectedCount == 0
                                  ? "Atleast select one recipient"
                                  : null;
                            },
                            onSaved: (String val) {},
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.view_list,
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(child: formInputChips())),
                                if (selectedCount > 0)
                                  GFBadge(
                                    child: Text(
                                      "$selectedCount",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: AppColors.arrivedColor,
                                    shape: GFBadgeShape.pills,
                                    size: GFSize.MEDIUM,
                                  ),
                                IconButton(
                                  icon: Icon(
                                    Icons.view_list,
                                    size: 30,
                                    color: AppColors.primaryColor,
                                  ),
                                  onPressed: () {
                                    _selectReceipents();
                                  },
                                ),
                              ],
                            ),
                          ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(AppLocalizations.of(context)
                              .translate("key_subject")),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: subjectController,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      validator: (String arg) {
                        if (arg.trim().length > 0) {
                          return null;
                        } else {
                          return AppLocalizations.of(context)
                              .translate("key_entersubject");
                        }
                      },
                      onSaved: (String val) {},
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        // labelText: AppLocalizations.of(context)
                        //     .translate("key_subject"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Enter message"),
                        ),
                      ],
                    ),
                    TextFormField(
                      minLines: 7,
                      controller: messageController,
                      autocorrect: false,
                      validator: (String arg) {
                        if (arg.trim().length > 0) {
                          return null;
                        } else {
                          return "Please enter message";
                        }
                      },
                      onSaved: (String val) {},
                      obscureText: false,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                          letterSpacing: 0.7,
                          height: 1.5,
                          fontSize: 15.0,
                          color: Color(ColorInfo.BLACK)),
                      maxLines: null,
                      decoration: InputDecoration(
                        //labelText: "Enter message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(AppLocalizations.of(context)
                              .translate("key_attach_file")),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("key_size_limit"),
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: attachments.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.attach_file_outlined),
                                  InkWell(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return ImageViewerDialog(
                                      //         imageFile:
                                      //             File(attachments[index].path),
                                      //         imageUrl: null,
                                      //       );
                                      //     });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              110,
                                          child: Text(
                                            attachments[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: AppColors.primaryColor),
                                          ),
                                        ),
                                        Text(
                                            "File Size: ${attachments[index].size} KB")
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          attachments.removeAt(index);
                                        });
                                      }),
                                ],
                              ),
                            ),
                          );
                        }),
                    Material(
                      color: AppColors.indentedLightColor,
                      child: InkWell(
                        onTap: () {
                          attachFiles();
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.publish_rounded),
                              const SizedBox(
                                width: 5,
                              ),
                              const Expanded(
                                child: Text("Browse File"),
                              ),
                              const Icon(Icons.add_box_rounded),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: 120,
                      child: RaisedButton(
                        color: AppColors.arrivedColor,
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _validateInputs();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formInputChips() {
    messageRecipientList.clear();
    if (selectedContacts != null) {
      selectedContacts.forEach((element) {
        messageRecipientList
            .add(MessageRecipient(element.contactName, RecepientType.Contact));
      });
    }

    if (selectedCommittee != null) {
      selectedCommittee.forEach((element) {
        messageRecipientList.add(
            MessageRecipient(element.committeeName, RecepientType.Committee));
      });
    }

    if (selectedGroups != null) {
      selectedGroups.forEach((element) {
        messageRecipientList
            .add(MessageRecipient(element.groupName, RecepientType.Group));
      });
    }

    return Wrap(
      spacing: 5.0,
      children: [
        for (MessageRecipient messageRecipient in messageRecipientList)
          InputChip(
            padding: EdgeInsets.all(2.0),
            avatar: null,
            label: Text(
              '${messageRecipient.name}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
            deleteIconColor: Colors.white,
            onSelected: (bool selected) {},
            onDeleted: () {
              //debugPrint("Delete recipient --> ${messageRecipient.name}");
              MessageRecipient messageRecipientLocal =
                  findMessageRecipientByName(messageRecipient.name);
              if (messageRecipientLocal != null) {
                messageRecipientList.remove(messageRecipientLocal);
                if (messageRecipient.recepientType == RecepientType.Contact) {
                  ContactInfo contactInfo =
                      findContactByContactName(messageRecipient.name);
                  selectedContacts.remove(contactInfo);
                } else if (messageRecipient.recepientType ==
                    RecepientType.Group) {
                  GroupInfo groupInfo =
                      findGroupByGroupName(messageRecipient.name);
                  selectedGroups.remove(groupInfo);
                } else if (messageRecipient.recepientType ==
                    RecepientType.Committee) {
                  CommitteeInfo committeeInfo =
                      findCommitteeByCommitteeName(messageRecipient.name);
                  selectedCommittee.remove(committeeInfo);
                }
                setState(() {
                  selectedCount =
                      (selectedContacts != null ? selectedContacts.length : 0) +
                          (selectedGroups != null ? selectedGroups.length : 0) +
                          (selectedCommittee != null
                              ? selectedCommittee.length
                              : 0);
                });
              }
            },
          ),
      ],
    );
  }

  void _validateInputs() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      CustomProgressLoader.showLoader(context);
      Map<String, dynamic> messageData = {};
      messageData["departmentName"] = await AppPreferences.getDeptName();
      messageData["messageContent"] = messageController.text;
      messageData["messageSubject"] = subjectController.text;

      List<Map<String, dynamic>> notificationsList =
          List<Map<String, dynamic>>();
      selectedContacts.forEach((element) {
        Map<String, dynamic> notification = Map<String, dynamic>();
        notification["departmentName"] = element.departmentName;
        notification["notificationName"] = element.contactName;
        notification["notificationType"] = "Contact";
        notification["userName"] = element.userName;
        notificationsList.add(notification);
      });

      selectedCommittee.forEach((element) {
        Map<String, dynamic> notification = Map<String, dynamic>();
        notification["departmentName"] = element.departmentName;
        notification["notificationName"] = element.committeeName;
        notification["notificationType"] = "Committee";
        notification["userName"] = element.committeeName;
        notificationsList.add(notification);
      });

      selectedGroups.forEach((element) {
        Map<String, dynamic> notification = Map<String, dynamic>();
        notification["departmentName"] = element.departmentName;
        notification["notificationName"] = element.groupName;
        notification["notificationType"] = "Group";
        notification["userName"] = "";
        notificationsList.add(notification);
      });
      messageData["notifications"] = notificationsList;

      debugPrint("messageData --> ${messageData.toString()}");
      http.Response response;

      if (attachments.isNotEmpty) {
        response = await _sendMessageRepository.sendMessageWithAttachments(
            messageData, attachments);
      } else {
        response = await _sendMessageRepository.sendMessage(messageData);
      }

      CustomProgressLoader.cancelLoader(context);

      if (response.statusCode == 204) {
        showDialog(
          context: context,
          barrierDismissible: false,
          child: SimpleDialog(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
                color: Colors.white,
                child: Image.asset(
                  "assets/images/checklist.png",
                  height: 110.0,
                  color: Colors.lightGreen,
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Your message has been sent",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
              SizedBox(height: 30),
            ],
          ),
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
              ModalRoute.withName(Routes.navigatorHomeScreen));
        });
      } else {
        String errorMsg = jsonDecode(response.body)['message'] as String;

        AlertUtils.showAlertDialog(
            context,
            errorMsg != null && errorMsg.isNotEmpty
                ? errorMsg
                : AppPreferences().getApisErrorMessage);
      }
    }
    // else {
    //   setState(() {
    //     _autoValidate = true;
    //   });
    // }
  }
}

enum RecepientType { Contact, Group, Committee }

class MessageRecipient {
  final String name;
  final RecepientType recepientType;

  const MessageRecipient(this.name, this.recepientType);
}
