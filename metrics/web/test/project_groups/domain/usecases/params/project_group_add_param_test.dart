import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupAddParam", () {
    test("throws an ArgumentError when created with null name", () {
      expect(
        () => AddProjectGroupParam(
          projectGroupName: null,
          projectIds: const [],
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError when created with null project ids", () {
      expect(
        () => AddProjectGroupParam(projectGroupName: 'name', projectIds: null),
        throwsArgumentError,
      );
    });
  });
}
