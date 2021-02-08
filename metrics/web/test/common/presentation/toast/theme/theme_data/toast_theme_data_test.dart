// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/theme/theme_data/toast_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ToastThemeData", () {
    test(
      "creates a theme with the default attention level if the given attention level is null",
      () {
        const theme = ToastThemeData(toastAttentionLevel: null);

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      const attentionLevel = ToastAttentionLevel(
        positive: ToastStyle(
          backgroundColor: Colors.red,
        ),
      );

      const theme = ToastThemeData(
        toastAttentionLevel: attentionLevel,
      );

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
