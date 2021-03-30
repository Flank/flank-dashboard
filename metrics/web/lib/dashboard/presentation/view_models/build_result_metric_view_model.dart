// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';

/// A view model that represents the build result metric.
class BuildResultMetricViewModel extends Equatable {
  /// A list of [BuildResultViewModel]s.
  final UnmodifiableListView<BuildResultViewModel> buildResults;

  /// A maximum [Duration] of a finished build within the [buildResults].
  final Duration maxBuildDuration;

  /// A [DateTime] of this view model's first build.
  final DateTime firstBuildDate;

  /// A [DateTime] of this view model's last build.
  final DateTime lastBuildDate;

  /// A number of [buildResults] elements to display.
  final int numberOfBuildsToDisplay;

  @override
  List<Object> get props => [
        buildResults,
        maxBuildDuration,
        firstBuildDate,
        lastBuildDate,
        numberOfBuildsToDisplay,
      ];

  /// Creates an instance of the [BuildResultMetricViewModel] with the given
  /// parameters.
  ///
  /// The [numberOfBuildsToDisplay] default value is
  /// [ReceiveProjectMetricsUpdates.buildsToLoadForChartMetrics].
  ///
  /// The [buildResults] must not be `null`.
  /// The [numberOfBuildsToDisplay] must not be `null`.
  const BuildResultMetricViewModel({
    @required this.buildResults,
    this.firstBuildDate,
    this.lastBuildDate,
    this.maxBuildDuration,
    this.numberOfBuildsToDisplay =
        ReceiveProjectMetricsUpdates.buildsToLoadForChartMetrics,
  })  : assert(buildResults != null),
        assert(numberOfBuildsToDisplay != null);
}
