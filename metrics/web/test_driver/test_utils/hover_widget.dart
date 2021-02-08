// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// An extension on [WidgetTester] that provides an ability to hover the widget.
extension HoverWidget on WidgetTester {
  /// Emulates hovering over the given [widgetFinder].
  Future<void> hoverWidget(
    Finder widgetFinder,
  ) async {
    final mouseRegion = firstWidget<MouseRegion>(
      find.descendant(
        of: widgetFinder,
        matching: find.byType(MouseRegion),
      ),
    );
    const pointerEvent = PointerEnterEvent();
    mouseRegion.onEnter(pointerEvent);
    await pumpAndSettle();
  }
}
