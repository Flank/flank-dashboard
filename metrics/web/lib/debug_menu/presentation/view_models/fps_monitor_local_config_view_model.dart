import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents a FPS monitor local config feature.
class FpsMonitorLocalConfigViewModel extends Equatable {
  /// Indicates whether this fps monitor is enabled.
  final bool isEnabled;

  @override
  List<Object> get props => [isEnabled];

  /// Creates a new instance of the [FpsMonitorLocalConfigViewModel]
  /// with the given [isEnabled] value.
  ///
  /// Throws an [AssertionError] if the given [isEnabled] is null.
  const FpsMonitorLocalConfigViewModel({
    @required this.isEnabled,
  }) : assert(isEnabled != null);
}
