// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/asset/strategy/value_based_asset_strategy.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:metrics/common/presentation/widgets/build_status_view.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/presentation/widgets/rive_animation_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildStatusView", () {
    const asset = 'asset';
    const finishedBuildStatus = BuildStatus.successful;
    const inProgressBuildStatus = BuildStatus.inProgress;

    final strategy = _ValueBasedAssetStrategyMock();

    final valueNetworkImageFinder = find.byWidgetPredicate((widget) {
      return widget is ValueNetworkImage<BuildStatus>;
    });

    tearDown(() {
      reset(strategy);
    });

    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BuildStatusViewTestbed(
            strategy: null,
            buildStatus: finishedBuildStatus,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given build status is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BuildStatusViewTestbed(
            strategy: strategy,
            buildStatus: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the rive animation widget if the given build status is in progress",
      (WidgetTester tester) async {
        when(strategy.getAsset(inProgressBuildStatus)).thenReturn(asset);

        await tester.pumpWidget(
          _BuildStatusViewTestbed(
            strategy: strategy,
            buildStatus: inProgressBuildStatus,
          ),
        );

        expect(find.byType(RiveAnimation), findsOneWidget);
      },
    );

    testWidgets(
      "applies the animation asset returned by the strategy to the rive animation",
      (WidgetTester tester) async {
        when(strategy.getAsset(inProgressBuildStatus)).thenReturn(asset);

        await tester.pumpWidget(
          _BuildStatusViewTestbed(
            strategy: strategy,
            buildStatus: inProgressBuildStatus,
          ),
        );

        final rive = FinderUtil.findRiveAnimation(tester);

        expect(rive.assetName, equals(asset));
      },
    );

    testWidgets(
      "displays the rive animation widget with the use artboard size parameter set to true",
      (WidgetTester tester) async {
        when(strategy.getAsset(inProgressBuildStatus)).thenReturn(asset);

        await tester.pumpWidget(
          _BuildStatusViewTestbed(
            strategy: strategy,
            buildStatus: inProgressBuildStatus,
          ),
        );

        final rive = FinderUtil.findRiveAnimation(tester);

        expect(rive.useArtboardSize, isTrue);
      },
    );

    testWidgets(
      "displays the rive animation with the correct animation name",
      (WidgetTester tester) async {
        const expectedAnimationName = 'Animation 1';
        when(strategy.getAsset(inProgressBuildStatus)).thenReturn(asset);

        await tester.pumpWidget(
          _BuildStatusViewTestbed(
            strategy: strategy,
            buildStatus: inProgressBuildStatus,
          ),
        );

        final rive = FinderUtil.findRiveAnimation(tester);

        final animationControllerMatcher = predicate((controller) {
          return controller is SimpleAnimation &&
              controller.animationName == expectedAnimationName;
        });

        expect(rive.controller, animationControllerMatcher);
      },
    );

    testWidgets(
      "displays the value network image widget if the given build status is finished",
      (WidgetTester tester) async {
        when(strategy.getAsset(finishedBuildStatus)).thenReturn(asset);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildStatusViewTestbed(
              strategy: strategy,
              buildStatus: finishedBuildStatus,
            ),
          );
        });

        expect(valueNetworkImageFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given asset strategy to the value network image",
      (WidgetTester tester) async {
        when(strategy.getAsset(finishedBuildStatus)).thenReturn(asset);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildStatusViewTestbed(
              strategy: strategy,
              buildStatus: finishedBuildStatus,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueNetworkImageFinder,
        );

        expect(valueNetworkImage.strategy, equals(strategy));
      },
    );

    testWidgets(
      "displays the value network image with the given build status",
      (WidgetTester tester) async {
        const expectedBuildStatus = BuildStatus.failed;
        when(strategy.getAsset(expectedBuildStatus)).thenReturn(asset);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildStatusViewTestbed(
              strategy: strategy,
              buildStatus: expectedBuildStatus,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueNetworkImageFinder,
        );

        expect(valueNetworkImage.value, equals(expectedBuildStatus));
      },
    );

    testWidgets(
      "applies the given height to the value network image",
      (WidgetTester tester) async {
        const expectedHeight = 24.0;
        when(strategy.getAsset(finishedBuildStatus)).thenReturn(asset);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildStatusViewTestbed(
              strategy: strategy,
              buildStatus: finishedBuildStatus,
              height: expectedHeight,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueNetworkImageFinder,
        );

        expect(valueNetworkImage.height, equals(expectedHeight));
      },
    );

    testWidgets(
      "applies the given width to the value network image",
      (WidgetTester tester) async {
        const expectedWidth = 24.0;
        when(strategy.getAsset(finishedBuildStatus)).thenReturn(asset);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildStatusViewTestbed(
              strategy: strategy,
              buildStatus: finishedBuildStatus,
              width: expectedWidth,
            ),
          );
        });

        final valueNetworkImage = tester.widget<ValueNetworkImage>(
          valueNetworkImageFinder,
        );

        expect(valueNetworkImage.width, equals(expectedWidth));
      },
    );
  });
}

/// A testbed class that is used to test the [BuildStatusView] widget.
class _BuildStatusViewTestbed extends StatelessWidget {
  /// A [BuildStatus] to use in tests.
  final BuildStatus buildStatus;

  /// A [ValueBasedAssetStrategy] to use in tests.
  final ValueBasedAssetStrategy<BuildStatus> strategy;

  /// A height to use in tests.
  final double height;

  /// A width to use in tests.
  final double width;

  /// Creates a new instance of the [_BuildStatusViewTestbed] with the
  /// given parameters.
  const _BuildStatusViewTestbed({
    Key key,
    this.strategy,
    this.buildStatus,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RiveAnimationTestbed(
        child: BuildStatusView(
          strategy: strategy,
          buildStatus: buildStatus,
          height: height,
          width: width,
        ),
      ),
    );
  }
}

class _ValueBasedAssetStrategyMock extends Mock
    implements ValueBasedAssetStrategy<BuildStatus> {}
