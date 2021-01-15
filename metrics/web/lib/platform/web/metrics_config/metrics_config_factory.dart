import 'package:metrics/common/domain/entities/metrics_config.dart';
import 'package:metrics/platform/web/metrics_config/web_metrics_config.dart';

/// A factory class that creates instances of [WebMetricsConfig].
class MetricsConfigFactory {
  /// Creates a new instance of the [WebMetricsConfig].
  MetricsConfig create() {
    return WebMetricsConfig();
  }
}
