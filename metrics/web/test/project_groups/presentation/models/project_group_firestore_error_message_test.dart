import 'package:metrics/common/domain/entities/firestore_error_code.dart';
import 'package:metrics/project_groups/presentation/models/project_group_firestore_error_message.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group(
    "ProjectGroupSavingErrorMessage",
    () {
      test(
        ".message returns null if the given code is null",
        () {
          const errorMessage = ProjectGroupFirestoreErrorMessage(null);

          expect(errorMessage.message, isNull);
        },
      );

      test(
        ".message returns an error message if the given error code is not null",
        () {
          const errorMessage =
              ProjectGroupFirestoreErrorMessage(FirestoreErrorCode.unknown);

          expect(
            errorMessage.message,
            ProjectGroupsStrings.unknownErrorMessage,
          );
        },
      );
    },
  );
}
