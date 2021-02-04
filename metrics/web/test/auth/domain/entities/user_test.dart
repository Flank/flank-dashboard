// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/user.dart';
import 'package:test/test.dart';

void main() {
  group("User", () {
    test("throws an ArgumentError if the given id is null", () {
      expect(() => User(id: null), throwsArgumentError);
    });
  });
}
