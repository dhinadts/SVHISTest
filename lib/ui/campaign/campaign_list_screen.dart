import '../../ui/advertise/adWidget.dart';
import '../../ui/campaign/api/campaign_api_client.dart';
import '../../ui/campaign/bloc/campaign_bloc.dart';
import '../../ui/campaign/campaign_inappwebview_screen.dart';
import '../../ui/campaign/repository/campaign_repository.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'bloc/campaign_bloc.dart';
import 'bloc/campaign_event.dart';

class CampaignListScreen extends StatefulWidget {
  final String title;
  const CampaignListScreen({Key key, this.title}) : super(key: key);
  @override
  _CampaignListScreenState createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  CampaignRepository campaignRepository;
  CampaignBloc _campaignBloc;

  @override
  void initState() {
    super.initState();
    campaignRepository = CampaignRepository(
        campaignApiClient: CampaignApiClient(httpClient: http.Client()));
    _campaignBloc = CampaignBloc(repository: campaignRepository);
    _campaignBloc.add(GetCampaignList(
        departmentName: AppPreferences().deptmentName,
        userName: AppPreferences().username));

    initializeAd();
  }

  void updateListData(bool isChangedData) {
    if (isChangedData != null && isChangedData) {
      _campaignBloc.add(GetCampaignList(
          departmentName: AppPreferences().deptmentName,
          userName: AppPreferences().username));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: widget.title, pageId: Constants.PAGE_ID_CAMPAIGN_LIST),
        body: BlocBuilder(
          bloc: _campaignBloc,
          builder: (BuildContext context, CampaignState state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.hasError) {
              return Container(
                child: Text('Error'),
              );
            }

            final campaignList = state.campaignList;

            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                      child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppUIDimens.paddingMedium),
                          child: Column(children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      onChanged: (data) {
                                        _campaignBloc.add(
                                            GetCampaignListSearch(query: data));
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Search by Name",
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        //fillColor: Colors.green
                                      ),
                                      keyboardType: TextInputType.text,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(
                                            RegExp('[0-9]')),
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

//              if (false)
                                ]),
                            (campaignList.length > 0)
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      _widgetTitle(context),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          color: Colors.grey,
                                        ),
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                                onTap: () async {
                                                  final refresh = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CampaignInAppWebViewScreen()));
                                                  updateListData(refresh);
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (index == 0)
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 5, 10, 5),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 0, 10, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${campaignList[index].formName}",
                                                                //getListItem(suggestionList[index]),
                                                                maxLines: 3,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                "Starts: ${campaignList[index].campaignStartDate}",
                                                                //getListItem(suggestionList[index]),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              Text(
                                                                "Ends: ${campaignList[index].campaignEndDate}",
                                                                //getListItem(suggestionList[index]),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      height: 1,
                                                      color:
                                                          AppColors.borderLine,
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      height: 5,
                                                      color: AppColors
                                                          .borderShadow,
                                                    ),
                                                  ],
                                                )),
                                        itemCount: campaignList.length,
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Container(
                                          child: Text("No record found"),
                                        ),
                                      ),
                                    ],
                                  )
                          ]))),
                ),

                /// Show Banner Ad
                getSivisoftAdWidget(),
              ],
            );
          },
        ));
  }

  Widget _widgetTitle(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 10, left: 10),
        decoration: BoxDecoration(
            color: AppColors.arrivedColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            )),
        child: SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 7,
            ),
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 5),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ))),
            SizedBox(
              height: 7,
            ),
          ],
        )),
      ),
    );
  }
}
