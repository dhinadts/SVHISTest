import 'dart:io';

import '../model/people.dart';
import '../ui/advertise/adWidget.dart';
import '../ui/diagnosis/bloc/people_search_event.dart';
import '../ui/diagnosis/bloc/people_search_state.dart';
import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeopleSearch extends SearchDelegate<People> {
  final Bloc<PeopleSearchEvent, PeopleSearchState> peopleBloc;
  final String searchText;

  PeopleSearch({@required this.peopleBloc, @required this.searchText});

  bool isDataReceived = false;

  @override
  String get searchFieldLabel => 'Search by Name';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: theme.primaryTextTheme.headline6.color)),
      primaryColor: AppColors.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
      textTheme: theme.textTheme.copyWith(
        headline6: theme.textTheme.headline6
            .copyWith(color: theme.primaryTextTheme.headline6.color),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    initializeAd();
    return IconButton(
      icon: (Platform.isIOS)
          ? Icon(Icons.arrow_back_ios)
          : Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //return Container();
    return searchUser();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return searchUser();
  }

  Widget searchUser() {
    if (!isDataReceived) {
      query = searchText;
      isDataReceived = true;
      peopleBloc.add(GetPeople());
    }

    return BlocBuilder(
      bloc: peopleBloc,
      builder: (BuildContext context, PeopleSearchState state) {
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

        final suggestionList = query.isEmpty
            ? state.people
            : state.people
                .where((p) =>
                    getListItem(p).toLowerCase().contains(query.toLowerCase()))
                .toList();
        return Column(
          children: [
            Expanded(
              child: (suggestionList.length > 0)
                  ? Scrollbar(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey,
                        ),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            close(context, suggestionList[index]);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                if (index == 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        getListItem(suggestionList[index]),
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15),
                                      )
                                      // RichText(
                                      //   text: TextSpan(
                                      //     text: getListItem(suggestionList[index])
                                      //         .substring(0, query.length),
                                      //     style: TextStyle(
                                      //         color: Colors.red,
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 15),
                                      //     children: [
                                      //       TextSpan(
                                      //         text: getListItem(suggestionList[index])
                                      //             .substring(query.length),
                                      //         style: TextStyle(
                                      //             color: Colors.black87,
                                      //             fontSize: 15),
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                if (suggestionList[index].emailId != null &&
                                    suggestionList[index].emailId.isNotEmpty)
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child:
                                            Text(suggestionList[index].emailId),
                                      ),
                                    ],
                                  ),
                                if (suggestionList[index].mobileNo != null &&
                                    suggestionList[index].mobileNo.isNotEmpty)
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                            suggestionList[index].mobileNo),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        itemCount: suggestionList.length,
                      ),
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
                    ),
            ),

            /// Show Banner Ad
            getSivisoftAdWidget(),
          ],
        );
      },
    );
  }

  String getListItem(People people) {
    String resultStr = people.userFullName == null ? '' : people.userFullName;
    // if (people.emailId != null && people.emailId.isNotEmpty)
    //   resultStr += "\n" + people.emailId;

    // if (people.mobileNo != null && people.mobileNo.isNotEmpty)
    //   resultStr += "\n" + people.mobileNo;

    return resultStr;
  }
}
