import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../ui_utils/ui_dimens.dart';
import '../../../widgets/loading_widget.dart';
import '../../tabs/app_localizations.dart';
import '../model/contact_info.dart';
import '../repository/send_message_api_client.dart';
import '../repository/send_message_repository.dart';

class ContactListTab extends StatefulWidget {
  final void Function(int) recordCountCallBack;
  final void Function(ContactInfo, bool) contactChangeCallBack;
  final List<ContactInfo> contacts;

  const ContactListTab(
      {Key key,
      this.recordCountCallBack,
      this.contactChangeCallBack,
      this.contacts})
      : super(key: key);
  @override
  ContactListTabState createState() => ContactListTabState();
}

class ContactListTabState extends State<ContactListTab>
    with AutomaticKeepAliveClientMixin<ContactListTab> {
  final SendMessageRepository _sendMessageRepository =
      SendMessageRepository(SendMessageApiClient(httpClient: http.Client()));

  List<Recipient> contacts = <Recipient>[];
  List<ContactInfo> contactList = <ContactInfo>[];
  bool isDataLoaded = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  bool init = false, searchableStringEntered = false;
  String searchQuery = "";
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchContactList();
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
                              labelText: "Search by Contact Name",
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
                                fetchSearchContactList(controller.text);
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
                    contacts.length == 0
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
                                  color: contacts[index].selected
                                      ? Colors.green[50]
                                      : null,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    //FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      contacts[index].selected =
                                          !contacts[index].selected;
                                    });

                                    ContactInfo contactInfo =
                                        findContactByContactName(
                                            contacts[index].title);
                                    if (contactInfo != null) {
                                      // debugPrint(
                                      //     "contactInfo --> ${contactInfo.contactName}");
                                      widget.contactChangeCallBack(contactInfo,
                                          contacts[index].selected);
                                    }
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16.0),
                                  dense: true,
                                  selected: contacts[index].selected,
                                  leading: (contacts[index].selected)
                                      ? Icon(Icons.check_box)
                                      : Icon(Icons.check_box_outline_blank),
                                  title: Text(
                                    contacts[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(contacts[index].subTitle,
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
                            itemCount: contacts.length,
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  fetchContactList() async {
    contactList.clear();
    contacts.clear();
    contactList = await _sendMessageRepository.getContactsList();
    if (contactList.isNotEmpty) {
      contactList.forEach((v) {
        if (v.contactName != null && v.userFullName != null) {
          contacts.add(Recipient(v.contactName, v.userFullName));
        }
      });
    }
    // Select the previously selected data
    setSelectedContacts();
    setState(() {
      isDataLoaded = true;
    });
    widget.recordCountCallBack(contacts.length);
  }

  fetchSearchContactList(String searchStr) async {
    setState(() {
      isDataLoaded = false;
    });
    contactList.clear();
    contacts.clear();
    contactList = await _sendMessageRepository.getSearchContactsList(searchStr);
    if (contactList.isNotEmpty) {
      contactList.forEach((v) {
        if (v.contactName != null && v.userFullName != null) {
          contacts.add(Recipient(v.contactName, v.userFullName));
        }
      });
    }
    // Select the previously selected data
    setSelectedContacts();
    setState(() {
      isDataLoaded = true;
    });
    widget.recordCountCallBack(contacts.length);
  }

  ContactInfo findContactByContactName(String contactName) {
    ContactInfo contactInfo;
    if (contactList.isNotEmpty) {
      contactList.forEach((v) {
        if (v.contactName != null &&
            v.userFullName != null &&
            v.contactName == contactName) {
          contactInfo = v;
        }
      });
    }
    return contactInfo;
  }

  setSelectedContacts() {
    widget.contacts.forEach((element) {
      contacts.forEach((v) {
        if (v.title == element.contactName) {
          v.selected = true;
        }
      });
    });
  }

  resetSelectedContacts() {
    if (contacts != null)
      contacts.forEach((v) {
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

      fetchContactList();
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
