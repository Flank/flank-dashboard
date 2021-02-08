// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/icon_label_button.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("IconLabelButton", () {
    const defaultPadding = EdgeInsets.zero;
    const defaultIcon = Icon(Icons.cake);
    const hoverIcon = Icon(Icons.add);
    const defaultLabel = 'label';
    const hoverLabel = 'hover';

    final tappableAreaFinder = find.byType(TappableArea);
    final mouseRegionFinder = find.byType(MouseRegion);

    Future<void> _hoverIconLabelButton(WidgetTester tester) async {
      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(of: tappableAreaFinder, matching: mouseRegionFinder),
      );

      const pointerEnterEvent = PointerEnterEvent();
      mouseRegion.onEnter(pointerEnterEvent);

      await tester.pump();
    }

    Widget _iconBuilder(BuildContext context, bool isHovered) {
      return isHovered ? hoverIcon : defaultIcon;
    }

    Widget _labelBuilder(BuildContext context, bool isHovered) {
      return Text(isHovered ? hoverLabel : defaultLabel);
    }

    testWidgets(
      "throws an AssertionError if the given label builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _IconLabelButtonTestbed(
          labelBuilder: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given icon builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _IconLabelButtonTestbed(
          iconBuilder: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given icon padding is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _IconLabelButtonTestbed(
          iconPadding: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given content padding is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _IconLabelButtonTestbed(
          contentPadding: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the default icon padding if it's not specified",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          iconBuilder: _iconBuilder,
        ));

        final iconPadding = tester.widget<Padding>(
          find.ancestor(
            of: find.byWidget(defaultIcon),
            matching: find.byType(Padding).last,
          ),
        );

        expect(iconPadding.padding, equals(defaultPadding));
      },
    );

    testWidgets(
      "applies the default content padding if it's not specified",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _IconLabelButtonTestbed());

        final contentPadding = tester.widget<Padding>(
          find.descendant(
            of: find.byType(IconLabelButton),
            matching: find.byType(Padding).first,
          ),
        );

        expect(contentPadding.padding, equals(defaultPadding));
      },
    );

    testWidgets(
      "displays the corresponding label when the button is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          labelBuilder: _labelBuilder,
        ));

        expect(find.text(defaultLabel), findsOneWidget);
      },
    );

    testWidgets(
      "displays the corresponding label when the button is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          labelBuilder: _labelBuilder,
        ));

        await _hoverIconLabelButton(tester);

        await tester.pump();

        expect(find.text(hoverLabel), findsOneWidget);
      },
    );

    testWidgets(
      "displays the corresponding icon when the button is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          iconBuilder: _iconBuilder,
        ));

        expect(find.byWidget(defaultIcon), findsOneWidget);
      },
    );

    testWidgets(
      "displays the corresponding icon when the button is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          iconBuilder: _iconBuilder,
        ));

        await _hoverIconLabelButton(tester);

        await tester.pump();

        expect(find.byWidget(hoverIcon), findsOneWidget);
      },
    );

    testWidgets("applies the given icon padding", (WidgetTester tester) async {
      const expectedIconPadding = EdgeInsets.all(4.0);

      await tester.pumpWidget(_IconLabelButtonTestbed(
        iconPadding: expectedIconPadding,
        iconBuilder: _iconBuilder,
      ));

      final iconPadding = tester.widget<Padding>(
        find.ancestor(
          of: find.byWidget(defaultIcon),
          matching: find.byType(Padding).last,
        ),
      );
      final actualIconPadding = iconPadding.padding;

      expect(actualIconPadding, equals(expectedIconPadding));
    });

    testWidgets(
      "applies the given content padding",
      (WidgetTester tester) async {
        const expectedContentPadding = EdgeInsets.all(4.0);

        await tester.pumpWidget(const _IconLabelButtonTestbed(
          contentPadding: expectedContentPadding,
        ));

        final contentPadding = tester.widget<Padding>(
          find.descendant(
            of: find.byType(IconLabelButton),
            matching: find.byType(Padding).first,
          ),
        );
        final actualContentPadding = contentPadding.padding;

        expect(actualContentPadding, equals(expectedContentPadding));
      },
    );

    testWidgets(
      "applies the given onPressed callback",
      (WidgetTester tester) async {
        void testCallback() {}

        await tester.pumpWidget(_IconLabelButtonTestbed(
          onPressed: testCallback,
        ));

        final tappableArea = tester.widget<TappableArea>(tappableAreaFinder);
        final actualCallback = tappableArea.onTap;

        expect(actualCallback, equals(testCallback));
      },
    );

    testWidgets(
      "applies tappable area to the row of the label and icon",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _IconLabelButtonTestbed());

        final iconFinder = find.ancestor(
          of: find.byType(Row),
          matching: find.byType(TappableArea),
        );

        expect(iconFinder, findsOneWidget);
      },
    );
  });
}

/// A testbed class required for testing the [IconLabelButton].
class _IconLabelButtonTestbed extends StatelessWidget {
  /// The callback for the [IconLabelButton] under test.
  final VoidCallback onPressed;

  /// The padding around the [IconLabelButton] under test.
  final EdgeInsets contentPadding;

  /// The padding around the icon.
  final EdgeInsets iconPadding;

  /// The builder of an icon of the button under tests.
  final HoverWidgetBuilder iconBuilder;

  /// The builder of a label of the button under tests.
  final HoverWidgetBuilder labelBuilder;

  /// Creates the instance of this testbed.
  ///
  /// Both [iconPadding] and [contentPadding] defaults to [EdgeInsets.zero].
  const _IconLabelButtonTestbed({
    this.labelBuilder = _defaultLabelBuilder,
    this.iconBuilder = _defaultIconBuilder,
    this.iconPadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IconLabelButton(
          labelBuilder: labelBuilder,
          iconBuilder: iconBuilder,
          iconPadding: iconPadding,
          contentPadding: contentPadding,
          onPressed: onPressed,
        ),
      ),
    );
  }

  /// A default icon builder for this testbed.
  static Widget _defaultIconBuilder(BuildContext context, bool isHovered) {
    return const Icon(Icons.add);
  }

  /// A default label builder for this testbed.
  static Widget _defaultLabelBuilder(BuildContext context, bool isHovered) {
    return const Text("hover");
  }
}
