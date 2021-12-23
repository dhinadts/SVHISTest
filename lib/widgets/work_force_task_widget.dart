import '../bloc/check_in_bloc.dart';
import '../bloc/work_force_task_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/work_force_task_model.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/ui_dimens.dart';
import '../utils/validation_utils.dart';
import '../widgets/drop_down_item.dart';
import '../widgets/loading_widget.dart';
import '../widgets/split_text_item.dart';
import '../widgets/time_picker_item.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class WorkForceTaskWidget extends StatefulWidget {
  final bool readOnly;
  final List<WorkForceTaskModel> models;
  final GlobalKey<FormState> formKey;
  final ValueChanged<List<WorkForceTaskModel>> onChanged;
  final ValueChanged<bool> onValidationCallBack;
  final ValueChanged<List<ExpandableController>> expandableControllerCallBack;
  final CheckInBloc bloc;

  WorkForceTaskWidget(
      {this.readOnly: false,
      this.onChanged,
      this.models,
      this.formKey,
      this.bloc,
      this.expandableControllerCallBack,
      this.onValidationCallBack});

  @override
  WorkForceTaskWidgetState createState() => WorkForceTaskWidgetState();
}

class WorkForceTaskWidgetState extends State<WorkForceTaskWidget> {
  List<WorkForceTaskModel> models;
  WorkForceTaskBloc _bloc;
  List<ExpandableController> localExpandableControllerList = List();
  ExpandableController expandableController = ExpandableController();

  @override
  void initState() {
    _bloc = WorkForceTaskBloc(context);
    if (widget.bloc != null) {
      widget.bloc.expandableControllerFetcher.listen((value) {
        localExpandableControllerList = value;
        setState(() {});
      });
    }
    models = List();
    if (widget.models != null) {
      setState(() {
        models = widget.models;
      });
    } else {
      models.add(WorkForceTaskModel());
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      _bloc.getWorkForceTask(models);
    });
    super.initState();
  }

  bool init = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      addTaskWidget(),
      StreamBuilder(
          stream: _bloc.workForceTaskFetcher,
          builder: (context, AsyncSnapshot<List<WorkForceTaskModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return taskForceWidget(index);
                },
              );
            } else {
              return ListLoading();
            }
          })
    ]);
  }

  Widget taskForceWidget(int index, {bool isNewRecord: false}) {
    if (index == localExpandableControllerList.length) {
      if (index > 0 && widget.models == null) {
        localExpandableControllerList[index - 1].expanded = false;
      }
      expandableController = ExpandableController();
      expandableController.expanded = true;
      localExpandableControllerList.add(expandableController);
      widget.expandableControllerCallBack(localExpandableControllerList);
    }
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: getColor(), width: 2)),
            child: ExpandablePanel(
                key: Key(models[index].taskId),
                controller: localExpandableControllerList[index],
                header: Container(
                  width: double.infinity,
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      "Task ${index + 1}",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                expanded: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    SplitTextItem("Task Name",
                        hideRulerLine: false,
                        defValue: models.length > index
                            ? models.elementAt(index)?.taskName
                            : null, onChange: (value) {
                      models[index]?.taskName = value;
                      widget.formKey.currentState.validate();
                      widget.onChanged(models);
                    }, validator: ValidationUtils.dynamicFieldsValidator),
                    SplitTextItem("Description",
                        hideRulerLine: false,
                        defValue: models.length > index
                            ? models.elementAt(index)?.description
                            : null, onChange: (value) {
                      models[index]?.description = value;
                      widget.formKey.currentState.validate();
                      widget.onChanged(models);
                    }, validator: ValidationUtils.dynamicFieldsValidator),
                    TimePickerItem("Start time",
                        hideRulerLine: false,
                        defValue: models.length > index
                            ? models.elementAt(index)?.startTime
                            : null, onChange: (value) {
                      models[index]?.startTime = value;
                      widget.formKey.currentState.validate();
                      widget.onChanged(models);
                    }, validator: ValidationUtils.dynamicFieldsValidator),
                    TimePickerItem("End time",
                        hideRulerLine: false,
                        defValue: models.length > index
                            ? models.elementAt(index)?.endTime
                            : null, onChange: (value) {
                      models[index]?.endTime = value;
                      widget.formKey.currentState.validate();
                      widget.onChanged(models);
                    }, validator: ValidationUtils.dynamicFieldsValidator),
                    DropDownItem(
                      "Status",
                      defValue: models.length > index
                          ? models.elementAt(index)?.status
                          : null,
                      onChange: (value) {
                        models[index]?.status = value;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        widget.formKey.currentState.validate();
                        widget.onChanged(models);
                      },
                      validator: (arg) {
                        if (models[index]?.status == null ||
                            models[index].status.isEmpty) {
                          return "Status is required";
                        }
                        return null;
                      },
                      dropDownItems: ["Pending", "Progress", "Completed"],
                    ),
                    SplitTextItem("Comment",
                        hideRulerLine: false,
                        defValue: models.length > index
                            ? models.elementAt(index)?.comments
                            : null, onChange: (value) {
                      models[index]?.comments = value;
                      widget.formKey.currentState.validate();
                      widget.onChanged(models);
                    }, validator: ValidationUtils.dynamicFieldsValidator),
                  ],
                ))
            /*])*/),
        if (index != 0)
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            padding: EdgeInsets.only(
                left: AppUIDimens.paddingXMedium,
                top: AppUIDimens.paddingSmall),
            onPressed: () {
              models.removeAt(index);
              widget.onChanged(models);
              localExpandableControllerList.removeAt(index);
              widget
                  .expandableControllerCallBack(localExpandableControllerList);
              setState(() {});
            },
          )
      ],
    );
  }

  Widget addTaskWidget() {
    return Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text("Task"),
            SizedBox(
              width: AppUIDimens.paddingMedium,
            ),
            InkWell(
                onTap: () {
                  if (widget.formKey.currentState.validate()) {
                    CustomProgressLoader.showLoader(context);
                    new Future.delayed(const Duration(milliseconds: 200), () {
                      CustomProgressLoader.cancelLoader(context);
                      widget.onValidationCallBack(false);
                      models.add(WorkForceTaskModel());
                      _bloc.getWorkForceTask(models);
                      setState(() {});
                    });
                  } else {
                    localExpandableControllerList[
                            localExpandableControllerList.length - 1]
                        .expanded = true;
                    widget.onValidationCallBack(true);
                  }
                },
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child:
                        Icon(Icons.add_circle, color: AppColors.arrivedColor)))
          ],
        ));
  }

  getColor() {
    if (widget.models == null) {
      return AppColors.arrivedColor;
    } else {
      return Colors.grey;
    }
  }
}
