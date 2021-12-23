import '../../../ui/hierarchical/model/sub_department_model.dart';
import '../../../ui/membership/model/membership_info.dart';
import '../../../ui/membership/widgets/member_list_widget_with_search.dart';
import '../../../ui_utils/app_colors.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  final SubDepartmentModel model;
  final ExpandableController mController;
  final int index;

  ExpandableWidget({this.model, this.mController, this.index});

  @override
  ExpandableWidgetState createState() => ExpandableWidgetState();
}

class ExpandableWidgetState extends State<ExpandableWidget> {
  ExpandableController expandableController = ExpandableController();
  TextEditingController controller = new TextEditingController();
  FocusNode focusNode = new FocusNode();
  List<MembershipInfo> membershipList = List();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.index == 0)
      setState(() {
        expandableController.expanded = true;
      });
    super.initState();
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
                key: Key(widget.model.createdOn),
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
                    ? MembershipListWidgetWithSearch(
                        widget.model.departmentName)
                    : Container())),
        Container(
            margin: EdgeInsets.only(top: 2, right: 25),
            child: IconButton(
              color: Colors.transparent,
              icon: Icon(expandableController.expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() {
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
