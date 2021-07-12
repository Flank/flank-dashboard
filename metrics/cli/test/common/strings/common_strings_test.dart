// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/strings/common_strings.dart';
import 'package:test/test.dart';

void main() {
  group("CommonStrings", () {
    test(
      ".executionWentWrong() returns an error message that contains the given executable",
      () {
        const executable = 'testErrorMessage';

        expect(
          CommonStrings.executionWentWrong(executable),
          contains(executable),
        );
      },
    );
  });
}
