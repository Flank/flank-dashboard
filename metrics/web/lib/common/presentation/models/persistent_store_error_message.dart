// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

/// A class that provides an error description based
/// on the [PersistentStoreErrorCode].
class PersistentStoreErrorMessage {
  final PersistentStoreErrorCode _code;

  /// Creates the [PersistentStoreErrorMessage] with
  /// the given [PersistentStoreErrorCode].
  const PersistentStoreErrorMessage(this._code);

  /// Provides the error message based on the [PersistentStoreErrorCode].
  String get message {
    switch (_code) {
      case PersistentStoreErrorCode.openConnectionFailed:
        return CommonStrings.openConnectionFailedErrorMessage;
      case PersistentStoreErrorCode.readError:
        return CommonStrings.readErrorMessage;
      case PersistentStoreErrorCode.updateError:
        return CommonStrings.updateErrorMessage;
      case PersistentStoreErrorCode.closeConnectionFailed:
        return CommonStrings.closeConnectionFailedErrorMessage;
      case PersistentStoreErrorCode.unknown:
        return CommonStrings.unknownErrorMessage;
      default:
        return null;
    }
  }
}
