import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:metrics/main.dart';

/// Duplicated app.dart from driver_tests as the app is not running from
/// test_driver
void main() {
  enableFlutterDriverExtension();

  runApp(MyApp());
}
