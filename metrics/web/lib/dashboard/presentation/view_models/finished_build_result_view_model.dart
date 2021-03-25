// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [BuildResultViewModel] that holds the data about a [Build] that is
/// finished to display as a bar on a [BarGraph].
class FinishedBuildResultViewModel extends BuildResultViewModel
    with EquatableMixin {
  /// A [Duration] of the build.
  final Duration duration;

  @override
  List<Object> get props => super.props..add(duration);

  /// Creates a new instance of the [FinishedBuildResultViewModel].
  ///
  /// All the required parameters must not be null.
  ///
  /// Throws an [AssertionError] if any of the required parameters is `null`.
  const FinishedBuildResultViewModel({
    @required this.duration,
    @required BuildResultPopupViewModel buildResultPopupViewModel,
    @required DateTime date,
    String url,
    BuildStatus buildStatus,
  })  : assert(duration != null),
        assert(buildStatus != BuildStatus.inProgress),
        super(
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );
}
