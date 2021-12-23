import 'dart:async';
import 'package:flutter/material.dart';



class LogOutQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppRoot();
}

class AppRoot extends StatefulWidget {
  @override
  AppRootState createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _initializeTimer();
  }

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 3), (_) => _logOutUser);
  }

  void _logOutUser() {
    // Log out the user if they're logged in, then cancel the timer.
    // You'll have to make sure to cancel the timer if the user manually logs out
    //   and to call _initializeTimer once the user logs in
    _timer.cancel();
  }

  // You'll probably want to wrap this function in a debounce
  void _handleUserInteraction([_]) {
    if (!_timer.isActive) {
      // This means the user has been logged out
      return;
    }

    _timer.cancel();
    _initializeTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      // ... repeat this for all gesture events
      child: MaterialApp(
          // ... from here it's just your normal app,
          // Remember that any GestureDetector within your app must have
          //   HitTestBehavior.translucent
          ),
    );
  }
}
