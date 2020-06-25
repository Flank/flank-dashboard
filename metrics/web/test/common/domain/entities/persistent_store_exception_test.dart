// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:test/test.dart';

void main() {
  group("PersistentStoreException", () {
    test(
      "creates an instance with an unknown error code when the given code is null",
      () {
        final firestoreException = PersistentStoreException(code: null);

        expect(
          firestoreException.code,
          equals(PersistentStoreErrorCode.unknown),
        );
      },
    );
  });
}
