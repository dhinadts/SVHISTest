import '../../ui/advertise/adWidget.dart';
import 'package:flutter/material.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../utils/constants.dart';

class SmartNoteTextShowScreen extends StatefulWidget {
  final String noteTitle;
  final String noteComment;

  SmartNoteTextShowScreen({
    this.noteTitle,
    this.noteComment,
  });

  @override
  State<StatefulWidget> createState() {
    return _NotesState();
  }
}

class _NotesState extends State<SmartNoteTextShowScreen> {
  @override
  void initState() {
    super.initState();

    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noteCommentController = TextEditingController();
    noteCommentController.text = widget.noteComment;
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.noteTitle.length == 0 ? 'Text' : widget.noteTitle,
        pageId: Constants.PAGE_ID_SMART_NOTE,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(1.0),
              ),
              child: TextField(
                readOnly: true,
                maxLines: null,
                controller: noteCommentController,
                decoration: null,
                style: TextStyle(fontSize: 16.0),
                // decoration: InputDecoration(
                //   contentPadding: EdgeInsets.all(10.0),
                // ),
              ),
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }
}
