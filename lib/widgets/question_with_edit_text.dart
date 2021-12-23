import 'package:flutter/material.dart';

class QuestionWithEditText extends StatelessWidget {
  final String title;
  final ValueChanged<String> onChanged;

  QuestionWithEditText({this.title, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: EdgeInsets.only(left: 7, right: 10), child: Text(title)),
        SizedBox(
          height: 7,
        ),
        _textField(),
        SizedBox(
          height: 7,
        ),
      ],
    );
  }

  Widget _textField() {
    return Container(
        height: 45,
        child: new TextFormField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          keyboardType: TextInputType.text,
          onChanged: onChanged,
        ));
  }
}
