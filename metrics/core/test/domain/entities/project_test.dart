import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../test_utils/matcher_util.dart';

void main() {
  test(
    "throws an AssertionError if the given id is null",
    () {
      const projectName = 'name';

      expect(
        () => Project(name: projectName, id: null),
        MatcherUtil.throwsAssertionError,
      );
    },
  );

  test(
    "throws an AssertionError if the given name is null",
    () {
      const projectId = 'projectId';

      expect(
        () => Project(name: null, id: projectId),
        MatcherUtil.throwsAssertionError,
      );
    },
  );
}
