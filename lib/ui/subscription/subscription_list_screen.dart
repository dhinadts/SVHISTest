import '../../ui/custom_drawer/custom_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/subscription_response.dart';
import '../../model/subscriptions_model.dart';
import 'bloc/subscription_bloc.dart';
import 'subscription_list_widget.dart';
import '../tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../utils/app_preferences.dart';
import '../../widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class SubscriptionListScreen extends StatefulWidget {
  final String title;
  const SubscriptionListScreen({Key key, this.title}) : super(key: key);
  @override
  SubscriptionListScreenState createState() => SubscriptionListScreenState();
}

class SubscriptionListScreenState extends State<SubscriptionListScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SubscriptionBloc _bloc;
  SubscriptionResponse response;
  bool init = false;
  var controller = TextEditingController();
  @override
  void initState() {
    _bloc = SubscriptionBloc(context);
    _bloc.getSubscriptionList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: widget.title, pageId: null),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: TextFormField(
                        validator: (value) {
                          if (value.length > 0 && value.length < 2) {
                            return "Search string must be 2 characters";
                          } else if (value.length == 0) {
                            Fluttertoast.showToast(
                                msg: "Please enter text",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 5,
                                gravity: ToastGravity.TOP);
                          }
                        },
                        onChanged: (data) {
                          if (data.length == 0) {
                            _filter(data);
                          }
                        },
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: "Search by Subscription",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          //fillColor: Colors.green
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.blueGrey,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _filter(controller.text);
                              // _eventBloc.searchEventByName(searchController.text);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: _bloc.subscriptionListFetcher,
                  builder:
                      (context, AsyncSnapshot<SubscriptionResponse> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.subscriptionList.length > 0) {
                        if (!init) {
                          response = snapshot.data;
                          init = true;
                        }
                        return SubscriptionListWidget(
                          snapshot.data.subscriptionList,
                          onBackCall: (status) {
                            if (status) {
                              _bloc.getSubscriptionList();
                            }
                          },
                        );
                      } else {
                        return Text(searchQuery?.isNotEmpty
                            ? AppLocalizations.of(context)
                                .translate("key_no_record_found")
                            : AppLocalizations.of(context)
                                .translate("key_no_data_found"));
                      }
                    }
                    return ListLoading();
                  })
            ]))));
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      iconTheme: new IconThemeData(color: Colors.white),
      title: new Text(
        "Subscription List",
        style: AppPreferences().isLanguageTamil()
            ? TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
            : TextStyle(color: Colors.white),
      ),
      actions: <Widget>[],
    );
  }

  String searchQuery = "";

  _filter(String searchPeople) {
    setState(() {
      searchQuery = searchPeople;
    });
    // print("Search date is --> $searchPeople");
    List<SubscriptionsModel> filteredList = new List();
    for (final subscription in response.subscriptionList) {
      if (subscription.subscriptionName
          .toLowerCase()
          .contains(searchPeople.toLowerCase())) {
        filteredList.add(subscription);
      }
    }
    Map<String, dynamic> jsonMapData = new Map();
    try {
      jsonMapData.putIfAbsent("subscriptionList", () => filteredList);
      debugPrint("filtered peopleList - ${filteredList.toString()}");
    } catch (_) {
      // print("" + _);
    }
    SubscriptionResponse historyList = SubscriptionResponse();
    historyList.subscriptionList = filteredList;
    debugPrint("filtered peopleList - ${filteredList.toString()}");
    _bloc.subscriptionListFetcher.sink.add(historyList);
  }
}
