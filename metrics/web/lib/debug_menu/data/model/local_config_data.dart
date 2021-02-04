// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the [LocalConfig] entity.
class LocalConfigData extends LocalConfig implements DataModel {
  /// Creates a new instance of the [LocalConfigData]
  /// with the given [isFpsMonitorEnabled].
  const LocalConfigData({
    bool isFpsMonitorEnabled,
  }) : super(isFpsMonitorEnabled: isFpsMonitorEnabled);

  /// Creates the [LocalConfigData] from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory LocalConfigData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return LocalConfigData(
      isFpsMonitorEnabled: json['isFpsMonitorEnabled'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isFpsMonitorEnabled': isFpsMonitorEnabled,
    };
  }
}
