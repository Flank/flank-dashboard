import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents an instant config parameter.
class InstantConfigParam extends Equatable {
  /// Indicates whether the login form with email and password is enabled.
  final bool isLoginFormEnabled;

  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  /// Indicates whether the renderer display feature is enabled.
  final bool isRendererDisplayEnabled;

  /// Indicates whether the debug menu feature is enabled.
  final bool isDebugMenuEnabled;

  @override
  List<Object> get props => [
        isLoginFormEnabled,
        isFpsMonitorEnabled,
        isRendererDisplayEnabled,
        isDebugMenuEnabled,
      ];

  /// Creates a new instance of the [InstantConfigParam]
  /// with the given config parameters.
  ///
  /// Throws an [ArgumentError] if one of the required parameters is `null`.
  InstantConfigParam({
    @required this.isLoginFormEnabled,
    @required this.isFpsMonitorEnabled,
    @required this.isRendererDisplayEnabled,
    @required this.isDebugMenuEnabled,
  }) {
    ArgumentError.checkNotNull(isLoginFormEnabled, 'isLoginFormEnabled');
    ArgumentError.checkNotNull(isFpsMonitorEnabled, 'isFpsMonitorEnabled');
    ArgumentError.checkNotNull(
      isRendererDisplayEnabled,
      'isRendererDisplayEnabled',
    );
    ArgumentError.checkNotNull(
      isDebugMenuEnabled,
      'isDebugMenuEnabled',
    );
  }
}
