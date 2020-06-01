import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics_core/metrics_core.dart';

/// [DataModel] that represents the [ProjectGroup] entity.
class ProjectGroupData extends ProjectGroup implements DataModel {
  const ProjectGroupData({
    String id,
    String name,
    List<String> projectIds,
  }) : super(id: id, name: name, projectIds: projectIds);

  /// Creates the [ProjectGroupData] using the [json] and [documentId].
  factory ProjectGroupData.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return ProjectGroupData(
      id: documentId,
      name: json['name'] as String,
      projectIds: List.from(json['projectIds'] as List),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'projectIds': projectIds,
    };
  }
}
