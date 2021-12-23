import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import '../../../../ui_utils/app_colors.dart';
import 'package:agora_rtc_engine/rtc_engine.dart' as rtcEngine;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

enum AnnotateMode { send, receive }

class Draw extends StatefulWidget {
  final AnnotateMode annotateMode;
  final rtcEngine.RtcEngine engine;
  final int rtcDataStreamId;
  final Function(List<Map<String, String>>) annotateCallback;
  final List<Map<String, String>> annotates;
  final StreamController<List<Map<String, String>>> annotateStream;

  const Draw({
    Key key,
    @required this.annotateMode,
    @required this.engine,
    @required this.rtcDataStreamId,
    @required this.annotateCallback,
    @required this.annotates,
    @required this.annotateStream,
  }) : super(key: key);

  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  List<Map<String, String>> totalPoints = List();
  List<Map<String, String>> tempPoints = List();

  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  bool showDrawTools = false;

  @override
  void initState() {
    if (widget.annotateMode == AnnotateMode.send) {
      Map<String, dynamic> messageBody = {};
      messageBody["event"] = "annotate";
      Map<String, dynamic> data = {};
      data["action"] = "open";
      messageBody["data"] = data;

      widget.engine
          .sendStreamMessage(widget.rtcDataStreamId, jsonEncode(messageBody));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: (showDrawTools)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.greenAccent),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.album),
                                onPressed: () {
                                  setState(() {
                                    if (selectedMode ==
                                        SelectedMode.StrokeWidth)
                                      showBottomList = !showBottomList;
                                    selectedMode = SelectedMode.StrokeWidth;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.opacity),
                                onPressed: () {
                                  setState(() {
                                    if (selectedMode == SelectedMode.Opacity)
                                      showBottomList = !showBottomList;
                                    selectedMode = SelectedMode.Opacity;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.color_lens),
                                onPressed: () {
                                  setState(() {
                                    if (selectedMode == SelectedMode.Color)
                                      showBottomList = !showBottomList;
                                    selectedMode = SelectedMode.Color;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    showBottomList = false;
                                    points.clear();
                                    tempPoints.clear();
                                    totalPoints.clear();
                                  });
                                }),
                          ],
                        ),
                        Visibility(
                          child: (selectedMode == SelectedMode.Color)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: getColorList(),
                                )
                              : Slider(
                                  value:
                                      (selectedMode == SelectedMode.StrokeWidth)
                                          ? strokeWidth
                                          : opacity,
                                  max:
                                      (selectedMode == SelectedMode.StrokeWidth)
                                          ? 50.0
                                          : 1.0,
                                  min: 0.0,
                                  onChanged: (val) {
                                    setState(() {
                                      if (selectedMode ==
                                          SelectedMode.StrokeWidth)
                                        strokeWidth = val;
                                      else
                                        opacity = val;
                                    });
                                  }),
                          visible: showBottomList,
                        ),
                      ],
                    ),
                  )),
            )
          : const SizedBox.shrink(),
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: !showDrawTools
                ? null
                : (details) {
                    debugPrint("onPanUpdate --> ${details.globalPosition}");
                    setState(() {
                      RenderBox renderBox = context.findRenderObject();
                      points.add(DrawingPoints(
                          points:
                              renderBox.globalToLocal(details.globalPosition),
                          paint: Paint()
                            ..strokeCap = strokeCap
                            ..isAntiAlias = true
                            ..color = selectedColor.withOpacity(opacity)
                            ..strokeWidth = strokeWidth));

                      Map<String, String> point = Map<String, String>();
                      point["dx"] =
                          details.globalPosition.dx.toStringAsFixed(2);
                      point["dy"] =
                          details.globalPosition.dy.toStringAsFixed(2);

                      debugPrint("point update --> $point");
                      //temp
                      tempPoints.add(point);
                    });
                  },
            onPanStart: !showDrawTools
                ? null
                : (details) {
                    debugPrint("onPanStart --> ${details.globalPosition}");
                    setState(() {
                      RenderBox renderBox = context.findRenderObject();
                      points.add(DrawingPoints(
                          points:
                              renderBox.globalToLocal(details.globalPosition),
                          paint: Paint()
                            ..strokeCap = strokeCap
                            ..isAntiAlias = true
                            ..color = selectedColor.withOpacity(opacity)
                            ..strokeWidth = strokeWidth));
                      //Temp
                      Map<String, String> point = Map<String, String>();
                      point["dx"] =
                          details.globalPosition.dx.toStringAsFixed(2);
                      point["dy"] =
                          details.globalPosition.dy.toStringAsFixed(2);

                      debugPrint("point start--> $point");
                      //temp
                      tempPoints.add(point);
                    });
                  },
            onPanEnd: !showDrawTools
                ? null
                : (details) {
                    debugPrint("onPanEnd -->");
                    setState(() {
                      points.add(null);
                      tempPoints.add(null);
                      totalPoints.addAll(tempPoints);
                    });
                    Map<String, dynamic> messageBody = {};
                    messageBody["event"] = "annotate";
                    Map<String, dynamic> data = {};
                    data['action'] = "draw";
                    data["offset"] = tempPoints;
                    messageBody["data"] = data;

                    debugPrint("messageBody --> ${jsonEncode(messageBody)}");

                    widget.engine.sendStreamMessage(
                        widget.rtcDataStreamId, jsonEncode(messageBody));
                    tempPoints.clear();
                  },
            child: widget.annotateMode == AnnotateMode.send
                ? CustomPaint(
                    size: Size.infinite,
                    painter: DrawingPainter(
                      pointsList: points,
                    ),
                  )
                : StreamBuilder<Object>(
                    stream: widget.annotateStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        RenderBox renderBox = context.findRenderObject();
                        List<Map<String, String>> annotates = snapshot.data;
                        annotates.forEach((element) {
                          double dx = double.parse(element["dx"]);
                          double dy = double.parse(element["dy"]);
                          Offset offset = Offset(dx, dy);
                          points.add(DrawingPoints(
                              points: renderBox.globalToLocal(offset),
                              paint: Paint()
                                ..strokeCap = strokeCap
                                ..isAntiAlias = true
                                ..color = selectedColor.withOpacity(opacity)
                                ..strokeWidth = strokeWidth));
                        });
                        points.add(null);
                      } else {
                        //messages = widget.messageBubbles;
                        RenderBox renderBox = context.findRenderObject();

                        widget.annotates.forEach((element) {
                          double dx = double.parse(element["dx"]);
                          double dy = double.parse(element["dy"]);
                          Offset offset = Offset(dx, dy);
                          points.add(DrawingPoints(
                              points: renderBox.globalToLocal(offset),
                              paint: Paint()
                                ..strokeCap = strokeCap
                                ..isAntiAlias = true
                                ..color = selectedColor.withOpacity(opacity)
                                ..strokeWidth = strokeWidth));
                        });
                        points.add(null);
                      }
                      return CustomPaint(
                        size: Size.infinite,
                        painter: DrawingPainter(
                          pointsList: points,
                        ),
                      );
                    }),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.annotateMode == AnnotateMode.send) {
                    Map<String, dynamic> messageBody = {};
                    messageBody["event"] = "annotate";
                    Map<String, dynamic> data = {};
                    data['action'] = "close";
                    messageBody["data"] = data;

                    widget.engine.sendStreamMessage(
                        widget.rtcDataStreamId, jsonEncode(messageBody));
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showDrawTools = !showDrawTools;
          });
        },
        child: Icon(Icons.mode_edit),
        backgroundColor: showDrawTools ? AppColors.primaryColor : Colors.grey,
      ),
    );
  }

  getColorList() {
    List<Widget> listWidget = List();
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                //enableLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() => selectedColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
