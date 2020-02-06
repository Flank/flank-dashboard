import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';

/// The bar of the [BarGraph] that displays the [BuildResultBarData].
class BuildResultBar extends StatelessWidget {
  final BuildResultBarData buildResult;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Border border;

  /// Creates a [BuildResultBar] from [buildResult].
  ///
  /// [padding] is the padding to inset this bar.
  /// [border] is the border decoration of this bar.
  /// [borderRadius] is the radius of the border of this bar.
  const BuildResultBar({
    Key key,
    @required this.buildResult,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.border,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: _getBuildResultColor(buildResult.result),
          borderRadius: borderRadius,
          border: border,
        ),
      ),
    );
  }

  /// Selects the color based on [result].
  Color _getBuildResultColor(BuildResult result) {
    switch (result) {
      case BuildResult.successful:
        return Colors.teal[400];
      case BuildResult.canceled:
        return Colors.yellowAccent;
      case BuildResult.failed:
        return Colors.redAccent;
      default:
        return null;
    }
  }
}
