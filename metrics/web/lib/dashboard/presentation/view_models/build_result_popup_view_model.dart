// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the build
/// to display on the [BuildResultPopupCard].
class BuildResultPopupViewModel extends Equatable {
  /// A [DateTime] when the build is started.
  final DateTime date;

  /// A [Duration] of the build.
  final Duration duration;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  @override
  List<Object> get props => [date, duration, buildStatus];

  /// Creates a new instance of the [BuildResultPopupViewModel].
  ///
  /// Both the [date] and [duration] must not be `null`.
  const BuildResultPopupViewModel({
    @required this.date,
    @required this.duration,
    this.buildStatus,
  })  : assert(date != null),
        assert(duration != null);
}
