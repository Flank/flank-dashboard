import 'package:metrics/project_groups/domain/entities/project_group_selection_error_code.dart';
import 'package:metrics/project_groups/presentation/models/project_group_selecting_error_message.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectGroupSelectingErrorMessage", () {
    test(".message returns null if the given code is null", () {
      final errorMessage = ProjectGroupSelectionErrorMessage(null);

      expect(errorMessage.message, isNull);
    });

    test(
      ".message returns a selecting error message if the given error code is the selecting error code",
          () {
        final errorMessage = ProjectGroupSelectionErrorMessage(
          ProjectGroupSelectionErrorCode.selectionError,
        );

        expect(
          errorMessage.message,
          ProjectGroupsStrings.getProjectSelectionError(
            ProjectGroupsNotifier.maxSelectedProjects,
          ),
        );
      },
    );
  });
}
