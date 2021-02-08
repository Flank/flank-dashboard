// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroup", () {
    const id = 'id';
    const name = 'name';
    const List<String> projectIds = [];

    test("successfully creates with the given required parameters", () {
      expect(
        () => ProjectGroup(id: id, name: name, projectIds: projectIds),
        returnsNormally,
      );
    });

    test("throws an ArgumentError when created with null name", () {
      expect(
        () => ProjectGroup(id: id, name: null, projectIds: projectIds),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError when created with null project ids", () {
      expect(
        () => ProjectGroup(id: id, name: name, projectIds: null),
        throwsArgumentError,
      );
    });
  });
}
