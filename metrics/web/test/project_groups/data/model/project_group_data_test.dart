// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/data/model/project_group_data.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupData", () {
    const id = 'id';
    const name = 'name';
    const List<String> projectIds = [];

    const json = {'name': name, 'projectIds': projectIds};

    test(".fromJson() returns null if the given json is null", () {
      final projectGroup = ProjectGroupData.fromJson(null, id);

      expect(projectGroup, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final expectedProjectGroup = ProjectGroupData(
        id: id,
        name: name,
        projectIds: projectIds,
      );
      final projectGroup = ProjectGroupData.fromJson(json, id);

      expect(projectGroup, equals(expectedProjectGroup));
    });

    test(".toJson() converts an instance to the json encodable map", () {
      final projectGroupData = ProjectGroupData(
        id: id,
        name: name,
        projectIds: projectIds,
      );

      expect(projectGroupData.toJson(), equals(json));
    });
  });
}
