/*

_showAddDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Calendar Event:'),
      content: TextFormField(
        decoration: new InputDecoration(
            labelText: 'Event Name', hintText: 'eg. SDX'
        ),
        controller: _eventController,
        keyboardType: TextInputType.multiline,
        maxLines: 1,
      ),

      actions: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              color: Colors.blueGrey,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  if (_eventController.text.isEmpty) return;
                  if (_events[_calendarController.selectedDay] != null) {
                    _events[_calendarController.selectedDay]
                        .add(_eventController.text);
                  } else {
                    _events[_calendarController.selectedDay] = [
                      _eventController.text
                    ];
                  }
                  prefs.setString('events', json.encode(encodeMap(_events)));
                  Navigator.of(context).pop();
                  _eventController.clear();
                });
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            FlatButton(
              color: Colors.grey,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ],
    ),
  );
}


*/

/*content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                decoration: new InputDecoration(
                    labelText: 'Event Name', hintText: 'eg. SDX'),
                controller: _eventController,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
              ),

            ),
            SizedBox(
              width: 10.0,
            ),
            //BasicTimeField(),
            new Expanded(
              child: new TextFormField(
                decoration: new InputDecoration(
                    labelText: 'Time', hintText: 'eg. SDX'),
                controller: _eventController,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
              ),

            ),
          ],
        ),*/
