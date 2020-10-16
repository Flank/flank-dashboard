import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectBuildStatusAttentionLevel", () {
    test(
      "creates an instance with default styles if styles are not specified",
      () {
        const attentionLevel = ProjectBuildStatusAttentionLevel();

        expect(attentionLevel.positive, isNotNull);
        expect(attentionLevel.negative, isNotNull);
        expect(attentionLevel.unknown, isNotNull);
      },
    );

    test("creates an instance with the given styles", () {
      const positive = ProjectBuildStatusStyle(backgroundColor: Colors.green);
      const negative = ProjectBuildStatusStyle(backgroundColor: Colors.blue);
      const unknown = ProjectBuildStatusStyle(backgroundColor: Colors.red);

      final attentionLevel = ProjectBuildStatusAttentionLevel(
        positive: positive,
        negative: negative,
        unknown: unknown,
      );

      expect(attentionLevel.positive, equals(positive));
      expect(attentionLevel.negative, equals(negative));
      expect(attentionLevel.unknown, equals(unknown));
    });
  });
}
