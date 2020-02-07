import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/presentation/config/color_config.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';

class BuildResultBarGraph extends StatelessWidget {
  final List<BuildResultBarData> data;

  const BuildResultBarGraph({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarGraph(
      title: "Build task name",
      data: data,
      barBuilder: (BuildResultBarData data) {
        return ColoredBar(
          color: _getBuildResultColor(data.result),
        );
      },
    );
  }

  /// Selects the color based on [result].
  Color _getBuildResultColor(BuildResult result) {
    switch (result) {
      case BuildResult.successful:
        return ColorConfig.accentColor;
      case BuildResult.canceled:
        return ColorConfig.cancelColor;
      case BuildResult.failed:
        return ColorConfig.errorColor;
      default:
        return null;
    }
  }
}
