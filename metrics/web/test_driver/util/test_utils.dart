import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A utility class that provides methods for integration tests.
class TestUtils {
  /// Emulates hovering over the given [widgetFinder].
  static Future<void> hoverWidget(
    WidgetTester tester,
    Finder widgetFinder,
  ) async {
    final mouseRegion = tester.firstWidget<MouseRegion>(
      find.descendant(
        of: widgetFinder,
        matching: find.byType(MouseRegion),
      ),
    );
    const pointerEvent = PointerEnterEvent();
    mouseRegion.onEnter(pointerEvent);
    await tester.pumpAndSettle();
  }
}
