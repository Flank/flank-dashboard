import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the bar to display on the [BarGraph].
class BuildResultViewModel extends Equatable {
  /// A [Duration] of the build.
  final Duration duration;

  /// A [DateTime] when the build is started.
  final DateTime date;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  /// The url of the CI build.
  final String url;

  @override
  List<Object> get props => [duration, date, buildStatus, url];

  /// Creates the [BuildResultViewModel] with the given build parameters.
  ///
  /// The [buildResultPopupViewModel] must not be null.
  const BuildResultViewModel({
    @required this.duration,
    @required this.date,
    this.buildStatus,
    this.url,
  })  : assert(date != null),
        assert(duration != null);
}
