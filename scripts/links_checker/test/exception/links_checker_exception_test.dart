// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:links_checker/exception/links_checker_exception.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerException", () {
    test(
      ".toString() returns the error message with the given errors descriptions",
      () {
        const errorDescriptions = ['error1', 'error2'];
        const linksCheckerException = LinksCheckerException(errorDescriptions);

        final errorsList = errorDescriptions.join('\n');
        final expectedMessage =
            'Found ${errorDescriptions.length} non-master links:\n$errorsList';

        expect(linksCheckerException.toString(), equals(expectedMessage));
      },
    );

    test(
      ".toString() returns an empty string if the given error descriptions are null",
      () {
        const linksCheckerException = LinksCheckerException(null);

        expect(linksCheckerException.toString(), isEmpty);
      },
    );
  });
}
