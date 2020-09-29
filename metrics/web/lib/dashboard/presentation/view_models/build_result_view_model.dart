import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/dashboard_popup_card_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the bar to display in the [BarGraph].
class BuildResultViewModel extends Equatable {
  /// The dashboard popup card view model.
  final DashboardPopupCardViewModel dashboardPopupCardViewModel;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  /// The url of the CI build.
  final String url;

  @override
  List<Object> get props => [dashboardPopupCardViewModel, buildStatus, url];

  /// Creates the [BuildResultViewModel] with the given build parameters.
  ///
  /// The [dashboardPopupCardViewModel] must not be null.
  const BuildResultViewModel({
    @required this.dashboardPopupCardViewModel,
    this.buildStatus,
    this.url,
  }) : assert(dashboardPopupCardViewModel != null);
}
