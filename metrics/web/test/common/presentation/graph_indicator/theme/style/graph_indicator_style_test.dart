import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("GraphIndicatorStyle", () {
    test(
      "creates an instance with the default colors if the parameters are not specified",
      () {
        const style = GraphIndicatorStyle();

        expect(style.innerColor, isNotNull);
        expect(style.outerColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const innerColor = Colors.red;
      const outerColor = Colors.grey;
      final style = GraphIndicatorStyle(
        innerColor: innerColor,
        outerColor: outerColor,
      );

      expect(style.innerColor, equals(innerColor));
      expect(style.outerColor, equals(outerColor));
    });
  });
}
