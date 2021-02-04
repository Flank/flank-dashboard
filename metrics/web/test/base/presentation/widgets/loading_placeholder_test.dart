// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';

void main() {
  group("LoadingPlaceholder", () {
    testWidgets(
      "displays the centered CircularProgressIndicator",
      (WidgetTester tester) async {
        await tester.pumpWidget(_LoadingPlaceholderTestbed());

        final finder = find.descendant(
          of: find.byType(Center),
          matching: find.byType(CircularProgressIndicator),
        );

        expect(finder, findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [LoadingPlaceholder] widget.
class _LoadingPlaceholderTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LoadingPlaceholder(),
      ),
    );
  }
}
