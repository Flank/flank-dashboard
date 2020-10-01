import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/attention_level/metrics_circle_graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/style/metrics_circle_graph_indicator_style.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// An abstract widget that displays a metrics styled circle graph indicator
/// and applies the [MetricsThemeData.metricsCircleGraphIndicatorTheme].
abstract class MetricsCircleGraphIndicator extends StatelessWidget {
  /// A diameter of the inner circle.
  static const _innerDiameter = 4.0;

  /// Creates a new instance of the [MetricsCircleGraphIndicator].
  const MetricsCircleGraphIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).metricsCircleGraphIndicatorTheme;
    final attentionLevel = theme.attentionLevel;
    final style = selectStyle(attentionLevel);

    return CircleGraphIndicator(
      innerDiameter: _innerDiameter,
      outerDiameter: DimensionsConfig.circleGraphIndicatorOuterDiameter,
      innerColor: style.innerColor,
      outerColor: style.outerColor,
    );
  }

  /// Selects a [MetricsCircleGraphIndicatorStyle] for this
  /// circle graph from the given [attentionLevel].
  MetricsCircleGraphIndicatorStyle selectStyle(
    MetricsCircleGraphIndicatorAttentionLevel attentionLevel,
  );
}
