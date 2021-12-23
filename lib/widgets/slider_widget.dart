import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  int value, min, max;
  final ValueChanged<int> onChange;
  final String unit;

  SliderWidget(this.value, {this.min, this.max, this.onChange, this.unit});

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(
              widget.value.toString(),
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                  color: widget.onChange != null
                      ? Colors.black
                      : Colors.grey[400]),
            ),
            Text(
              " ${widget.unit}",
              style: TextStyle(
                  color: widget.onChange != null
                      ? Colors.black
                      : Colors.grey[400]),
            )
          ],
        ),
        Slider(
          value: widget.value.toDouble(),
          min: widget.min.toDouble(),
          max: widget.max.toDouble(),
          activeColor:
              widget.onChange == null ? Colors.grey[400] : Colors.blueAccent,
          onChanged: (double value) {
            setState(() {
              if (widget.onChange != null) {
                widget.value = value.toInt();
                widget.onChange(value.toInt());
              }
            });
          },
        ),
      ],
    );
  }
}
