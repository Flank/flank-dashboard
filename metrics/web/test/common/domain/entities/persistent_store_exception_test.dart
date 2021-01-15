import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("PersistentStoreException", () {
    test(
      "creates an instance with an unknown error code when the given code is null",
      () {
        const persistentStoreException = PersistentStoreException(code: null);

        expect(
          persistentStoreException.code,
          equals(PersistentStoreErrorCode.unknown),
        );
      },
    );
  });
}
