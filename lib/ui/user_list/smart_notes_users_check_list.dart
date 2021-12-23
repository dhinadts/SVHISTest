import 'package:flutter/material.dart';
import '../../bloc/people_list_bloc.dart';
import '../../model/people_response.dart';
import '../../model/people.dart';
import '../../utils/app_preferences.dart';
import '../../repo/common_repository.dart';
import '../../ui_utils/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui_utils/ui_dimens.dart';

class UserCheckList extends StatefulWidget {
  String noteId;
  String entityName;
  String userName;
  String departmentName;
  UserCheckList(
      {this.noteId, this.entityName, this.departmentName, this.userName});
  @override
  _UserCheckListState createState() => _UserCheckListState();
}

class _UserCheckListState extends State<UserCheckList> {
  PeopleListBloc _bloc;
  List<bool> checkedUsersList = [];
  List<People> selectedPeopleList = [];
  PeopleResponse peopleList;
  var start = 0;
  var controller = TextEditingController();
  List<People> searchedPeopleList = [];

  @override
  initState() {
    _bloc = new PeopleListBloc(context);
  }

  apiCall() async {
    selectedPeopleList.forEach((element) async {
      var response = await http.post(WebserviceConstants.baseNotesURL +
          "/transfer/" +
          "${widget.departmentName}/users/${widget.userName}/entities/${widget.entityName}/notes/${widget.noteId}" +
          "?targetUser=${element.userName}&transferType=USER");
      // print("==============> Smart Notes Share API");
      // print(response.statusCode);
      // print(WebserviceConstants.baseNotesURL +
      //     "/transfer/" +
      //     "${widget.departmentName}/users/${widget.userName}/entities/${widget.entityName}/notes/${widget.noteId}" +
      //     "?targetUser=${element.userName}&transferType=USER");
    });
    Fluttertoast.showToast(
        msg: "Shared the note successfully", gravity: ToastGravity.TOP);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<PeopleResponse> getLocalData() async {
    return peopleList;
  }

  onItemChanged(String value) {
    setState(() {
      searchedPeopleList = peopleList.peopleResponse
          .where((val) =>
              val.firstName.toLowerCase().contains(value.toLowerCase()) ||
              val.lastName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          title: Text("Select Users"),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                selectedPeopleList.forEach((element) {
                  print(element.firstName + " " + element.lastName);
                });
                apiCall();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: StreamBuilder(
                stream: peopleList == null
                    ? _bloc
                        .fetchPeopleList(
                            departmentName: AppPreferences().deptmentName)
                        .asStream()
                    : getLocalData().asStream(),
                builder:
                    (BuildContext context, AsyncSnapshot<PeopleResponse> snp) {
                  if (snp.hasData) {
                    // if (snp > 199 && snp.data.status < 299) {
                    if (start == 0) {
                      snp.data.peopleResponse.forEach((e) {
                        checkedUsersList.add(false);
                      });
                      start = 1;
                    }
                    peopleList = snp.data;
                    if (controller.text.isEmpty) {
                      searchedPeopleList = peopleList.peopleResponse;
                      searchedPeopleList.sort((a, b) => a.firstName
                          .toLowerCase()
                          .compareTo(b.firstName.toLowerCase()));
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: onItemChanged,
                            controller: controller,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              prefixIcon: Icon(Icons.search),
                              labelText: "Search users",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                                "Selected ${selectedPeopleList.length} of ${peopleList.peopleResponse.length}"),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: searchedPeopleList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value:
                                                checkedUsersList[index] == null
                                                    ? false
                                                    : checkedUsersList[index],
                                            onChanged: (bool value) {
                                              if (!checkedUsersList[index]) {
                                                selectedPeopleList.add(
                                                    searchedPeopleList[index]);
                                              } else {
                                                var itemIndex =
                                                    selectedPeopleList
                                                        .indexWhere((element) =>
                                                            element
                                                                .employeeId ==
                                                            searchedPeopleList[
                                                                    index]
                                                                .employeeId);
                                                if (itemIndex >= 0) {
                                                  selectedPeopleList
                                                      .removeAt(itemIndex);
                                                  print(selectedPeopleList
                                                      .length);
                                                  selectedPeopleList.map((e) {
                                                    print(e.firstName +
                                                        " " +
                                                        e.lastName);
                                                  });
                                                }
                                              }
                                              setState(() {
                                                print("Inside the list check");
                                                checkedUsersList[index] =
                                                    !checkedUsersList[index];
                                              });
                                            },
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  searchedPeopleList[index]
                                                              .firstName !=
                                                          null
                                                      ? searchedPeopleList[
                                                                  index]
                                                              .firstName +
                                                          " " +
                                                          searchedPeopleList[
                                                                  index]
                                                              .lastName
                                                      : "",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      searchedPeopleList[index]
                                                                  .emailId !=
                                                              null
                                                          ? searchedPeopleList[
                                                                  index]
                                                              .emailId
                                                          : "",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey[700])),
                                                  Text(
                                                      searchedPeopleList[index]
                                                                  .mobileNo !=
                                                              null
                                                          ? searchedPeopleList[
                                                                  index]
                                                              .mobileNo
                                                          : "",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey[700])),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 2,
                                      color: Colors.grey[200],
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                    // } else {
                    //   return Container(
                    //     child: Text(snp.data.error),
                    //   );
                    // }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ));
  }
}
