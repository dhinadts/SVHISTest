import 'package:flutter/material.dart';

abstract class Bloc {
  BuildContext context;

  Bloc(this.context) {
    init();
  }

  /// Use to initialize bloc objects
  void init();

  /// To write Bloc objects state update
  void update() {}

  /// To write Bloc objects memory clear code.
  void dispose();
}
