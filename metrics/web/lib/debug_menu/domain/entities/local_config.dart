import 'package:equatable/equatable.dart';

/// An entity representing a local config.
class LocalConfig extends Equatable {
  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  @override
  List<Object> get props => [isFpsMonitorEnabled];

  /// Creates a new instance of the [LocalConfig]
  /// with the given [isFpsMonitorEnabled].
  const LocalConfig({
    this.isFpsMonitorEnabled,
  });
}
