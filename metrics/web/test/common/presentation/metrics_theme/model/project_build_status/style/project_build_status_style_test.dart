// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusStyle", () {
    test("creates an instance with the given background color", () {
      const expectedBackgroundColor = Colors.red;

      const style = ProjectBuildStatusStyle(
        backgroundColor: expectedBackgroundColor,
      );

      expect(style.backgroundColor, equals(expectedBackgroundColor));
    });
  });
}
