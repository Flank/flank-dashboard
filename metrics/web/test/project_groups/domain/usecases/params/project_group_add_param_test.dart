import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupAddParam", () {
    test("throws an AssertionError when created with null name", () {
      expect(
        () => AddProjectGroupParam(
          projectGroupName: null,
          projectIds: [],
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError when created with null project ids", () {
      expect(
        () => AddProjectGroupParam(projectGroupName: 'name', projectIds: null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
