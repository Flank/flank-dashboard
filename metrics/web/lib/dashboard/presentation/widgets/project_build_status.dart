import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_image.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_status_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that displays an image representation of the project build status.
class ProjectBuildStatus extends StatelessWidget {
  /// A [ProjectBuildStatusViewModel] that represents a status of the build
  /// to display.
  final ProjectBuildStatusViewModel buildStatus;

  /// A class that provides a [ProjectBuildStatusStyle] and icon image
  /// based on the [BuildStatus].
  final BuildStatusStyleStrategy buildStatusStyleStrategy;

  /// Creates an instance of the [ProjectBuildStatus]
  /// with the given [buildStatus] and [strategy].
  ///
  /// Both [buildStatus] and [strategy] must not be null.
  const ProjectBuildStatus({
    Key key,
    @required this.buildStatus,
    @required this.buildStatusStyleStrategy,
  })  : assert(buildStatus != null),
        assert(buildStatusStyleStrategy != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectBuildStatus = buildStatus?.value ?? BuildStatus.unknown;
    final theme = buildStatusStyleStrategy.getWidgetAppearance(
      MetricsTheme.of(context),
      projectBuildStatus,
    );

    return DecoratedContainer(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: ValueImage<BuildStatus>(
        value: projectBuildStatus,
        strategy: buildStatusStyleStrategy,
      ),
    );
  }
}
