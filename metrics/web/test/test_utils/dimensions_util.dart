import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

/// A utility class provides an ability to configure dimension constraints for testing widgets.
class DimensionsUtil {
  /// Sets the window size for widget testing.
  ///
  /// Calculate the window size from given logical pixels
  /// in respect of the test device pixel ratio.
  static void setTestWindowSize({double width, double height}) {
    final testBinding = TestWidgetsFlutterBinding.ensureInitialized()
        as TestWidgetsFlutterBinding;
    final testWindow = testBinding.window;

    double windowWidth = testWindow.physicalSize.width;
    double windowHeight = testWindow.physicalSize.height;

    if (width != null) {
      windowWidth = width * testWindow.devicePixelRatio;
    }

    if (height != null) {
      windowHeight = height * testWindow.devicePixelRatio;
    }

    testWindow.physicalSizeTestValue = Size(
      windowWidth,
      windowHeight,
    );
  }

  /// Resets the window size for widget testing to the default values.
  static void clearTestWindowSize() {
    final testBinding = TestWidgetsFlutterBinding.ensureInitialized()
        as TestWidgetsFlutterBinding;
    final testWindow = testBinding.window;

    testWindow.clearPhysicalSizeTestValue();
  }
}
