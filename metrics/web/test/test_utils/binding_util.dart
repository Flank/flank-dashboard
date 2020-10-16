import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

/// A utility class that provides an easy way of interaction
/// with the [TestWidgetsFlutterBinding].
class BindingUtil {
  /// Sets the platform brightness to the given [brightness].
  static void setPlatformBrightness(
    WidgetTester tester,
    Brightness brightness,
  ) {
    final testBinding = tester.binding;
    testBinding.window.platformBrightnessTestValue = brightness;
  }
}
