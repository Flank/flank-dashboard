import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a local config parameter.
class LocalConfigParam extends Equatable {
  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  @override
  List<Object> get props => [isFpsMonitorEnabled];

  /// Creates a new instance of the [LocalConfigParam]
  /// with the given [isFprsMonitorEnabled].
  ///
  /// Throws an [ArgumentError] if the given [isFpsMonitorEnabled] is `null`.
  LocalConfigParam({@required this.isFpsMonitorEnabled}) {
    ArgumentError.checkNotNull(
        isFpsMonitorEnabled, 'isPasswordSignInOptionEnabled');
  }
}
