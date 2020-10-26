import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics_core/metrics_core.dart';

/// A view model that represents the data of the build
/// to display on the [BuildResultPopupCard].
class BuildResultPopupViewModel extends Equatable {
  /// A [Duration] of the build.
  final Duration duration;

  /// A [DateTime] when the build is started.
  final DateTime date;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  @override
  List<Object> get props => [duration, date, buildStatus];

  /// Creates a new instance of the [BuildResultPopupViewModel].
  ///
  /// Both the [duration] and [date] must not be `null`.
  const BuildResultPopupViewModel({
    @required this.duration,
    @required this.date,
    this.buildStatus,
  })  : assert(duration != null),
        assert(date != null);
}
