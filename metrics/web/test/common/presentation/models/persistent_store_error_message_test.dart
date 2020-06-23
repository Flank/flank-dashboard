// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:test/test.dart';

void main() {
  group("PersistentStoreErrorMessage", () {
    test(
      "maps the null error code to the null error message",
      () {
        final errorMessage = PersistentStoreErrorMessage(null);

        expect(errorMessage.message, isNull);
      },
    );

    test(
      "maps the unknown error code to the unknown error message",
      () {
        final errorMessage = PersistentStoreErrorMessage(
          PersistentStoreErrorCode.unknown,
        );

        expect(errorMessage.message, CommonStrings.unknownErrorMessage);
      },
    );
  });
}
