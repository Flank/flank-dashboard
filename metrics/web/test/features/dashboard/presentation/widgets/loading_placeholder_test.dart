// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/widgets/loading_placeholder.dart';

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

class _LoadingPlaceholderTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoadingPlaceholder(),
      ),
    );
  }
}
