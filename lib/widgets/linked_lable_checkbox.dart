import 'package:flutter/material.dart';

// ...

class LinkedLabelCheckbox extends StatelessWidget {
  const LinkedLabelCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onChanged(!value);
        },
        child: Ink(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: Checkbox(
                    value: value,
                    onChanged: (bool newValue) {
                      onChanged(newValue);
                    },
                  )),
              SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ));
  }
}
