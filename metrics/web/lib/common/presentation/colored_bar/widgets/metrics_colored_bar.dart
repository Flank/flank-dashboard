import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/colored_bar/strategy/metrics_colored_bar_appearance_strategy.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that displays the styled bar for the graphs.
class MetricsColoredBar<T> extends StatelessWidget {
  /// A border radius of this bar.
  static const Radius _borderRadius = Radius.circular(1.0);

  /// An appearance strategy to apply to this bar.
  final MetricsColoredBarAppearanceStrategy<T> strategy;

  /// A value to display by this bar.
  final T value;

  /// A height of this bar.
  final double height;

  /// Indicates whether this widget is hovered.
  final bool isHovered;

  /// Creates a new instance of the [MetricsColoredBar].
  const MetricsColoredBar({
    Key key,
    @required this.strategy,
    this.value,
    this.height,
    this.isHovered,
  })  : assert(strategy != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const barWidth = DimensionsConfig.graphBarWidth;
    final style = strategy.getWidgetAppearance(MetricsTheme.of(context), value);

    return Container(
      width: barWidth,
      color: isHovered ? style.backgroundColor : null,
      alignment: Alignment.bottomCenter,
      child: ColoredBar(
        width: barWidth,
        height: height,
        borderRadius: const BorderRadius.only(
          topLeft: _borderRadius,
          topRight: _borderRadius,
        ),
        color: style.color,
      ),
    );
  }
}
