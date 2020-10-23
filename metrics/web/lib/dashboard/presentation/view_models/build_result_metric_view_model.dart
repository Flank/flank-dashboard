import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_bar_view_model.dart';

/// A view model that represents the build result metric.
class BuildResultMetricViewModel extends Equatable {
  /// A list of [BuildResultBarViewModel]s.
  final UnmodifiableListView<BuildResultBarViewModel> buildResults;

  /// A number of [buildResults] elements to display.
  final int numberOfBuildsToDisplay;

  @override
  List<Object> get props => [buildResults];

  /// Creates the [BuildResultMetricViewModel] with the given [buildResults].
  ///
  /// The [numberOfBuildsToDisplay] default value is
  /// [ReceiveProjectMetricsUpdates.buildsToLoadForChartMetrics].
  ///
  /// The [buildResults] must not be `null`.
  /// The [numberOfBuildsToDisplay] must not be `null`.
  const BuildResultMetricViewModel({
    @required this.buildResults,
    this.numberOfBuildsToDisplay =
        ReceiveProjectMetricsUpdates.buildsToLoadForChartMetrics,
  })  : assert(buildResults != null),
        assert(numberOfBuildsToDisplay != null);
}
