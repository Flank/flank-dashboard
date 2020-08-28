import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ToastStyle", () {
    test("creates an instance with the given values", () {
      const backgroundColor = Colors.red;
      const textStyle = TextStyle(color: Colors.black);

      final style = ToastStyle(
        backgroundColor: backgroundColor,
        textStyle: textStyle,
      );

      expect(style.backgroundColor, equals(backgroundColor));
      expect(style.textStyle, equals(textStyle));
    });
  });
}
