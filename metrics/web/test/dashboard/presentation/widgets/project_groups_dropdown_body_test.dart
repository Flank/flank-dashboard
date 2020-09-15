import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_body.dart';
import 'package:selection_menu/components_configurations.dart';

// ignore_for_file: avoid_redundant_argument_values

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
      "applies the menuState from the given data to the dropdown body",
      (tester) async {
        const menuState = MenuState.Opened;
        final animationComponentData = _AnimationComponentDataStub(
          menuState: menuState,
        );

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
          equals(menuState),
        );
      },
    );

    testWidgets(
      "applies the max height from the given data to the dropdown body",
      (tester) async {
        const maxHeight = 30.0;
        final animationComponentData = _AnimationComponentDataStub(
          constraints: const BoxConstraints(
            maxHeight: maxHeight,
          ),
        );

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
          equals(maxHeight),
        );
      },
    );

    testWidgets(
      "applies the animation duration constant to the dropdown body",
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
      "notifies about the dropdown menu finishes opening",
      (tester) async {
        bool isOpenedCalled = false;

        final animationComponentData = _AnimationComponentDataStub(opened: () {
          isOpenedCalled = true;
        });

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
          isOpenedCalled,
          isTrue,
        );
      },
    );

    testWidgets(
      "notifies about the dropdown menu finishes closing",
      (tester) async {
        bool isClosedCalled = false;

        final animationComponentData = _AnimationComponentDataStub(
          closed: () {
            isClosedCalled = true;
          },
        );

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
          isClosedCalled,
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

  @override
  final MenuState menuState;

  @override
  final Widget child;

  @override
  final BoxConstraints constraints;

  @override
  final MenuAnimationDurations menuAnimationDurations;

  @override
  final MenuStateChanged opened;

  @override
  final MenuStateChanged closed;

  _AnimationComponentDataStub({
    this.menuState = MenuState.OpeningStart,
    this.child = const Text('child'),
    this.constraints = const BoxConstraints(
      maxHeight: 120.0,
    ),
    this.menuAnimationDurations = const MenuAnimationDurations(
      forward: _animationDuration,
      reverse: _animationDuration,
    ),
    this.opened,
    this.closed,
  });

  @override
  TickerProvider get tickerProvider => null;

  @override
  MenuAnimationCurves get menuAnimationCurves => null;

  @override
  BuildContext get context => null;

  @override
  dynamic get selectedItem => null;

  @override
  MenuStateWillChangeAfter get willCloseAfter => null;

  @override
  MenuStateWillChangeAfter get willOpenAfter => null;
}
