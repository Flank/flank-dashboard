// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/widgets/negative_toast.dart';

void main() {
  group("NegativeToast", () {
    test(
      ".getStyle() returns a negative style of the given attention level",
      () {
        const toast = NegativeToast(message: 'message');
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
