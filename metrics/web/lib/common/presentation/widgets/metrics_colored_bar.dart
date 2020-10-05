import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// Rectangle bar of the [BarGraph] painted based on [barStyleStrategy] and [buildStatus].
class MetricsColoredBar extends StatelessWidget {
  /// A border radius of this bar.
  static const _borderRadius = Radius.circular(1.0);

  /// An appearance strategy applied to the [MetricsColoredBar] widget.
  final BuildResultBarStyleStrategy barStrategy;

  /// The resulting status of the build.
  final BuildStatus status;

  /// A height of this bar.
  final double height;

  /// Indicates whether this widget is hovered.
  final bool isHovered;

  /// Creates a new instance of the [MetricsColoredBar].
  const MetricsColoredBar({
    Key key,
    this.barStrategy,
    this.status,
    this.height,
    this.isHovered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const barWidth = DimensionsConfig.buildResultBarWidth;
    final theme = barStrategy.getWidgetAppearance(
      MetricsTheme.of(context),
      status,
    );

    return Container(
      width: barWidth,
      color: isHovered ? theme.backgroundColor : null,
      alignment: Alignment.bottomCenter,
      child: ColoredBar(
        width: barWidth,
        height: height,
        borderRadius: const BorderRadius.only(
          topLeft: _borderRadius,
          topRight: _borderRadius,
        ),
        color: theme.color,
      ),
    );
  }
}
