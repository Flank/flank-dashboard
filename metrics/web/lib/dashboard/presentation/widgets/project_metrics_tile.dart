// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/loading_builder.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_scorecard.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
import 'package:metrics/dashboard/presentation/widgets/stability_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_style_strategy.dart';

/// Displays the project name and it's metrics.
class ProjectMetricsTile extends StatefulWidget {
  /// A [ProjectMetricsTileViewModel] to display.
  final ProjectMetricsTileViewModel projectMetricsViewModel;

  /// Creates the [ProjectMetricsTile].
  ///
  /// Throws an [AssertionError] when the given [projectMetricsViewModel] is null.
  const ProjectMetricsTile({
    Key key,
    @required this.projectMetricsViewModel,
  })  : assert(projectMetricsViewModel != null),
        super(key: key);

  @override
  _ProjectMetricsTileState createState() => _ProjectMetricsTileState();
}

class _ProjectMetricsTileState extends State<ProjectMetricsTile>
    with AutomaticKeepAliveClientMixin {
  /// A height of this tile.
  static const double _tileHeight = 144.0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final projectMetrics = widget.projectMetricsViewModel;
    final theme = MetricsTheme.of(context)
        .projectMetricsTableTheme
        .projectMetricsTileTheme;

    return TappableArea(
      mouseCursor: SystemMouseCursors.basic,
      builder: (context, isHovered, child) {
        return DecoratedContainer(
          height: _tileHeight,
          margin: const EdgeInsets.only(bottom: 4.0),
          decoration: BoxDecoration(
            color:
                isHovered ? theme.hoverBackgroundColor : theme.backgroundColor,
            borderRadius: BorderRadius.circular(2.0),
            border: Border.all(
              color: isHovered ? theme.hoverBorderColor : theme.borderColor,
            ),
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: MetricsTableRow(
          status: ProjectBuildStatus(
            buildStatus: projectMetrics.buildStatus,
            buildStatusStyleStrategy: const ProjectBuildStatusStyleStrategy(),
          ),
          name: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 28.0),
            child: Text(
              projectMetrics.projectName ?? '',
              style: theme.textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          buildResults: SizedBox(
            height: 80.0,
            child: LoadingBuilder(
              isLoading: projectMetrics.buildResultMetrics == null,
              builder: (_) => BuildResultBarGraph(
                buildResultMetric: projectMetrics.buildResultMetrics,
              ),
            ),
          ),
          performance: SizedBox(
            height: 81.0,
            child: LoadingBuilder(
              isLoading: projectMetrics.performanceSparkline == null,
              builder: (_) => PerformanceSparklineGraph(
                performanceSparkline: projectMetrics.performanceSparkline,
              ),
            ),
          ),
          buildNumber: SizedBox(
            height: 80.0,
            child: LoadingBuilder(
              isLoading: projectMetrics.buildNumberMetric == null,
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BuildNumberScorecard(
                    buildNumberMetric: projectMetrics.buildNumberMetric,
                  ),
                );
              },
            ),
          ),
          stability: SizedBox(
            height: 72.0,
            child: LoadingBuilder(
              isLoading: projectMetrics == null,
              builder: (_) => StabilityCirclePercentage(
                stability: projectMetrics.stability,
              ),
            ),
          ),
          coverage: Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 6.0),
            child: SizedBox(
              height: 72.0,
              child: LoadingBuilder(
                isLoading: projectMetrics == null,
                builder: (_) => CoverageCirclePercentage(
                  coverage: projectMetrics.coverage,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
