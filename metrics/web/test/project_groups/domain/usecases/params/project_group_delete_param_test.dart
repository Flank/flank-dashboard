import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupDeleteParam", () {
    test("throws an ArgumentError when created with null id", () {
      expect(
        () => DeleteProjectGroupParam(projectGroupId: null),
        throwsArgumentError,
      );
    });
  });
}
