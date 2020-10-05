import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// An abstract widget that displays a styled graph indicator
/// and applies the [MetricsThemeData.graphIndicatorTheme].
abstract class GraphIndicator extends StatelessWidget {
  /// Creates a new instance of the [GraphIndicator].
  const GraphIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).graphIndicatorTheme;
    final attentionLevel = theme.attentionLevel;
    final style = selectStyle(attentionLevel);

    return CircleGraphIndicator(
      innerDiameter: DimensionsConfig.graphIndicatorInnerDiameter,
      outerDiameter: DimensionsConfig.graphIndicatorOuterDiameter,
      innerColor: style.innerColor,
      outerColor: style.outerColor,
    );
  }

  /// Selects a [GraphIndicatorStyle] for this circle graph
  /// from the given [attentionLevel].
  GraphIndicatorStyle selectStyle(GraphIndicatorAttentionLevel attentionLevel);
}
