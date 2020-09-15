import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("ToastAttentionLevel", () {
    test(
      "creates an instance with the default positive style if the given style is null",
      () {
        const attentionLevel = ToastAttentionLevel(positive: null);

        expect(attentionLevel.positive, isNotNull);
      },
    );

    test(
      "creates an instance with the default negative style if the given style is null",
      () {
        const attentionLevel = ToastAttentionLevel(negative: null);

        expect(attentionLevel.negative, isNotNull);
      },
    );

    test("creates an instance with the given styles", () {
      const positive = ToastStyle(backgroundColor: Colors.red);
      const negative = ToastStyle(backgroundColor: Colors.black);

      final attentionLevel = ToastAttentionLevel(
        positive: positive,
        negative: negative,
      );

      expect(attentionLevel.positive, equals(positive));
      expect(attentionLevel.negative, equals(negative));
    });
  });
}
