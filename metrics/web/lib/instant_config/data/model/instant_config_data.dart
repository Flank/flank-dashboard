import 'package:metrics/instant_config/domain/entities/instant_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the [InstantConfig] entity.
class InstantConfigData extends InstantConfig implements DataModel {
  /// Creates a new instance of the [InstantConfigData]
  /// with the given config parameters.
  const InstantConfigData({
    bool isLoginFormEnabled,
    bool isFpsMonitorEnabled,
    bool isRendererDisplayEnabled,
  }) : super(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        );

  /// Creates the [InstantConfigData] from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory InstantConfigData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return InstantConfigData(
      isLoginFormEnabled: json['isLoginFormEnabled'] as bool,
      isFpsMonitorEnabled: json['isFpsMonitorEnabled'] as bool,
      isRendererDisplayEnabled: json['isRendererDisplayEnabled'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isLoginFormEnabled': isLoginFormEnabled,
      'isFpsMonitorEnabled': isFpsMonitorEnabled,
      'isRendererDisplayEnabled': isRendererDisplayEnabled,
    };
  }
}
