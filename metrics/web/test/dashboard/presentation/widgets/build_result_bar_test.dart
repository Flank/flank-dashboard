// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_appearance_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultBar", () {
    final successfulBuildResult = FinishedBuildResultViewModel(
      buildResultPopupViewModel: BuildResultPopupViewModel(
        date: DateTime.now(),
        duration: Duration.zero,
        buildStatus: BuildStatus.successful,
      ),
      date: DateTime.now(),
      duration: const Duration(seconds: 20),
      buildStatus: BuildStatus.successful,
      url: 'url',
    );

    final metricsColoredBarFinder = find.byWidgetPredicate(
      (widget) => widget is MetricsColoredBar<BuildStatus>,
    );

    final mouseRegionFinder = find.ancestor(
      of: find.byType(GestureDetector),
      matching: find.byType(MouseRegion),
    );

    MetricsColoredBar getMetricsColoredBar(WidgetTester tester) {
      return tester.widget<MetricsColoredBar>(metricsColoredBarFinder);
    }

    Future<void> hoverBar(WidgetTester tester) async {
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
      mouseRegion.onEnter(const PointerEnterEvent());

      await mockNetworkImagesFor(() {
        return tester.pumpAndSettle();
      });
    }

    testWidgets(
      "throws an AssertionError if the given build result view model is null",
      (tester) async {
        await tester.pumpWidget(const _BuildResultBarTestbed(
          buildResult: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the BuildResultBarAppearanceStrategy to the MetricsColoredBar",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        final bar = getMetricsColoredBar(tester);

        expect(bar.strategy, isA<BuildResultBarAppearanceStrategy>());
      },
    );

    testWidgets(
      "displays the MetricsColoredBar with the build status from the build result view model",
      (tester) async {
        final expectedStatus = successfulBuildResult.buildStatus;
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        final bar = getMetricsColoredBar(tester);

        expect(bar.value, equals(expectedStatus));
      },
    );

    testWidgets(
      "applies the tappable area",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        expect(find.byType(TappableArea), findsOneWidget);
      },
    );

    testWidgets(
      "applies the hover state to the MetricsColoredBar",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        await hoverBar(tester);

        final bar = getMetricsColoredBar(tester);

        expect(bar.isHovered, isTrue);
      },
    );

    testWidgets(
      "applies the minimum height to the metrics colored bar from the constraints",
      (tester) async {
        const expectedHeight = 10.0;

        await tester.pumpWidget(
          _BuildResultBarTestbed(
            constraints: const BoxConstraints(minHeight: expectedHeight),
            buildResult: successfulBuildResult,
          ),
        );

        final bar = getMetricsColoredBar(tester);

        expect(bar.height, equals(expectedHeight));
      },
    );
  });
}

/// A testbed class required to test the [BuildResultBar].
class _BuildResultBarTestbed extends StatelessWidget {
  /// A [BuildResultViewModel] to display.
  final BuildResultViewModel buildResult;

  /// A [BoxConstraints] to apply to this bar in tests.
  final BoxConstraints constraints;

  /// Creates an instance of this testbed.
  ///
  /// The [themeData] default value is an empty [MetricsThemeData] instance.
  /// The [strategy] default value is an empty
  /// [BuildResultBarPaddingStrategy] instance.
  /// The [barHeight] default value is `20.0`.
  const _BuildResultBarTestbed({
    Key key,
    this.buildResult,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          constraints: constraints,
          child: BuildResultBar(
            buildResult: buildResult,
          ),
        ),
      ),
    );
  }
}
