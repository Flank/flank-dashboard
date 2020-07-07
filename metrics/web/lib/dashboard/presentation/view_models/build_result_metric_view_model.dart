import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';

/// A view model that represents the build result metric.
class BuildResultMetricViewModel extends Equatable {
  /// A list of [BuildResultViewModel]s.
  final UnmodifiableListView<BuildResultViewModel> buildResults;

  /// A number of [buildResults] elements to display.
  final int numberOfBuildsToDisplay;

  @override
  List<Object> get props => [buildResults];

  /// Creates the [BuildResultMetricViewModel] with the given [buildResults].
  ///
  /// The default value of the [buildResults] is an empty list.
  /// The [buildResults] must not be `null`.
  /// The [numberOfBuildsToDisplay] must not be `null`.
  const BuildResultMetricViewModel({
    @required this.buildResults,
    this.numberOfBuildsToDisplay =
        ReceiveProjectMetricsUpdates.lastBuildsForChartsMetrics,
  })  : assert(buildResults != null),
        assert(numberOfBuildsToDisplay != null);
}
