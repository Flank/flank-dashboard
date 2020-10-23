import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract view model that represents the build result data.
abstract class BuildResultViewModel extends Equatable {
  /// A [Duration] of the build.
  final Duration duration;

  /// A [DateTime] when the build is started.
  final DateTime date;

  /// The resulting status of the build.
  final BuildStatus buildStatus;

  /// Creates a new instance of the [BuildResultViewModel].
  const BuildResultViewModel({this.duration, this.date, this.buildStatus});
}