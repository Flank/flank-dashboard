// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
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

        expect(find.byWidget(animationComponentData.child), findsOneWidget);
      },
    );

    testWidgets(
      "applies the menu state from the given data to the dropdown body",
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
  /// A default animation duration to use within this stub.
  static const Duration _animationDuration = Duration(milliseconds: 100);

  /// A default [MenuStateChanged] to use in tests.
  static void _defaultMenuStateChangedCallback() {}

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

  /// Creates a new instance of the [_AnimationComponentDataStub].
  ///
  /// The [menuState] defaults to the [MenuState.OpeningStart].
  /// The [child] defaults to the [Text] with the 'child' label.
  /// The [constraints] defaults to the [BoxConstraints].
  /// The [menuAnimationDurations] defaults to the [MenuAnimationDurations]
  /// with [_animationDuration] parameter for arguments.
  ///
  /// If the given [opened] callback is `null`,
  /// the [_defaultMenuStateChangedCallback] is used.
  /// If the given [closed] callback is `null`,
  /// the [_defaultMenuStateChangedCallback] is used.
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
    MenuStateChanged opened,
    MenuStateChanged closed,
  })  : opened = opened ?? _defaultMenuStateChangedCallback,
        closed = closed ?? _defaultMenuStateChangedCallback;

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
