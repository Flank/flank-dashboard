import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/project_groups/presentation/models/project_group_firestore_error_message.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group(
    "ProjectGroupSavingErrorMessage",
    () {
      test(
        "maps the unknown error code to unknown error message",
        () {
          const errorMessage =
              ProjectGroupFirestoreErrorMessage(PersistentStoreErrorCode.unknown);

          expect(
              errorMessage.message, ProjectGroupsStrings.unknownErrorMessage);
        },
      );
    },
  );
}
