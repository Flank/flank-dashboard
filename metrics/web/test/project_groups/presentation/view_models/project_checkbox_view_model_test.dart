// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectCheckboxViewModel", () {
    const id = 'id';
    const name = 'name';
    const isChecked = false;

    test("successfully creates an instance on a valid input", () {
      expect(
        () => ProjectCheckboxViewModel(
          id: id,
          name: name,
          isChecked: isChecked,
        ),
        returnsNormally,
      );
    });

    test("throws an AssertionError if an id parameter is null", () {
      expect(
        () => ProjectCheckboxViewModel(
          id: null,
          name: name,
          isChecked: isChecked,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if a name parameter is null", () {
      expect(
        () => ProjectCheckboxViewModel(
          id: id,
          name: null,
          isChecked: isChecked,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if an isChecked parameter is null", () {
      expect(
        () => ProjectCheckboxViewModel(
          id: id,
          name: name,
          isChecked: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
