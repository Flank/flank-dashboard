// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_component.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultBarGraph", () {
    const duration = Duration(seconds: 5);

    final buildResults = _BuildResultBarGraphTestbed.buildResultBarTestData;
    final numberOfBuildsToDisplay = buildResults.length;
    final buildResultMetric = BuildResultMetricViewModel(
      buildResults: UnmodifiableListView(buildResults),
    );

    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: Duration.zero,
      date: DateTime.now(),
    );

    final durationStrategy = _BuildResultDurationStrategyMock();

    final barGraphFinder = find.byWidgetPredicate(
      (widget) => widget is BarGraph<int>,
    );

    tearDown(() {
      reset(durationStrategy);
    });

    testWidgets(
      "throws an AssertionError if the given build result metric is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BuildResultBarGraphTestbed(
            buildResultMetric: null,
            durationStrategy: durationStrategy,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given build result duration strategy is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BuildResultBarGraphTestbed(
            buildResultMetric: buildResultMetric,
            durationStrategy: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "creates the number of BuildResultBarComponents equal to the number of the given builds results",
      (WidgetTester tester) async {
        when(durationStrategy.getDuration(any)).thenReturn(duration);
        final buildResultMetric = BuildResultMetricViewModel(
          buildResults: UnmodifiableListView(buildResults),
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
        );

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: buildResultMetric,
          durationStrategy: durationStrategy,
        ));

        final barWidgets = tester.widgetList<BuildResultBarComponent>(
          find.byType(BuildResultBarComponent),
        );

        expect(barWidgets, hasLength(equals(buildResults.length)));
      },
    );

    testWidgets(
      "applies the build result bar padding strategy initialized with build results to the build result components",
      (WidgetTester tester) async {
        when(durationStrategy.getDuration(any)).thenReturn(duration);

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          ),
          durationStrategy: durationStrategy,
        ));

        final barWidgets = tester.widgetList<BuildResultBarComponent>(
          find.byType(BuildResultBarComponent),
        );

        final strategies = barWidgets.map((bar) => bar.paddingStrategy);
        final strategyBuildResults = strategies.map(
          (strategy) => strategy.buildResults,
        );

        expect(strategies, everyElement(isA<BuildResultBarPaddingStrategy>()));
        expect(strategyBuildResults, everyElement(equals(buildResults)));
      },
    );

    testWidgets(
      "wraps each build result bar component with constrained box having non-null min height",
      (WidgetTester tester) async {
        when(durationStrategy.getDuration(any)).thenReturn(duration);

        final results = UnmodifiableListView(buildResults);
        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: results,
            numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          ),
          durationStrategy: durationStrategy,
        ));

        final constrainedBoxes = tester.widgetList<ConstrainedBox>(
          find.byWidgetPredicate((widget) {
            return widget is ConstrainedBox &&
                widget.child is BuildResultBarComponent;
          }),
        );
        final minHeights = constrainedBoxes.map(
          (box) => box.constraints.minHeight,
        );

        expect(minHeights, everyElement(isNotNull));
      },
    );

    testWidgets(
      "displays build result bar components with the build results from the build result metric view model",
      (WidgetTester tester) async {
        when(durationStrategy.getDuration(any)).thenReturn(duration);

        final results = UnmodifiableListView(buildResults);
        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: results,
            numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          ),
          durationStrategy: durationStrategy,
        ));

        final buildResultComponents =
            tester.widgetList<BuildResultBarComponent>(
          find.byType(BuildResultBarComponent),
        );
        final actualResults = buildResultComponents.map(
          (component) => component.buildResult,
        );

        expect(actualResults, equals(results));
      },
    );

    testWidgets(
      "gets the duration of the given build results using the duration strategy",
      (WidgetTester tester) async {
        when(
          durationStrategy.getDuration(any, maxBuildDuration: duration),
        ).thenReturn(duration);

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: numberOfBuildsToDisplay,
            maxBuildDuration: duration,
          ),
          durationStrategy: durationStrategy,
        ));

        verifyInOrder(
          buildResults.map(
            (result) {
              return durationStrategy.getDuration(
                result,
                maxBuildDuration: duration,
              );
            },
          ).toList(),
        );
      },
    );

    testWidgets(
      "displays the bar graph with the data created from the build durations returned by the duration strategy",
      (WidgetTester tester) async {
        when(
          durationStrategy.getDuration(any, maxBuildDuration: duration),
        ).thenReturn(duration);
        final expectedData = [duration.inMilliseconds, duration.inMilliseconds];

        final buildResults = [
          FinishedBuildResultViewModel(
            duration: const Duration(seconds: 5),
            date: DateTime.now(),
            buildStatus: BuildStatus.successful,
            buildResultPopupViewModel: buildResultPopupViewModel,
          ),
          InProgressBuildResultViewModel(
            date: DateTime.now(),
            buildResultPopupViewModel: buildResultPopupViewModel,
          ),
        ];

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: numberOfBuildsToDisplay,
            maxBuildDuration: duration,
          ),
          durationStrategy: durationStrategy,
        ));

        final barGraph = tester.widget<BarGraph>(barGraphFinder);

        expect(barGraph.data, equals(expectedData));
      },
    );

    testWidgets(
      "rebuilds on TimerNotifier tick",
      (WidgetTester tester) async {
        const expectedDuration = Duration(days: 2);
        const initialDuration = Duration(days: 1);

        final timerNotifier = _TimerNotifierMock();
        when(durationStrategy.getDuration(any)).thenReturn(initialDuration);

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: buildResults.length,
          ),
          timerNotifier: timerNotifier,
          durationStrategy: durationStrategy,
        ));

        when(durationStrategy.getDuration(any)).thenReturn(expectedDuration);
        timerNotifier.notifyListeners();
        await tester.pump();

        final barGraph = tester.widget<BarGraph>(barGraphFinder);
        final barGraphData = barGraph.data;

        expect(
          barGraphData,
          everyElement(equals(expectedDuration.inMilliseconds)),
        );
      },
    );
  });
}

/// A testbed class required to test the [BuildResultBarGraph].
class _BuildResultBarGraphTestbed extends StatelessWidget {
  /// A [BuildResultPopupViewModel] test data to test the [BuildResultBarGraph].
  static final _buildResultPopupViewModel = BuildResultPopupViewModel(
    duration: Duration.zero,
    date: DateTime.now(),
  );

  /// A list of [BuildResultViewModel] test data to test the [BuildResultBarGraph].
  static final buildResultBarTestData = [
    FinishedBuildResultViewModel(
      duration: const Duration(seconds: 5),
      date: DateTime.now(),
      buildStatus: BuildStatus.successful,
      buildResultPopupViewModel: _buildResultPopupViewModel,
    ),
    FinishedBuildResultViewModel(
      duration: const Duration(seconds: 5),
      date: DateTime.now().add(const Duration(days: 1)),
      buildStatus: BuildStatus.failed,
      buildResultPopupViewModel: _buildResultPopupViewModel,
    ),
    FinishedBuildResultViewModel(
      duration: const Duration(seconds: 5),
      date: DateTime.now().add(const Duration(days: 2)),
      buildStatus: BuildStatus.unknown,
      buildResultPopupViewModel: _buildResultPopupViewModel,
    ),
  ];

  /// A [BuildResultMetricViewModel] with the data to display.
  final BuildResultMetricViewModel buildResultMetric;

  /// A [BuildResultDurationStrategy] the [BuildResultBarGraph] uses to
  /// calculate the build durations.
  final BuildResultDurationStrategy durationStrategy;

  /// A [TimerNotifier] to use in tests.
  final TimerNotifier timerNotifier;

  /// Creates the [_BuildResultBarGraphTestbed] with the given [buildResultMetric].
  ///
  /// If the [theme] is not specified, an empty [MetricsThemeData] used.
  const _BuildResultBarGraphTestbed({
    Key key,
    this.buildResultMetric,
    this.durationStrategy,
    this.timerNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TestInjectionContainer(
          timerNotifier: timerNotifier,
          child: BuildResultBarGraph(
            buildResultMetric: buildResultMetric,
            durationStrategy: durationStrategy,
          ),
        ),
      ),
    );
  }
}

class _BuildResultDurationStrategyMock extends Mock
    implements BuildResultDurationStrategy {}

class _TimerNotifierMock extends Mock
    with ChangeNotifier
    implements TimerNotifier {}
