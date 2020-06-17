import 'package:metrics/common/domain/entities/firestore_error_code.dart';

/// A class that represents the firestore exception.
class FirestoreException implements Exception {
  /// The code of this error that specifies the concrete reason
  /// for the exception occurrence.
  final FirestoreErrorCode code;

  /// Creates the [FirestoreException] with the given [code].
  ///
  /// If null code is passed - the [FirestoreErrorCode.unknown] is used.
  const FirestoreException({
    FirestoreErrorCode code,
  }) : code = code ?? FirestoreErrorCode.unknown;
}
