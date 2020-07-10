// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/project_groups/presentation/view_models/delete_project_group_dialog_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupDeleteDialogViewModel", () {
    const id = 'id';
    const name = 'name';

    test("successfully creates an instance on a valid input", () {
      expect(
        () => DeleteProjectGroupDialogViewModel(id: id, name: name),
        returnsNormally,
      );
    });

    test("throws an AssertionError if the id parameter is null", () {
      expect(
        () => DeleteProjectGroupDialogViewModel(id: null, name: name),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the name parameter is null", () {
      expect(
        () => DeleteProjectGroupDialogViewModel(id: id, name: null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
