import 'package:flutter/material.dart';

class InitialInformationScreen extends StatefulWidget {
  @override
  _InitialInformationScreenState createState() =>
      _InitialInformationScreenState();
}

class _InitialInformationScreenState extends State<InitialInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information"),
      ),
      body: Container(
        child: Text("Requester Information"),
      ),
    );
  }
}
