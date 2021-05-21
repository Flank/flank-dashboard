// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:links_checker/checker/error/links_checker_error.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerError", () {
    test(
      ".toString() returns the error message with the given errors descriptions",
      () {
        const errorDescriptions = ['error1', 'error2'];
        final linksCheckerException = LinksCheckerError(errorDescriptions);

        final errorsList = errorDescriptions.join('\n');
        final expectedMessage =
            'Found ${errorDescriptions.length} non-master links:\n$errorsList';

        expect(linksCheckerException.toString(), equals(expectedMessage));
      },
    );

    test(
      ".toString() returns an empty string if the given error descriptions are null",
      () {
        final linksCheckerException = LinksCheckerError(null);

        expect(linksCheckerException.toString(), isEmpty);
      },
    );
  });
}
