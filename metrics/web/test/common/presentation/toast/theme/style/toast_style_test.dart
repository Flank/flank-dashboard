// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:test/test.dart';

void main() {
  group("ToastStyle", () {
    test("creates an instance with the given values", () {
      const backgroundColor = Colors.red;
      const textStyle = TextStyle(color: Colors.black);

      const style = ToastStyle(
        backgroundColor: backgroundColor,
        textStyle: textStyle,
      );

      expect(style.backgroundColor, equals(backgroundColor));
      expect(style.textStyle, equals(textStyle));
    });
  });
}
