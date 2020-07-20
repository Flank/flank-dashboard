import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
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
      "displays the child widget from the animation component data",
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
      "delegates the menuState to the DropdownBody",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: animationComponentData,
          ),
        );

        final dropdownBodyWidget = tester.widget<DropdownBody>(
          find.byType(DropdownBody),
        );

        expect(
          dropdownBodyWidget.state,
          equals(animationComponentData.menuState),
        );
      },
    );

    testWidgets(
      "delegates the max height to the DropdownBody",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: animationComponentData,
          ),
        );

        final dropdownBodyWidget = tester.widget<DropdownBody>(
          find.byType(DropdownBody),
        );

        expect(
          dropdownBodyWidget.maxHeight,
          equals(animationComponentData.constraints.maxHeight),
        );
      },
    );

    testWidgets(
      "applies the animation duration constant to the DropdownBody",
      (tester) async {
        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: _AnimationComponentDataStub(),
          ),
        );

        final dropdownBodyWidget = tester.widget<DropdownBody>(
          find.byType(DropdownBody),
        );

        expect(
          dropdownBodyWidget.animationDuration,
          equals(DurationConstants.animation),
        );
      },
    );

    testWidgets(
      "notifies about the DropdownMenu finishes opening",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: animationComponentData,
          ),
        );

        final dropdownBodyWidget = tester.widget<DropdownBody>(
          find.byType(DropdownBody),
        );

        dropdownBodyWidget.onOpenStateChanged(true);

        expect(
          animationComponentData.isOpenedCalled,
          isTrue,
        );
      },
    );

    testWidgets(
      "notifies about the DropdownMenu finishes closing",
      (tester) async {
        final animationComponentData = _AnimationComponentDataStub();

        await tester.pumpWidget(
          _ProjectGroupsDropdownBodyTestbed(
            data: animationComponentData,
          ),
        );

        final dropdownBodyWidget = tester.widget<DropdownBody>(
          find.byType(DropdownBody),
        );

        dropdownBodyWidget.onOpenStateChanged(false);

        expect(
          animationComponentData.isClosedCalled,
          isTrue,
        );
      },
    );
  });
}

/// A testbed class used to test the [ProjectGroupsDropdownBody] widget.
class _ProjectGroupsDropdownBodyTestbed extends StatelessWidget {
  /// An [AnimationComponentData] that provides an information about menu animation.
  final AnimationComponentData data;

  /// Creates the testbed with the given [data].
  const _ProjectGroupsDropdownBodyTestbed({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ProjectGroupsDropdownBody(data: data),
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
