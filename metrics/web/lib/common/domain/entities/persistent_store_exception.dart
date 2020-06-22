import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';

/// A class that represents the firestore exception.
class PersistentStoreException implements Exception {
  /// The code of this error that specifies the concrete reason
  /// for the exception occurrence.
  final PersistentStoreErrorCode code;

  /// Creates the [PersistentStoreException] with the given [code].
  ///
  /// If null code is passed - the [PersistentStoreErrorCode.unknown] is used.
  const PersistentStoreException({
    PersistentStoreErrorCode code,
  }) : code = code ?? PersistentStoreErrorCode.unknown;
}
