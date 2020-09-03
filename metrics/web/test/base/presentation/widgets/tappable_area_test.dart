import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/constants/mouse_cursor.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

import '../../../test_utils/finder_util.dart';

void main() {
  const hoveredColor = Colors.yellow;
  const defaultColor = Colors.red;

  Widget _builder(bool isHovered) {
    return DecoratedContainer(
      decoration: BoxDecoration(
        color: isHovered ? hoveredColor : defaultColor,
      ),
    );
  }

  void onTap() {}

  final tappableAreaFinder = find.byType(TappableArea);

  group("TappableArea", () {
    testWidgets(
      "throws an assertion error if the given builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const TappableAreaTestbed(builder: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "creates an instance with the given builder value",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TappableAreaTestbed(builder: _builder),
        );

        final tappableArea = tester.widget<TappableArea>(tappableAreaFinder);

        expect(tappableArea.builder, equals(_builder));
      },
    );

    testWidgets(
      "creates an instance with the given cursor value",
      (WidgetTester tester) async {
        const cursor = MouseCursor.forbidden;

        await tester.pumpWidget(
          TappableAreaTestbed(
            builder: _builder,
            mouseCursor: cursor,
          ),
        );

        final tappableArea = tester.widget<TappableArea>(tappableAreaFinder);

        expect(tappableArea.mouseCursor, equals(cursor));
      },
    );

    testWidgets(
      "creates an instance with the given onTap value",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TappableAreaTestbed(builder: _builder, onTap: onTap),
        );

        final tappableArea = tester.widget<TappableArea>(tappableAreaFinder);

        expect(tappableArea.onTap, equals(onTap));
      },
    );

    testWidgets(
      "applies the given on tap callback",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TappableAreaTestbed(builder: _builder, onTap: onTap),
        );

        final gestureDetector =
            tester.widget<GestureDetector>(find.byType(GestureDetector));

        expect(gestureDetector.onTap, equals(onTap));
      },
    );

    testWidgets(
      "builds the given widget according to the given builder",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TappableAreaTestbed(builder: _builder),
        );

        final decoration = FinderUtil.findBoxDecoration(tester);
        expect(decoration.color, equals(defaultColor));
      },
    );

    testWidgets(
      "rebuilds the given widget according to the given builder when the area is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TappableAreaTestbed(
            builder: _builder,
          ),
        );

        final mouseRegion = tester.firstWidget<MouseRegion>(
          find.ancestor(
            of: find.byType(GestureDetector),
            matching: find.byType(MouseRegion),
          ),
        );

        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await tester.pump();

        final decoration = FinderUtil.findBoxDecoration(tester);
        expect(decoration.color, equals(hoveredColor));
      },
    );
  });
}

/// A testbed class needed to test the [TappableArea] widget.
class TappableAreaTestbed extends StatelessWidget {
  /// A callback that is called when the area is tapped.
  final VoidCallback onTap;

  /// A cursor that is used when the area is hovered.
  final MouseCursor mouseCursor;

  /// A widget builder that builds the given widget differently depending on
  /// if the this area is hovered.
  final Widget Function(bool) builder;

  /// Creates a new [TappableAreaTestbed] instance.
  const TappableAreaTestbed({
    Key key,
    this.onTap,
    this.mouseCursor,
    this.builder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TappableArea(
          onTap: onTap,
          builder: builder,
          mouseCursor: mouseCursor,
        ),
      ),
    );
  }
}
