import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupDeleteParam", () {
    test("throws an AssertionError when created with null id", () {
      expect(
        () => DeleteProjectGroupParam(projectGroupId: null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
