import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/attention_level/metrics_circle_graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/style/metrics_circle_graph_indicator_style.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/theme/metrics_circle_graph_indicator_theme_data.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/widgets/metrics_circle_graph_indicator.dart';

/// A [MetricsCircleGraphIndicator] widget that applies
/// the [MetricsCircleGraphIndicatorAttentionLevel.failed] circle graph style
/// from the [MetricsCircleGraphIndicatorThemeData].
class MetricsFailedCircleGraphIndicator extends MetricsCircleGraphIndicator {
  /// Creates a new instance of the [MetricsFailedCircleGraphIndicator].
  const MetricsFailedCircleGraphIndicator({Key key}) : super(key: key);

  @override
  MetricsCircleGraphIndicatorStyle selectStyle(
    MetricsCircleGraphIndicatorAttentionLevel attentionLevel,
  ) {
    return attentionLevel.failed;
  }
}
