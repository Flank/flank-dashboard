// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';

void main() {
  group("PaddedCard", () {
    const text = 'text';
    const child = Text(text);

    testWidgets(
      "throws an AssertionError is the given child is null",
      (tester) async {
        await tester.pumpWidget(const _PaddedCardTestbed(child: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays a card with the given child",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PaddedCardTestbed(child: child));

        final actualChild = find.descendant(
          of: find.byType(PaddedCard),
          matching: find.byWidget(child),
        );

        expect(actualChild, findsOneWidget);
      },
    );

    testWidgets(
      "displays a card with the given background-color",
      (WidgetTester tester) async {
        const backgroundColor = Colors.red;

        await tester.pumpWidget(
          const _PaddedCardTestbed(backgroundColor: backgroundColor),
        );

        final cardWidget = tester.widget<Card>(find.byType(Card));

        expect(cardWidget.color, backgroundColor);
      },
    );

    testWidgets(
      "delegates the given margin to the card widget",
      (WidgetTester tester) async {
        const margin = EdgeInsets.all(10.0);

        await tester.pumpWidget(const _PaddedCardTestbed(margin: margin));

        final cardWidget = tester.widget<Card>(find.byType(Card));

        expect(cardWidget.margin, equals(margin));
      },
    );

    testWidgets(
      "applies the given padding to the child",
      (WidgetTester tester) async {
        const padding = EdgeInsets.all(10.0);

        await tester.pumpWidget(
          const _PaddedCardTestbed(padding: padding, child: child),
        );

        final widget = tester.widget<Padding>(
          find.ancestor(
            of: find.byWidget(child),
            matching: find.byType(Padding).last,
          ),
        );

        expect(widget.padding, equals(padding));
      },
    );

    testWidgets(
      "delegates the given elevation to the card widget",
      (WidgetTester tester) async {
        const elevation = 2.0;

        await tester.pumpWidget(const _PaddedCardTestbed(elevation: elevation));

        final cardWidget = tester.widget<Card>(find.byType(Card));

        expect(cardWidget.elevation, equals(elevation));
      },
    );
  });
}

/// A testbed class required to test the [PaddedCard] widget.
class _PaddedCardTestbed extends StatelessWidget {
  /// A default child widget used in tests.
  static const Widget _defaultChild = Text('default text');

  /// An elevation of this card.
  final double elevation;

  /// A background color of this card.
  final Color backgroundColor;

  /// An empty space that surrounds this card.
  final EdgeInsetsGeometry margin;

  /// A child widget to be displayed.
  final Widget child;

  /// An empty space that surrounds the [child].
  final EdgeInsetsGeometry padding;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [child] defaults to [_defaultChild].
  /// The [margin] and the [padding] default value is [EdgeInsets.zero].
  /// The [elevation] default value is 0.0.
  const _PaddedCardTestbed({
    Key key,
    this.child = _defaultChild,
    this.backgroundColor,
    this.elevation = 0.0,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PaddedCard(
          backgroundColor: backgroundColor,
          elevation: elevation,
          margin: margin,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
