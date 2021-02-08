// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/src/data/model/data_model.dart';
import 'package:metrics_core/src/domain/entities/project.dart';

/// [DataModel] that represents the [Project] entity.
class ProjectData extends Project implements DataModel {
  /// Creates a new instance of the [ProjectData].
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
