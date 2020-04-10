import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/loading_placeholder.dart';

void main() {
  testWidgets(
    "Displays LoadingPlaceholder",
    (WidgetTester tester) async {
      Widget widget = MaterialApp(
        home: Scaffold(
          body: LoadingPlaceholder(),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
