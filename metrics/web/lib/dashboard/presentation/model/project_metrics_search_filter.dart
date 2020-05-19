import 'package:metrics/common/presentation/model/filter.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_data.dart';

/// A class that is a specific version of the [Filter],
/// that handles logic to filter the list of [ProjectMetricsData].
class ProjectsSearchMetricsFilter implements Filter<ProjectMetricsData> {
  final String search;

  /// Creates the [ProjectsSearchMetricsFilter].
  ///
  /// The [search] is the search string, that used to find a project.
  const ProjectsSearchMetricsFilter({
    this.search,
  });

  @override
  List<ProjectMetricsData> apply(List<ProjectMetricsData> projects) {
    if (search == null) return projects;

    return projects
        .where((project) =>
            project.projectName.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
}
