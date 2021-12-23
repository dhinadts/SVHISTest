import 'dart:async';
import 'dart:convert';

import '../../../ui_utils/app_colors.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final RtcEngine engine;
  final int rtcDataStreamId;
  final Function(MessageBubble) messageBubbleCallback;
  final String userFullName;
  final List<MessageBubble> messageBubbles;
  final StreamController<List<MessageBubble>> messageStream;

  const ChatScreen({
    Key key,
    @required this.engine,
    @required this.rtcDataStreamId,
    @required this.messageBubbleCallback,
    @required this.userFullName,
    @required this.messageBubbles,
    @required this.messageStream,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String messageText;

  @override
  void initState() {
    super.initState();
    debugPrint("messageBubbles count --> ${widget.messageBubbles.length}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      middle: Center(
        child: Text(
          'Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Text(
            'Close',
            style: TextStyle(
              color: CupertinoTheme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: CupertinoPageScaffold(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: widget.messageStream.stream,
                  builder: (context, snapshot) {
                    List<MessageBubble> messages = [];
                    if (snapshot.data != null) {
                      messages = snapshot.data;
                    } else {
                      messages = widget.messageBubbles;
                    }
                    // Reverse the messeage list to scroll the listview automatically
                    List<MessageBubble> reversedMessages =
                        messages.reversed.toList();

                    return ListView.builder(
                      itemCount: reversedMessages.length,
                      reverse: true,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: reversedMessages[index],
                        );
                      },
                    );
                  },
                ),
              ),
              //Divider(height: 1),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(vertical: 4),
                //height: 50,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight:
                                150 //put here the max height to which you need to resize the textbox
                            ),
                        child: TextField(
                          maxLines: null,
                          style: TextStyle(fontSize: 14),
                          // textInputAction: TextInputAction.send,
                          controller: messageTextController,
                          onChanged: (value) {
                            setState(() {
                              messageText = value;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              hintText: "Send a message...",
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        onPressed: messageText != null && messageText.isNotEmpty
                            ? () async {
                                int streamId;
                                if (widget.rtcDataStreamId == null) {
                                  streamId = await widget.engine
                                      .createDataStream(true, true);
                                  debugPrint("streamId --> $streamId");
                                } else {
                                  streamId = widget.rtcDataStreamId;
                                  debugPrint("rtcDataStreamId --> $streamId");
                                }

                                if (streamId > 0) {
                                  messageTextController.clear();
                                  final messageBubble = MessageBubble(
                                    sender: widget.userFullName,
                                    text: messageText,
                                    isMe: true,
                                  );
                                  widget.messageBubbleCallback(messageBubble);

                                  Map<String, dynamic> messageBody = {};
                                  messageBody["event"] = "chat";
                                  Map<String, dynamic> data = {};
                                  data["type"] = "text";
                                  data["message"] = messageText;
                                  messageBody["data"] = data;

                                  widget.engine.sendStreamMessage(
                                      streamId, jsonEncode(messageBody));
                                }
                              }
                            : null,
                        child: Icon(
                          Icons.send,
                          color: messageText != null && messageText.isNotEmpty
                              ? Colors.white
                              : Colors.grey[300],
                          size: 20,
                        ),
                        backgroundColor:
                            messageText != null && messageText.isNotEmpty
                                ? Colors.blue
                                : Colors.grey,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Text(
              sender,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 10.0 : 0.0),
              topRight: Radius.circular(isMe ? 0.0 : 10.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            elevation: 5.0,
            color: isMe ? AppColors.kChatMeColor : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.black87 : Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
