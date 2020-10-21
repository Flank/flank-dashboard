import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/colored_bar/strategy/metrics_colored_bar_appearance_strategy.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that displays the styled bar for the graphs.
class MetricsColoredBar<T> extends StatelessWidget {
  /// An appearance strategy to apply to this bar.
  final MetricsColoredBarAppearanceStrategy<T> strategy;

  /// A value to display by this bar.
  final T value;

  /// A height of this bar.
  final double height;

  /// Indicates whether this widget is hovered.
  final bool isHovered;

  /// Creates a new instance of the [MetricsColoredBar].
  ///
  /// The [isHovered] default value is `false`.
  const MetricsColoredBar({
    Key key,
    @required this.strategy,
    this.isHovered = false,
    this.value,
    this.height,
  })  : assert(strategy != null),
        assert(isHovered != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(1.0);
    const barWidth = DimensionsConfig.graphBarWidth;
    final style = strategy.getWidgetAppearance(MetricsTheme.of(context), value);

    return Container(
      width: barWidth,
      alignment: Alignment.bottomCenter,
      child: ColoredBar(
        width: barWidth,
        height: height,
        borderRadius: const BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        color: isHovered ? style.backgroundColor : style.color,
      ),
    );
  }
}
