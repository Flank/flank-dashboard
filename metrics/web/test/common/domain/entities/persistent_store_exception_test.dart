// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:test/test.dart';

void main() {
  group("PersistentStoreException", () {
    test(
      "successfully creates an instance with unknown error code when the null is passed",
      () {
        final firestoreException = PersistentStoreException(code: null);

        expect(firestoreException.code, PersistentStoreErrorCode.unknown);
      },
    );
  });
}
