// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the bar to display on the [BarGraph].
class BuildResultViewModel extends Equatable {
  /// A view model with data to display on the build result popup.
  final BuildResultPopupViewModel buildResultPopupViewModel;

  /// A [DateTime] when the build is started.
  final DateTime date;

  /// A [Duration] of the build.
  final Duration duration;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  /// The url of the CI build.
  final String url;

  @override
  List<Object> get props =>
      [buildResultPopupViewModel, date, duration, buildStatus, url];

  /// Creates a new instance of the [BuildResultViewModel].
  ///
  /// All the required parameters must not be null.
  const BuildResultViewModel({
    @required this.buildResultPopupViewModel,
    @required this.date,
    @required this.duration,
    this.buildStatus,
    this.url,
  })  : assert(buildResultPopupViewModel != null),
        assert(date != null),
        assert(duration != null);
}
