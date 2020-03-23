import 'package:metrics/features/dashboard/data/model/data_model.dart';
import 'package:metrics/features/dashboard/domain/entities/core/project.dart';

/// [DataModel] that represents the [Project] entity.
class ProjectData extends Project implements DataModel {
  const ProjectData({
    String id,
    String name,
  }) : super(
          id: id,
          name: name,
        );

  /// Creates the [ProjectData] using the [json] and it's [id].
  factory ProjectData.fromJson(Map<String, dynamic> json, String id) {
    return ProjectData(
      id: id,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
