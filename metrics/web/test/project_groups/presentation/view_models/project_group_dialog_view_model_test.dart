// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupDialogViewModel", () {
    const id = 'id';
    const name = 'name';
    const projectIds = <String>[];

    test("successfully creates an instance on a valid input", () {
      expect(
        () => ProjectGroupDialogViewModel(
          id: id,
          name: name,
          selectedProjectIds: projectIds,
        ),
        returnsNormally,
      );
    });

    test("throws an AssertionError if a name parameter is null", () {
      expect(
        () => ProjectGroupDialogViewModel(
          id: id,
          name: null,
          selectedProjectIds: projectIds,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "throws an AssertionError if a selected project ids parameter is null",
      () {
        expect(
          () => ProjectGroupDialogViewModel(
            id: id,
            name: name,
            selectedProjectIds: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );
  });
}
