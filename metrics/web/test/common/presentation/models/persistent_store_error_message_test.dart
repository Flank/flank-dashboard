// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:test/test.dart';

void main() {
  group("PersistentStoreErrorMessage", () {
    test(
      ".message returns null if the given code is null",
      () {
        const errorMessage = PersistentStoreErrorMessage(null);

        expect(errorMessage.message, isNull);
      },
    );

    test(
      ".message returns an open connection failed error message if the given error code is the open connection failed error code",
      () {
        const expectedMessage = CommonStrings.openConnectionFailedErrorMessage;

        const errorMessage = PersistentStoreErrorMessage(
          PersistentStoreErrorCode.openConnectionFailed,
        );

        expect(errorMessage.message, equals(expectedMessage));
      },
    );

    test(
      ".message returns a read failed error message if the given error code is the read error code",
      () {
        const expectedMessage = CommonStrings.readErrorMessage;

        const errorMessage = PersistentStoreErrorMessage(
          PersistentStoreErrorCode.readError,
        );

        expect(errorMessage.message, equals(expectedMessage));
      },
    );

    test(
      ".message returns an update failed error message if the given error code is the update error code",
      () {
        const expectedMessage = CommonStrings.updateErrorMessage;

        const errorMessage = PersistentStoreErrorMessage(
          PersistentStoreErrorCode.updateError,
        );

        expect(errorMessage.message, equals(expectedMessage));
      },
    );

    test(
      ".message returns a close connection failed error message if the given error code is the close connection failed error code",
      () {
        const expectedMessage = CommonStrings.closeConnectionFailedErrorMessage;

        const errorMessage = PersistentStoreErrorMessage(
          PersistentStoreErrorCode.closeConnectionFailed,
        );

        expect(errorMessage.message, equals(expectedMessage));
      },
    );

    test(
      ".message returns an unknown error message if the given error code is the unknown error code",
      () {
        const expectedMessage = CommonStrings.unknownErrorMessage;

        const errorMessage = PersistentStoreErrorMessage(
          PersistentStoreErrorCode.unknown,
        );

        expect(errorMessage.message, equals(expectedMessage));
      },
    );
  });
}
