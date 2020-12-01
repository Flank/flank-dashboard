import 'package:ci_integration/cli/error/sync_error.dart';
import 'package:test/test.dart';

void main() {
  group("SyncError", () {
    const message = 'error message';

    test("creates an instance with the given parameters", () {
      final syncError = SyncError(message: message);

      expect(syncError.message, equals(message));
    });

    test(".toString() returns an error message", () {
      final syncError = SyncError(message: message);

      expect(syncError.toString(), equals(message));
    });

    test(".toString() returns an empty string if the message is null", () {
      final syncError = SyncError();

      expect(syncError.toString(), isEmpty);
    });
  });
}
