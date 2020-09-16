import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the bar to display in [BarGraph].
class BuildResultViewModel extends Equatable {
  /// The abstract value of the build.
  ///
  /// Usually stands for the duration of the build this view model belongs to.
  /// But can be any other integer parameter of the build.
  final int value;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  /// The url of the CI build.
  final String url;

  @override
  List<Object> get props => [value, buildStatus, url];

  /// Creates the [BuildResultViewModel] with the given build parameters.
  const BuildResultViewModel({
    @required this.value,
    this.buildStatus,
    this.url,
  }) : assert(value != null);
}
