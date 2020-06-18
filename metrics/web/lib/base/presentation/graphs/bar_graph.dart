import 'package:flutter/material.dart';

/// A widget builder function for building the bar graph.
typedef BarBuilder = Widget Function(int index);

/// Displays the bar graph with bars
/// built using the [barBuilder] function from [data].
///
/// This [Widget] will try to fill all available space defined by it's parent
/// constraints.
class BarGraph<T extends num> extends StatelessWidget {
  /// The padding to inset this graph.
  final EdgeInsets graphPadding;

  /// The list of data to be displayed on the graph.
  final List<T> data;

  /// The function to build the bar using the [T].
  final BarBuilder barBuilder;

  /// Creates the [BarGraph].
  ///
  /// The [barBuilder] must not be `null`.
  /// The [graphPadding] default value is [EdgeInsets.all] with
  /// parameter equal to `16.0`.
  const BarGraph({
    Key key,
    this.data,
    @required this.barBuilder,
    this.graphPadding = const EdgeInsets.all(16.0),
  })  : assert(barBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: graphPadding,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final valueUnitHeight = _calculateValueUnitHeight(constraints);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _createChartBars(data, valueUnitHeight),
          );
        },
      ),
    );
  }

  /// Calculates the height of the value unit based on [constraints].
  double _calculateValueUnitHeight(BoxConstraints constraints) {
    if (data == null || data.isEmpty) return 0.0;

    final maxBarValue =
        data.reduce((value, element) => value <= element ? element : value);

    return constraints.maxHeight / maxBarValue;
  }

  /// Creates the list of bars from the [data],
  /// using the [valueUnitHeight] to calculate the bar height.
  List<Widget> _createChartBars(List<num> data, double valueUnitHeight) {
    final List<Widget> bars = [];

    if (data == null || data.isEmpty) return bars;

    for (int index = 0; index < data.length; index++) {
      final barData = data[index];
      final barHeight = barData.toDouble() * valueUnitHeight;

      bars.add(
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              minHeight: barHeight,
              maxHeight: barHeight,
            ),
            child: barBuilder(index),
          ),
        ),
      );
    }

    return bars;
  }
}
