import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the bar to display on the [BarGraph].
class BuildResultViewModel extends BuildResultPopupViewModel {
  /// The url of the CI build.
  final String url;

  @override
  List<Object> get props => [duration, date, buildStatus, url];

  /// Creates a new instance of the [BuildResultViewModel].
  const BuildResultViewModel({
    DateTime date,
    Duration duration,
    BuildStatus buildStatus,
    this.url,
  }) : super(
          duration: duration,
          date: date,
          buildStatus: buildStatus,
        );
}
