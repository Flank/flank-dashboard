// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [BuildResultViewModel] that holds the data about an in-progress [Build]
/// to display as a bar on a [BarGraph].
class InProgressBuildResultViewModel extends BuildResultViewModel {
  /// Creates a new instance of the [InProgressBuildResultViewModel].
  ///
  /// All the required parameters must not be null.
  ///
  /// Throws an [AssertionError] if the [buildResultPopupViewModel] or [date]
  /// is `null`.
  const InProgressBuildResultViewModel({
    @required BuildResultPopupViewModel buildResultPopupViewModel,
    @required DateTime date,
    String url,
  }) : super(
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
          buildStatus: BuildStatus.inProgress,
          url: url,
        );
}
