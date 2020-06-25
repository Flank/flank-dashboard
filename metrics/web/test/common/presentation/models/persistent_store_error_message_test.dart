// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:test/test.dart';

void main() {
  group("PersistentStoreErrorMessage", () {
    test(
      ".message returns null if the given code is null",
      () {
        final errorMessage = PersistentStoreErrorMessage(null);

        expect(errorMessage.message, isNull);
      },
    );

    test(
      ".message returns an unknown error message if the given error code is the unknown error code",
      () {
        final errorMessage = PersistentStoreErrorMessage(
          PersistentStoreErrorCode.unknown,
        );

        expect(errorMessage.message, CommonStrings.unknownErrorMessage);
      },
    );
  });
}
