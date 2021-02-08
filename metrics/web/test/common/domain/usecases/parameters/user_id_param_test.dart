// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/domain/usecases/parameters/user_id_param.dart';
import 'package:test/test.dart';

void main() {
  group("UserIdParam", () {
    const id = 'id';

    test("throws an ArgumentError if the given id is null", () {
      expect(() => UserIdParam(id: null), throwsArgumentError);
    });

    test("creates an instance with the given params", () {
      final userIdParam = UserIdParam(id: id);

      expect(userIdParam.id, equals(id));
    });
  });
}
