import '../../../login/utils/custom_progress_dialog.dart';
import '../../../ui/b2c/bloc/staticDetails_bloc.dart';
import '../../../ui/b2c/bloc/userDetails_bloc.dart';
import '../../../ui/b2c/model/category_model.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/network_check.dart';
import '../../../utils/constants.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../utils/app_preferences.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class ProfileCategoryTabScreen extends StatefulWidget {
  ProfileCategoryTabScreen(
      {this.dropDownCategoryList, this.isProfile, this.profileCategoryList});

  final List<DropdownMenuItem> dropDownCategoryList;
  final List<ProfileCategoryModel> profileCategoryList;
  final bool isProfile;

  @override
  _ProfileCategoryTabScreenState createState() =>
      _ProfileCategoryTabScreenState();
}

class _ProfileCategoryTabScreenState extends State<ProfileCategoryTabScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<String> subCategoryList = new List();
  List<DropdownMenuItem> dropDownSubCategoryList = new List();
  List<DropdownMenuItem> dropDownMatchedSubCategoryList = [];

  bool _autoValidate = false;

  bool isNewUser = false;

  bool update = false;
  bool isDuplicateCategory = false;

  TextEditingController categoryTypeController = new TextEditingController();
  TextEditingController subCategoryTypeController = new TextEditingController();

  List<ProfileCategoryModel> categoryList = new List();

  @override
  void initState() {
    // TODO: implement initState

    print(
        "Value of Prfoile Category List length ${widget.profileCategoryList.length}");

//    widget.profileCategoryList.forEach((element) {
//      categoryList.add(element);

    //  });
    getProfileCategoryList();
//    for (int i = 0; i < 30; i++) {
//      dropDownSubCategoryList.add(DropdownMenuItem(
//        child: Text(""),
//        value: "",
//      ));
//    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("Hello Pranay Value of category ${widget.profileCategoryList[0].categoryType} and Sub Category ${widget.profileCategoryList[0].subCategoryType} and length of list ${widget.profileCategoryList.length}");
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: addCategoryWidget(),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              height: MediaQuery.of(context).size.height * .60,
              width: MediaQuery.of(context).size.width * .9,
              child: categoryList.length > 0
                  ? ListView.builder(
                      itemCount: categoryList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return categoryData(categoryList[index]);
                      })
                  : Container(
                      height: MediaQuery.of(context).size.height * .1,
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("No data found"),
                      ),
                    )),
        ],
      ),
    );
  }

  Widget categoryData(ProfileCategoryModel category) {
    return Container(
      alignment: Alignment.centerLeft,
//      height: MediaQuery
//          .of(context)
//          .size
//          .height * .12,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.grey),
              // color: AppColors.borderShadow,
            ),
            alignment: Alignment.centerLeft,
            child: Container(
                width: MediaQuery.of(context).size.width * .88,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .74,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .74,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .22,
                                        child: Text("Category : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800)),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .50,
                                          child:
                                              Text("${category.categoryType}")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .74,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .27,
                                        child: Text("Subcategory : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800)),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .45,
                                          child: Text(
                                              "${category.subCategoryType}")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .07,
                        child: InkWell(
                            onTap: () {
                              deleteDailog(category.categoryType,
                                  category.subCategoryType);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      )
                    ],
                  ),
                )),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 0),
            height: 5,
            color: AppColors.borderShadow,
          ),
        ],
      ),
    );
  }

  Widget addCategoryWidget() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              //controller: expandableController,
              header: Container(
                width: double.infinity,
                height: 50,
                color: Colors.cyan[300],
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Category",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 0, bottom: 0, right: 15.0),
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey[500],
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: SearchableDropdown.single(
                                items: widget.dropDownCategoryList,
                                value: categoryTypeController.text,
                                hint: "Category type *",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                                searchHint: "Select Category",
                                underline: null,
                                onClear: () {
                                  setState(() {
//                                    print(
//                                        "Hello Pranay in clearing sub category list");
                                    int previousLength =
                                        dropDownSubCategoryList.length;
                                    dropDownSubCategoryList.clear();
                                    subCategoryTypeController.text = "";
//                                    List.generate(
//                                      previousLength,
//                                      (index) {
                                    dropDownSubCategoryList
                                        .add(DropdownMenuItem(
                                      child: Text(""),
                                      value: "",
                                    ));
//                                      },
//                                    );
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    if (value == null)
                                      categoryTypeController.text = "";
                                    else
                                      categoryTypeController.text = value;
//                                    print(
//                                        "selectedItem is ${categoryTypeController.text}");
                                    // dropDownSubCategoryList = new List();
                                    // subCategoryTypeController.clear();
                                    if (categoryTypeController
                                        .text.isNotEmpty) {
                                      getSubCategoryList(
                                          categoryTypeController.text,
                                          update: true);
                                    }
                                  });
                                },
                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints:
                                    BoxConstraints.tight(Size.fromHeight(350)),
                                validator: (_autoValidate)
                                    ? (selectedItemsForValidator) {
                                        if (selectedItemsForValidator == null) {
                                          return ("");
                                        }
                                        return (null);
                                      }
                                    : null,
                              ),
                            ),
                            (_autoValidate &&
                                    categoryTypeController.text.isEmpty)
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        Constants
                                            .VALIDATION_BLANK_CATEGORY_TYPE,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffD32F2F)),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 0, bottom: 0, right: 15.0),
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey[500],
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: SearchableDropdown.single(
//                                items: dropDownMatchedSubCategoryList.length > 0
//                                    ? dropDownMatchedSubCategoryList
//                                    : dropDownSubCategoryList,
                                items: dropDownSubCategoryList,

                                value: subCategoryTypeController.text,
                                hint: "Subcategory type *",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                                searchHint: "Search Subcategory",
                                underline: null,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == null)
                                      subCategoryTypeController.text = "";
                                    else
                                      subCategoryTypeController.text = value;
//                                    print(
//                                        "selectedItem is ${subCategoryTypeController.text}");
                                  });
                                },
                                dialogBox: true,
                                isExpanded: true,
//                                menuConstraints:
//                                    BoxConstraints.tight(Size.fromHeight(350)),
                                validator: (_autoValidate)
                                    ? (selectedItemsForValidator) {
                                        if (selectedItemsForValidator == null) {
                                          return ("");
                                        }
                                        return (null);
                                      }
                                    : null,
                              ),
                            ),
                            (_autoValidate &&
                                    subCategoryTypeController.text.isEmpty)
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        Constants
                                            .VALIDATION_BLANK_SUBCATEGORY_TYPE,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffD32F2F)),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 5,
                        color: AppColors.borderShadow,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          onPressed: () {
                            onSubmitClick();
                          },
                          color: AppColors.primaryColor,
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ],
        ),
      ),
    );
  }

  void onSubmitClick() {
    _validateInputsForNewRequest();
  }

  void _validateInputsForNewRequest() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (categoryTypeController.text.isNotEmpty &&
          subCategoryTypeController.text.isNotEmpty) {
        for (int i = 0; i < categoryList.length; i++) {
          if (categoryTypeController.text == categoryList[i].categoryType &&
              subCategoryTypeController.text ==
                  categoryList[i].subCategoryType) {
            isDuplicateCategory = true;
            break;
          }
        }
        if (isDuplicateCategory) {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Duplicate category cannot be added",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
          setState(() {
            isDuplicateCategory = false;
            // categoryTypeController = new TextEditingController();
          });
        } else {
          var connectivityResult = await NetworkCheck().check();
          if (connectivityResult) {
            apiCall();
          } else {
            Fluttertoast.showToast(
                timeInSecForIosWeb: 5,
                msg: Constants.NO_INTERNET_CONNECTION,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP);
          }
        }
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  apiCall() async {
    CustomProgressLoader.showLoader(context);

    UserDetailsBloc _bloc = new UserDetailsBloc(context);
    _bloc.addCategoryAndSubcategory(
        categoryTypeController.text, subCategoryTypeController.text);
    _bloc.addCategoryAndSubcategoryFetcher.listen((response) async {
      if (response.status == 200) {
        //   print("Hello Pranay connectSupplier is successful ${response.status}");

        getProfileCategoryList();

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Category added Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
      } else if (response.status == 404) {
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: response.error,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
      } else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: response?.error ?? AppPreferences().getApisErrorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }

  getSubCategoryList(String categoryType, {bool update: false}) async {
    var connectivityResult = await NetworkCheck().check();
    if (connectivityResult) {
      await getSubCategoryListApiCall(categoryType, update: update);
    } else {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: Constants.NO_INTERNET_CONNECTION,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  getSubCategoryListApiCall(String categoryType, {bool update: false}) {
    CustomProgressLoader.showLoader(context);

    StaticDetailsBloc staticDetailsBloc = StaticDetailsBloc(context);
    subCategoryList = new List();
    // dropDownMatchedSubCategoryList.clear();
//    setState(() {});

    staticDetailsBloc.fetchSubCategoryList(categoryType);
    staticDetailsBloc.subCategoryListFetcher.listen((value) async {
      //  print("Value of tags $value");
      dropDownSubCategoryList.clear();
      setState(() {
        value.forEach((element) {
          // itemsList.add(element);
          dropDownSubCategoryList.add(DropdownMenuItem(
            child: Text(element.toString()),
            value: element.toString(),
          ));
        });
      });
      subCategoryTypeController.text = value[0];
      CustomProgressLoader.cancelLoader(context);
    });
    //setState(() {});
    //CustomProgressLoader.cancelLoader(context);
  }

  deleteDailog(String categoryType, String subCategoryType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Are you sure you want to delete this \nCategory : $categoryType \nSubcategory : $subCategoryType ?",
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
                deleteRequestApiCall(categoryType, subCategoryType);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: new TextStyle(fontFamily: "customRegular"),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteRequestApiCall(String categoryType, String subCategoryType) async {
    // print("Hello Pranay Request is ready for deletion");
    CustomProgressLoader.showLoader(context);
    UserDetailsBloc _bloc = new UserDetailsBloc(context);
    _bloc.deleteCategoryAndSubcategory(categoryType, subCategoryType);
    _bloc.deleteCategoryAndSubcategoryFetcher.listen((response) async {
      if (response.status == 200) {
        getProfileCategoryList();
        //  print("Hello Pranay Request submission is successful");

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Deleted successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);

        CustomProgressLoader.cancelLoader(context);
      } else if (response.status == 404) {
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: response.error,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
      } else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: response?.error ?? AppPreferences().getApisErrorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }

  getProfileCategoryList() {
    UserDetailsBloc _userBloc = new UserDetailsBloc(context);

    categoryList = new List();
    _userBloc.fetchProfileCategoryList();
    _userBloc.profileCategoryListFetcher.listen((value) async {
      //  print("List of Profile Category length ${value.length}");

      // itemsList.add(element);

      value.forEach((element) {
        categoryList.add(element);
      });

      setState(() {});
    });
  }
}
