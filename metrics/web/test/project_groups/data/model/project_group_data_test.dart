import 'package:metrics/project_groups/data/model/project_group_data.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupData", () {
    const id = 'id';
    const name = 'name';
    const List<String> projectIds = [];

    const json = {'name': name, 'projectIds': projectIds};

    test(".fromJson() creates an instance from a json map", () {
      final projectGroup = ProjectGroupData.fromJson(json, id);

      expect(projectGroup.id, equals(id));
      expect(projectGroup.name, equals(name));
      expect(projectGroup.projectIds, equals(projectIds));
    });

    test(".toJson() converts an instance to the json encodable map", () {
      const projectGroupData = ProjectGroupData(
        id: id,
        name: name,
        projectIds: projectIds,
      );

      expect(projectGroupData.toJson(), equals(json));
    });
  });
}
