import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/widgets/negative_toast.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("NegativeToast", () {
    test(
      ".getStyle() returns a negative style of the given attention level",
      () {
        final toast = NegativeToast(message: 'message');
        const toastAttentionLevel = ToastAttentionLevel(
          positive: ToastStyle(backgroundColor: Colors.red),
          negative: ToastStyle(backgroundColor: Colors.black),
        );

        final style = toast.getStyle(toastAttentionLevel);

        expect(style, equals(toastAttentionLevel.negative));
      },
    );
  });
}
