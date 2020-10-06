import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the bar to display on the [BarGraph].
class BuildResultViewModel extends Equatable {
  /// A view model with data to display on the build result popup.
  final BuildResultPopupViewModel buildResultPopupViewModel;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  /// The url of the CI build.
  final String url;

  @override
  List<Object> get props => [buildResultPopupViewModel, buildStatus, url];

  /// Creates the [BuildResultViewModel] with the given build parameters.
  ///
  /// The [buildResultPopupViewModel] must not be null.
  const BuildResultViewModel({
    @required this.buildResultPopupViewModel,
    this.buildStatus,
    this.url,
  }) : assert(buildResultPopupViewModel != null);
}
