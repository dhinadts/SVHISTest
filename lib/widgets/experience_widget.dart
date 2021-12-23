import '../bloc/work_force_task_bloc.dart';
import '../login/utils/custom_progress_dialog.dart';
import '../model/work_force_task_model.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/ui_dimens.dart';
import '../utils/validation_utils.dart';
import '../widgets/loading_widget.dart';
import '../widgets/split_text_item.dart';
import '../widgets/time_picker_item.dart';
import 'package:flutter/material.dart';

class ExperienceWidget extends StatefulWidget {
  final bool readOnly;
  final List<WorkForceTaskModel> model;
  final GlobalKey<FormState> formKey;
  final ValueChanged<List<WorkForceTaskModel>> onChanged;
  final ValueChanged<bool> onValidationCallBack;

  ExperienceWidget(
      {this.readOnly: false,
      this.onChanged,
      this.model,
      this.formKey,
      this.onValidationCallBack});

  @override
  ExperienceWidgetState createState() => ExperienceWidgetState();
}

class ExperienceWidgetState extends State<ExperienceWidget> {
  List<WorkForceTaskModel> models;
  WorkForceTaskBloc _bloc;
  final GlobalKey<FormState> localFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _bloc = WorkForceTaskBloc(context);
    models = List();
    if (widget.model != null) {
      setState(() {
        models = widget.model;
      });
    } else {
      models.add(WorkForceTaskModel());
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      _bloc.getWorkForceTask(models);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: localFormKey,
        child: Column(children: [
          (widget.model == null)
              ? addTaskWidget()
              : SizedBox(
                  height: 10,
                ),
          StreamBuilder(
              stream: _bloc.workForceTaskFetcher,
              builder:
                  (context, AsyncSnapshot<List<WorkForceTaskModel>> snapshot) {
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
        ]));
  }

  Widget taskForceWidget(int index, {bool isNewRecord: false}) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: getColor(), width: 2)),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 15, top: 10),
                color: getColor(),
                child: Stack(alignment: Alignment.centerRight, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Experience ${index + 1}",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ],
                  ),
                  if (index + 1 != 1)
                    InkWell(
                        onTap: () {
                          if (models.length > 1) {
                            CustomProgressLoader.showLoader(context);
                            new Future.delayed(
                                const Duration(milliseconds: 200), () {
                              CustomProgressLoader.cancelLoader(context);
                              // print(
                              // "Removed Index $index  Total ${models.length}");
                              models.removeAt(index);

                              // print("After removed Total ${models.length}");
                              setState(() {});
                              _bloc.getWorkForceTask(null);
                              _bloc.getWorkForceTask(models);
                            });
                          } else {
                            widget.onValidationCallBack(true);
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            )))
                ])),
            SizedBox(
              height: 10,
            ),
            SplitTextItem("Company",
                hideRulerLine: false,
                defValue:
                    models.length > index ? models[index]?.taskName : null,
                onChange: widget.readOnly ? null : (value) {},
                validator: ValidationUtils.dynamicFieldsValidator),
            SplitTextItem("Job Title",
                hideRulerLine: false,
                defValue:
                    models.length > index ? models[index]?.description : null,
                onChange: widget.readOnly ? null : (value) {},
                validator: ValidationUtils.dynamicFieldsValidator),
            TimePickerItem("From",
                hideRulerLine: false,
                defValue:
                    models.length > index ? models[index]?.startTime : null,
                onChange: widget.readOnly ? null : (value) {},
                validator: ValidationUtils.dynamicFieldsValidator),
            TimePickerItem("To",
                hideRulerLine: false,
                defValue: models.length > index ? models[index]?.endTime : null,
                onChange: widget.readOnly ? null : (value) {},
                validator: ValidationUtils.dynamicFieldsValidator),
            SplitTextItem(
              "Location",
              hideRulerLine: false,
              defValue: models.length > index ? models[index]?.comments : null,
              onChange: widget.readOnly ? null : (value) {},
              /*validator: ValidationUtils.dynamicFieldsValidator*/
            ),
          ],
        ));
  }

  Widget addTaskWidget() {
    return Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text("Experience"),
            SizedBox(
              width: AppUIDimens.paddingMedium,
            ),
            InkWell(
                onTap: () {
                  if (localFormKey.currentState.validate()) {
                    CustomProgressLoader.showLoader(context);
                    new Future.delayed(const Duration(milliseconds: 200), () {
                      CustomProgressLoader.cancelLoader(context);
                      //widget.onValidationCallBack(false);
                      models.add(WorkForceTaskModel());
                      _bloc.getWorkForceTask(models);
                      setState(() {});
                    });
                  } else {
                    //widget.onValidationCallBack(true);
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
    if (widget.model == null) {
      return AppColors.arrivedColor;
    } else {
      return Colors.grey;
    }
  }
}
