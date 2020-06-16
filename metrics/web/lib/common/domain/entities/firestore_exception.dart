import 'package:metrics/common/domain/entities/firestore_error_code.dart';

/// Represents the firestore exception.
class FirestoreException {
  /// [code] is the code of this error that specifies the concrete reason
  /// for the exception occurrence.
  final FirestoreErrorCode code;

  /// Creates the [FirestoreException] with the given [code].
  ///
  /// If null code is passed - the [FirestoreErrorCode.unknown] will be used.
  const FirestoreException({
    FirestoreErrorCode code,
  }) : code = code ?? FirestoreErrorCode.unknown;
}
