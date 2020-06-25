import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/project_groups/presentation/models/project_group_persistent_store_error_message.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group(
    "ProjectGroupPersistentStoreErrorMessage",
    () {
      test(
        ".message returns null if the given code is null",
        () {
          const errorMessage = ProjectGroupPersistentStoreErrorMessage(null);

          expect(errorMessage.message, isNull);
        },
      );

      test(
        ".message returns unknown error message if the given code is unknown error code",
        () {
          const errorMessage = ProjectGroupPersistentStoreErrorMessage(
            PersistentStoreErrorCode.unknown,
          );

          expect(
            errorMessage.message,
            ProjectGroupsStrings.unknownErrorMessage,
          );
        },
      );
    },
  );
}
