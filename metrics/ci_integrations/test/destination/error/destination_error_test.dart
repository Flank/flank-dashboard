// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/error/destination_error.dart';
import 'package:test/test.dart';

void main() {
  group("DestinationError", () {
    const message = 'error message';

    test("creates an instance with the given parameters", () {
      final destinationError = DestinationError(message: message);

      expect(destinationError.message, equals(message));
    });

    test(".toString() returns an error message", () {
      final destinationError = DestinationError(message: message);

      expect(destinationError.toString(), equals(message));
    });

    test(".toString() returns an empty string if the message is null", () {
      final destinationError = DestinationError();

      expect(destinationError.toString(), isEmpty);
    });
  });
}
