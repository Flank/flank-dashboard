// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:test/test.dart';

void main() {
  group("InteractionResult", () {
    const errorMessage = 'Error';
    const successMessage = 'Hooray';
    const errorResult = -1;
    const successResult = 1;

    const failed = InteractionResult.error(
      message: errorMessage,
      result: errorResult,
    );
    const success = InteractionResult.success(
      message: successMessage,
      result: successResult,
    );

    test(
      ".error() creates an instance describing the failed interaction",
      () {
        expect(failed.isError, isTrue);
        expect(failed.message, equals(errorMessage));
        expect(failed.result, equals(errorResult));
      },
    );

    test(
      ".success() creates an instance describing the success interaction",
      () {
        expect(success.isSuccess, isTrue);
        expect(success.message, equals(successMessage));
        expect(success.result, equals(successResult));
      },
    );
  });
}
