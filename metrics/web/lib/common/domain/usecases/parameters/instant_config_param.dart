import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents an instant config parameter.
class InstantConfigParam extends Equatable {
  /// Indicates whether to show the login form.
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

  /// Creates a new instance of the [InstantConfigParam]
  /// with the given [isLoginFormEnabled], [isFpsMonitorEnabled],
  /// and [isRendererDisplayEnabled].
  ///
  /// Throws an [ArgumentError] if one of the required parameters is `null`.
  InstantConfigParam({
    @required this.isLoginFormEnabled,
    @required this.isFpsMonitorEnabled,
    @required this.isRendererDisplayEnabled,
  }) {
    ArgumentError.checkNotNull(isLoginFormEnabled, 'isLoginFormEnabled');
    ArgumentError.checkNotNull(isFpsMonitorEnabled, 'isFpsMonitorEnabled');
    ArgumentError.checkNotNull(
      isRendererDisplayEnabled,
      'isRendererDisplayEnabled',
    );
  }
}
