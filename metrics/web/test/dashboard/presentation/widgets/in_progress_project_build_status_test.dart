// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/in_progress_project_build_status.dart';
import 'package:mockito/mockito.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/presentation/widgets/rive_animation_testbed.dart';
import '../../../test_utils/test_injection_container.dart';
import '../../../test_utils/theme_notifier_mock.dart';

void main() {
  group("InProgressProjectBuildStatus", () {
    ThemeNotifier themeNotifier;

    final riveAnimationFinder = find.byType(RiveAnimation);

    setUp(() {
      themeNotifier = ThemeNotifierMock();
    });

    testWidgets(
      "displays a RiveAnimation widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressProjectBuildStatusTestbed(),
        );

        expect(riveAnimationFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays a dark asset if the current theme is dark",
      (WidgetTester tester) async {
        const expectedAsset =
            'web/animation/in_progress_project_build_status_dark.riv';
        when(themeNotifier.isDark).thenReturn(true);

        await tester.pumpWidget(
          _InProgressProjectBuildStatusTestbed(
            themeNotifier: themeNotifier,
          ),
        );

        final riveAnimation = FinderUtil.findRiveAnimation(tester);

        expect(riveAnimation.assetName, equals(expectedAsset));
      },
    );

    testWidgets(
      "displays a light asset if the current theme is light",
      (WidgetTester tester) async {
        const expectedAsset =
            'web/animation/in_progress_project_build_status_light.riv';
        when(themeNotifier.isDark).thenReturn(false);

        await tester.pumpWidget(
          _InProgressProjectBuildStatusTestbed(
            themeNotifier: themeNotifier,
          ),
        );

        final riveAnimation = FinderUtil.findRiveAnimation(tester);

        expect(riveAnimation.assetName, equals(expectedAsset));
      },
    );

    testWidgets(
      "displays a rive animation widget with the artboard size parameter set as true",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressProjectBuildStatusTestbed(),
        );

        final riveAnimation = FinderUtil.findRiveAnimation(tester);

        expect(riveAnimation.useArtboardSize, isTrue);
      },
    );

    testWidgets(
      "displays the rive animation with the correct animation name",
      (WidgetTester tester) async {
        const expectedAnimationName = 'Animation 1';
        await tester.pumpWidget(
          const _InProgressProjectBuildStatusTestbed(),
        );

        final riveAnimation = FinderUtil.findRiveAnimation(tester);

        final animationControllerMatcher = predicate((controller) {
          return controller is SimpleAnimation &&
              controller.animationName == expectedAnimationName;
        });

        expect(riveAnimation.controller, animationControllerMatcher);
      },
    );
  });
}

/// A testbed class needed to test the
class _InProgressProjectBuildStatusTestbed extends StatelessWidget {
  /// A [ThemeNotifier] used in tests.
  final ThemeNotifier themeNotifier;

  /// Creates a new instance of this testbed.
  const _InProgressProjectBuildStatusTestbed({
    Key key,
    this.themeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestInjectionContainer(
        themeNotifier: themeNotifier,
        child: const RiveAnimationTestbed(
          child: InProgressProjectBuildStatus(),
        ),
      ),
    );
  }
}
