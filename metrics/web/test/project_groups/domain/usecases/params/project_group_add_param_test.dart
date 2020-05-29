import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupAddParam", () {
    test("throws an AssertionError when created with null name", () {
      expect(
        () => AddProjectGroupParam(null, []),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError when created with null project ids", () {
      expect(
        () => AddProjectGroupParam('name', null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
