// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../test_utils/matcher_util.dart';

void main() {
  group("Percent", () {
    test("can't be created with the null value", () {
      expect(
        () => Percent(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("can't be created with the value, less then 0.0", () {
      expect(
        () => Percent(-1.0),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("can't be created with the value, more then 1.0", () {
      expect(
        () => Percent(1.1),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("two intances with the equal value are equal", () {
      const percentValue = 0.1;
      final firstPercent = Percent(percentValue);
      final secondPercent = Percent(percentValue);

      expect(firstPercent, equals(secondPercent));
    });
  });
}
