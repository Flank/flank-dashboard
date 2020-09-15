import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:selection_menu/components_configurations.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
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
      "applies the given animation curve",
      (tester) async {
        const animationCurve = Curves.linear;
        await tester.pumpWidget(
          const _DropdownBodyTestbed(animationCurve: animationCurve),
        );

        final container = tester.widget<SizeTransition>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(SizeTransition),
          ),
        );

        final animation = container.sizeFactor as CurvedAnimation;

        expect(animation.curve, equals(animationCurve));
        expect(animation.reverseCurve, equals(animationCurve));
      },
    );

    testWidgets(
      "applies the given animation duration",
      (tester) async {
        const animationDuration = Duration(milliseconds: 200);
        await tester.pumpWidget(
          const _DropdownBodyTestbed(animationDuration: animationDuration),
        );

        final container = tester.widget<SizeTransition>(
          find.descendant(
            of: find.byType(DropdownBody),
            matching: find.byType(SizeTransition),
          ),
        );

        final animation = container.sizeFactor as CurvedAnimation;
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
      "displays the given child",
      (tester) async {
        const child = Text('test');

        await tester.pumpWidget(
          const _DropdownBodyTestbed(child: child),
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

  /// A [Curve] to use in the animation.
  final Curve animationCurve;

  /// A [Duration] to use in the animation.
  final Duration animationDuration;

  /// A max height of this the dropdown body.
  final double maxHeight;

  /// A [ValueChanged] callback used to notify about opened state changes.
  final ValueChanged<bool> onOpenStateChanged;

  /// A current state of the dropdown body.
  final MenuState state;

  /// A child widget of this dropdown body.
  final Widget child;

  /// Creates an instance of this testbed.
  const _DropdownBodyTestbed({
    Key key,
    this.state = MenuState.OpeningStart,
    this.animationCurve = Curves.ease,
    this.animationDuration = const Duration(milliseconds: 100),
    this.maxHeight,
    this.onOpenStateChanged,
    this.child,
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
              onOpenStateChanged: widget.onOpenStateChanged,
              state: state,
              child: widget.child,
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
