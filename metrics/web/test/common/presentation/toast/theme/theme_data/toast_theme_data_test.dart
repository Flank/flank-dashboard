import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/theme/theme_data/toast_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ToastThemeData", () {
    test(
      "creates a theme with the default attention level if the given attention level is null",
      () {
        final theme = ToastThemeData(toastAttentionLevel: null);

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      const attentionLevel = ToastAttentionLevel(
        positive: ToastStyle(
          backgroundColor: Colors.red,
        ),
      );

      final theme = ToastThemeData(
        toastAttentionLevel: attentionLevel,
      );

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
