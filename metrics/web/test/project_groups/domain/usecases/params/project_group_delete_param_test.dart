// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupDeleteParam", () {
    test("successfully creates an instance on a valid input", () {
      expect(
        () => DeleteProjectGroupParam(projectGroupId: 'id'),
        returnsNormally,
      );
    });

    test("throws an ArgumentError when created with null id", () {
      expect(
        () => DeleteProjectGroupParam(projectGroupId: null),
        throwsArgumentError,
      );
    });
  });
}
