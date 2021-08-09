// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/material_container.dart';

void main() {
  group("MaterialContainer", () {
    Finder findMaterialByPredicate(bool Function(Material widget) predicate) {
      return find.byWidgetPredicate(
        (widget) => widget is Material && predicate(widget),
      );
    }

    testWidgets(
      "throws an AssertionError if the given padding is null",
      (tester) async {
        await tester.pumpWidget(const _MaterialContainerTestbed(
          padding: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given type is null",
      (tester) async {
        await tester.pumpWidget(const _MaterialContainerTestbed(
          type: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given elevation is null",
      (tester) async {
        await tester.pumpWidget(const _MaterialContainerTestbed(
          elevation: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given elevation less than 0",
      (tester) async {
        await tester.pumpWidget(const _MaterialContainerTestbed(
          elevation: -1.0,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given child",
      (tester) async {
        const child = SizedBox();

        await tester.pumpWidget(const _MaterialContainerTestbed(
          child: child,
        ));

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given padding",
      (tester) async {
        const padding = EdgeInsets.all(8.0);

        await tester.pumpWidget(const _MaterialContainerTestbed(
          padding: padding,
        ));

        final paddingWidget = tester.widget<Padding>(find.byType(Padding));

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given type",
      (tester) async {
        const type = MaterialType.card;

        await tester.pumpWidget(const _MaterialContainerTestbed(
          type: type,
        ));

        final materialWidgetFinder = findMaterialByPredicate(
          (widget) => widget.type == type,
        );

        expect(materialWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given elevation",
      (tester) async {
        const elevation = 10.0;

        await tester.pumpWidget(const _MaterialContainerTestbed(
          elevation: elevation,
        ));

        final materialWidgetFinder = findMaterialByPredicate(
          (widget) => widget.elevation == elevation,
        );

        expect(materialWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given background color",
      (tester) async {
        const backgroundColor = Colors.grey;

        await tester.pumpWidget(const _MaterialContainerTestbed(
          backgroundColor: backgroundColor,
        ));

        final materialWidgetFinder = findMaterialByPredicate(
          (widget) => widget.color == backgroundColor,
        );

        expect(materialWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given shadow color",
      (tester) async {
        const shadowColor = Colors.grey;

        await tester.pumpWidget(const _MaterialContainerTestbed(
          shadowColor: shadowColor,
        ));

        final materialWidgetFinder = findMaterialByPredicate(
          (widget) => widget.shadowColor == shadowColor,
        );

        expect(materialWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given border radius",
      (tester) async {
        const borderRadius = BorderRadius.all(Radius.zero);

        await tester.pumpWidget(const _MaterialContainerTestbed(
          borderRadius: borderRadius,
        ));

        final materialWidgetFinder = findMaterialByPredicate(
          (widget) => widget.borderRadius == borderRadius,
        );

        expect(materialWidgetFinder, findsOneWidget);
      },
    );
  });
}

/// A testbed class needed to test the [MaterialContainer] widget.
class _MaterialContainerTestbed extends StatelessWidget {
  /// A [Widget] below the [MaterialContainer] in the widget tree.
  final Widget child;

  /// An [EdgeInsets] to apply to the [MaterialContainer].
  final EdgeInsets padding;

  /// A [MaterialType] of the [MaterialContainer] widget.
  final MaterialType type;

  /// A z-coordinate at which to place the [MaterialContainer] widget related to
  /// it's parents.
  final double elevation;

  /// A background [Color] of the [MaterialContainer] widget.
  final Color backgroundColor;

  /// A [Color] of the [MaterialContainer]'s shadow.
  final Color shadowColor;

  /// A [BorderRadiusGeometry] of the [MaterialContainer] widget.
  final BorderRadiusGeometry borderRadius;

  /// Creates a new instance of the [_MaterialContainerTestbed] with the given
  /// parameters.
  ///
  /// The [padding] defaults to [EdgeInsets.zero].
  /// The [type] defaults to [MaterialType.canvas].
  /// The [elevation] defaults to `0.0`.
  const _MaterialContainerTestbed({
    Key key,
    this.child,
    this.padding = EdgeInsets.zero,
    this.type = MaterialType.canvas,
    this.elevation = 0.0,
    this.backgroundColor,
    this.shadowColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MaterialContainer(
          padding: padding,
          type: type,
          elevation: elevation,
          backgroundColor: backgroundColor,
          shadowColor: shadowColor,
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
