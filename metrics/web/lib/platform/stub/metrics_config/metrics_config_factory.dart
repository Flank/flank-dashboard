import 'package:metrics/common/domain/entities/metrics_config.dart';

/// A factory class stub implementation to support conditional imports.
class MetricsConfigFactory {
  /// Implemented in platform specific packages within `platform`.
  MetricsConfig create() {
    throw UnsupportedError(
      'Cannot create config without dart:html',
    );
  }
}
