// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/domain/entities/firestore_error_code.dart';
import 'package:metrics/common/domain/entities/firestore_exception.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreException", () {
    test(
      "constructor creates the instance with unknown error code when the null is passed",
          () {
        final firestoreException = FirestoreException(code: null);

        expect(firestoreException.code, FirestoreErrorCode.unknown);
      },
    );
  });
}
