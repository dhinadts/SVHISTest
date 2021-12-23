import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

class ComboBoxItem extends StatefulWidget {
  @override
  ComboBoxItemState createState() => ComboBoxItemState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final List<String> possibleValues;

  ComboBoxItem(
    this.name, {
    this.onChange,
    this.defValue,
    this.hideRulerLine: false,
    this.possibleValues,
  });
}

class ComboBoxItemState extends State<ComboBoxItem> {
  String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defValue;
    // print("_selectedValue --> $_selectedValue");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(widget.name)),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Wrap(
                children: [
                  for (var value in widget.possibleValues)
                    Row(
                      children: [
                        ChoiceChip(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          label: Text(value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (_selectedValue == value)
                                      ? Colors.white
                                      : Colors.black87)),
                          selectedColor: getChipColor(value),
                          backgroundColor: getChipColor(value),
                          selected: (_selectedValue == value) ? true : false,
                          // onSelected: (bool selected) {
                          //   setState(() {
                          //     _selectedValue = value;
                          //   });
                          // },
                          onSelected: widget.onChange == null
                              ? widget.onChange
                              : (bool selected) {
                                  setState(() {
                                    _selectedValue = value;
                                    widget.onChange(value);
                                  });
                                },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
        if (!widget.hideRulerLine)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: 5,
            color: AppColors.borderShadow,
          ),
      ],
    );
  }

  Color getChipColor(String option) {
    Color returnColor;
    for (var i = 0; i < widget.possibleValues.length; i++) {
      if (option == widget.possibleValues[i]) {
        switch (i) {
          case 0:
            returnColor = Colors.green;
            break;
          case 1:
            returnColor = Colors.yellow;
            break;
          case 2:
            returnColor = Colors.red[200];
            break;
          case 3:
            returnColor = Colors.red;
            break;
          default:
            returnColor = Colors.grey;
            break;
        }
      }
    }
    return returnColor;
  }
}
