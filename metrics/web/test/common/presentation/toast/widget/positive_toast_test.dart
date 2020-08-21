import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/widgets/positive_toast.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("PositiveToast", () {
    test(
      ".getStyle() returns a positive style of the given attention level",
      () {
        final toast = PositiveToast(message: 'message');
        const toastAttentionLevel = ToastAttentionLevel(
          positive: ToastStyle(backgroundColor: Colors.red),
          negative: ToastStyle(backgroundColor: Colors.black),
        );

        final style = toast.getStyle(toastAttentionLevel);

        expect(style, equals(toastAttentionLevel.positive));
      },
    );
  });
}
