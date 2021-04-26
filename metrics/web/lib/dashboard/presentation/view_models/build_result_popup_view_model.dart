// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';

/// A view model that represents the data of the build
/// to display on the [BuildResultPopupCard].
class BuildResultPopupViewModel extends Equatable {
  /// A [DateTime] when the build is started.
  final DateTime date;

  /// A [Duration] of the build.
  final Duration duration;

  /// A [ProjectBuildStatusViewModel] with the [BuildStatus] of the build.
  final ProjectBuildStatusViewModel buildStatus;

  @override
  List<Object> get props => [date, duration, buildStatus];

  /// Creates a new instance of the [BuildResultPopupViewModel] with the given
  /// parameters.
  ///
  /// Throws an [AssertionError] if the given [date] is `null`.
  const BuildResultPopupViewModel({
    @required this.date,
    this.duration,
    this.buildStatus,
  }) : assert(date != null);
}
