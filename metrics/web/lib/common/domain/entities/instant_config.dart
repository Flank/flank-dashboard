import 'package:meta/meta.dart';

/// An entity representing an instant config.
@immutable
class InstantConfig {
  /// Indicates whether the login form with email and password is enabled.
  final bool isLoginFormEnabled;

  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  /// Indicates whether the renderer display feature is enabled.
  final bool isRendererDisplayEnabled;

  /// Creates a new instance of the [InstantConfig].
  const InstantConfig({
    this.isLoginFormEnabled,
    this.isFpsMonitorEnabled,
    this.isRendererDisplayEnabled,
  });
}
