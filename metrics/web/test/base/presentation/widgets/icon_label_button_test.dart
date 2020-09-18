import 'package:flutter/gestures.dart';
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
    const hoverIcon = Icon(Icons.add);
    const defaultLabel = 'label';
    const hoverLabel = 'label';

    Widget _iconBuilder(BuildContext context, bool isHovered, Widget child) {
      return isHovered ? hoverIcon : defaultIcon;
    }

    Widget _labelBuilder(BuildContext context, bool isHovered, Widget child) {
      return Text(isHovered ? hoverLabel : defaultLabel);
    }

    testWidgets(
      "throws an AssertionError if the given label builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: null,
          icon: _iconBuilder,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given icon builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          icon: null,
          label: _labelBuilder,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given icon padding is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: _labelBuilder,
          icon: _iconBuilder,
          iconPadding: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given content padding is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: _labelBuilder,
          icon: _iconBuilder,
          contentPadding: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the default icon padding if it's not specified",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: _labelBuilder,
          icon: _iconBuilder,
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
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: _labelBuilder,
          icon: _iconBuilder,
        ));

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
          label: _labelBuilder,
          icon: _iconBuilder,
        ));

        expect(find.text(defaultLabel), findsOneWidget);
      },
    );

    testWidgets(
      "displays the corresponding label when the button is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: _labelBuilder,
          icon: _iconBuilder,
        ));

        final mouseRegion = tester.firstWidget<MouseRegion>(
          find.ancestor(
            of: find.byType(GestureDetector),
            matching: find.byType(MouseRegion),
          ),
        );

        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await tester.pump();

        expect(find.text(hoverLabel), findsOneWidget);
      },
    );

    testWidgets(
      "displays the corresponding icon when the button is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: _labelBuilder,
          icon: _iconBuilder,
        ));

        expect(find.byWidget(defaultIcon), findsOneWidget);
      },
    );

    testWidgets(
      "displays the corresponding icon when the button is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_IconLabelButtonTestbed(
          label: _labelBuilder,
          icon: _iconBuilder,
        ));

        final mouseRegion = tester.firstWidget<MouseRegion>(
          find.ancestor(
            of: find.byType(GestureDetector),
            matching: find.byType(MouseRegion),
          ),
        );

        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await tester.pump();

        expect(find.byWidget(hoverIcon), findsOneWidget);
      },
    );

    testWidgets("applies the given icon padding", (WidgetTester tester) async {
      final expectedIconPadding = EdgeInsets.all(4.0);

      await tester.pumpWidget(_IconLabelButtonTestbed(
        iconPadding: expectedIconPadding,
        label: _labelBuilder,
        icon: _iconBuilder,
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
        final expectedContentPadding = EdgeInsets.all(4.0);

        await tester.pumpWidget(_IconLabelButtonTestbed(
          contentPadding: expectedContentPadding,
          label: _labelBuilder,
          icon: _iconBuilder,
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
          label: _labelBuilder,
          icon: _iconBuilder,
        ));

        final tappableArea =
            tester.widget<TappableArea>(find.byType(TappableArea));
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

  /// The padding around the [icon].
  final EdgeInsets iconPadding;

  /// The builder of this button's icon.
  final HoverWidgetBuilder icon;

  /// The builder of this button's label.
  final HoverWidgetBuilder label;

  /// Creates the instance of this testbed.
  ///
  /// Both [iconPadding] and [contentPadding] defaults to [EdgeInsets.zero].
  const _IconLabelButtonTestbed({
    this.label,
    this.icon,
    this.iconPadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.onPressed,
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
        ),
      ),
    );
  }
}
