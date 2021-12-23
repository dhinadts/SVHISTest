import '../ui_utils/app_colors.dart';
import '../ui_utils/ui_dimens.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/validation_utils.dart';
import '../widgets/split_text_item.dart';
import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<dynamic> choiceList;
  final List<dynamic> selectedList;
  final String displayName;
  final bool readOnly;
  final Function(List<dynamic>) onSelectionChanged; // +added
  MultiSelectChip(this.displayName,
      {this.choiceList,
      this.selectedList,
      this.onSelectionChanged,
      this.readOnly: false});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<dynamic> selectedChoices = List();

  @override
  void initState() {
    if (widget.selectedList != null && widget.selectedList.length > 0) {
      setState(() {
        selectedChoices = widget.selectedList;
      });
    } else {
      selectedChoices = [];
      widget.onSelectionChanged(selectedChoices); // +added
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(widget.displayName)),
        Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Wrap(
              children: _buildChoiceList(),
            )),
        Container(
          width: double.infinity,
          height: 5,
          margin: EdgeInsets.symmetric(horizontal: AppUIDimens.paddingMedium),
          color: AppColors.borderShadow,
        ),
      ],
    );
  }

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.choiceList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(
            item,
            style: TextStyle(color: Colors.black),
          ),
          selected: selectedChoices.contains(item),
          avatar: selectedChoices.contains(item)
              ? Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 17,
                  ))
              : null,
          backgroundColor: Colors.grey[300],
          selectedColor: Colors.grey[300],
          onSelected: widget.readOnly
              ? null
              : (selected) {
                  setState(() {
                    selectedChoices.contains(item)
                        ? selectedChoices.remove(item)
                        : selectedChoices.add(item);
                    if (!selectedChoices.contains("Others")) {
                      removeUnWantedValue();
                    }
                    widget.onSelectionChanged(selectedChoices); // +added
                  });
                },
        ),
      ));

      if (selectedChoices.contains("Others") &&
          item.toLowerCase() == "Others".toLowerCase())
        choices.add(Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: SplitTextItem("Others",
                defValue: doseNotContains(),
                onSaved: (s) {
                  selectedChoices.add(s);
                  widget.onSelectionChanged(selectedChoices);
                },
                onChange: widget.readOnly
                    ? null
                    : (s) {
                        removeUnWantedValue();
                        // print("Onchange ");
                      },
                validator: (arg) {
                  return ValidationUtils.dynamicFieldsValidator(arg,
                      errorMessage: "Others is required");
                },
                hideRulerLine: true,
                hideCounterText: true,
                decoration: WidgetStyles.heightAndWeightDecoration())));
    });
    return choices;
  }

  doseNotContains() {
    for (String selectedValue in selectedChoices) {
      bool isAvailable = false;
      for (String arg in widget.choiceList) {
        if (selectedValue == arg) {
          isAvailable = true;
        }
      }
      if (!isAvailable) {
        return selectedValue;
      }
    }
    return "";
  }

  removeUnWantedValue() {
    List<dynamic> temp = List();
    for (String selectedValue in selectedChoices) {
      bool isAvailable = false;
      for (String arg in widget.choiceList) {
        if (selectedValue == arg) {
          isAvailable = true;
        }
      }
      if (!isAvailable) {
        temp.add(selectedValue);
      }
    }
    selectedChoices.removeWhere((e) => temp.contains(e));
    return "";
  }
}
