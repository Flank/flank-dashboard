import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/model/bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

typedef BarBuilder<T> = Widget Function(T data);

/// Displays the bar graph with bars.
/// built using the [barBuilder] function from [data].
///
///
/// This [Widget] will try to fill all available space defined by
/// it's parent constraints.
class BarGraph<T extends BarData> extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final EdgeInsets graphPadding;
  final List<T> data;
  final BarBuilder<T> barBuilder;
  final ValueChanged<T> onBarTap;
  final ShapeBorder graphShapeBorder;

  /// Creates the [BarGraph].
  ///
  /// The [title] and [data] should not be null.
  ///
  /// The [title] is the text displayed above the graph.
  /// [data] is the list of data to be displayed on the graph.
  /// [graphPadding] is the padding to inset the graph.
  /// [titleStyle] the [TextStyle] of the [title] text.
  /// [onBarTap] the [ValueChanged] callback to be called on tap on bar.
  /// [valueFunction] it the function to get the bar value from [T].
  /// [barBuilder] the function to build the bar using the [T].
  /// [graphShapeBorder] is the border of the graph.
  const BarGraph({
    Key key,
    @required this.title,
    @required this.data,
    @required this.barBuilder,
    this.graphShapeBorder,
    this.onBarTap,
    this.graphPadding = const EdgeInsets.all(16.0),
    this.titleStyle,
  })  : assert(title != null),
        assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ExpandableText(
              title,
              style: titleStyle,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Card(
            shape: graphShapeBorder,
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
          ),
        ),
      ],
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
