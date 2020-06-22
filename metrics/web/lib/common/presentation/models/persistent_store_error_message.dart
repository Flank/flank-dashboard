import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

class PersistentStoreErrorMessage {
  final PersistentStoreErrorCode _code;

  PersistentStoreErrorMessage(this._code);

  String get message {
    switch (_code) {
      case PersistentStoreErrorCode.unknown:
        return CommonStrings.unknownErrorMessage;
      default:
        return null;
    }
  }
}
