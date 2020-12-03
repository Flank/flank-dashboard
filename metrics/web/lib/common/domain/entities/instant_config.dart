import 'package:equatable/equatable.dart';

/// An entity representing an instant config.
class InstantConfig extends Equatable {
  /// Indicates whether the login form with email and password is enabled.
  final bool isLoginFormEnabled;

  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  /// Indicates whether the renderer display feature is enabled.
  final bool isRendererDisplayEnabled;

  @override
  List<Object> get props => [
        isLoginFormEnabled,
        isFpsMonitorEnabled,
        isRendererDisplayEnabled,
      ];

  /// Creates a new instance of the [InstantConfig].
  const InstantConfig({
    this.isLoginFormEnabled,
    this.isFpsMonitorEnabled,
    this.isRendererDisplayEnabled,
  });
}
