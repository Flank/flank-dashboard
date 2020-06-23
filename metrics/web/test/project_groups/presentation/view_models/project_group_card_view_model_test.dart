// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupCardViewModel", () {
    const id = 'id';
    const name = 'name';
    const projectsCount = 0;

    test("successfully creates an instance on a valid input", () {
      expect(
        () => ProjectGroupCardViewModel(
          id: id,
          name: name,
          projectsCount: projectsCount,
        ),
        returnsNormally,
      );
    });

    test("throws an AssertionError if an id parameter is null", () {
      expect(
        () => ProjectGroupCardViewModel(
          id: null,
          name: name,
          projectsCount: projectsCount,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if a name parameter is null", () {
      expect(
        () => ProjectGroupCardViewModel(
          id: id,
          name: null,
          projectsCount: projectsCount,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if a projects count parameter is null", () {
      expect(
        () => ProjectGroupCardViewModel(
          id: id,
          name: name,
          projectsCount: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
