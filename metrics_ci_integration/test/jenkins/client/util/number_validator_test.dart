import 'package:ci_integration/jenkins/client/util/number_validator.dart';
import 'package:test/test.dart';

void main() {
  group("NumberValidator", () {
    test(".checkValue() should throw ArgumentError if a number is null", () {
      expect(() => NumberValidator.checkPositive(null), throwsArgumentError);
    });

    test(".checkValue() should throw ArgumentError if a number is negative",
        () {
      expect(() => NumberValidator.checkPositive(-1), throwsArgumentError);
    });

    test(".checkValue() should validate the given number", () {
      expect(() => NumberValidator.checkPositive(1), returnsNormally);
    });

    test(
      ".checkRange() should throw ArgumentError if the begin value is null",
      () {
        expect(() => NumberValidator.checkRange(null, 1), throwsArgumentError);
      },
    );

    test(
      ".checkRange() should throw ArgumentError if the end value is null",
      () {
        expect(() => NumberValidator.checkRange(1, null), throwsArgumentError);
      },
    );

    test(
      ".checkRange() should throw ArgumentError if the begin value is negative",
      () {
        expect(() => NumberValidator.checkRange(-1, 1), throwsArgumentError);
      },
    );

    test(
      ".checkRange() should throw ArgumentError if the end value is negative",
      () {
        expect(() => NumberValidator.checkRange(1, -1), throwsArgumentError);
      },
    );

    test(
      ".checkRange() should throw ArgumentError if the end value is less than the begin one",
      () {
        expect(() => NumberValidator.checkRange(2, 1), throwsArgumentError);
      },
    );

    test(".checkRange() should validate the given rande", () {
      expect(() => NumberValidator.checkRange(1, 2), returnsNormally);
    });
  });
}
