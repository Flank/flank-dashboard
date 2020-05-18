import 'package:metrics/dashboard/presentation/model/filter.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_data.dart';

class ProjectsSearchMetricsFilter implements Filter<ProjectMetricsData> {
  final String search;

  const ProjectsSearchMetricsFilter({this.search});

  @override
  List<ProjectMetricsData> apply(List<ProjectMetricsData> projects) {
    if (search == null) return projects;

    return projects
        .where((project) =>
        project.projectName.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
}