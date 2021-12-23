import 'package:Memberly/bloc/people_list_bloc.dart';
import 'package:Memberly/model/people.dart';
import 'package:Memberly/ui/user_list_hierarchical/widgets/user_list_widget_with_search.dart';
import 'package:Memberly/ui_utils/ui_dimens.dart';
import 'package:Memberly/widgets/people_list_widget.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../ui/hierarchical/bloc/department_bloc.dart';
import '../../../ui/hierarchical/model/department_model.dart';
import '../../../ui/hierarchical/model/sub_department_model.dart';
import '../../../ui/tabs/app_localizations.dart';
import '../../../ui/user_list_hierarchical/widgets/user_list_expandable_widget.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/people_list_loading.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class HierarchicalUserListWidget extends StatefulWidget {
  @override
  HierarchicalUserListWidgetState createState() =>
      HierarchicalUserListWidgetState();
}

class HierarchicalUserListWidgetState
    extends State<HierarchicalUserListWidget> {
  DepartmentBloc _bloc;
  PeopleListBloc _blocPeople;
  List<ExpandableController> localExpandableControllerList = List();
  ExpandableController expandableController;
  var filterMenulist = List<PopupMenuEntry<Object>>();
  //final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final TextEditingController controller = TextEditingController();
  var peopleList = <People>[];
  List<People> peopleListForSubscriptionTemp = new List();
  bool showLoader = true;
  bool hideUserList = true;

  @override
  void initState() {
    mainSearchController.clear();
    for (int i = 0; i < 10; i++) {
      localExpandableControllerList.add(new ExpandableController());
    }
    _bloc = DepartmentBloc(context);
    initializeData();
    super.initState();

    _blocPeople = new PeopleListBloc(context);

    _blocPeople.peopleListFetcher.listen((value) {
      setState(() {
        showLoader = true;
      });
      if (value != null) {
        setState(() {
          peopleList = value.peopleResponse;
          hideUserList = false;
          showLoader = false;
        });
      }
    });
  }

  initializeData() async {
    _bloc.getDepartment();
  }

  @override
  void dispose() {
    super.dispose();
    // mainSearchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppUIDimens.paddingSmall),
                    child: TextFormField(
                      //focusNode: focusNode,
                      onChanged: (data) {
                        print(data);
                        if (data.length == 0) {
                          setState(() {
                            hideUserList = true;
                          });
                          print('::: Reset :::');
                          initializeData();
                        }
                      },
                      controller: mainSearchController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate("key_search_by_name"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                      ],
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
                ),

//              if (false)
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
                          mainSearchController.text.trim().length > 1) {
                        print(mainSearchController.text);
                        // callsearchapi();
                        setState(() {
                          showLoader = true;
                        });

                        peopleList.clear();
                        Future.delayed(Duration(seconds: 2), () {
                          _blocPeople.fetchPeopleListGlobal(
                            searchUsernameString: mainSearchController.text,
                          );
                          // if (peopleList.isEmpty || peopleList.length == 0) {
                          //   setState(() {
                          //     showLoader = false;
                          //   });
                          // }
                        });
                        setState(() {
                          // showLoader = true;
                          hideUserList = false;
                        });
                      } else {
                        if (mainSearchController.text.trim().length == 0) {
                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)
                                  .translate("key_entersometext"),
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_LONG);
                        }
                      }
                      print(mainSearchController.text);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (false)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: PopupMenuButton(
                      itemBuilder: (context) {
                        return filterMenulist;
                      },
                      onCanceled: () {},
                      onSelected: (value) {},
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
                    ),
                  ),
              ]),
            ),
            const SizedBox(
              width: 10,
            ),
            hideUserList
                ? StreamBuilder<DepartmentModel>(
                    stream: _bloc.departmentFetcher,
                    builder: (BuildContext context,
                        AsyncSnapshot<DepartmentModel> snapshot) {
                      if (snapshot.hasData) {
                        DepartmentModel response = snapshot.data;
                        if (ValidationUtils.isSuccessResponse(
                                response.status) &&
                            response.subDepartments.length > 0) {
                          SubDepartmentModel headDepartmentModel =
                              SubDepartmentModel.fromJson(
                                  snapshot.data.toJson());
                          List<SubDepartmentModel> deptModel = List();
                          deptModel.add(headDepartmentModel);
                          deptModel.addAll(response.subDepartments);

                          return ListView.builder(
                              itemCount: deptModel.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                TextEditingController controller =
                                    TextEditingController();
                                return UserListExpandableWidget(
                                  model: deptModel[index],
                                  index: index,
                                  searchController: controller,
                                );
                              });
                        }
                        return noRecordFoundWidget(response);
                      }
                      return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: PeopleListLoadingWidget());
                    })
                : peopleList.isEmpty || peopleList.length == 0
                    ? showLoader
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text("No Data Avaialable")
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: PeopleListWidget(peopleList, updateListData,
                            showBottomSheet: true,
                            isCameFromContactInfo: false,
                            usernameForContact: null,
                            isCameFromCoping: false,
                            isCameFromAddUserFamily: false,
                            isCameFromSubscription: false,
                            isCameFromDiabetesRiskScore: false,
                            constructingDataList: null,
                            isGlobalSearch: true, peopleListForSubscription:
                                (peopleListForSubscription) {
                          setState(() {
                            // print("length of peopleListForSubscription afterPeople list widget ${peopleListForSubscription.length}");
                            // print("Value of peopleListForSubscription afterPeople list widget ${peopleListForSubscription[0].userName}");

                            peopleListForSubscriptionTemp =
                                List.from(peopleListForSubscription);
                            // print("length of peopleListForSubscriptionTemp after copy list widget ${peopleListForSubscriptionTemp.length}");
                            //  peopleListForSubscription = peopleListForSubscription;
                            if ((peopleListForSubscriptionTemp.length + 0) >
                                25) {
                              Fluttertoast.showToast(
                                  msg: "Already added max number of users",
                                  gravity: ToastGravity.TOP,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          });
                        }),
                      ),
            SizedBox(
              height: 90,
            ),
          ],
        ),
      ),
    );
  }

  void updateListData(String userName) {}
  Widget noRecordFoundWidget(DepartmentModel response) {
    return Text(response.message != null && response.message.isNotEmpty
        ? response.message
        : AppLocalizations.of(context).translate("key_no_data_found"));
  }
}
