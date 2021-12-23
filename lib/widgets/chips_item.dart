import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';

///
class ChipsItem extends StatefulWidget {
  final ValueChanged<String> onChange;
  final List<String> options;
  final String name;

  ChipsItem({this.onChange, @required this.options, this.name});

  @override
  ChipsItemState createState() => ChipsItemState();
}

class ChipsItemState extends State<ChipsItem> {
  String _selectedValuesJson = 'Nothing to show';
  List<SelectionModel> _selectedLanguages;

  @override
  void initState() {
    _selectedLanguages = [];
    super.initState();
  }

  @override
  void dispose() {
    _selectedLanguages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlutterTagging<SelectionModel>(
            initialItems: _selectedLanguages,
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.blueAccent.withAlpha(30),
                hintText: 'Search ${widget.name}',
                labelText: 'Select ${widget.name}',
              ),
            ),
            findSuggestions: getLanguages,
            additionCallback: (value) {
              return SelectionModel(
                name: value,
                position: 0,
              );
            },
            onAdded: (language) {
              // api calls here, triggered when add to tag button is pressed
              return SelectionModel();
            },
            configureSuggestion: (lang) {
              return SuggestionConfiguration(
                title: Text(lang.name),
                //subtitle: Text(lang.position.toString()),
                additionWidget: Chip(
                  avatar: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  label: Text('Add New Tag'),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
              );
            },
            configureChip: (lang) {
              return ChipConfiguration(
                label: Text(lang.name),
                backgroundColor: Colors.blueAccent,
                labelStyle: TextStyle(color: Colors.white),
                deleteIconColor: Colors.white,
              );
            },
            onChanged: () {
              setState(() {
                _selectedValuesJson = _selectedLanguages
                    .map<String>((lang) => '\n${lang.toJson()}')
                    .toList()
                    .toString();
                _selectedValuesJson =
                    _selectedValuesJson.replaceFirst('}]', '}\n]');
              });
            },
          ),
        ),
      ],
    ));
  }

  Future<List<SelectionModel>> getLanguages(String query) async {
    await Future.delayed(Duration(milliseconds: 500), null);
    return setupSelectModel()
        .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<SelectionModel> setupSelectModel() {
    List<SelectionModel> returnList = List();
    for (int i = 0; i < widget.options.length; i++) {
      returnList.add(SelectionModel(name: widget.options[i], position: i + 1));
    }
    return returnList;
  }
}

/// Language Class
class SelectionModel extends Taggable {
  ///
  final String name;

  ///
  final int position;

  /// Creates Language
  SelectionModel({
    this.name,
    this.position,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $name,\n
    "position": $position\n
  }''';
}
