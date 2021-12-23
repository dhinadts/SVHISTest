import 'dart:math';
import 'dart:ui';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParticipantsScreen extends StatelessWidget {
  final List<int> participantsList;
  final List<String> participantsUserNameList;
  final List<int> participantsVideoMutedList;
  final List<int> participantsAudioMutedList;

  const ParticipantsScreen({
    Key key,
    this.participantsList,
    this.participantsUserNameList,
    this.participantsVideoMutedList,
    this.participantsAudioMutedList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: CupertinoPageScaffold(
        child: ListView.builder(
          itemCount: participantsList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: userNameAvatar(
                    participantsUserNameList[index].split(',')[0]),
                title: Text(
                  index == 0
                      ? '${participantsUserNameList[index]} (Me)'
                      : '${participantsUserNameList[index]}',
                  style: TextStyle(fontSize: 13),
                ),
                trailing: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        participantsAudioMutedList
                                .contains(participantsList[index])
                            ? Icons.mic_off
                            : Icons.mic,
                        color: participantsAudioMutedList
                                .contains(participantsList[index])
                            ? Colors.red
                            : Colors.grey,
                        size: 24.0,
                      ),
                      SizedBox(width: 6),
                      Icon(
                        participantsVideoMutedList
                                .contains(participantsList[index])
                            ? Icons.videocam_off
                            : Icons.videocam,
                        color: participantsVideoMutedList
                                .contains(participantsList[index])
                            ? Colors.red
                            : Colors.grey,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      middle: Center(
        child: Text(
          'Participants (${participantsList.length})',
          style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget userNameAvatar(String userAccountName) {
    return AvatarLetter(
      size: 34,
      backgroundColor:
          Colors.primaries[Random().nextInt(Colors.primaries.length)],
      textColor: Colors.white,
      fontSize: 14,
      upperCase: true,
      numberLetters: 2,
      letterType: LetterType.Circular,
      text: userAccountName,
      backgroundColorHex: null,
      textColorHex: null,
    );
  }
}
