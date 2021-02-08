// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:selection_menu/components_configurations.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  Widget _defaultChildBuilder(BuildContext context, CurvedAnimation animation) {
    return FadeTransition(
      opacity: animation,
      child: const Text("child"),
    );
  }

  group("DropdownBody", () {
    testWidgets(
      "throws an AssertionError if the given state is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownBodyTestbed(state: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given animation curve is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownBodyTestbed(animationCurve: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownBodyTestbed(animationCurve: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given animation duration is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownBodyTestbed(animationDuration: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given max height",
      (tester) async {
        const maxHeight = 11.0;
        await tester.pumpWidget(
          const _DropdownBodyTestbed(maxHeight: maxHeight),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints.maxHeight, equals(maxHeight));
      },
    );

    testWidgets(
      "applies the given max width",
      (tester) async {
        const maxWidth = 11.0;
        await tester.pumpWidget(
          const _DropdownBodyTestbed(maxWidth: maxWidth),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints.maxWidth, equals(maxWidth));
      },
    );

    testWidgets(
      "applies the given decoration",
      (tester) async {
        const decoration = BoxDecoration(color: Colors.red);

        await tester.pumpWidget(
          const _DropdownBodyTestbed(decoration: decoration),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(Container),
          ),
        );

        expect(container.decoration, equals(decoration));
      },
    );

    testWidgets(
      "applies the given animation curve",
      (tester) async {
        const animationCurve = Curves.linear;
        await tester.pumpWidget(
          _DropdownBodyTestbed(
            animationCurve: animationCurve,
            builder: _defaultChildBuilder,
          ),
        );

        final container = tester.widget<FadeTransition>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(FadeTransition),
          ),
        );

        final animation = container.opacity as CurvedAnimation;

        expect(animation.curve, equals(animationCurve));
        expect(animation.reverseCurve, equals(animationCurve));
      },
    );

    testWidgets(
      "applies the given animation duration",
      (tester) async {
        const animationDuration = Duration(milliseconds: 200);
        await tester.pumpWidget(
          _DropdownBodyTestbed(
            animationDuration: animationDuration,
            builder: _defaultChildBuilder,
          ),
        );

        final container = tester.widget<FadeTransition>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(FadeTransition),
          ),
        );

        final animation = container.opacity as CurvedAnimation;
        final animationController = animation.parent as AnimationController;

        expect(animationController.duration, equals(animationDuration));
        expect(animationController.reverseDuration, equals(animationDuration));
      },
    );

    testWidgets(
      "applies the double.infinity if the given max height is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownBodyTestbed(maxHeight: null),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints.maxHeight, equals(double.infinity));
      },
    );

    testWidgets(
      "applies the double.infinity if the given max width is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownBodyTestbed(maxWidth: null),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints.maxWidth, equals(double.infinity));
      },
    );

    testWidgets(
      "builds the child with the given builder",
      (tester) async {
        const child = Text('test');

        await tester.pumpWidget(
          _DropdownBodyTestbed(
            builder: (context, animation) {
              return child;
            },
          ),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "notifies about menu finished opening using the given callback",
      (tester) async {
        bool isOpened;

        await tester.pumpWidget(
          _DropdownBodyTestbed(
            onOpenStateChanged: (value) => isOpened = value,
          ),
        );

        await tester.pumpAndSettle();

        expect(isOpened, isTrue);
      },
    );

    testWidgets(
      "notifies about menu finished closing using the given callback",
      (tester) async {
        bool isOpened;

        await tester.pumpWidget(
          _DropdownBodyTestbed(
            onOpenStateChanged: (value) => isOpened = value,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(_DropdownBodyTestbed.closeButtonKey));
        await tester.pumpAndSettle();

        expect(isOpened, isFalse);
      },
    );
  });
}

/// A testbed class required to test the [DropdownBody] widget.
class _DropdownBodyTestbed extends StatefulWidget {
  static final Key closeButtonKey = UniqueKey();

  /// A default builder for this testbed.
  static Widget _defaultBuilder(
    BuildContext context,
    CurvedAnimation animation,
  ) {
    return const Text("child");
  }

  /// A [Curve] to use in the animation.
  final Curve animationCurve;

  /// A [Duration] to use in the animation.
  final Duration animationDuration;

  /// A max height of this the dropdown body.
  final double maxHeight;

  /// A max width of this the dropdown body.
  final double maxWidth;

  /// A decoration of this dropdown body.
  final BoxDecoration decoration;

  /// A [ValueChanged] callback used to notify about opened state changes.
  final ValueChanged<bool> onOpenStateChanged;

  /// A current state of the dropdown body.
  final MenuState state;

  /// An animated builder of the child of this dropdown body.
  final AnimatedWidgetBuilder builder;

  /// Creates an instance of this testbed.
  const _DropdownBodyTestbed({
    Key key,
    this.state = MenuState.OpeningStart,
    this.animationCurve = Curves.ease,
    this.animationDuration = const Duration(milliseconds: 100),
    this.decoration,
    this.maxHeight,
    this.maxWidth,
    this.onOpenStateChanged,
    this.builder = _defaultBuilder,
  }) : super(key: key);

  @override
  __DropdownBodyTestbedState createState() => __DropdownBodyTestbedState();
}

class __DropdownBodyTestbedState extends State<_DropdownBodyTestbed> {
  MenuState state;

  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            DropdownBody(
              animationCurve: widget.animationCurve,
              animationDuration: widget.animationDuration,
              maxHeight: widget.maxHeight,
              maxWidth: widget.maxWidth,
              decoration: widget.decoration,
              onOpenStateChanged: widget.onOpenStateChanged,
              state: state,
              builder: widget.builder,
            ),
            RaisedButton(
              key: _DropdownBodyTestbed.closeButtonKey,
              onPressed: () => setState(() {
                state = MenuState.ClosingStart;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
