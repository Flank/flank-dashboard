import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupAddParam", () {
    test("constructs an instance on a valid input", () {
      expect(
        () => AddProjectGroupParam(
          projectGroupName: 'name',
          projectIds: const [],
        ),
        returnsNormally,
      );
    });

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
