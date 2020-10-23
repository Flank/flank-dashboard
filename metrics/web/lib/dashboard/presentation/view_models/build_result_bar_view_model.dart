import 'package:flutter/cupertino.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the bar to display on the [BarGraph].
class BuildResultBarViewModel extends BuildResultViewModel {
  /// The url of the CI build.
  final String url;

  @override
  List<Object> get props => [duration, date, buildStatus, url];

  /// Creates a new instance of the [BuildResultBarViewModel].
  ///
  /// Both the [duration] and [date] must not be `null`.
  const BuildResultBarViewModel({
    @required DateTime date,
    @required Duration duration,
    BuildStatus buildStatus,
    this.url,
  })  : assert(date != null),
        assert(duration != null),
        super(duration: duration, date: date, buildStatus: buildStatus);
}
