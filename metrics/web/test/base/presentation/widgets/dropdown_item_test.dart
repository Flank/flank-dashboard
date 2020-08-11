import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_item.dart';

void main() {
  group("DropdownItem", () {
    final mouseRegionFinder = find.byWidgetPredicate(
      (widget) => widget is MouseRegion && widget.child is Container,
    );

//    Implement metrics switch. Move toggle_theme_data to the switch folder. Add tests.

    final containerFinder = find.descendant(
      of: find.byType(DropdownItem),
      matching: find.byType(Container),
    );

    testWidgets(
      "throws an AssertionError if the given child widget is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownItemTestbed(child: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given child widget",
      (tester) async {
        const child = Text('test');

        await tester.pumpWidget(const _DropdownItemTestbed(child: child));

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given width",
      (tester) async {
        const width = 100.0;
        const expectedConstraints = BoxConstraints.tightFor(width: width);

        await tester.pumpWidget(
          const _DropdownItemTestbed(width: width),
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
          const _DropdownItemTestbed(height: height),
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
          const _DropdownItemTestbed(
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
          const _DropdownItemTestbed(
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

        await tester.pumpWidget(const _DropdownItemTestbed(
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

        await tester.pumpWidget(const _DropdownItemTestbed(
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
  /// The child widget to display.
  final Widget child;

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
  ///
  /// The [child] defaults to [SizedBox].
  const _DropdownItemTestbed({
    Key key,
    this.child = const SizedBox(),
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
          child: child,
        ),
      ),
    );
  }
}
