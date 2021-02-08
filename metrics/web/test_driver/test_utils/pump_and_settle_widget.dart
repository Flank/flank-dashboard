// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// An extension on [WidgetTester] that provides an ability to render widget,
/// and wait until no frames scheduled.
extension PumpAndSettleWidget on WidgetTester {
  /// Renders the given [widget] and repeatedly calls [WidgetTester.pump] until
  /// there are no longer any frames scheduled.
  Future<void> pumpAndSettleWidget(
    Widget widget,
  ) async {
    await pumpWidget(widget);
    await pumpAndSettle();
  }
}
