import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:test/test.dart';
import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroup", () {
    const id = 'id';
    const name = 'name';
    const List<String> projectIds = [];

    test("throws an AssertionError then created with null id", () {
      expect(
        () => ProjectGroup(id: null, name: name, projectIds: projectIds),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError then created with null name", () {
      expect(
        () => ProjectGroup(id: id, name: null, projectIds: projectIds),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError then created with null projectIds", () {
      expect(
        () => ProjectGroup(id: id, name: name, projectIds: null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
