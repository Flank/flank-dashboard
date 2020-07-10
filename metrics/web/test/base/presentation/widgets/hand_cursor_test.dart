import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';

void main() {
  group("HandCursor", () {
    testWidgets("displays the given child", (WidgetTester tester) async {
      const child = Card();

      await tester.pumpWidget(const _HandCursorTestbed(child: child));

      expect(find.byWidget(child), findsOneWidget);
    });

    testWidgets(
      "displays the mouse region widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _HandCursorTestbed());

        expect(
          find.descendant(
            of: find.byType(HandCursor),
            matching: find.byType(MouseRegion),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "sets non-null on enter callback for the mouse region",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _HandCursorTestbed());

        final mouseRegion = tester.widget<MouseRegion>(
          find.descendant(
            of: find.byType(HandCursor),
            matching: find.byType(MouseRegion),
          ),
        );

        expect(mouseRegion.onEnter, isNotNull);
      },
    );

    testWidgets(
      "sets non-null on exit callback for the mouse region",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _HandCursorTestbed());

        final mouseRegion = tester.widget<MouseRegion>(
          find.descendant(
            of: find.byType(HandCursor),
            matching: find.byType(MouseRegion),
          ),
        );

        expect(mouseRegion.onExit, isNotNull);
      },
    );
  });
}

/// A testbed class needed to test the [HandCursor].
class _HandCursorTestbed extends StatelessWidget {
  /// A child widget of this widget the cursor has to be handled for.
  final Widget child;

  /// Creates the instance of this testbed.
  const _HandCursorTestbed({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HandCursor(
        child: child,
      ),
    );
  }
}
