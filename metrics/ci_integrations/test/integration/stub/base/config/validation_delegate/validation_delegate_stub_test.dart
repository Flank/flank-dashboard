// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/stub/base/config/validation_delegate/validation_delegate_stub.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("ValidationDelegateStub", () {
    test(
      ".validateAuth() returns null",
      () async {
        final delegate = ValidationDelegateStub();
        final auth = BearerAuthorization('token');

        final result = await delegate.validateAuth(auth);

        expect(result, isNull);
      },
    );
  });
}
