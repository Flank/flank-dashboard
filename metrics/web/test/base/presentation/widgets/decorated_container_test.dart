import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';

void main() {
  group("DecoratedContainer", () {
    final containerFinder = find.descendant(
      of: find.byType(DecoratedContainer),
      matching: find.byType(Container),
    );

    testWidgets(
      "throws an AssertionError if the given decoration is null",
      (tester) async {
        await tester.pumpWidget(
          const _DecoratedContainerTestbed(decoration: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "delegates the given decoration to the decorated box",
      (tester) async {
        const decoration = BoxDecoration(color: Colors.red);

        await tester.pumpWidget(
          const _DecoratedContainerTestbed(decoration: decoration),
        );

        final decoratedBox = tester.widget<DecoratedBox>(
          find.descendant(
            of: find.byType(DecoratedContainer),
            matching: find.byType(DecoratedBox),
          ),
        );

        expect(decoratedBox.decoration, equals(decoration));
      },
    );

    testWidgets(
      "displays the decorated box with the given child",
      (tester) async {
        const text = 'test';

        await tester.pumpWidget(
          const _DecoratedContainerTestbed(child: Text(text)),
        );

        final child = find.descendant(
          of: find.byType(DecoratedBox),
          matching: find.text(text),
        );

        expect(child, findsOneWidget);
      },
    );

    testWidgets(
      "delegates the given margin to the container",
      (tester) async {
        const margin = EdgeInsets.all(10.0);

        await tester.pumpWidget(
          const _DecoratedContainerTestbed(margin: margin),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.margin, equals(margin));
      },
    );

    testWidgets(
      "delegates the given padding to the container",
      (tester) async {
        const padding = EdgeInsets.all(10.0);

        await tester.pumpWidget(
          const _DecoratedContainerTestbed(padding: padding),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.padding, equals(padding));
      },
    );

    testWidgets(
      "delegates the given width to the container",
      (tester) async {
        const width = 10.0;

        await tester.pumpWidget(
          const _DecoratedContainerTestbed(width: width),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.constraints.maxWidth, equals(width));
        expect(container.constraints.minWidth, equals(width));
      },
    );

    testWidgets(
      "delegates the given height to the container",
      (tester) async {
        const height = 10.0;

        await tester.pumpWidget(
          const _DecoratedContainerTestbed(height: height),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.constraints.maxHeight, equals(height));
        expect(container.constraints.minHeight, equals(height));
      },
    );

    testWidgets(
      "delegates the given constraints to the container",
      (tester) async {
        const constraints = BoxConstraints(maxHeight: 10.0);

        await tester.pumpWidget(
          const _DecoratedContainerTestbed(constraints: constraints),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.constraints, equals(constraints));
      },
    );
  });
}

/// A testbed class required to test the [DecoratedContainer] widget.
class _DecoratedContainerTestbed extends StatelessWidget {
  /// A default child widget used in tests.
  static const Widget _defaultChild = Text('default text');

  /// A [Decoration] of this container.
  final Decoration decoration;

  /// A widget below this container in the tree.
  final Widget child;

  /// A height of this container.
  final double height;

  /// A width of this container.
  final double width;

  /// An empty space surrounds the [child].
  final EdgeInsetsGeometry padding;

  /// An empty space to around the [decoration] and [child].
  final EdgeInsetsGeometry margin;

  /// A [BoxConstraints] of this container.
  final BoxConstraints constraints;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [child] defaults to [_defaultChild].
  /// The [decoration] defaults to an empty [BoxDecoration].
  /// The [margin] and the [padding] default value is [EdgeInsets.zero].
  const _DecoratedContainerTestbed({
    Key key,
    this.child = _defaultChild,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.decoration = const BoxDecoration(),
    this.height,
    this.width,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DecoratedContainer(
          margin: margin,
          padding: padding,
          decoration: decoration,
          height: height,
          width: width,
          constraints: constraints,
          child: child,
        ),
      ),
    );
  }
}
