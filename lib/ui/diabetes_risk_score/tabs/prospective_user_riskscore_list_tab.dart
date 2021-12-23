import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../ui_utils/ui_dimens.dart';
import '../../../widgets/loading_widget.dart';
import '../../tabs/app_localizations.dart';
import '../bloc/diabetes_risk_score_bloc.dart';
import '../bloc/diabetes_risk_score_event.dart';
import '../bloc/diabetes_risk_score_state.dart';
import '../diabetes_risk_score_screen.dart';
import '../widgets/prospects_risk_score_list_widget.dart';

class ProspectiveUserRiskscoreListTab extends StatefulWidget {
  final void Function(bool) updateCallback;

  const ProspectiveUserRiskscoreListTab(
      {Key key, @required this.updateCallback})
      : super(key: key);

  @override
  _ProspectiveUserRiskscoreListTabState createState() =>
      _ProspectiveUserRiskscoreListTabState();
}

class _ProspectiveUserRiskscoreListTabState
    extends State<ProspectiveUserRiskscoreListTab> {
  DiabetesRiskScoreBloc _diabetesRiskScoreBloc;
  var isDataLoaded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  bool init = false, searchableStringEntered = false;
  String searchQuery = "";
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _diabetesRiskScoreBloc = DiabetesRiskScoreBloc();
    initializeData();
  }

  void initializeData() {
    _diabetesRiskScoreBloc
        .add(GetHealthScoreHistoryListForProspects(controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppUIDimens.paddingXMedium),
          child: Column(
            children: [
              SizedBox(
                height: 30,
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
                        labelText: AppLocalizations.of(context)
                            .translate("key_search_by_name"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        //fillColor: Colors.green
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                      ],
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
                          _diabetesRiskScoreBloc.add(
                              GetHealthScoreHistoryListForProspects(
                                  controller.text));
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
              SizedBox(
                height: 20.0,
              ),
              BlocBuilder<DiabetesRiskScoreBloc, DiabetesRiskScoreState>(
                  bloc: _diabetesRiskScoreBloc,
                  builder:
                      (BuildContext context, DiabetesRiskScoreState state) {
                    if (state.isLoading) {
                      return ListLoading();
                    }
                    if (state.hasError) {
                      return Center(
                        child: Text('Error'),
                      );
                    }
                    if (state.healthScoreList.isNotEmpty) {
                      return ProspectsRiskScoreListWidget(
                        //people: null,
                        healthScore: state.healthScoreList,
                      );
                    }
                    return Center(
                      child: Text(AppLocalizations.of(context)
                          .translate("key_no_data_found")),
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child:  FloatingActionButton.extended(
          label: Text("Check for someone else"),
          onPressed: () async {
            final refresh = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => DiabetesRiskScoreScreen(
                  isProspect: true,
                ),
              ),
            );

            updateListData(refresh);
          },
        ),

//        child: Icon(Icons.add),
      ),
    );
  }

  void updateListData(bool isChangedData) {
    if (isChangedData != null && isChangedData) {
      isDataLoaded = false;
      widget.updateCallback(true);
      _diabetesRiskScoreBloc
          .add(GetHealthScoreHistoryListForProspects(controller.text));
    }
  }

  callSearchAPI() {
    // debugPrint("callSearchAPI ...");
    _formKey.currentState.validate();
    if (searchableStringEntered && controller.text.length == 0) {
      setState(() {
        searchableStringEntered = false;
      });
      _diabetesRiskScoreBloc
          .add(GetHealthScoreHistoryListForProspects(controller.text));
    }
  }
}
