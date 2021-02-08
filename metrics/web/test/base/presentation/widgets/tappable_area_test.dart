// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

import '../../../test_utils/finder_util.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("TappableArea", () {
    const hoveredColor = Colors.yellow;
    const defaultColor = Colors.red;
    const defaultCursor = SystemMouseCursors.click;

    final tappableAreaFinder = find.byType(TappableArea);

    Widget _builder(BuildContext context, bool isHovered, Widget child) {
      return DecoratedContainer(
        decoration: BoxDecoration(
          color: isHovered ? hoveredColor : defaultColor,
        ),
      );
    }

    void _defaultOnTap() {}

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const TappableAreaTestbed(builder: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "uses default mouse cursor if the mouse cursor is not specified",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TappableAreaTestbed(builder: _builder),
        );

        final tappableArea =
            tester.widget<TappableArea>(find.byType(TappableArea));

        expect(tappableArea.mouseCursor, equals(defaultCursor));
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
        const cursor = SystemMouseCursors.forbidden;

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
          TappableAreaTestbed(builder: _builder, onTap: _defaultOnTap),
        );

        final tappableArea = tester.widget<TappableArea>(tappableAreaFinder);

        expect(tappableArea.onTap, equals(_defaultOnTap));
      },
    );

    testWidgets(
      "applies the given on tap callback",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TappableAreaTestbed(builder: _builder, onTap: _defaultOnTap),
        );

        final gestureDetector =
            tester.widget<GestureDetector>(find.byType(GestureDetector));

        expect(gestureDetector.onTap, equals(_defaultOnTap));
      },
    );

    testWidgets(
      "applies the given hit test behavior",
      (WidgetTester tester) async {
        const hitTestBehavior = HitTestBehavior.opaque;

        await tester.pumpWidget(
          TappableAreaTestbed(
            builder: _builder,
            hitTestBehavior: hitTestBehavior,
          ),
        );

        final gestureDetector =
            tester.widget<GestureDetector>(find.byType(GestureDetector));

        expect(gestureDetector.behavior, hitTestBehavior);
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
  final HoverWidgetChildBuilder builder;

  /// How the [TappableArea] should behave during hit testing.
  final HitTestBehavior hitTestBehavior;

  /// Creates a new instance of the [TappableAreaTestbed].
  const TappableAreaTestbed({
    Key key,
    this.onTap,
    this.mouseCursor,
    this.builder,
    this.hitTestBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TappableArea(
          onTap: onTap,
          builder: builder,
          mouseCursor: mouseCursor,
          hitTestBehavior: hitTestBehavior,
        ),
      ),
    );
  }
}
