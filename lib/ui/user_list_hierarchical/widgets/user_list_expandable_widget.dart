import '../../../ui/hierarchical/model/sub_department_model.dart';
import '../../../ui/membership/model/membership_info.dart';
import '../../../ui/user_list_hierarchical/widgets/user_list_widget_with_search.dart';
import '../../../ui_utils/app_colors.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'user_list_searchbar.dart';

class UserListExpandableWidget extends StatefulWidget {
  final SubDepartmentModel model;
  final ExpandableController mController;
  final TextEditingController searchController;
  final int index;

  UserListExpandableWidget(
      {this.model, this.mController, this.index, this.searchController});

  @override
  UserListExpandableWidgetState createState() =>
      UserListExpandableWidgetState();
}

class UserListExpandableWidgetState extends State<UserListExpandableWidget> {
  ExpandableController expandableController = ExpandableController();
  TextEditingController controller = new TextEditingController();
  FocusNode focusNode = new FocusNode();
  List<MembershipInfo> membershipList = List();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.index == 0)
      setState(() {
        text = "";
        expandableController.expanded = true;
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    expandableController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return departmentTask();
  }

  Widget departmentTask() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: widget.index == 0
                        ? Theme.of(context)
                            .primaryColor //AppColors.arrivedColor
                        : AppColors.deliveredColor,
                    width: 2)),
            child: ExpandablePanel(
                key: Key(widget.model.departmentName),
                controller: expandableController,
                header: InkWell(
                    onTap: () {
                      setState(() {
                        expandableController.expanded =
                            !expandableController.expanded;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      height: 50,
                      padding: EdgeInsets.only(left: 10),
                      color: widget.index == 0
                          ? Theme.of(context)
                              .primaryColor //AppColors.arrivedColor
                          : AppColors.deliveredColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.index == 0)
                            Image.asset(
                              "assets/images/ic_head_office.png",
                            ),
                          SizedBox(width: 15),
                          Text(
                            "${widget.model.departmentName}",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )),
                expanded: expandableController.expanded
                    ? UserListWidgetWithSearch(
                        widget.model.departmentName,
                        searchController: widget.searchController,
                      )
                    : SizedBox.shrink())),
        Container(
            margin: EdgeInsets.only(top: 2, right: 25),
            child: IconButton(
              color: Colors.transparent,
              icon: Icon(expandableController.expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() {
                  text = "";
                  expandableController.expanded =
                      !expandableController.expanded;
                });
              },
            )),
      ],
    );
  }

  getColor() {
    return AppColors.arrivedColor;
  }
}
