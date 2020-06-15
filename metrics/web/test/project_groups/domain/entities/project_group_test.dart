import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroup", () {
    const id = 'id';
    const name = 'name';
    const List<String> projectIds = [];

    test("throws an ArgumentError then created with null name", () {
      expect(
        () => ProjectGroup(id: id, name: null, projectIds: projectIds),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError then created with null projectIds", () {
      expect(
        () => ProjectGroup(id: id, name: name, projectIds: null),
        throwsArgumentError,
      );
    });
  });
}
