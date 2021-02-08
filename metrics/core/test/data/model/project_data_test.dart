// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectData", () {
    const id = 'id';
    const name = 'name';

    const json = {
      'name': name,
    };

    test(".fromJson() creates an instance from a json map", () {
      final project = ProjectData.fromJson(json, id);

      expect(project.id, equals(id));
      expect(project.name, equals(name));
    });

    test(".toJson() converts an instance to the json encodable map", () {
      const projectData = ProjectData(id: id, name: name);

      expect(projectData.toJson(), equals(json));
    });
  });
}
