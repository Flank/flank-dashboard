import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_body.dart';
import 'package:selection_menu/components_configurations.dart';

void main() {
  group("ProjectGroupsDropdownBody", () {
    testWidgets(
      "throws an AssertionError if the given data is null",
      (tester) async {
        await tester.pumpWidget(
          const _ProjectGroupsDropdownBodyTestbed(data: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the biggest height from the AnimationComponentData constraints to the Container constraints",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: animationComponentData,
          ),
        );

        final container = tester.widget<Container>(
          find.ancestor(
            of: find.byType(Card),
            matching: find.byType(Container),
          ),
        );

        expect(
          container.constraints.maxHeight,
          equals(animationComponentData.constraints.maxHeight),
        );
      },
    );

    testWidgets(
      "displays the child widget from the AnimationComponentData",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: animationComponentData,
          ),
        );

        expect(
          find.byWidget(animationComponentData.child),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "calls the AnimationComponentData.opened() method after the menu finished opening",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(data: animationComponentData),
        );

        await tester.pumpAndSettle();

        expect(animationComponentData.isOpenedCalled, isTrue);
      },
    );

    testWidgets(
      "calls the AnimationComponentData.closed() method after the menu finished closing",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: animationComponentData,
          ),
        );
        await tester.pumpAndSettle();

        animationComponentData.menuState = MenuState.ClosingStart;

        await tester.tap(
          find.byKey(_ProjectGroupsDropdownBodyTestbed.updateButtonKey),
        );
        await tester.pumpAndSettle();

        expect(
          animationComponentData.isClosedCalled,
          isTrue,
        );
      },
    );
  });
}

/// A testbed class used to test the [ProjectGroupsDropdownBody] widget.
class _ProjectGroupsDropdownBodyTestbed extends StatefulWidget {
  /// An [AnimationComponentData] that provides an information about menu animation.
  final AnimationComponentData data;

  /// A [Key] used to find an update button in tests.
  static final Key updateButtonKey = UniqueKey();

  /// Creates the testbed with the given [data].
  const _ProjectGroupsDropdownBodyTestbed({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _ProjectGroupsDropdownBodyTestbedState createState() =>
      _ProjectGroupsDropdownBodyTestbedState();
}

class _ProjectGroupsDropdownBodyTestbedState
    extends State<_ProjectGroupsDropdownBodyTestbed> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            ProjectGroupsDropdownBody(data: widget.data),
            FlatButton(
              key: _ProjectGroupsDropdownBodyTestbed.updateButtonKey,
              onPressed: () => setState(() {}),
              child: const Text("update"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stub implementation of the [AnimationComponentData].
///
/// Provides test implementation of the [AnimationComponentData] methods.
class _AnimationComponentDataStub implements AnimationComponentData {
  static const Duration _animationDuration = Duration(milliseconds: 100);

  /// Holds an info if [opened] was called at least once.
  bool _isOpenedCalled = false;

  /// Holds an info if [closed] was called at least once.
  bool _isClosedCalled = false;

  /// Determines whether the [opened] callback was called at least once.
  bool get isOpenedCalled => _isOpenedCalled;

  /// Determines whether the [opened] callback was called at least once.
  bool get isClosedCalled => _isClosedCalled;

  @override
  MenuState menuState = MenuState.OpeningStart;

  @override
  final Widget child = const Text('child');

  @override
  final BoxConstraints constraints = const BoxConstraints(
    maxHeight: 120.0,
  );

  @override
  final MenuAnimationDurations menuAnimationDurations =
      const MenuAnimationDurations(
    forward: _animationDuration,
    reverse: _animationDuration,
  );

  @override
  TickerProvider get tickerProvider => null;

  @override
  MenuAnimationCurves get menuAnimationCurves => null;

  @override
  BuildContext get context => null;

  @override
  dynamic get selectedItem => null;

  @override
  MenuStateChanged get opened => () {
        _isOpenedCalled = true;
      };

  @override
  MenuStateChanged get closed => () {
        _isClosedCalled = true;
      };

  @override
  MenuStateWillChangeAfter get willCloseAfter => null;

  @override
  MenuStateWillChangeAfter get willOpenAfter => null;
}
