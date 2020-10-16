import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectBuildStatusStyle", () {
    test("creates an instance with the given background color", () {
      const expectedBackgroundColor = Colors.red;

      final style = ProjectBuildStatusStyle(
        backgroundColor: expectedBackgroundColor,
      );

      expect(style.backgroundColor, equals(expectedBackgroundColor));
    });
  });
}
