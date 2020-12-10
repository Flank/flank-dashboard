import 'package:equatable/equatable.dart';

/// An entity representing an instant config.
class InstantConfig extends Equatable {
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

  /// Creates a new instance of the [InstantConfig] with the given parameters.
  const InstantConfig({
    this.isLoginFormEnabled,
    this.isFpsMonitorEnabled,
    this.isRendererDisplayEnabled,
    this.isDebugMenuEnabled,
  });
}
