import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/model/bar_data.dart';

typedef BarBuilder<T> = Widget Function(T data);

/// Displays the bar graph with bars.
/// built using the [barBuilder] function from [data].
///
/// This [Widget] will try to fill all available space defined by
/// it's parent constraints.
class BarGraph<T extends BarData> extends StatelessWidget {
  final EdgeInsets graphPadding;
  final List<T> data;
  final BarBuilder<T> barBuilder;
  final ValueChanged<T> onBarTap;
  final ShapeBorder graphShapeBorder;
  final Color backgroundColor;

  /// Creates the [BarGraph].
  ///
  /// The [data] should not be null.
  ///
  /// [data] is the list of data to be displayed on the graph.
  /// [graphPadding] is the padding to inset the graph.
  /// [onBarTap] the [ValueChanged] callback to be called on tap on bar.
  /// [barBuilder] the function to build the bar using the [T].
  /// [graphShapeBorder] is the border of the graph.
  /// [backgroundColor] is the color of graph background.
  const BarGraph({
    Key key,
    @required this.data,
    @required this.barBuilder,
    this.graphShapeBorder,
    this.onBarTap,
    this.graphPadding = const EdgeInsets.all(16.0),
    this.backgroundColor,
  })  : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetThemeData = MetricsTheme.of(context);

    return Card(
      shape: graphShapeBorder,
      color: backgroundColor ?? widgetThemeData.barGraphBackgroundColor,
      child: Padding(
        padding: graphPadding,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final valueUnitHeight = _calculateValueHeight(constraints);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _createChartBars(data, valueUnitHeight),
            );
          },
        ),
      ),
    );
  }

  /// Calculates the height of the value unit based on [constraints].
  double _calculateValueHeight(BoxConstraints constraints) {
    if (data == null || data.isEmpty) return 0;

    final maxBarValue = data
        .map((data) => data.value)
        .reduce((value, element) => value <= element ? element : value);

    final valueHeight = constraints.maxHeight / maxBarValue;
    return valueHeight;
  }

  /// Creates the list of bars from the [data],
  /// using the [valueUnitHeight] to calculate the bar height.
  List<Widget> _createChartBars(List<T> data, double valueUnitHeight) {
    final List<Widget> bars = [];

    if (data == null || data.isEmpty) return bars;

    for (final barData in data) {
      final barHeight = barData.value.toDouble() * valueUnitHeight;

      bars.add(
        Expanded(
          child: GestureDetector(
            onTap: () => onBarTap?.call(barData),
            child: Container(
              constraints: BoxConstraints(
                minHeight: barHeight,
                maxHeight: barHeight,
              ),
              child: barBuilder(barData),
            ),
          ),
        ),
      );
    }

    return bars;
  }
}
