// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupDropdownItemViewModel", () {
    const id = 'id';
    const name = 'name';

    test(
      "successfully creates an instance on a valid input",
      () {
        expect(
          () => ProjectGroupDropdownItemViewModel(id: id, name: name),
          returnsNormally,
        );
      },
    );

    test(
      "throws an AssertionError if the given name is null",
      () {
        expect(
          () => ProjectGroupDropdownItemViewModel(id: id, name: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "equals to another ProjectGroupDropdownItemViewModel instance with the same value",
      () {
        final firstViewModel = ProjectGroupDropdownItemViewModel(
          id: id,
          name: name,
        );

        final secondViewModel = ProjectGroupDropdownItemViewModel(
          id: id,
          name: name,
        );

        expect(firstViewModel, equals(secondViewModel));
      },
    );
  });
}
