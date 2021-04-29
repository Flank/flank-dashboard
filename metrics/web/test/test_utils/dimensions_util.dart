// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:universal_html/prefer_universal/html.dart';

/// A utility class provides an ability to configure dimension constraints
/// for testing widgets.
class DimensionsUtil {
  /// A [TestWidgetsFlutterBinding] used to configure tests.
  static final _testBinding = TestWidgetsFlutterBinding.ensureInitialized()
      as TestWidgetsFlutterBinding;

  /// A [Window] used in tests.
  static final _testWindow = _testBinding.window;

  /// Sets the window size for widget testing.
  ///
  /// Calculate the window size from given logical pixels
  /// in respect of the test device pixel ratio.
  static void setTestWindowSize({double width, double height}) {
    double windowWidth = _testWindow.physicalSize.width;
    double windowHeight = _testWindow.physicalSize.height;

    if (width != null) {
      windowWidth = width * _testWindow.devicePixelRatio;
    }

    if (height != null) {
      windowHeight = height * _testWindow.devicePixelRatio;
    }

    _testWindow.physicalSizeTestValue = Size(
      windowWidth,
      windowHeight,
    );
  }

  /// Resets the window size for widget testing to the default values.
  static void clearTestWindowSize() {
    _testWindow.clearPhysicalSizeTestValue();
  }
}
