import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectBuildStatusAttentionLevel", () {
    test(
      "creates an instance with default styles if styles are not specified",
      () {
        const attentionLevel = ProjectBuildStatusAttentionLevel();

        expect(attentionLevel.successful, isNotNull);
        expect(attentionLevel.failed, isNotNull);
        expect(attentionLevel.unknown, isNotNull);
      },
    );

    test("creates an instance with the given styles", () {
      const successful = ProjectBuildStatusStyle(backgroundColor: Colors.green);
      const failed = ProjectBuildStatusStyle(backgroundColor: Colors.blue);
      const unknown = ProjectBuildStatusStyle(backgroundColor: Colors.red);

      final attentionLevel = ProjectBuildStatusAttentionLevel(
        successful: successful,
        failed: failed,
        unknown: unknown,
      );

      expect(attentionLevel.successful, equals(successful));
      expect(attentionLevel.failed, equals(failed));
      expect(attentionLevel.unknown, equals(unknown));
    });
  });
}
