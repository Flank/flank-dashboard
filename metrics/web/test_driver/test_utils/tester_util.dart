import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A utility class that provides methods for interacting
/// with the [WidgetTester].
class TesterUtil {
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

  /// Renders the given [widget] and repeatedly calls [WidgetTester.pump] until
  /// there are no longer any frames scheduled.
  static Future<void> pumpAndSettleWidget(
    WidgetTester tester,
    Widget widget,
  ) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }
}
