import '../../../ui/hierarchical/bloc/department_bloc.dart';
import '../../../ui/hierarchical/model/department_model.dart';
import '../../../ui/hierarchical/model/sub_department_model.dart';
import '../../../ui/hierarchical/widget/expandable_widget.dart';
import '../../../ui/tabs/app_localizations.dart';
import '../../../utils/validation_utils.dart';
import '../../../widgets/people_list_loading.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class HierarchicalMembershipWidget extends StatefulWidget {
  @override
  HierarchicalMembershipWidgetState createState() =>
      HierarchicalMembershipWidgetState();
}

class HierarchicalMembershipWidgetState
    extends State<HierarchicalMembershipWidget> {
  DepartmentBloc _bloc;
  List<ExpandableController> localExpandableControllerList = List();
  ExpandableController expandableController;

  @override
  void initState() {
    // TODO: implement initState
    for (int i = 0; i < 10; i++) {
      localExpandableControllerList.add(new ExpandableController());
    }
    _bloc = DepartmentBloc(context);
    initializeData();
    super.initState();
  }

  initializeData() async {
    _bloc.getDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          StreamBuilder<DepartmentModel>(
              stream: _bloc.departmentFetcher,
              builder: (BuildContext context,
                  AsyncSnapshot<DepartmentModel> snapshot) {
                if (snapshot.hasData) {
                  DepartmentModel response = snapshot.data;
                  if (ValidationUtils.isSuccessResponse(response.status) &&
                      response.subDepartments.length > 0) {
                    SubDepartmentModel headDepartmentModel =
                        SubDepartmentModel.fromJson(snapshot.data.toJson());
                    List<SubDepartmentModel> deptModel = List();
                    deptModel.add(headDepartmentModel);
                    deptModel.addAll(response.subDepartments);
                    return ListView.builder(
                        itemCount: deptModel.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return ExpandableWidget(
                            model: deptModel[index],
                            index: index,
                          );
                        });
                  }
                  return noRecordFoundWidget(response);
                }
                return Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: PeopleListLoadingWidget());
              }),
          SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }

  Widget noRecordFoundWidget(DepartmentModel response) {
    return Text(response.message != null && response.message.isNotEmpty
        ? response.message
        : AppLocalizations.of(context).translate("key_no_data_found"));
  }
}
