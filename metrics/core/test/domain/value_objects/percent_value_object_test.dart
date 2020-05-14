// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("PercentValueObject", () {
    test("can't be created with the null value", () {
      expect(
        () => PercentValueObject(null),
        throwsArgumentError,
      );
    });

    test("can't be created with the value, less than 0.0", () {
      expect(
        () => PercentValueObject(-1.0),
        throwsArgumentError,
      );
    });

    test("can't be created with the value, more than 1.0", () {
      expect(
        () => PercentValueObject(1.1),
        throwsArgumentError,
      );
    });

    test("two instances with the equal value are equal", () {
      const percentValue = 0.1;
      final firstPercent = PercentValueObject(percentValue);
      final secondPercent = PercentValueObject(percentValue);

      expect(firstPercent, equals(secondPercent));
    });
  });
}
