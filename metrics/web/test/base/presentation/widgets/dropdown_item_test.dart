import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_item.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

void main() {
  group("DropdownItem", () {
    final mouseRegionFinder = find.byWidgetPredicate(
      (widget) => widget is MouseRegion && widget.child is GestureDetector,
    );

    final containerFinder = find.descendant(
      of: find.byType(DropdownItem),
      matching: find.byType(Container),
    );

    const hoveredText = "hovered text";
    const text = "text";

    Widget _builder(BuildContext context, bool isHovered) {
      return Text(isHovered ? hoveredText : text);
    }

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownItemTestbed(builder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the proper widget when the dropdown item is not hovered",
      (tester) async {
        await tester.pumpWidget(_DropdownItemTestbed(builder: _builder));

        expect(find.text(text), findsOneWidget);
      },
    );

    testWidgets(
      "displays the proper widget when the dropdown item is hovered",
      (tester) async {
        await tester.pumpWidget(_DropdownItemTestbed(builder: _builder));

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await tester.pump();

        expect(find.text(hoveredText), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given width",
      (tester) async {
        const width = 100.0;
        const expectedConstraints = BoxConstraints.tightFor(width: width);

        await tester.pumpWidget(
          _DropdownItemTestbed(builder: _builder, width: width),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.constraints, equals(expectedConstraints));
      },
    );

    testWidgets(
      "applies the given height",
      (tester) async {
        const height = 100.0;
        const expectedConstraints = BoxConstraints.tightFor(height: height);

        await tester.pumpWidget(
          _DropdownItemTestbed(builder: _builder, height: height),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.constraints, equals(expectedConstraints));
      },
    );

    testWidgets(
      "applies the given alignment",
      (tester) async {
        const expectedAlignment = Alignment.bottomRight;

        await tester.pumpWidget(
          _DropdownItemTestbed(
            builder: _builder,
            alignment: expectedAlignment,
          ),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.alignment, equals(expectedAlignment));
      },
    );

    testWidgets(
      "applies the given padding",
      (tester) async {
        const expectedPadding = EdgeInsets.all(10.0);

        await tester.pumpWidget(
          _DropdownItemTestbed(
            builder: _builder,
            padding: expectedPadding,
          ),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.padding, equals(expectedPadding));
      },
    );

    testWidgets(
      "applies the given background color if is not hovered",
      (tester) async {
        const backgroundColor = Colors.red;
        const expectedDecoration = BoxDecoration(color: backgroundColor);

        await tester.pumpWidget(_DropdownItemTestbed(
          builder: _builder,
          backgroundColor: backgroundColor,
        ));

        final container = tester.widget<Container>(containerFinder);

        expect(container.decoration, equals(expectedDecoration));
      },
    );

    testWidgets(
      "applies the given hover color if is hovered",
      (tester) async {
        const hoverColor = Colors.red;
        const expectedDecoration = BoxDecoration(color: hoverColor);

        await tester.pumpWidget(_DropdownItemTestbed(
          builder: _builder,
          hoverColor: hoverColor,
        ));

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await tester.pump();

        final container = tester.widget<Container>(containerFinder);

        expect(container.decoration, equals(expectedDecoration));
      },
    );
  });
}

/// A testbed class required to test the [DropdownItem] widget.
class _DropdownItemTestbed extends StatelessWidget {
  /// A builder function used to build the child widget depending on the hover
  /// status of this widget.
  final HoverWidgetBuilder builder;

  /// A [Color] of the [DropdownItem] if it is not hovered.
  final Color backgroundColor;

  /// A [Color] of the [DropdownItem] if it is hovered.
  final Color hoverColor;

  /// A width of the [DropdownItem].
  final double width;

  /// A height of the [DropdownItem].
  final double height;

  /// A padding of the [DropdownItem].
  final EdgeInsets padding;

  /// An alignment of the [DropdownItem].
  final Alignment alignment;

  /// Creates an instance of this testbed.
  const _DropdownItemTestbed({
    Key key,
    this.builder,
    this.backgroundColor,
    this.hoverColor,
    this.width,
    this.height,
    this.padding,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DropdownItem(
          backgroundColor: backgroundColor,
          hoverColor: hoverColor,
          width: width,
          height: height,
          padding: padding,
          alignment: alignment,
          builder: builder,
        ),
      ),
    );
  }
}
