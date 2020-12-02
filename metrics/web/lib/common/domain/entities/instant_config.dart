import 'package:meta/meta.dart';

/// An entity representing the instant config.
@immutable
class InstantConfig {
  /// Indicates whether to show the login form.
  final bool isLoginFormEnabled;

  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  /// Indicates whether the renderer display feature is enabled.
  final bool isRendererDisplayEnabled;

  /// Creates a new instance of the [InstantConfig].
  ///
  /// Throws an [ArgumentError] if either of the given [isLoginFormEnabled],
  /// [isFpsMonitorEnabled] or [isRendererDisplayEnabled] is `null`.
  InstantConfig({
    this.isLoginFormEnabled,
    this.isFpsMonitorEnabled,
    this.isRendererDisplayEnabled,
  }) {
    ArgumentError.checkNotNull(isLoginFormEnabled, 'isLoginFormEnabled');
    ArgumentError.checkNotNull(isFpsMonitorEnabled, 'isFpsMonitorEnabled');
    ArgumentError.checkNotNull(
      isRendererDisplayEnabled,
      'isRendererDisplayEnabled',
    );
  }
}
