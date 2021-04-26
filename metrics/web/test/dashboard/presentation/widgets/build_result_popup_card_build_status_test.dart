// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card_build_status.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/presentation/widgets/rive_animation_testbed.dart';

void main() {
  group("BuildResultPopupCardBuildStatus", () {
    const inProgressProjectBuildStatus = ProjectBuildStatusViewModel(
      value: BuildStatus.inProgress,
    );
    const successfulProjectBuildStatus = ProjectBuildStatusViewModel(
      value: BuildStatus.successful,
    );

    final riveAnimationFinder = find.byType(RiveAnimation);
    final valueImageFinder = find.byWidgetPredicate((widget) {
      return widget is ValueNetworkImage<BuildStatus>;
    });

    testWidgets(
      "throws an AssertionError if the given project build status is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BuildResultPopupCardBuildStatusTestbed(
            projectBuildStatus: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the RiveAnimation widget if the given project build status is in-progress",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BuildResultPopupCardBuildStatusTestbed(
            projectBuildStatus: inProgressProjectBuildStatus,
          ),
        );

        expect(riveAnimationFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the right animation asset to the RiveAnimationWidget",
      (WidgetTester tester) async {
        const expectedAsset =
            'web/animation/in_progress_popup_build_status.riv';

        await tester.pumpWidget(
          const _BuildResultPopupCardBuildStatusTestbed(
            projectBuildStatus: inProgressProjectBuildStatus,
          ),
        );

        final riveAnimation = tester.widget<RiveAnimation>(
          riveAnimationFinder,
        );

        expect(riveAnimation.assetName, equals(expectedAsset));
      },
    );

    testWidgets(
      "applies the true 'use artboard size' parameter to the RiveAnimation widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BuildResultPopupCardBuildStatusTestbed(
            projectBuildStatus: inProgressProjectBuildStatus,
          ),
        );

        final riveAnimation = tester.widget<RiveAnimation>(
          riveAnimationFinder,
        );

        expect(riveAnimation.useArtboardSize, isTrue);
      },
    );

    testWidgets(
      "applies the animation controller with the correct animation name to the RiveAnimation widget",
      (WidgetTester tester) async {
        const expectedAnimationName = 'Animation 1';

        await tester.pumpWidget(
          const _BuildResultPopupCardBuildStatusTestbed(
            projectBuildStatus: inProgressProjectBuildStatus,
          ),
        );

        final riveAnimation = tester.widget<RiveAnimation>(
          riveAnimationFinder,
        );

        final animationControllerMatcher = predicate((controller) {
          return controller is SimpleAnimation &&
              controller.animationName == expectedAnimationName;
        });

        expect(riveAnimation.controller, equals(animationControllerMatcher));
      },
    );

    testWidgets(
      "displays the ValueImage widget if the given project build status is finished",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _BuildResultPopupCardBuildStatusTestbed(
              projectBuildStatus: successfulProjectBuildStatus,
            ),
          );
        });

        expect(valueImageFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the builds status from the view model to the value network image",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _BuildResultPopupCardBuildStatusTestbed(
              projectBuildStatus: successfulProjectBuildStatus,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueImageFinder,
        );

        expect(
          valueNetworkImage.value,
          equals(successfulProjectBuildStatus.value),
        );
      },
    );

    testWidgets(
      "applies the BuildResultPopupImageStrategy to the value network image",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _BuildResultPopupCardBuildStatusTestbed(
              projectBuildStatus: successfulProjectBuildStatus,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueImageFinder,
        );

        expect(
          valueNetworkImage.strategy,
          isA<BuildResultPopupImageStrategy>(),
        );
      },
    );

    testWidgets(
      "applies the correct height to the ValueNetworkImage widget",
      (WidgetTester tester) async {
        const expectedHeight = 24.0;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _BuildResultPopupCardBuildStatusTestbed(
              projectBuildStatus: successfulProjectBuildStatus,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueImageFinder,
        );

        expect(valueNetworkImage.height, equals(expectedHeight));
      },
    );

    testWidgets(
      "applies the correct width to the ValueNetworkImage widget",
      (WidgetTester tester) async {
        const expectedWidth = 24.0;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _BuildResultPopupCardBuildStatusTestbed(
              projectBuildStatus: successfulProjectBuildStatus,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueImageFinder,
        );

        expect(
          valueNetworkImage.width,
          equals(expectedWidth),
        );
      },
    );
  });
}

/// A testbed class required to test the [BuildResultPopupCardBuildStatus].
class _BuildResultPopupCardBuildStatusTestbed extends StatelessWidget {
  /// A [ProjectBuildStatusViewModel] used in tests.
  final ProjectBuildStatusViewModel projectBuildStatus;

  /// Creates a new instance of this testbed with the given [projectBuildStatus].
  const _BuildResultPopupCardBuildStatusTestbed({
    Key key,
    this.projectBuildStatus = const ProjectBuildStatusViewModel(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RiveAnimationTestbed(
        child: BuildResultPopupCardBuildStatus(
          projectBuildStatus: projectBuildStatus,
        ),
      ),
    );
  }
}
