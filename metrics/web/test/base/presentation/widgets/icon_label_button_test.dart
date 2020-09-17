import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/icon_label_button.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("IconLabelButton", () {
    const defaultPadding = EdgeInsets.zero;
    const defaultIcon = Icon(Icons.cake);

    testWidgets(
      "throws an AssertionError if the given label is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(label: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given icon is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(icon: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given icon padding is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(iconPadding: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given content padding is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(contentPadding: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the default icon padding if it's not specified",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(icon: defaultIcon));

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
        await tester.pumpWidget(_IconLabelButtonTestbed());

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
      "displays the given label",
      (WidgetTester tester) async {
        const expectedLabel = 'testLabel';

        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: expectedLabel,
        ));

        final textWidget = tester.widget<Text>(
          find.descendant(
            of: find.byType(IconLabelButton),
            matching: find.byType(Text),
          ),
        );

        final actualLabel = textWidget.data;

        expect(actualLabel, equals(expectedLabel));
      },
    );

    testWidgets(
      "applies the given labelStyle to the displayed label",
      (WidgetTester tester) async {
        const expectedStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(_IconLabelButtonTestbed(
          labelStyle: expectedStyle,
        ));

        final textWidget = tester.widget<Text>(
          find.descendant(
            of: find.byType(IconLabelButton),
            matching: find.byType(Text),
          ),
        );

        final actualStyle = textWidget.style;

        expect(actualStyle, equals(expectedStyle));
      },
    );

    testWidgets(
      "displays the given icon",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(icon: defaultIcon));

        expect(find.byWidget(defaultIcon), findsOneWidget);
      },
    );

    testWidgets("applies the given icon padding", (WidgetTester tester) async {
      final expectedIconPadding = EdgeInsets.all(4.0);
      final icon = Icon(Icons.delete);

      await tester.pumpWidget(_IconLabelButtonTestbed(
        iconPadding: expectedIconPadding,
        icon: icon,
      ));

      final iconPadding = tester.widget<Padding>(
        find.ancestor(
          of: find.byWidget(icon),
          matching: find.byType(Padding).last,
        ),
      );
      final actualIconPadding = iconPadding.padding;

      expect(actualIconPadding, equals(expectedIconPadding));
    });

    testWidgets(
      "applies the given content padding",
      (WidgetTester tester) async {
        final expectedContentPadding = EdgeInsets.all(4.0);

        await tester.pumpWidget(_IconLabelButtonTestbed(
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

        final tappableArea = tester.widget<TappableArea>(
          find.byType(TappableArea)
        );
        final actualCallback = tappableArea.onTap;

        expect(actualCallback, equals(testCallback));
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

  /// The icon of the [IconLabelButton] under test.
  final Icon icon;

  /// The padding around the [icon].
  final EdgeInsets iconPadding;

  /// The label of the [IconLabelButton] under test.
  final String label;

  /// The [TextStyle] of the [label].
  final TextStyle labelStyle;

  /// Creates the instance of this testbed.
  ///
  /// Both [iconPadding] and [contentPadding] defaults to [EdgeInsets.zero].
  /// The [label] defaults to `label`.
  /// The [icon] defaults to [Icons.add].
  const _IconLabelButtonTestbed({
    this.label = "label",
    this.icon = const Icon(Icons.add),
    this.iconPadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.onPressed,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IconLabelButton(
          label: label,
          icon: icon,
          iconPadding: iconPadding,
          contentPadding: contentPadding,
          onPressed: onPressed,
          labelStyle: labelStyle,
        ),
      ),
    );
  }
}
