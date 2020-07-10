// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:collection/collection.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupDialogViewModel", () {
    const id = 'id';
    const name = 'name';
    final projectIds = UnmodifiableListView<String>([]);

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

    test(
      "throws an AssertionError if the selected project ids parameter is null",
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

    test(
      "equals to another ProjectGroupDialogViewModel with the same parameters",
      () {
        final firstViewModel = ProjectGroupDialogViewModel(
          id: id,
          name: name,
          selectedProjectIds: projectIds,
        );

        final secondViewModel = ProjectGroupDialogViewModel(
          id: id,
          name: name,
          selectedProjectIds: projectIds,
        );

        expect(
          firstViewModel,
          equals(secondViewModel),
        );
      },
    );
  });
}
