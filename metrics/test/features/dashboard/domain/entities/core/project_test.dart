import 'package:metrics/features/dashboard/domain/entities/core/project.dart';
import 'package:test/test.dart';

import '../../../../../test_utils/matcher_util.dart';

void main() {
  test("Can't create project with null id", () {
    const projectName = 'name';

    expect(
      () => Project(name: projectName, id: null),
      MatcherUtil.throwsAssertionError,
    );
  });

  test("Can't create project without name", () {
    const projectId = 'projectId';

    expect(
      () => Project(name: null, id: projectId),
      MatcherUtil.throwsAssertionError,
    );
  });
}
