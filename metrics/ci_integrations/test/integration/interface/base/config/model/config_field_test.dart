// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:test/test.dart';

import '../../../../../test_utils/config_field_stub.dart';

void main() {
  group("ConfigField", () {
    const value = 'value';

    test(
      "throws an ArgumentError if the given value is null",
      () {
        expect(() => ConfigFieldStub(null), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given value",
      () {
        final field = ConfigFieldStub(value);

        expect(field.value, equals(value));
      },
    );

    test(
      ".toString() returns the given value",
      () {
        final field = ConfigFieldStub(value);

        expect(field.toString(), equals(value));
      },
    );
  });
}
